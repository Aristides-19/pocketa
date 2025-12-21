CREATE TRIGGER ensure_account_limit
BEFORE INSERT ON api.accounts
FOR EACH ROW
EXECUTE FUNCTION api.ensure_account_limit();

CREATE TRIGGER ensure_single_default_account
BEFORE INSERT OR UPDATE ON api.accounts
FOR EACH ROW
EXECUTE FUNCTION api.ensure_single_default_account();

CREATE TRIGGER ensure_transactions_currency_consistency
BEFORE UPDATE ON api.accounts
FOR EACH ROW
EXECUTE FUNCTION api.ensure_transactions_currency_consistency();

CREATE TRIGGER ensure_default_account_on_delete
AFTER DELETE ON api.accounts
FOR EACH ROW
EXECUTE FUNCTION api.ensure_default_account_on_delete();