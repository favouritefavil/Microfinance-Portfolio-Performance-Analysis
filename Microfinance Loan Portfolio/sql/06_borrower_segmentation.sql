-- Loan Cycle Performance (Repeat Borrower Effect)

SELECT 
    loan_cycle_number,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount), 0) AS avg_loan_amount,
    ROUND((COUNT(*) FILTER (WHERE loan_status = 'default')::NUMERIC / COUNT(*)) * 100, 2) AS default_rate,
    ROUND(AVG(collection_rate), 2) AS avg_collection_rate
FROM vw_loan_metrics
GROUP BY loan_cycle_number
ORDER BY loan_cycle_number;

-- Business Type Risk Analysis

SELECT 
    borrower_business_type,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount), 0) AS avg_loan_amount,
    ROUND((COUNT(*) FILTER (WHERE loan_status = 'default')::NUMERIC / COUNT(*)) * 100, 2) AS default_rate
FROM vw_loan_metrics
GROUP BY borrower_business_type
ORDER BY default_rate DESC;
