-- =====================================================
-- PROJECT: SmartCart E-Commerce Analytics
-- FILE: 04_return_analysis.sql
-- PURPOSE: Analyse product returns, refund patterns and return rates
-- DATABASE: smartcart
-- =====================================================
-- SECTION 1: RETURN PERFORMANCE
-- =====================================================

DESCRIBE smartcart.returns;

-- Business Question:
-- Which products have the highest number of returned units?

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(r.quantity_returned) AS total_units_returned,
    COUNT(r.return_id) AS total_return_records
FROM smartcart.products p
JOIN smartcart.returns r
    ON p.product_id = r.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_units_returned DESC
LIMIT 10;

-- Business Question:
-- Which product categories have the highest number of returned units?

SELECT
    p.category,
    COUNT(DISTINCT p.product_id) AS products_with_returns,
    SUM(r.quantity_returned) AS total_units_returned,
    COUNT(r.return_id) AS total_return_records,
    ROUND(SUM(r.refund_amount_usd), 2) AS total_refund_usd
FROM smartcart.products p
JOIN smartcart.returns r
    ON p.product_id = r.product_id
GROUP BY p.category
ORDER BY total_units_returned DESC;

-- Business Question:
-- What percentage of sold units were returned in each category?

SELECT
    p.category,
    SUM(oi.quantity) AS total_units_sold,
    SUM(COALESCE(r.returned_units, 0)) AS total_units_returned,
    ROUND(
        SUM(COALESCE(r.returned_units, 0)) /
        NULLIF(SUM(oi.quantity), 0) * 100,
        2
    ) AS return_rate_pct
FROM smartcart.products p
JOIN smartcart.order_items oi
    ON p.product_id = oi.product_id
LEFT JOIN (
    SELECT
        order_item_id,
        SUM(quantity_returned) AS returned_units
    FROM smartcart.returns
    GROUP BY order_item_id
) r
    ON oi.order_item_id = r.order_item_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;



-- =====================================================
-- SECTION 2: RETURN REASONS ANALYSIS
-- =====================================================
-- Analysis 2.1: Overall Return Reasons

-- Business Question:
-- What are the most common reasons for product returns?

SELECT
    return_reason,
    COUNT(return_id) AS total_return_records,
    SUM(quantity_returned) AS total_units_returned,
    ROUND(SUM(refund_amount_usd), 2) AS total_refund_usd
FROM smartcart.returns
GROUP BY return_reason
ORDER BY total_return_records DESC;



-- Analysis 2.2: Return Reasons by Product Category

-- Business Question:
-- What are the most common return reasons within each product category?

SELECT
    p.category,
    r.return_reason,
    COUNT(r.return_id) AS total_return_records,
    SUM(r.quantity_returned) AS total_units_returned,
    ROUND(SUM(r.refund_amount_usd), 2) AS total_refund_usd
FROM smartcart.products p
JOIN smartcart.returns r
    ON p.product_id = r.product_id
GROUP BY
    p.category,
    r.return_reason
ORDER BY
    p.category,
    total_return_records DESC;
    
    -- =====================================================
-- SECTION 3: RETURN TIMING ANALYSIS
-- =====================================================

-- Analysis 3.1: Average Time to Return

-- Business Question:
-- How many days do customers typically take to return products?

SELECT
    COUNT(return_id) AS total_return_records,
    ROUND(AVG(days_to_return), 2) AS average_days_to_return,
    MIN(days_to_return) AS minimum_days_to_return,
    MAX(days_to_return) AS maximum_days_to_return
FROM smartcart.returns;

-- Analysis 3.2: Return Timing Groups

-- Business Question:
-- During which time period do customers return products most frequently?

SELECT
    CASE
        WHEN days_to_return BETWEEN 2 AND 7 THEN '2–7 Days'
        WHEN days_to_return BETWEEN 8 AND 14 THEN '8–14 Days'
        WHEN days_to_return BETWEEN 15 AND 21 THEN '15–21 Days'
        WHEN days_to_return BETWEEN 22 AND 30 THEN '22–30 Days'
    END AS return_time_group,
    COUNT(return_id) AS total_return_records,
    SUM(quantity_returned) AS total_units_returned,
    ROUND(SUM(refund_amount_usd), 2) AS total_refund_usd
FROM smartcart.returns
GROUP BY return_time_group
ORDER BY total_return_records DESC;

-- Analysis 3.3: Return Timing by Product Category

-- Business Question:
-- How does return timing vary across product categories?

