-- Nigerian Microfinance Portfolio Analysis
-- Database Schema
-- PostgreSQL 14+

CREATE TABLE IF NOT EXISTS microfinance_loans (
    loan_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    branch_name VARCHAR(50),
    region VARCHAR(20),
    loan_officer_id VARCHAR(10),
    loan_amount INTEGER,
    interest_rate DECIMAL(4,2),
    loan_tenure_weeks INTEGER,
    repayment_frequency VARCHAR(10),
    disbursement_date DATE,
    expected_maturity_date DATE,
    total_amount_due INTEGER,
    total_amount_paid INTEGER,
    days_past_due INTEGER,
    loan_status VARCHAR(20),
    borrower_business_type VARCHAR(20),
    borrower_income_estimate INTEGER,
    loan_cycle_number INTEGER,
    prior_default_flag VARCHAR(3),
    collection_efficiency_percent DECIMAL(5,2),
    officer_portfolio_size INTEGER
);

-- Indexes
CREATE INDEX idx_customer_id ON microfinance_loans(customer_id);
CREATE INDEX idx_loan_status ON microfinance_loans(loan_status);
CREATE INDEX idx_region ON microfinance_loans(region);
CREATE INDEX idx_disbursement_date ON microfinance_loans(disbursement_date);
