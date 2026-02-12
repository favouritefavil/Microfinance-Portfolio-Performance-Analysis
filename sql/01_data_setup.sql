-- Create Analytical View with Derived Metrics

CREATE OR REPLACE VIEW vw_loan_metrics AS
SELECT 
    *,
    total_amount_due - total_amount_paid AS outstanding_balance,
    CASE 
        WHEN total_amount_due > 0 
        THEN ROUND((total_amount_paid::NUMERIC / total_amount_due) * 100, 2)
        ELSE 0 
    END AS collection_rate,
    CASE WHEN days_past_due >= 30 THEN 1 ELSE 0 END AS is_par30,
    CASE WHEN days_past_due >= 60 THEN 1 ELSE 0 END AS is_par60,
    CASE WHEN days_past_due >= 90 THEN 1 ELSE 0 END AS is_par90,
    CASE 
        WHEN loan_status = 'default' THEN 'High Risk'
        WHEN days_past_due >= 90 THEN 'High Risk'
        WHEN days_past_due >= 30 THEN 'Medium Risk'
        WHEN days_past_due > 0 THEN 'Low Risk'
        ELSE 'Current'
    END AS risk_category,
    TO_CHAR(disbursement_date, 'YYYY-MM') AS disbursement_period
FROM microfinance_loans
WHERE loan_status IS NOT NULL;
