-- Table for storing currencies
CREATE TABLE IF NOT EXISTS api.currencies(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    code VARCHAR(3) UNIQUE NOT NULL,
    symbol VARCHAR(8) NOT NULL,
    decimal_digits SMALLINT NOT NULL DEFAULT 2,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    allow_base BOOLEAN NOT NULL,
    allow_conversion BOOLEAN NOT NULL
);

-- Table for storing exchange rates for currencies
CREATE TABLE IF NOT EXISTS api.exchange_rates(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    rate NUMERIC(20,8) NOT NULL,
    effective_at TIMESTAMP WITH TIME ZONE NOT NULL,
    from_currency VARCHAR(3) NOT NULL,
    to_currency VARCHAR(3) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    FOREIGN KEY(from_currency) REFERENCES api.currencies(code),
    FOREIGN KEY(to_currency) REFERENCES api.currencies(code),
    UNIQUE(effective_at, from_currency, to_currency)
);
CREATE INDEX IF NOT EXISTS exchange_rates_from_currency_to_currency_effective_at_idx ON api.exchange_rates USING btree (from_currency, to_currency, effective_at);
CREATE INDEX IF NOT EXISTS exchange_rates_to_currency_from_currency_effective_at_idx ON api.exchange_rates USING btree (to_currency, from_currency, effective_at);

-- Table for storing user accounts
CREATE TABLE IF NOT EXISTS api.accounts(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL DEFAULT auth.uid(),
    name VARCHAR(32) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT false,
    base_currency VARCHAR(3) NOT NULL,
    conversion_currency VARCHAR(3) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    "type" api.account_type NOT NULL DEFAULT 'manual',
    FOREIGN KEY(base_currency) REFERENCES api.currencies(code),
    FOREIGN KEY(conversion_currency) REFERENCES api.currencies(code),
    FOREIGN KEY(user_id) REFERENCES auth.users(id)
);
CREATE INDEX IF NOT EXISTS accounts_user_id_idx ON api.accounts USING btree (user_id);

-- Table for storing account balances
CREATE TABLE IF NOT EXISTS api.balances(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    amount VARCHAR NOT NULL,
    account_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    FOREIGN KEY(account_id) REFERENCES api.accounts(id)
);
CREATE INDEX IF NOT EXISTS balances_account_id_idx ON api.balances USING btree (account_id);

-- Table for storing transaction categories (per user)
CREATE TABLE IF NOT EXISTS api.categories(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    name VARCHAR(32) NOT NULL,
    user_id UUID NOT NULL DEFAULT auth.uid(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    FOREIGN KEY(user_id) REFERENCES auth.users(id),
    UNIQUE(user_id, name)
);

-- Table for storing account transactions
CREATE TABLE IF NOT EXISTS api.transactions(
    id UUID PRIMARY KEY NOT NULL DEFAULT gen_random_uuid(),
    description VARCHAR NOT NULL,
    amount VARCHAR NOT NULL,
    converted_amount VARCHAR,
    applied_rate NUMERIC(20,8),
    "type" api.transaction_type NOT NULL,
    effective_date DATE NOT NULL DEFAULT now(),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    account_id UUID NOT NULL,
    category_id UUID NOT NULL,
    FOREIGN KEY(account_id) REFERENCES api.accounts(id),
    FOREIGN KEY(category_id) REFERENCES api.categories(id)
);
CREATE INDEX IF NOT EXISTS transactions_account_id_idx ON api.transactions USING btree (account_id);
CREATE INDEX IF NOT EXISTS transactions_category_id_idx ON api.transactions USING btree (category_id);

-- Table for storing encrypted secret keys per user
CREATE TABLE IF NOT EXISTS secret.keys(
    id UUID PRIMARY KEY NOT NULL DEFAULT auth.uid(),
    encrypted_key VARCHAR(128) NOT NULL,
    salt CHAR(16) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    FOREIGN KEY(id) REFERENCES auth.users(id)
);