-- Ensure that only one account per user is marked as default
CREATE OR REPLACE FUNCTION api.ensure_single_default_account()
RETURNS trigger 
LANGUAGE plpgsql
SET search_path = api
SECURITY INVOKER
AS $$
BEGIN

  -- If the new or updated account is set as default, unset all other accounts for that user
  IF NEW.is_default = true THEN
    UPDATE api.accounts
    SET is_default = false
    WHERE user_id = NEW.user_id AND id != NEW.id;
  ELSE
    -- If the new or updated account is not set as default, check if there are no other default accounts for that user
    IF NOT EXISTS (
      SELECT 1 FROM api.accounts
      WHERE user_id = NEW.user_id AND is_default = true AND id != NEW.id
    ) THEN

      NEW.is_default := true;
    END IF;

  END IF;

  RETURN NEW;
END;
$$;

-- Ensure that when a default account is deleted, the oldest account becomes the new default
CREATE OR REPLACE FUNCTION api.ensure_default_account_on_delete()
RETURNS trigger 
LANGUAGE plpgsql
SET search_path = api
SECURITY INVOKER
AS $$
BEGIN

  IF OLD.is_default = true THEN
    UPDATE api.accounts
    SET is_default = true
    WHERE id != OLD.id AND id = (
      SELECT id FROM api.accounts
      WHERE id != OLD.id
      ORDER BY created_at ASC
      LIMIT 1
    );
  END IF;

  RETURN OLD;
END;
$$;

-- Ensure that a user cannot have more than 10 accounts
CREATE OR REPLACE FUNCTION api.ensure_account_limit()
RETURNS trigger 
LANGUAGE plpgsql
SET search_path = api
SECURITY INVOKER
AS $$
DECLARE
  account_count int;
BEGIN
  SELECT COUNT(*)
  INTO account_count
  FROM api.accounts;

  IF account_count >= 10 THEN
    
    RAISE EXCEPTION USING
      errcode = 'AC010',
      message = 'Cannot have more than 10 accounts';

  END IF;

  RETURN NEW;
END;
$$;

-- Ensure that the base_currency and conversion_currency of an account cannot be changed if there are transactions linked to it
CREATE OR REPLACE FUNCTION api.ensure_transactions_currency_consistency()
RETURNS trigger 
LANGUAGE plpgsql
SET search_path = api
SECURITY INVOKER
AS $$
BEGIN
  IF NEW.base_currency != OLD.base_currency OR NEW.conversion_currency != OLD.conversion_currency THEN
    IF EXISTS (
      SELECT 1 FROM api.transactions
      WHERE account_id = NEW.id
    ) THEN
      RAISE EXCEPTION USING
        errcode = 'AC001',
        message = 'Cannot update currencies for accounts with one transaction or more';
    END IF;
  END IF;

  RETURN NEW;
END;
$$;

-- Functions to manage user encryption keys 
CREATE OR REPLACE FUNCTION api.get_user_key()
RETURNS json 
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = api, secret
AS $$
DECLARE
    data json;
BEGIN
    SELECT json_build_object(
        'encrypted_key', k.encrypted_key,
        'salt', k.salt
    )
    INTO data
    FROM secret.keys k
    WHERE k.id = auth.uid();
    IF NOT FOUND THEN
       RAISE EXCEPTION 'No key found for user %', auth.uid()
         USING ERRCODE = 'P0002';
    END IF;

    RETURN data;
END;
$$;

-- Upsert user encryption key
CREATE OR REPLACE FUNCTION api.upsert_user_key(
   p_encrypted_key varchar,
   p_salt varchar
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = api, secret
AS $$
BEGIN
    INSERT INTO secret.keys (id, encrypted_key, salt)
    VALUES (auth.uid(), p_encrypted_key, p_salt)
    ON CONFLICT (id) DO UPDATE
    SET
        encrypted_key = EXCLUDED.encrypted_key,
        salt = EXCLUDED.salt;
END;
$$;

GRANT EXECUTE ON FUNCTION api.upsert_user_key TO authenticated;
GRANT EXECUTE ON FUNCTION api.get_user_key TO authenticated;