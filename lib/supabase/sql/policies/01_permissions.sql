-- Grant permissions to authenticated users
GRANT SELECT, INSERT, UPDATE, DELETE 
ON TABLE api.accounts 
TO authenticated;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON TABLE api.transactions 
TO authenticated;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON TABLE api.categories
TO authenticated;

GRANT SELECT, INSERT, UPDATE, DELETE 
ON TABLE api.balances
TO authenticated;

GRANT SELECT
ON TABLE api.currencies
TO authenticated;

GRANT SELECT
ON TABLE api.exchange_rates
TO authenticated;