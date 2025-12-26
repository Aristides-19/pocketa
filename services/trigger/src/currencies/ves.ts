import * as supabase from "@supabase/supabase-js";
import { logger, schedules, task } from "@trigger.dev/sdk/v3";
import * as cheerio from "cheerio";
import "dotenv/config";
import { DateTime } from "luxon";
import { Agent, request } from "undici";

/** Save VES rate to USD/EUR to DB */
export const SaveBcvRate = task({
  id: "ves-bcv-save-rate",
  machine: "micro",
  run: async (payload: { currency: "USD" | "EUR"; selector: string; html: string }) => {
    try {
      const $ = cheerio.load(payload.html);

      const date = $(".pull-right.dinpro.center .date-display-single").attr("content");
      if (!date) {
        throw new Error("Could not extract effective date from BCV");
      }

      const rate = parseFloat($(payload.selector).text().trim().replace(",", "."));
      if (isNaN(rate)) {
        throw new Error(`Could not extract rate for currency ${payload.currency}: ${rate}`);
      }
      const client = supabase.createClient(
        process.env.SUPABASE_URL!,
        process.env.SUPABASE_SECRET_KEY!,
        {
          db: {
            schema: "api",
          },
        },
      );

      const { data, error } = await client
        .from("exchange_rates")
        .insert({
          rate: rate,
          effective_at: DateTime.fromISO(date).toJSDate(),
          from_currency: "VES",
          to_currency: payload.currency,
        })
        .select();

      if (error) {
        if (error.code === "23505") {
          logger.warn(`VES to ${payload.currency} rate for date ${date} already exists`);
          return { rate, date };
        }

        throw error;
      }

      logger.log(`Saved ${payload.currency} rate`, { data });

      return { data, rate, date };
    } catch (error) {
      logger.error(`VES to ${payload.currency} rate saving failed`, { error });
      throw error;
    }
  },
});

/** Request VES exchange rates to USD/EUR, and trigger Batch to save it */
export const VesRatesScheduler = schedules.task({
  id: "ves-bcv-rates-scheduler",
  cron: {
    pattern: "0 0 * * *",
    timezone: "America/Caracas",
  },
  machine: "micro",
  run: async () => {
    try {
      const { body } = await request("https://www.bcv.org.ve/", {
        dispatcher: new Agent({
          connect: {
            rejectUnauthorized: false,
          },
        }),
      });

      const html = await body.text();
      await SaveBcvRate.batchTrigger([
        { payload: { currency: "USD", selector: "#dolar strong", html } },
        { payload: { currency: "EUR", selector: "#euro strong", html } },
      ]);

      logger.log("Triggered VES exchange rates for USD and EUR extraction tasks");
    } catch (error) {
      logger.error("BCV extraction failed", { error });
      throw error;
    }
  },
});
