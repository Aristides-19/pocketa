import "dotenv/config";
import { logger, schedules } from "@trigger.dev/sdk/v3";
import { Agent, request } from "undici";
import * as cheerio from "cheerio";
import * as supabase from "@supabase/supabase-js";
import { DateTime } from "luxon";

export const VesUsdRate = schedules.task({
  id: "bcv-ves-usd-rate",
  cron: {
    pattern: "0 0 * * *",
    timezone: "America/Caracas",
  },
  machine: "micro",
  maxDuration: 300,
  run: async (payload, { ctx }) => {
    try {
      const { body } = await request("https://www.bcv.org.ve/", {
        dispatcher: new Agent({
          connect: {
            rejectUnauthorized: false,
          },
        }),
      });

      const $ = cheerio.load(await body.text());

      const rate = parseFloat(
        $("#dolar strong").text().trim().replace(",", ".")
      );
      if (isNaN(rate)) {
        throw new Error("Could not extract VES USD rate from BCV");
      }

      const isoDate = $(".pull-right.dinpro.center .date-display-single").attr(
        "content"
      );
      if (!isoDate) {
        throw new Error("Could not extract effective date from BCV");
      }

      logger.log("BCV VES USD Rate extracted", { rate, isoDate });

      const client = supabase.createClient(
        process.env.SUPABASE_URL!,
        process.env.SUPABASE_SECRET_KEY!,
        {
          db: {
            schema: "api",
          },
        }
      );

      const { data, error } = await client
        .from("exchange_rates")
        .insert({
          rate,
          effective_at: DateTime.fromISO(isoDate!).toJSDate(),
          from_currency: "VES",
          to_currency: "USD",
        })
        .select();

      if (error) throw error;

      logger.log("BCV VES USD Rate stored in database", { data });

      return { data, rate, isoDate };
    } catch (error) {
      logger.error("BCV VES USD extraction request failed", { error });
      throw error;
    }
  },
});
