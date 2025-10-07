-- Vista de productos más vendidos
DROP VIEW IF EXISTS vw_TopProducts;

CREATE VIEW vw_TopProducts AS
SELECT
    p.id AS product_id,
    p.name AS product_name,
    p.sku AS product_sku,
    b.trade_name AS business_name,
    pc.name AS category_name,
    br.name AS brand_name,
    -- Período
    YEAR(s.sale_datetime) AS sale_year,
    MONTH(s.sale_datetime) AS sale_month,
    DATE_FORMAT(s.sale_datetime, '%Y-%m') AS period,
    -- Métricas
    SUM(sl.quantity) AS total_quantity_sold,
    COUNT(DISTINCT s.id) AS total_transactions,
    AVG(sl.unit_price) AS avg_price,
    SUM(sl.line_total) AS total_revenue,
    -- Ranking
    RANK() OVER (
        PARTITION BY YEAR(s.sale_datetime), MONTH(s.sale_datetime) 
        ORDER BY SUM(sl.quantity) DESC
    ) AS ranking_by_quantity,
    RANK() OVER (
        PARTITION BY YEAR(s.sale_datetime), MONTH(s.sale_datetime) 
        ORDER BY SUM(sl.line_total) DESC
    ) AS ranking_by_revenue
FROM
    Products p
    INNER JOIN SaleLines sl ON p.id = sl.product_id
    INNER JOIN Sales s ON sl.sale_id = s.id
    INNER JOIN Businesses b ON p.business_id = b.id
    LEFT JOIN ProductCategories pc ON p.category_id = pc.id
    LEFT JOIN Brands br ON p.brand_id = br.id
WHERE
    sl.deleted = 0
    AND s.invoice_status_id = (SELECT id FROM InvoiceStatus WHERE name = 'ISSUED')
GROUP BY
    p.id,
    p.name,
    p.sku,
    b.trade_name,
    pc.name,
    br.name,
    YEAR(s.sale_datetime),
    MONTH(s.sale_datetime),
    DATE_FORMAT(s.sale_datetime, '%Y-%m')
ORDER BY
    sale_year DESC,
    sale_month DESC,
    total_quantity_sold DESC;