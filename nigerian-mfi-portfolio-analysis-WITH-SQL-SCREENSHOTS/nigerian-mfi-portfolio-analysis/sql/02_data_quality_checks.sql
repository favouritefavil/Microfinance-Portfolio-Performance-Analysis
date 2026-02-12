-- ================================================================
-- 02: DATA QUALITY CHECKS
-- ================================================================
-- Purpose: Validate data integrity and identify any issues before
--          proceeding with analysis
-- ================================================================

-- CHECK 1: Duplicate loan IDs
SELECT 
    'Duplicate Loan IDs' AS check_name,
    COUNT(*) AS issue_count
FROM (
    SELECT loan_id, COUNT(*) AS duplicate_count
    FROM microfinance_loans
    GROUP BY loan_id
    HAVING COUNT(*) > 1
) duplicates;

-- Expected: 0 duplicates


-- CHECK 2: Null or invalid loan amounts
SELECT 
    'Invalid Loan Amounts' AS check_name,
    COUNT(*) AS issue_count
FROM microfinance_loans
WHERE loan_amount IS NULL 
   OR loan_amount <= 0;

-- Expected: 0 issues


-- CHECK 3: Future disbursement dates (impossible)
SELECT 
    'Future Disbursement Dates' AS check_name,
    COUNT(*) AS issue_count
FROM microfinance_loans
WHERE disbursement_date > CURRENT_DATE;

-- Expected: 0 issues


-- CHECK 4: Payments exceeding amounts due (logical error)
SELECT 
    'Overpayments (Paid > Due)' AS check_name,
    COUNT(*) AS issue_count
FROM microfinance_loans
WHERE total_amount_paid > total_amount_due;

-- Expected: 0 issues


-- CHECK 5: Verify loan status values
SELECT 
    loan_status,
    COUNT(*) AS count,
    ROUND((COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM microfinance_loans)) * 100, 2) AS percentage
FROM microfinance_loans
GROUP BY loan_status
ORDER BY count DESC;

-- Expected statuses: current, overdue, default
-- Percentages should be reasonable (majority current/overdue)


-- CHECK 6: Verify region names (no typos)
SELECT 
    region,
    COUNT(*) AS loan_count
FROM microfinance_loans
GROUP BY region
ORDER BY region;

-- Expected: Exactly 7 regions
-- North East, North Central, North West
-- South East, South West, South South
-- Lagos


-- CHECK 7: Check for orphaned customer records
SELECT 
    'Customers with No Loans' AS check_name,
    COUNT(DISTINCT customer_id) - 
    (SELECT COUNT(DISTINCT customer_id) FROM microfinance_loans) AS issue_count;

-- Expected: 0 (all customers should have loans in this dataset)


-- CHECK 8: Validate loan cycle logic (cycle 1 should be most common)
SELECT 
    loan_cycle_number,
    COUNT(*) AS count
FROM microfinance_loans
GROUP BY loan_cycle_number
ORDER BY loan_cycle_number;

-- Expected: Decreasing pattern (more cycle 1 than cycle 2, etc.)


-- CHECK 9: Check days_past_due consistency with loan_status
SELECT 
    'Current Loans with Days Past Due' AS check_name,
    COUNT(*) AS issue_count
FROM microfinance_loans
WHERE loan_status = 'current' AND days_past_due > 0;

-- Expected: 0 issues (current loans should have 0 days past due)


-- CHECK 10: Verify interest rate reasonableness
SELECT 
    MIN(interest_rate) AS min_rate,
    AVG(interest_rate) AS avg_rate,
    MAX(interest_rate) AS max_rate
FROM microfinance_loans;

-- Expected: Rates between 2-4% monthly (24-48% annually)


-- CHECK 11: Data completeness summary
SELECT 
    'Total Records' AS metric,
    COUNT(*) AS value
FROM microfinance_loans

UNION ALL

SELECT 
    'Records with All Required Fields',
    COUNT(*)
FROM microfinance_loans
WHERE loan_id IS NOT NULL
  AND customer_id IS NOT NULL
  AND region IS NOT NULL
  AND loan_amount IS NOT NULL
  AND loan_status IS NOT NULL
  AND disbursement_date IS NOT NULL

UNION ALL

SELECT 
    'Completeness Percentage',
    ROUND((
        SELECT COUNT(*)::NUMERIC 
        FROM microfinance_loans
        WHERE loan_id IS NOT NULL
          AND customer_id IS NOT NULL
          AND region IS NOT NULL
          AND loan_amount IS NOT NULL
          AND loan_status IS NOT NULL
          AND disbursement_date IS NOT NULL
    ) / COUNT(*) * 100, 2)
FROM microfinance_loans;

-- Expected: 100% completeness


-- SUMMARY: Data Quality Assessment
SELECT 
    'Data Quality Status' AS assessment,
    CASE 
        WHEN (
            -- No duplicates
            (SELECT COUNT(*) FROM (
                SELECT loan_id FROM microfinance_loans GROUP BY loan_id HAVING COUNT(*) > 1
            ) dup) = 0
            -- No invalid amounts
            AND (SELECT COUNT(*) FROM microfinance_loans WHERE loan_amount IS NULL OR loan_amount <= 0) = 0
            -- No future dates
            AND (SELECT COUNT(*) FROM microfinance_loans WHERE disbursement_date > CURRENT_DATE) = 0
            -- No overpayments
            AND (SELECT COUNT(*) FROM microfinance_loans WHERE total_amount_paid > total_amount_due) = 0
        )
        THEN '✅ PASSED - Data is clean and ready for analysis'
        ELSE '⚠️ ISSUES FOUND - Review checks above'
    END AS status;

