-- Portfolio Health Summary

SELECT 
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(outstanding_balance) AS total_outstanding,
    ROUND((SUM(total_amount_paid)::NUMERIC / SUM(total_amount_due)) * 100, 2) AS collection_rate,
    ROUND((COUNT(*) FILTER (WHERE loan_status = 'default')::NUMERIC / COUNT(*)) * 100, 2) AS default_rate,
    ROUND((SUM(outstanding_balance) FILTER (WHERE is_par30 = 1)::NUMERIC / NULLIF(SUM(outstanding_balance), 0)) * 100, 2) AS par30_rate,
    ROUND((SUM(outstanding_balance) FILTER (WHERE is_par90 = 1)::NUMERIC / NULLIF(SUM(outstanding_balance), 0)) * 100, 2) AS par90_rate
FROM vw_loan_metrics;
