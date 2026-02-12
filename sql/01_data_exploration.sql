-- ================================================================
-- 01: DATA EXPLORATION
-- ================================================================
-- Purpose: Initial inspection of the dataset to understand structure,
--          completeness, and date ranges before analysis
-- ================================================================

-- Check total number of records
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM microfinance_loans;

-- Expected Output:
-- total_records: 3922
-- unique_customers: 1854


-- Examine date range of the portfolio
SELECT 
    MIN(disbursement_date) AS earliest_loan,
    MAX(disbursement_date) AS latest_loan,
    MAX(disbursement_date) - MIN(disbursement_date) AS portfolio_age_days,
    ROUND((MAX(disbursement_date) - MIN(disbursement_date)) / 30.0, 1) AS portfolio_age_months
FROM microfinance_loans;

-- Expected Output:
-- earliest_loan: 2024-01-01
-- latest_loan: 2025-02-08
-- portfolio_age_days: ~400 days
-- portfolio_age_months: ~13-14 months


-- Check data completeness for key fields
SELECT 
    'Total Records' AS field_check,
    COUNT(*) AS count,
    ROUND((COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM microfinance_loans)) * 100, 2) AS completeness_pct
FROM microfinance_loans

UNION ALL

SELECT 
    'Has Loan ID',
    COUNT(loan_id),
    ROUND((COUNT(loan_id)::NUMERIC / (SELECT COUNT(*) FROM microfinance_loans)) * 100, 2)
FROM microfinance_loans

UNION ALL

SELECT 
    'Has Customer ID',
    COUNT(customer_id),
    ROUND((COUNT(customer_id)::NUMERIC / (SELECT COUNT(*) FROM microfinance_loans)) * 100, 2)
FROM microfinance_loans

UNION ALL

SELECT 
    'Has Region',
    COUNT(region),
    ROUND((COUNT(region)::NUMERIC / (SELECT COUNT(*) FROM microfinance_loans)) * 100, 2)
FROM microfinance_loans

UNION ALL

SELECT 
    'Has Loan Amount',
    COUNT(loan_amount),
    ROUND((COUNT(loan_amount)::NUMERIC / (SELECT COUNT(*) FROM microfinance_loans)) * 100, 2)
FROM microfinance_loans

UNION ALL

SELECT 
    'Has Loan Status',
    COUNT(loan_status),
    ROUND((COUNT(loan_status)::NUMERIC / (SELECT COUNT(*) FROM microfinance_loans)) * 100, 2)
FROM microfinance_loans;


-- Preview sample records
SELECT * 
FROM microfinance_loans 
LIMIT 5;


-- Check distribution of categorical fields
SELECT 
    'Regions' AS category,
    COUNT(DISTINCT region) AS distinct_values
FROM microfinance_loans

UNION ALL

SELECT 
    'Loan Status',
    COUNT(DISTINCT loan_status)
FROM microfinance_loans

UNION ALL

SELECT 
    'Business Types',
    COUNT(DISTINCT borrower_business_type)
FROM microfinance_loans

UNION ALL

SELECT 
    'Loan Officers',
    COUNT(DISTINCT loan_officer_id)
FROM microfinance_loans;

-- Expected Output:
-- Regions: 7
-- Loan Status: 3 (current, overdue, default)
-- Business Types: 5 (farmer, trader, SME, artisan, transport)
-- Loan Officers: 9


-- Check loan amount distribution
SELECT 
    MIN(loan_amount) AS min_loan,
    ROUND(AVG(loan_amount), 0) AS avg_loan,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loan_amount) AS median_loan,
    MAX(loan_amount) AS max_loan
FROM microfinance_loans;


-- Check loan cycle distribution (repeat vs first-time borrowers)
SELECT 
    loan_cycle_number,
    COUNT(*) AS loan_count,
    ROUND((COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM microfinance_loans)) * 100, 2) AS percentage
FROM microfinance_loans
GROUP BY loan_cycle_number
ORDER BY loan_cycle_number;

