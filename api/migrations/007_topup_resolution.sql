ALTER TABLE topups ADD COLUMN resolution text CHECK (resolution IN ('accept_received_amount','refund_outside_system','no_action')),
  ADD COLUMN resolution_note text, ADD COLUMN resolved_by uuid, ADD COLUMN resolved_at timestamptz;
