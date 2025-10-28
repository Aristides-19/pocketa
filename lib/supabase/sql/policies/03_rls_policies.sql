-- RLS Policies for api tables
CREATE POLICY crud_user_accounts ON api.accounts
    FOR ALL
    TO authenticated
    USING (( SELECT auth.uid() AS uid) = user_id)
    WITH CHECK (( SELECT auth.uid() AS uid) = user_id);

CREATE POLICY crud_user_transactions ON api.transactions
    FOR ALL
    TO authenticated
    USING (( SELECT auth.uid() AS uid) = (SELECT user_id FROM api.accounts AS ac WHERE ac.id = account_id))
    WITH CHECK (( SELECT auth.uid() AS uid) = (SELECT user_id FROM api.accounts AS ac WHERE ac.id = account_id));

CREATE POLICY crud_user_categories ON api.categories
    FOR ALL
    TO authenticated
    USING (( SELECT auth.uid() AS uid) = user_id)
    WITH CHECK (( SELECT auth.uid() AS uid) = user_id);

CREATE POLICY crud_user_balances ON api.balances
    FOR ALL
    TO authenticated
    USING (( SELECT auth.uid() AS uid) = (SELECT user_id FROM api.accounts AS ac WHERE ac.id = account_id))
    WITH CHECK (( SELECT auth.uid() AS uid) = (SELECT user_id FROM api.accounts AS ac WHERE ac.id = account_id));

CREATE POLICY read_currencies ON api.currencies
    FOR SELECT
    TO authenticated
    USING (true);

CREATE POLICY read_exchange_rates ON api.exchange_rates
    FOR SELECT
    TO authenticated
    USING (true);