-- Business Question:
-- Do all five SmartCart tables contain the expected number of records?

SELECT 'customers' AS table_name, COUNT(*) AS total_rows
FROM smartcart.customers

UNION ALL

SELECT 'products', COUNT(*)
FROM smartcart.products

UNION ALL

SELECT 'orders', COUNT(*)
FROM smartcart.`smartcart(orders)`

UNION ALL

SELECT 'order_items', COUNT(*)
FROM smartcart.order_items

UNION ALL

SELECT 'returns', COUNT(*)
FROM smartcart.returns;

-- Business Question:
-- Are all orders linked to valid customer records?

SELECT COUNT(*) AS unmatched_orders
FROM smartcart.`smartcart(orders)` o
LEFT JOIN smartcart.customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Business Question:
-- Are all order items linked to valid orders?

SELECT COUNT(*) AS unmatched_order_items
FROM smartcart.order_items oi
LEFT JOIN smartcart.`smartcart(orders)` o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Business Question:
-- Are all order items linked to existing products?

SELECT COUNT(*) AS unmatched_products
FROM smartcart.order_items oi
LEFT JOIN smartcart.products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Business Question:
-- Are all returns linked to existing orders?

SELECT COUNT(*) AS unmatched_returns
FROM smartcart.returns r
LEFT JOIN smartcart.`smartcart(orders)` o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Business Question:
-- Are there any duplicate customer IDs?

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_ids
FROM smartcart.customers;

-- Business Question:
-- Are there any duplicate product IDs?

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_ids
FROM smartcart.products;

-- Business Question:
-- Are there any duplicate order item IDs?

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_item_id) AS unique_order_items,
    COUNT(*) - COUNT(DISTINCT order_item_id) AS duplicate_ids
FROM smartcart.order_items;

-- Business Question:
-- Are there any duplicate return IDs?

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT return_id) AS unique_returns,
    COUNT(*) - COUNT(DISTINCT return_id) AS duplicate_ids
FROM smartcart.returns;

-- Business Question:
-- Are there any duplicate order IDs?

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_ids
FROM smartcart.`smartcart(orders)`;

