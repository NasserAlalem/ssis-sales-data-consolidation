# SSIS Multi-Source Sales Data Integration Pipeline

## Overview
An enterprise ETL solution engineered using SQL Server Integration Services (SSIS) to extract, transform, and consolidate heterogeneous sales transactions across three commercial distributors into a centralized SQL Server Data Warehouse fact table (`dbo.Fact_Sales_Consolidated`).

---

## Architecture & Data Flow
The pipeline extracts records from flat files and disparate Excel formats, applies schema alignment, normalizes date formatting, computes derived revenue metrics, and ingests into the relational target.

![SSIS Data Flow Execution](docs/screenshots/ssis_data_flow_execution.png)

### Key Transformation Challenges Resolved
* **Heterogeneous Data Ingestion:** Integrated disparate source feeds including Delimited Flat File (`.txt`), legacy Excel 97–2003 (`.xls`), and modern Excel (`.xlsx`).
* **Schema & Column Mapping:** Standardized conflicting column nomenclatures:
  * `Client Code` / `Customer Code` $\rightarrow$ Standardized Client Mapping
  * `Qty` / `QTY` / `Quantity` $\rightarrow$ `Qty`
  * `Val` / `Sales` / `Value` $\rightarrow$ `Val`
* **Date Standardization:** Standardized multi-format date representations (`DD-MM-YYYY`, `MM/DD/YYYY`, and compact strings `MMDDYYYY`) into a single `DATE` standard (`SaleDate`).
* **Derived Business Metric:** Computed inline transaction value:
  $$\text{TotalAmount} = \text{Qty} \times \text{Val}$$
* **Audit Metadata:** Appended source provenance (`SourceFile`) and ETL ingestion timestamps (`LoadDate`).

---

## Data Validation & Quality Assurance

### 1. Volume and Revenue Reconciliation
Source distribution and metric sums verified using `GROUP BY WITH ROLLUP`:
![Row Count Reconciliation](docs/screenshots/row_count_reconciliation.png)

### 2. Mathematical Integrity Assertion
Validated that zero calculation deviations exist between the derived field and underlying transaction attributes:
![Metric Accuracy Validation](docs/screenshots/metric_accuracy_validation.png)

```sql
SELECT COUNT(*) AS CalculationMismatchCount
FROM dbo.Fact_Sales_Consolidated
WHERE ABS(TotalAmount - (Qty * Val)) > 0.01;
-- Output: 0 mismatches