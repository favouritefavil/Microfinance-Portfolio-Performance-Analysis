-- Nigerian Microfinance Portfolio Analysis
-- Database Schema
-- PostgreSQL 14+

CREATE TABLE loan(
	loan_id VARCHAR(20) PRIMARY KEY,
	customer_id VARCHAR(20),
	branch_name VARCHAR(100),
	region VARCHAR(50),
	loan_officer_id VARCHAR(20),
	loan_amount NUMERIC(14,2),
	interest_rate NUMERIC(5,2),
	loan_tenure_weeks INTEGER,
	repayment_frequency VARCHAR(12),
	disbursement_date DATE,
	expected_maturity_date DATE,
	total_amount_due NUMERIC(14,2),
	total_amount_paid NUMERIC(14,2),
	days_past_due INTEGER,
	loan_status VARCHAR(20),
	borrower_business_type VARCHAR(30),
	borrower_income_estimate NUMERIC(14,2),
	loan_cycle_number INTEGER,
	prior_default_flag VARCHAR(5),
	collection_efficiency_percent NUMERIC(5,2),
	officer_porfolio_size INTEGER
);
