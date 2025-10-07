-- Vista de reporte de negocios
DROP VIEW IF EXISTS vw_BusinessReport;

CREATE VIEW vw_BusinessReport AS
SELECT
    b.id AS business_id,
    b.trade_name AS business_name,
    b.legal_name AS legal_business_name,
    bt.name AS business_type,
    ss.id AS store_space_id,
    ss.code AS store_space_code,
    bld.name AS building_name,
    bld.id AS building_id,
    c.id AS contract_id,
    c.sales_fee_percent AS fee_percentage,
    c.base_monthly_rent AS monthly_rent,
    -- Período
    YEAR(s.sale_datetime) AS sale_year,
    MONTH(s.sale_datetime) AS sale_month,
    DATE_FORMAT(s.sale_datetime, '%Y-%m') AS period,
    -- Métricas de ventas
    COUNT(DISTINCT s.id) AS total_sales_count,
    COALESCE(SUM(sl.quantity), 0) AS total_items_sold,
    COALESCE(SUM(s.subtotal_amount), 0) AS subtotal_amount,
    COALESCE(SUM(s.discount_amount), 0) AS discount_amount,
    COALESCE(SUM(s.tax_amount), 0) AS tax_amount,
    COALESCE(SUM(s.total_amount), 0) AS total_sales_amount,
    -- Cálculos financieros
    COALESCE(SUM(s.total_amount * c.sales_fee_percent / 100), 0) AS fee_amount,
    c.base_monthly_rent AS rent_amount,
    COALESCE(SUM(s.total_amount * c.sales_fee_percent / 100), 0) + c.base_monthly_rent AS total_due_marketplace,
    COALESCE(SUM(s.total_amount), 0) - 
        (COALESCE(SUM(s.total_amount * c.sales_fee_percent / 100), 0) + c.base_monthly_rent) AS total_to_business,
    -- Estado de liquidación
    CASE 
        WHEN st.id IS NOT NULL AND st.is_settled = 1 THEN 'Liquidado'
        WHEN st.id IS NOT NULL AND st.is_settled = 0 THEN 'Pendiente'
        ELSE 'Sin liquidación'
    END AS settlement_status,
    st.id AS settlement_id,
    st.settled_at AS settlement_date,
    -- Fechas de venta
    MIN(s.sale_datetime) AS first_sale_date,
    MAX(s.sale_datetime) AS last_sale_date
FROM
    Businesses b
    INNER JOIN BusinessTypes bt ON b.business_type_id = bt.id
    INNER JOIN Contracts c ON b.id = c.business_id
    INNER JOIN StoreSpaces ss ON c.storeSpace_id = ss.id
    INNER JOIN Buildings bld ON ss.building_id = bld.id
    LEFT JOIN Sales s ON c.id = s.contract_id
    LEFT JOIN SaleLines sl ON s.id = sl.sale_id
    LEFT JOIN Settlements st ON c.id = st.contract_id 
        AND YEAR(s.sale_datetime) = st.period_year 
        AND MONTH(s.sale_datetime) = st.period_month
WHERE
    b.deleted = 0
    AND ss.deleted = 0
    AND s.id IS NOT NULL
GROUP BY
    b.id,
    b.trade_name,
    b.legal_name,
    bt.name,
    ss.id,
    ss.code,
    bld.name,
    bld.id,
    c.id,
    c.sales_fee_percent,
    c.base_monthly_rent,
    YEAR(s.sale_datetime),
    MONTH(s.sale_datetime),
    DATE_FORMAT(s.sale_datetime, '%Y-%m'),
    st.id,
    st.is_settled,
    st.settled_at
ORDER BY
    b.trade_name,
    sale_year DESC,
    sale_month DESC;