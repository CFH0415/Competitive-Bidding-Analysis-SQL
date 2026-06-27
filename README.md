# Construction Bid Underbidding Analysis

## Project Overview

In competitive construction bidding, **winning a contract doesn't always mean winning on price**. When a company's winning bid is substantially lower than the second-place bid, it leaves real revenue on the table — a phenomenon called **underbidding**.

This project analyzes historical bid data to answer:
- Which project categories drive the most underbidding loss?
- Are losses caused by *how often* underbidding happens, or *how much* is lost each time?
- Where should pricing strategy be reviewed first?

> **Note:** Company names, competitor names, and project identifiers have been anonymized to protect confidential information. Raw data is not included in this repository.

---

## Business Questions

| # | Question |
|---|----------|
| 1 | Which project types contribute the largest share of total underbidding loss? |
| 2 | Is underbidding loss concentrated in a few categories, or spread evenly? |
| 3 | Are losses driven by high frequency or high severity per event? |
| 4 | Which project categories should be prioritized for pricing review? |

---

## Repository Structure

```
construction-bid-analysis/
├── sql/
│   ├── 01_create_database_and_raw_table.sql   # Schema definition & data loading
│   └── 02_construction_bid_underbid_analysis.sql  # Core analysis queries
├── .gitignore
└── README.md
```

---

## Data Overview

The dataset contains historical construction bids with the following fields:

| Category | Fields |
|----------|--------|
| Bid metadata | Date, location, project description |
| Cost inputs | Diesel price, prevailing wages, material quantities |
| Bid results | Up to 15 competitor bids, engineer estimate |
| Target company | Winning bid amount, win/loss flag |
| Derived flags | `underbid_flag`, `missed_out_flag` |
| Classification | State, region, project type |

> Raw CSV data is excluded from this repository. See `.gitignore`.

---

## SQL Workflow

### Step 1 — Load Raw Data (`01_create_database_and_raw_table.sql`)

- Defines `bids_raw_v2` table schema with typed VARCHAR columns
- Loads CSV via `LOAD DATA INFILE`
- Verifies row counts and project type distribution

### Step 2 — Clean & Analyze (`02_construction_bid_underbid_analysis.sql`)

**Cleaning:**
- Casts strings to numeric types (`DECIMAL`, `UNSIGNED`)
- Handles nulls and `'NA'` strings with `NULLIF()`
- Standardizes text fields with `TRIM()`
- Creates `bids_clean` as a typed analytical table

**Analysis 1 — Contribution Analysis:**  
Identifies which project types account for the largest share of total underbidding loss.

**Analysis 2 — Frequency vs. Severity Decomposition:**  
Breaks total loss into its two components:

```
Total Underbidding Loss = Underbid Frequency × Avg Loss per Underbid Case
```

This separates *structural pricing problems* (high severity) from *operational discipline issues* (high frequency).

---

## SQL Techniques Demonstrated

- `CAST()` / `NULLIF()` for robust type conversion
- `CASE WHEN` inside `SUM()` for conditional aggregation
- Window functions: `SUM(...) OVER()` for share-of-total percentages
- `GROUP BY` with multi-metric aggregation
- Derived table / `CREATE TABLE AS SELECT` pattern
- Frequency vs. severity decomposition framework

---
## Dashboard Overview
Built an executive Tableau dashboard to analyze bid performance, geographic patterns, and competitor pricing behavior.

### Key Views
| # | View | Description |
|---|------|-------------|
| 1 | Geographic Distribution Map | Visualizes where underbidding events are concentrated across regions |
| 2 | Bomb % vs. Win % by Project Type | Compares underbidding frequency against win rate for each project category |
| 3 | Avg % Bid Difference by Competitor | Ranks competitors by how aggressively they underbid when runner-up |
| 4 | Project Type × Region Heatmap | Surfaces which project categories dominate in each geographic region |
| 5 | Contract Volume by Bid Winner | Shows bid count and total contract value won across the competitive landscape |

### Data Note
Due to confidentiality agreements, underlying data and Tableau workbook are not publicly available.
All company names, competitor names, and project identifiers have been anonymized in this documentation.

---

## Key Findings

### Analysis 1 — Loss Concentration
> **Major Reconstruction / New Road** and **Rehab — Mill & Overlay / FDR** together account for over **80% of total underbidding loss**, despite not representing 80% of bid volume.  
> Loss is highly concentrated — a Pareto-style distribution.

### Analysis 2 — Frequency vs. Severity
> High-loss categories are driven by a combination of:
> - **Frequent underbidding events** (structural pricing gaps)
> - **High average loss per event** (large contract values amplify each pricing error)

---

## Business Recommendations

1. **Prioritize pricing review** for Major Reconstruction and Rehab — Mill & Overlay / FDR categories
2. **Set pricing guardrails** (floor thresholds) for high-frequency underbid project types
3. **Investigate historical patterns** in high-severity categories — are there regional or seasonal drivers?
4. **Leverage the executive dashboard** for ongoing competitive intelligence, including:
   - Year-over-year trends in competitor bid volume and contract wins
   - Competitor specialization by project type
   - Geographic footprint of key competitors

---

## Skills Demonstrated

`MySQL` · `Data Cleaning` · `Aggregation` · `Window Functions` · `Business Analytics` · `Pricing Strategy`
