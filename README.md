# Nigerian Microfinance Portfolio Risk Analysis

![Project Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Tool](https://img.shields.io/badge/Tool-PostgreSQL-blue)
![Dashboard](https://img.shields.io/badge/Dashboard-Power%20BI-yellow)
![Dataset](https://img.shields.io/badge/Dataset-Simulated%20MFB%20Data-lightgrey)

---

## 🚨 Key Findings (At a Glance)

- **14.6% of loans defaulted** — above the bank's 10% internal target
- Total portfolio: **₦271.6M** across **3,922 loans** in 7 regions
- **North East region defaults at 23.8%** — nearly double the South South at 12.2%
- **Repeat borrowers (Cycle 5) default 4.2× less** than first-time borrowers
- **One loan officer is managing 765% of their assigned capacity** — a structural risk hidden inside operational data

> This project analyses where credit risk is actually concentrated in a Nigerian microfinance portfolio — and what the bank should do about it.

---

## Table of Contents

- [Introduction](#introduction)
- [Business Problem](#business-problem)
- [Dataset Overview](#dataset-overview)
- [Data Cleaning & Preparation](#data-cleaning--preparation)
- [Analysis Approach](#analysis-approach)
- [Dashboard Overview](#dashboard-overview)
- [Dashboard Preview](#dashboard-preview)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [Limitations](#limitations)
- [Conclusion](#conclusion)
- [Repository Structure](#repository-structure)

---

## Introduction

This project delivers a complete credit risk and portfolio monitoring analysis for a Nigerian microfinance bank. It simulates the work of a **credit risk analyst responsible for assessing portfolio health, identifying risk drivers, and providing data-backed strategic recommendations**.

The analysis covers 24 months of loan performance data — from January 2024 to February 2026 — across 7 geographic regions, 5 borrower business types, and 10+ loan cycles. It was built using **PostgreSQL** for data preparation and analysis, and **Power BI** for dashboard development and visualisation.

---

## Business Problem

Microfinance banks give small loans to borrowers who don't have access to traditional banking — farmers, traders, artisans, and small business owners. The challenge is balancing portfolio growth with credit quality. If too many borrowers default, the bank loses money, its ability to lend shrinks, and the customers it exists to serve lose access to credit.

This project addresses four core business questions:

- What is the **overall health** of the loan portfolio?
- Which **borrower segments and regions** carry the highest default risk?
- Is **portfolio quality improving or deteriorating** over time?
- What **operational and strategic actions** should the bank take?

---

## Dataset Overview

**Source:** Simulated Nigerian microfinance bank loan data  
**Records:** 3,922 loans (post-cleaning)  
**Scope:** January 2024 – February 2026 (24 months)

| Variable | Description |
|---|---|
| `loan_id` | Unique identifier for each loan |
| `customer_id` | Links multiple loans to the same borrower |
| `region` | One of 7 geographic regions in Nigeria |
| `loan_amount` | Principal disbursed to the borrower (₦) |
| `loan_status` | Final or current status: current / overdue / default |
| `loan_cycle_number` | Whether this is the borrower's 1st, 2nd, 3rd loan, etc. |
| `borrower_business_type` | Farmer / Trader / SME / Artisan / Transport |
| `days_past_due` | How many days late the borrower is (0 = on time) |
| `total_amount_due` | Principal + interest the borrower owes |
| `total_amount_paid` | Amount collected from the borrower to date |
| `loan_officer_id` | Officer who approved and manages the loan |
| `officer_portfolio_size` | Total number of loans assigned to that officer |
| `disbursement_date` | Date the loan was issued |
| `expected_maturity_date` | Date the loan is due to be fully repaid |

---

## Data Cleaning & Preparation

All cleaning was performed in PostgreSQL before any analysis queries were run. A raw backup table (`loans_raw`) was created before any changes were made, preserving the original data for reference.

**Key cleaning steps:**

- **Removed records with missing critical fields** — loans without a loan amount, disbursement date, repayment figures, or status cannot be reliably analysed
- **Removed structurally impossible records** — loans where the maturity date fell before the disbursement date were deleted as data entry errors
- **Standardised text fields** — `loan_status`, `repayment_frequency`, and `prior_default_flag` were trimmed and lowercased to prevent duplicate groupings (e.g. "Default" and "default" being counted as separate categories)
- **Corrected overpayment records** — where `total_amount_paid` exceeded `total_amount_due`, the paid amount was capped at what was owed. A borrower cannot pay back more than they owe; these were data entry errors
- **Checked for duplicate loan IDs** — loan ID is the primary key and must be unique; duplicates would corrupt counts and aggregations

**Final dataset: 3,922 clean records ready for analysis.**

---

## Analysis Approach

The analysis was structured across **six SQL scripts** covering three analytical themes:

**Portfolio Health**
- Total loans, total disbursed, total collected, total outstanding
- Portfolio-wide default rate and collection rate
- PAR 30 / PAR 60 / PAR 90 calculations
- Outstanding balance breakdown by loan status and risk category

**Risk Segmentation**
- Default rate by borrower business type (farmer, trader, SME, artisan, transport)
- Default rate by loan cycle — first-time vs repeat borrowers
- Default rate by region — all 7 geographic zones ranked
- Vintage analysis — default rates grouped by loan origination month to track quality over time

**Operational Performance**
- Loan officer performance: default rates, collection rates, and capacity utilisation per officer
- Portfolio age distribution: where the outstanding balance sits by loan maturity stage

A core analytical view (`vw_loan_metrics`) was created to centralise all derived metrics — outstanding balance, collection rate, PAR flags, and risk categories — so that every analysis query uses consistent definitions throughout.

**PAR (Portfolio At Risk)** is the standard risk metric in microfinance. PAR 30 means the percentage of outstanding balance belonging to loans that are 30 or more days overdue. PAR is measured on outstanding balance, not total portfolio — an important distinction when reading the dashboard numbers.

---

## Dashboard Overview

The Power BI dashboard is structured across three pages, each addressing a distinct analytical question. All pages share a persistent KPI banner displaying five headline metrics:

> **3,922 Loans | ₦271.6M Portfolio | ₦17.7M Outstanding | 93.5% Collection Rate | 15% Default Rate**

Four interactive filters — Disbursement Date, Loan Status, Region, and Business Type — allow segment-level exploration across all visuals.

---

### Page 1: Portfolio Health

| Visual | What It Shows |
|---|---|
| KPI cards | Headline metrics: total loans, customers, portfolio value, outstanding, default rate |
| PAR 30 / 60 / 90 indicators | How much of the outstanding balance is at risk by severity level |
| Total Loans by Risk Category (bar) | Spread across Current, Low Risk, Medium Risk, and High Risk tiers |
| Portfolio Collection Rate (gauge) | 94% collected — performance against the industry benchmark |
| Total Loans by Loan Status (donut) | 2,979 current, 571 default, 372 overdue |
| Outstanding Balance Breakdown (table) | 81.9% of outstanding balance sits in defaulted loans |
| Key Metrics Summary | Qualitative scorecard with strengths, concerns, and portfolio composition |

**Key takeaway:** The 93.5% collection rate confirms strong day-to-day operations. But with a 14.6% default rate above the 10% target and outstanding balance concentrated in legacy defaults, the portfolio has a quality problem that headline collection figures alone don't reveal.

---

### Page 2: Strategic Risk Analysis

| Visual | What It Shows |
|---|---|
| Default Rate by Region (bar) | North East at 23.8% vs South South at 12.2% |
| Default Rate by Business Type (bar) | Farmers at 20.0% vs Transport operators at 12.7% |
| Default Rate by Loan Cycle (bar) | Cycle 1 at 22.9% declining to Cycle 5 at 3.2% |
| Portfolio Quality over Time (line) | Vintage trend showing quality decline in Aug 2024 and Feb 2025 cohorts |
| Regional Performance & Action Table | Exit / Reduce / Maintain / Grow classification per region |
| Key Insights Panel | Critical risk zones, proven success factors, quality deterioration alerts |

**Key takeaway:** Geography is the dominant risk factor. The North-South performance gap is structural — driven by infrastructure, security, and economic conditions, not officer quality. The repeat borrower effect (4.2× risk reduction) is the clearest evidence for customer retention as a risk management strategy.

---

### Page 3: Operational Performance

| Visual | What It Shows |
|---|---|
| Officer Performance Table | Default rate, collection rate, and capacity utilisation per officer |
| Vintage Performance Matrix | Monthly and annual cohort performance broken down by year |
| Regional Action Matrix | Current vs target portfolio allocation with projected impact |
| Officer Capacity vs Default Rate (scatter) | Visual relationship between officer overload and credit quality |
| Strategic Action Plan | Full implementation roadmap with expected financial outcomes |

**Key takeaway:** Officer OFF041 is managing 681 loans against a system capacity of 89 — a 765% utilisation rate. This is a structural capacity failure that directly degrades loan quality, not a performance issue. The strategic plan projects that addressing capacity mismatches and exiting the North East will reduce the default rate to 11.8% and generate ₦8–10M in additional annual profit.

---

## Dashboard Preview

### Page 1 — Portfolio Health
![Portfolio Health](dashboard/portfolio_health.png)

---

### Page 2 — Strategic Risk Analysis
![Strategic Risk Analysis](dashboard/strategic_risk_analysis.png)

---

### Page 3 — Operational Performance
![Operational Performance](dashboard/operational_performance.png)

---

## Key Insights

**1. Strong collection rate and high default rate can coexist — and do here.**  
The bank collects 93.5% of what it is owed. But 14.6% of loans have defaulted entirely. These facts are not contradictory: the performing loans are well-managed, while the problem is concentrated in specific segments that were not well-selected at origination.

**2. Geography is the single strongest predictor of default risk.**  
The 11.6-point spread between the North East (23.8%) and South South (12.2%) is larger than the combined effect of business type and loan cycle differences. This gap is consistent across officers, loan sizes, and business types — pointing to market-level structural factors, not individual borrower or officer quality. No training programme resolves a structural market problem.

**3. Repeat borrowers are a measurable risk management asset.**  
The drop from 22.9% (Cycle 1) to 3.2% (Cycle 5) is not a marginal improvement — it is a 4.2× reduction in default likelihood. Every customer retained past their second or third loan cycle is a concrete reduction in portfolio risk. The business case for prioritising repeat customers over new customer acquisition is direct and quantifiable.

**4. Portfolio quality is deteriorating — and the trend is accelerating.**  
January 2024 loans: 12.0% default. August 2024: 17.5%. February 2025: 18.2%. Newer loans performing worse than older ones is not seasonal variation — it is a pattern of eroding underwriting standards. If unaddressed, the full cost of recent cohorts will become visible as they mature over the next 6–12 months.

**5. The high PAR figures require context to interpret correctly.**  
PAR 30 stands at 85.9% of outstanding balance. This reflects a portfolio maturity effect: since 93.5% of the total portfolio has already been collected, the remaining ₦17.7M is heavily concentrated in long-standing defaulted accounts. The figure describes where the outstanding balance sits — not that 86% of active lending is currently at risk.

**6. Capacity overload is a credit quality issue, not just a staffing issue.**  
The scatter plot on Page 3 shows a clear relationship between officer overload and higher default rates in their portfolios. An officer managing 765% of capacity has less time for client visits, early delinquency follow-up, and thorough loan assessments. Overloaded officers are a risk factor the bank controls directly.

---

## Business Recommendations

### Immediate Actions (0–3 Months)

- **Exit the North East market** — close the branch, transfer ₦6.8M in performing loans to Southern regions, and write off the non-performing balance. Expected write-off: ₦1.7M (one-time). Annual savings: ₦2M. Redeploying this capital to better-performing markets generates more value than continuing to absorb losses in a structurally challenged region.
- **Audit the August 2024 and February 2025 vintages** — these cohorts underperform every comparable historical cohort. A forensic review should identify whether the issue lies in borrower selection, loan sizing, regional conditions, or officer-level practices. Until the root cause is identified, the problem cannot be corrected.
- **Freeze new approvals in the North East and North Central** pending audit findings. Originating new loans in underperforming markets while the audit is underway compounds the risk.

### Short-Term Actions (3–6 Months)

- **Hire 24 additional loan officers** — by region: South East (6, urgent), Lagos (7), South South and South West (9 combined), North Central (2). Annual cost: approximately ₦43.2M. Expected profit improvement: ₦8–10M annually. This is a risk reduction investment, not an overhead cost.
- **Implement risk-based pricing** — Northern regions: 3.0–3.5% monthly. Southern regions: 2.5–2.8% monthly. Farmer borrowers: add a 0.5% seasonal risk premium. Flat rates across segments cross-subsidise the highest-risk borrowers at the expense of the safest ones; pricing should reflect actual risk.
- **Launch a repeat borrower retention programme** — fast-track renewals for Cycle 3+ customers and automate approvals for Cycle 5+ borrowers (3.2% default rate). These customers have earned preferential treatment and should be prioritised over continuous first-time borrower acquisition.

### Medium-Term Strategy (6–12 Months)

- **Rebalance the portfolio geographically** — from 23% North / 77% South toward 15% North / 85% South. Target allocations: South South from 15% to 20%, South West from 18% to 23%, Lagos from 27% to 30%.
- **Introduce harvest-linked repayment schedules for farmers** — farmers default at 20.0% but this largely reflects cash flow timing rather than unwillingness to repay. Aligning repayment dates with harvest seasons reduces defaults in this segment without reducing credit access.
- **Apply loan amount caps by cycle** — Cycle 1: ₦75,000 maximum. Cycles 2–5: progressive increase to ₦150,000. Cycle 6 and above: cap at ₦125,000 to prevent over-leverage. First-time borrowers at high loan amounts combine two risk factors simultaneously; graduated caps contain exposure while the lending relationship is being established.

---

## Limitations

**1. PAR is calculated on outstanding balance, not total portfolio.**  
This is the correct methodology for microfinance PAR reporting, but it means PAR percentages are not directly comparable to default rate percentages. A PAR 30 of 85.9% does not mean 85.9% of active loans are overdue.

**2. Loss figures assume no recovery.**  
Outstanding balance figures treat defaulted loan balances as total losses. In practice, some portion is recovered through collections activity. All exposure figures in this analysis are upper-bound estimates.

**3. No probability of default model.**  
Default rates here are observed historical frequencies segmented by borrower characteristics. They are descriptive, not predictive — they cannot be used directly as credit scores or origination pricing without additional statistical modelling.

**4. Simulated dataset.**  
This analysis uses simulated data modelled on Nigerian microfinance bank characteristics. The patterns, relationships, and magnitudes are designed to be realistic, but the findings should not be applied directly to a real institution without validation against its actual loan book.

**5. No instalment-level payment history.**  
The dataset records overall days past due but not a month-by-month repayment track for each loan. Intermediate delinquency data — 30-day and 60-day missed payments before formal default — would enable earlier warning analysis that is not currently possible with this dataset.

---

## Conclusion

This project produced a complete credit risk and portfolio monitoring analysis — covering data preparation, SQL-based risk segmentation, vintage quality tracking, officer performance assessment, and a three-page interactive dashboard built in Power BI.

Three findings carry the most direct strategic weight. First, geography is the dominant risk variable — the North-South default gap is structural and cannot be fixed through better officers or more training. The correct response is capital reallocation. Second, repeat borrowers are quantifiably and significantly safer — a 4.2× default reduction makes customer retention a financial strategy, not just a service goal. Third, portfolio quality is deteriorating in recent cohorts — the worsening vintage trend is an early warning that the bank's lending standards have slipped, and the cost of the February 2025 cohort has not yet fully appeared in the portfolio.

The recommended strategy — exit the North East, hire 24 officers, implement risk-based pricing, and shift capital toward Southern regions — is projected to reduce the default rate from 14.6% to 11.8% and generate ₦8–10M in additional annual profit within 12 months, with a 3-year NPV of ₦12–15M.

> *A 14.6% default rate and a 93.5% collection rate in the same portfolio tells you two things: the bank knows how to collect — it needs to get better at choosing who to lend to.*

---

## Repository Structure

```
nigerian-mfi-portfolio-analysis/
│
├── README.md
│
├── dashboard/
│   ├── portfolio_health.png
│   ├── strategic_risk_analysis.png
│   └── operational_performance.png
│
└── sql/
    ├── README.md                          # Guide to all 6 scripts and key concepts
    ├── 01_schema_and_setup.sql            # Table creation and raw data backup
    ├── 02_data_cleaning.sql               # Null removal, standardisation, validation
    ├── 03_analytical_view.sql             # Core view with all derived metrics
    ├── 04_portfolio_overview.sql          # Executive KPIs, PAR rates, status breakdown
    ├── 05_risk_and_borrower_analysis.sql  # Business type, loan cycle, region, vintage
    └── 06_operational_performance.sql     # Officer performance and portfolio age
```

---

## 💡 Key Takeaway

> A strong collection rate and a high default rate can coexist in the same portfolio. The collection rate tells you how well performing loans are managed — the default rate tells you how well borrowers were selected in the first place.

---

*Project by Favour Chegwe — Data Analyst*  
*Tools: PostgreSQL · Power BI · DAX*  
*Dataset: Simulated Nigerian Microfinance Bank loan data*
