-- Vintage Performance by Month

SELECT 
    disbursement_period,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    ROUND((COUNT(*) FILTER (WHERE loan_status = 'default')::NUMERIC / COUNT(*)) * 100, 2) AS default_rate,
    ROUND(AVG(collection_rate), 2) AS avg_collection_rate
FROM vw_loan_metrics
GROUP BY disbursement_period
ORDER BY disbursement_period;
