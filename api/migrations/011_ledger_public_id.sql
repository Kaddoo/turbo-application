-- WalletTransaction.id is a UUID in the contract; the ledger's own key is a sequence. Add a stable public id (additive; rows are never updated).
ALTER TABLE ledger_entries ADD COLUMN public_id uuid NOT NULL DEFAULT gen_random_uuid();
CREATE UNIQUE INDEX ledger_public_id_uq ON ledger_entries (public_id);