SELECT
    p.category,
    CASE
        WHEN r.days_to_return BETWEEN 2 AND 7 THEN '2–7 Days'
        WHEN r.days_to_return BETWEEN 8 AND 14 THEN '8–14 Days'
        WHEN r.days_to_return BETWEEN 15 AND 21 THEN '15–21 Days'
        WHEN r.days_to_return BETWEEN 22 AND 30 THEN '22–30 Days'
    END AS return_time_group,
    COUNT(r.return_id) AS total_return_records,
    SUM(r.quantity_returned) AS total_units_returned,
    ROUND(SUM(r.refund_amount_usd), 2) AS total_refund_usd
FROM smartcart.products p
JOIN smartcart.returns r
    ON p.product_id = r.product_id
GROUP BY
    p.category,
    return_time_group
ORDER BY
    p.category,
    total_return_records DESC;
    
-- =====================================================
-- SECTION 4: REFUND AND RESTOCKING ANALYSIS
-- =====================================================

-- Analysis 4.1: Refunds by Product Category

-- Business Question:
-- Which product categories generate the highest total refund amount?

SELECT
    p.category,
    COUNT(r.return_id) AS total_return_records,
    SUM(r.quantity_returned) AS total_units_returned,
    ROUND(SUM(r.refund_amount_usd), 2) AS total_refund_usd,
    ROUND(AVG(r.refund_amount_usd), 2) AS average_refund_usd
FROM smartcart.products p
JOIN smartcart.returns r
    ON p.product_id = r.product_id
GROUP BY p.category
ORDER BY total_refund_usd DESC;

-- Analysis 4.2: Refunds by Restocking Status

-- Business Question:
-- How do refund amounts differ between restocked and non-restocked products?

SELECT
    restocked,
    COUNT(return_id) AS total_return_records,
    SUM(quantity_returned) AS total_units_returned,
    ROUND(SUM(refund_amount_usd), 2) AS total_refund_usd,
    ROUND(AVG(refund_amount_usd), 2) AS average_refund_usd
FROM smartcart.returns
GROUP BY restocked
ORDER BY total_refund_usd DESC;

-- Analysis 4.3: Restocking by Return Reason

-- Business Question:
-- How does restocking status vary across different return reasons?

SELECT
    return_reason,
    restocked,
    COUNT(return_id) AS total_return_records,
    SUM(quantity_returned) AS total_units_returned,
    ROUND(SUM(refund_amount_usd), 2) AS total_refund_usd
FROM smartcart.returns
GROUP BY
    return_reason,
    restocked
ORDER BY
    return_reason,
    total_return_records DESC;
    
-- =====================================================
-- SECTION 5: CUSTOMER RETURN ANALYSIS
-- =====================================================

-- Analysis 5.1: Customers with the Most Returns

-- Business Question:
-- Which customers have the highest number of return records?

SELECT
    customer_id,
    COUNT(return_id) AS total_return_records,
    SUM(quantity_returned) AS total_units_returned,
    ROUND(SUM(refund_amount_usd), 2) AS total_refund_usd
FROM smartcart.returns
GROUP BY customer_id
ORDER BY total_return_records DESC
LIMIT 10;

-- Analysis 5.2: Customer Return Frequency

-- Business Question:
-- How many customers have returned products once versus multiple times?

SELECT
    CASE
        WHEN return_count = 1 THEN '1 Return'
        WHEN return_count BETWEEN 2 AND 3 THEN '2–3 Returns'
        WHEN return_count BETWEEN 4 AND 5 THEN '4–5 Returns'
        ELSE '6+ Returns'
    END AS customer_return_group,
    COUNT(*) AS total_customers
FROM (
    SELECT
        customer_id,
        COUNT(return_id) AS return_count
    FROM smartcart.returns
    GROUP BY customer_id
) customer_returns
GROUP BY customer_return_group
ORDER BY total_customers DESC;

-- Analysis 5.3: Customer Order Return Rate

-- Business Question:
-- What percentage of each customer's orders had at least one return?

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT r.order_id) AS orders_with_returns,
    ROUND(
        COUNT(DISTINCT r.order_id) /
        NULLIF(COUNT(DISTINCT o.order_id), 0) * 100,
        2
    ) AS order_return_rate_pct
FROM smartcart.`smartcart(orders)` o
LEFT JOIN smartcart.returns r
    ON o.order_id = r.order_id
GROUP BY o.customer_id
HAVING COUNT(DISTINCT r.order_id) > 0
ORDER BY order_return_rate_pct DESC
LIMIT 10;

-- =====================================================
-- SECTION 6: DATA QUALITY AND ANOMALY ANALYSIS
-- =====================================================

-- Analysis 6.1: Future-Dated Returns

-- Business Question:
-- Are any product returns recorded with dates later than the dataset's latest order date?

SELECT
    COUNT(return_id) AS future_dated_returns,
    MIN(return_date) AS earliest_return_date,
    MAX(return_date) AS latest_return_date
