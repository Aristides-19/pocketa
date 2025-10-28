-- Enum for transaction types
CREATE TYPE api.transaction_type AS ENUM (
    'expense',
    'income',
    'saving'
);

-- Enum for account types
CREATE TYPE api.account_type AS ENUM (
    'manual',
    'auto'
);