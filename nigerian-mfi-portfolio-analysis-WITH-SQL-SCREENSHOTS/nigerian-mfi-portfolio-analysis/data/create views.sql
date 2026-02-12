CREATE VIEW vw_loan_metrics AS
SELECT
    loan_id,
    customer_id,
    loan_amount,
    total_amount_due,
    total_amount_paid,
    days_past_due,
    loan_status,
    borrower_business_type,
    loan_cycle_number,
    disbursement_date,
	collection_efficiency_percent,
	region,
	loan_officer_id,
	officer_porfolio_size,
	branch_name,
	loan_tenure_weeks,
	repayment_frequency,
	expected_maturity_date,
	prior_default_flag,
	interest_rate,
	
    -- Derived metrics
	-- Outstanding balance (what is still owed)
    total_amount_due - total_amount_paid AS outstanding_balance,

	-- collection Rate (how much have we collected vs what was due)
    ROUND(
        total_amount_paid::NUMERIC
        / NULLIF(total_amount_due, 0)
        * 100,
        2
    ) AS collection_rate,


	-- PAR category (Portfolio at Risk Indicators)
    CASE WHEN days_past_due >= 30 THEN 1 ELSE 0 END AS is_par30,
    CASE WHEN days_past_due >= 60 THEN 1 ELSE 0 END AS is_par60,
    CASE WHEN days_past_due >= 90 THEN 1 ELSE 0 END AS is_par90,

	-- Risk severity Flag
    CASE
        WHEN loan_status = 'default' THEN 'High Risk'
        WHEN days_past_due >= 90 THEN 'High Risk'
        WHEN days_past_due >= 30 THEN 'Medium Risk'
        WHEN days_past_due > 0 THEN 'Low Risk'
        ELSE 'Current'
    END AS risk_category,

	-- Time based grouping
    DATE_PART('year', disbursement_date::DATE) AS disbursement_year,
    DATE_PART('month', disbursement_date::DATE) AS disbursement_month,
    TO_CHAR(disbursement_date::DATE, 'YYYY-MM') AS disbursement_period

FROM loan
WHERE loan_status IS NOT NULL;