FROM smartcart.returns
WHERE STR_TO_DATE(return_date, '%Y-%m-%d') >
      (
          SELECT MAX(STR_TO_DATE(order_date, '%Y-%m-%d'))
          FROM smartcart.`smartcart(orders)`
      );
      
   -- Analysis 6.2: Future-Dated Return Records

-- Business Question:
-- How many return records have dates later than their associated order dates?

SELECT
    COUNT(r.return_id) AS future_dated_returns,
    MIN(r.return_date) AS earliest_future_return_date,
    MAX(r.return_date) AS latest_future_return_date
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE STR_TO_DATE(r.return_date, '%d-%m-%Y') >
      STR_TO_DATE(o.order_date, '%d/%m/%Y');
      
      -- Analysis 6.3: Inspect Future-Dated Returns

-- Business Question:
-- Which individual return records have return dates later than their associated order dates?

SELECT
    r.return_id,
    r.order_id,
    r.return_date,
    o.order_date,
    r.days_to_return,
    DATEDIFF(
        STR_TO_DATE(r.return_date, '%d-%m-%Y'),
        STR_TO_DATE(o.order_date, '%d-%m-%Y')
    ) AS actual_days_between
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE STR_TO_DATE(r.return_date, '%d-%m-%Y') >
      STR_TO_DATE(o.order_date, '%d-%m-%Y')
ORDER BY actual_days_between DESC
LIMIT 20;

-- Analysis 6.4: Validate Return Duration

-- Business Question:
-- Do recorded return durations match the actual difference between order and return dates?

SELECT
    COUNT(r.return_id) AS total_return_records,
    SUM(
        CASE
            WHEN r.days_to_return =
                 DATEDIFF(
                     STR_TO_DATE(r.return_date, '%d-%m-%Y'),
                     STR_TO_DATE(o.order_date, '%d-%m-%Y')
                 )
            THEN 1
            ELSE 0
        END
    ) AS matching_duration_records,
    SUM(
        CASE
            WHEN r.days_to_return <>
                 DATEDIFF(
                     STR_TO_DATE(r.return_date, '%d-%m-%Y'),
                     STR_TO_DATE(o.order_date, '%d-%m-%Y')
                 )
            THEN 1
            ELSE 0
        END
    ) AS mismatched_duration_records
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id;
    
    -- Analysis 6.5: Missing Return Duration Values

-- Business Question:
-- How many return records have missing return duration values?

