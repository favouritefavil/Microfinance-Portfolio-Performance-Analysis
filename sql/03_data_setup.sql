-- ================================================================
-- 03: DATA SETUP - ANALYTICAL VIEW CREATION
-- ================================================================
-- Purpose: Create vw_loan_metrics with all derived metrics needed
--          for portfolio analysis
-- ================================================================

CREATE OR REPLACE VIEW vw_loan_metrics AS
SELECT 
    *,
    
    -- ============================================
    -- DERIVED METRIC 1: Outstanding Balance
    -- ============================================
    -- Formula: Total Amount Due - Total Amount Paid
    -- Represents: How much money is still owed
    -- Example: Loan with ₦100,000 due, ₦75,000 paid = ₦25,000 outstanding
    total_amount_due - total_amount_paid AS outstanding_balance,
    
    -- ============================================
    -- DERIVED METRIC 2: Collection Rate
    -- ============================================
    -- Formula: (Total Amount Paid / Total Amount Due) × 100
    -- Represents: Percentage of expected revenue collected
    -- Example: ₦75,000 paid / ₦100,000 due = 75% collection rate
    CASE 
        WHEN total_amount_due > 0 
        THEN ROUND((total_amount_paid::NUMERIC / total_amount_due) * 100, 2)
        ELSE 0 
    END AS collection_rate,
    
    -- ============================================
    -- DERIVED METRIC 3: PAR Flags
    -- ============================================
    -- Portfolio at Risk indicators (binary flags)
    -- is_par30 = 1 if loan is 30+ days overdue
    -- Used for calculating PAR 30, 60, 90 rates
    CASE WHEN days_past_due >= 30 THEN 1 ELSE 0 END AS is_par30,
    CASE WHEN days_past_due >= 60 THEN 1 ELSE 0 END AS is_par60,
    CASE WHEN days_past_due >= 90 THEN 1 ELSE 0 END AS is_par90,
    
    -- ============================================
    -- DERIVED METRIC 4: Risk Category
    -- ============================================
    -- Categorical risk assessment based on status and days overdue
    -- High Risk: Defaulted or 90+ days overdue
    -- Medium Risk: 30-89 days overdue
    -- Low Risk: 1-29 days overdue
    -- Current: No overdue payments
    CASE 
        WHEN loan_status = 'default' THEN 'High Risk'
        WHEN days_past_due >= 90 THEN 'High Risk'
        WHEN days_past_due >= 30 THEN 'Medium Risk'
        WHEN days_past_due > 0 THEN 'Low Risk'
        ELSE 'Current'
    END AS risk_category,
    
    -- ============================================
    -- DERIVED METRIC 5: Time Period Fields
    -- ============================================
    -- Extract year and month for vintage analysis
    -- Format: YYYY-MM (e.g., "2024-01")
    DATE_PART('year', disbursement_date) AS disbursement_year,
    DATE_PART('month', disbursement_date) AS disbursement_month,
    TO_CHAR(disbursement_date, 'YYYY-MM') AS disbursement_period,
    
    -- ============================================
    -- DERIVED METRIC 6: Loan Age
    -- ============================================
    -- How many days since loan was disbursed
    -- Used for maturity analysis
    CURRENT_DATE - disbursement_date AS loan_age_days

FROM microfinance_loans
WHERE loan_status IS NOT NULL;

-- Verify view creation
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers,
    'View created successfully' AS status
FROM vw_loan_metrics;
