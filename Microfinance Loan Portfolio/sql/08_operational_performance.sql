-- Loan Officer Performance Analysis

SELECT 
    loan_officer_id,
    region,
    COUNT(*) AS total_loans,
    MAX(officer_portfolio_size) AS capacity,
    ROUND((COUNT(*) FILTER (WHERE loan_status = 'default')::NUMERIC / COUNT(*)) * 100, 2) AS default_rate,
    ROUND(AVG(collection_rate), 2) AS avg_collection_rate
FROM vw_loan_metrics
GROUP BY loan_officer_id, region
ORDER BY default_rate DESC;
