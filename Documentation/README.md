# SmartCart - E-Commerce Sales & Return Analysis 

## About the Project 

SmartCart is an e-commerce data analytics project focused on analysing sales performance, customer distribution, product profitability, and product returns.

The project uses a dataset containing five related tables covering orders, customers, products, order items, and returns from 2024 to 2026.

The aim is to explore the data, identify business trends, and present the findings through an interactive Power BI dashboard.

## Business Questions

The analysis focuses on answering the following questions:

1. How are sales and order values distributed across different countries and sales channels?
2. Which product categories and products generate the highest revenue?
3. How is the customer base distributed across different countries?
4. Which products contribute the most to overall profit?
5. What are the most common reasons for product returns?
6. How much refund value is associated with returned products?
7. What patterns can be observed in monthly sales and refund trends?

## Dataset

**Dataset Name:** Global E-Commerce Orders & Returns Dataset – 5 Related Tables (2024–2026)

**Source:** Prime Levels

The dataset contains five interconnected tables:

| Table | Number of Records |
|---|---:|
| Customers | 3,000 |
| Products | 345 |
| Orders | 14,000 |
| Order Items | 29,671 |
| Returns | 2,433 |

The dataset is synthetic and represents a global e-commerce business scenario.

## Tools & Technologies

| Tool | Purpose |
|---|---|
| Excel | Data inspection, cleaning, validation, and workbook organisation |
| SQL | Querying and analysing data across related tables |
| Python | Data processing and analysis |
| Power BI | Data modelling, DAX measures, and interactive dashboard development |
| Visual Studio Code | Project documentation and code editing |

 ## Key Performance Indicators

| Metric | Result |
|---|---:|
| Total Orders | 14,000 |
| Recorded Order Value | $7.94M |
| Delivered Revenue | $6.84M |
| Delivery Rate | 85.93% |
| Total Customers | 3,000 |
| Total Products | 345 |
| Total Item Revenue | $7.09M |
| Total Item Profit | $2.41M |
| Units Sold | 41,784 |
| Total Return Records | 2,433 |
| Total Refund Value | $410,427.05 |
| Unit Return Rate | 6.90% |

**Note:** Recorded Order Value includes all order statuses, while Delivered Revenue includes only delivered orders. Total Item Revenue is calculated separately using order-item values.

## Power BI Dashboard

The Power BI report is organised into three pages, each focusing on a different area of e-commerce performance.

### 1. Sales Overview
- Overall order value and delivery performance.
- Revenue distribution by country and sales channel.
- Monthly order value and order volume trends.
- Order status distribution across regions.
- Geographic revenue analysis.

### 2. Customer & Product Intelligence
- Customer distribution across countries.
- Revenue by product category.
- Top 10 products by revenue.
- Product-level profitability analysis.

### 3. Returns & Refund Analysis
- Return records and units returned.
- Monthly refund value trends.
- Returns by country.
- Distribution of return reasons.
- Restock status analysis.
- Top 10 products by refund value.

## Key Findings

- The Mobile App was the highest-revenue sales channel, generating approximately $2.98M in item revenue.
- The business recorded approximately $7.09M in total item revenue and $2.41M in item profit.
- The overall item profit margin was approximately 34%.
- Wrong size or fit was the most frequently recorded reason for product returns.
- The dataset recorded $410,427.05 in refunds.
- The overall unit return rate was 6.90%.

## Limitations of the Analysis

- The dataset is synthetic and does not represent verified real-world business transactions.
- The available data does not include website browsing or add-to-cart activity, so cart abandonment cannot be measured.
- Order value and delivered revenue represent different measures and should not be treated as interchangeable.
- The analysis is limited to the information and date range available in the dataset.
- Return and refund trends may be affected by the dataset's reporting period.

## Project Structure

| Folder | Contents |
|---|---|
| Data | Raw and processed datasets |
| SQL | SQL scripts and queries |
| Python | Python scripts |
| Power BI | Dashboard file and related data |
| Screenshots | Dashboard screenshots |
| Documentation | Project documentation |

## Project Status

- Data preparation and organisation completed.
- SQL and Python analysis completed.
- Power BI dashboard completed with three analytical pages.
- Project documentation completed.
