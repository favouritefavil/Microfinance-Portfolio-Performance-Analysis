# Data Dictionary

## Field Definitions

| Field | Type | Description |
|-------|------|-------------|
| loan_id | VARCHAR(10) | Unique loan identifier |
| customer_id | VARCHAR(20) | Unique customer identifier |
| region | VARCHAR(20) | Geographic region (7 regions) |
| loan_amount | INTEGER | Principal disbursed (₦) |
| loan_status | VARCHAR(20) | current / overdue / default |
| loan_cycle_number | INTEGER | Nth loan for this customer |
| borrower_business_type | VARCHAR(20) | farmer / trader / SME / artisan / transport |
| days_past_due | INTEGER | Days overdue (0 if current) |
| total_amount_due | INTEGER | Principal + Interest |
| total_amount_paid | INTEGER | Amount collected |

## Derived Metrics

- **outstanding_balance** = total_amount_due - total_amount_paid
- **collection_rate** = (total_amount_paid / total_amount_due) × 100
- **PAR 30/60/90** = Loans overdue 30/60/90+ days
