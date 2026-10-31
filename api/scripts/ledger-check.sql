-- Must return ZERO rows. Every wallet's balance and reserved amount must equal the sum of its ledger entries.
-- (Demo wallets that the tests fund directly will show here; in production every change goes through the ledger.)
SELECT w.student_id, w.balance_pesewas, COALESCE(l.b,0) AS ledger_balance, w.reserved_pesewas, COALESCE(l.r,0) AS ledger_reserved
FROM wallets w
LEFT JOIN (SELECT student_id, sum(amount_pesewas) b, sum(reserved_delta) r FROM ledger_entries GROUP BY 1) l USING (student_id)
WHERE w.balance_pesewas <> COALESCE(l.b,0) OR w.reserved_pesewas <> COALESCE(l.r,0);