SELECT
    COUNT(*) AS total_return_records,
    SUM(
        CASE
            WHEN days_to_return IS NULL THEN 1
            ELSE 0
        END
    ) AS missing_duration_records,
    SUM(
        CASE
            WHEN days_to_return IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS available_duration_records
FROM smartcart.returns;

-- Analysis 6.6: Return Dates Before Order Dates

-- Business Question:
-- How many return records have dates earlier than their associated order dates?

SELECT
    COUNT(r.return_id) AS returns_before_order,
    MIN(r.return_date) AS earliest_return_date,
    MAX(r.return_date) AS latest_return_date
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE STR_TO_DATE(r.return_date, '%d-%m-%Y') <
      STR_TO_DATE(o.order_date, '%d-%m-%Y');
      
      -- Analysis 6.7: Same-Day Returns

-- Business Question:
-- How many return records have the same date as their associated orders?

SELECT
    COUNT(r.return_id) AS same_day_returns
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE STR_TO_DATE(r.return_date, '%d-%m-%Y') =
      STR_TO_DATE(o.order_date, '%d-%m-%Y');
      
      -- Analysis 6.8: Check Unparseable Dates

-- Business Question:
-- Are any order or return dates failing to convert into valid dates?

SELECT
    COUNT(*) AS total_return_records,
    SUM(
        CASE
            WHEN STR_TO_DATE(r.return_date, '%d-%m-%Y') IS NULL
            THEN 1 ELSE 0
        END
    ) AS unparseable_return_dates,
    SUM(
        CASE
            WHEN STR_TO_DATE(o.order_date, '%d-%m-%Y') IS NULL
            THEN 1 ELSE 0
        END
    ) AS unparseable_order_dates
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id;
    
    -- Analysis 6.9: Inspect Unparseable Order Dates

-- Business Question:
-- What format is used for order dates that cannot be parsed as DD-MM-YYYY?

SELECT
    r.return_id,
    r.order_id,
    r.return_date,
    o.order_date,
    r.days_to_return
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE STR_TO_DATE(o.order_date, '%d-%m-%Y') IS NULL
LIMIT 20;

-- Analysis 6.10: Validate Return Durations

-- Business Question:
-- Do recorded return durations match the actual date differences
-- after accounting for both order date formats?

SELECT
    COUNT(*) AS future_dated_returns,
    SUM(
        CASE
            WHEN r.days_to_return = DATEDIFF(
                STR_TO_DATE(r.return_date, '%d-%m-%Y'),
                CASE
                    WHEN o.order_date LIKE '%/%/%'
                        THEN STR_TO_DATE(o.order_date, '%m/%d/%Y')
                    ELSE STR_TO_DATE(o.order_date, '%d-%m-%Y')
                END
            )
            THEN 1 ELSE 0
        END
    ) AS matching_duration_records,
    SUM(
        CASE
            WHEN r.days_to_return <> DATEDIFF(
                STR_TO_DATE(r.return_date, '%d-%m-%Y'),
                CASE
                    WHEN o.order_date LIKE '%/%/%'
                        THEN STR_TO_DATE(o.order_date, '%m/%d/%Y')
                    ELSE STR_TO_DATE(o.order_date, '%d-%m-%Y')
                END
            )
            THEN 1 ELSE 0
        END
    ) AS mismatched_duration_records
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE STR_TO_DATE(r.return_date, '%d-%m-%Y') >
      CASE
          WHEN o.order_date LIKE '%/%/%'
              THEN STR_TO_DATE(o.order_date, '%m/%d/%Y')
          ELSE STR_TO_DATE(o.order_date, '%d-%m-%Y')
      END;

-- Analysis 6.11: Inspect Return Duration Mismatches

-- Business Question:
-- Which return records have recorded durations that differ
-- from the actual difference between order and return dates?

SELECT
    r.return_id,
    r.order_id,
    r.return_date,
    o.order_date,
    r.days_to_return AS recorded_days,
    DATEDIFF(
        STR_TO_DATE(r.return_date, '%d-%m-%Y'),
        CASE
            WHEN o.order_date LIKE '%/%/%'
                THEN STR_TO_DATE(o.order_date, '%d/%m/%Y')
            ELSE STR_TO_DATE(o.order_date, '%d-%m-%Y')
        END
    ) AS actual_days
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE STR_TO_DATE(r.return_date, '%d-%m-%Y') >
      CASE
          WHEN o.order_date LIKE '%/%/%'
              THEN STR_TO_DATE(o.order_date, '%d/%m/%Y')
          ELSE STR_TO_DATE(o.order_date, '%d-%m-%Y')
      END
  AND r.days_to_return <> DATEDIFF(
        STR_TO_DATE(r.return_date, '%d-%m-%Y'),
        CASE
            WHEN o.order_date LIKE '%/%/%'
                THEN STR_TO_DATE(o.order_date, '%d/%m/%Y')
            ELSE STR_TO_DATE(o.order_date, '%d-%m-%Y')
        END
      )
ORDER BY r.return_id
LIMIT 20;

-- Analysis 6.12: Returns After Latest Order Date

-- Business Question:
-- Are any returns recorded after the latest order date in the dataset?

SELECT
    COUNT(*) AS returns_after_latest_order,
    MIN(r.return_date) AS earliest_return_date,
    MAX(r.return_date) AS latest_return_date
FROM smartcart.returns r
WHERE STR_TO_DATE(r.return_date, '%d-%m-%Y') >
      (
          SELECT MAX(
              CASE
                  WHEN order_date LIKE '%/%/%'
                      THEN STR_TO_DATE(order_date, '%m/%d/%Y')
                  ELSE STR_TO_DATE(order_date, '%d-%m-%Y')
              END
          )
          FROM smartcart.`smartcart(orders)`
      );
      
      -- Analysis 6.13: Inspect Returns After Latest Order Date

-- Business Question:
-- Which return records occur after the latest order date in the dataset?

SELECT
    r.return_id,
    r.order_id,
    r.return_date,
    o.order_date,
    r.days_to_return
FROM smartcart.returns r
JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE STR_TO_DATE(r.return_date, '%d-%m-%Y') >
      (
          SELECT MAX(
              CASE
                  WHEN order_date LIKE '%/%/%'
                      THEN STR_TO_DATE(order_date, '%m/%d/%Y')
                  ELSE STR_TO_DATE(order_date, '%d-%m-%Y')
              END
          )
          FROM smartcart.`smartcart(orders)`
      )
ORDER BY r.return_date
LIMIT 20;

-- Analysis 6.14: Order Date Format Distribution

-- Business Question:
-- How many order records use each date format?

SELECT
    CASE
        WHEN order_date LIKE '%/%/%'
            THEN 'MM/DD/YYYY'
        ELSE 'DD-MM-YYYY'
    END AS date_format,
    COUNT(*) AS total_orders
FROM smartcart.`smartcart(orders)`
GROUP BY date_format;