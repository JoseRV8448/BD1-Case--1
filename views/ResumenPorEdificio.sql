-- Vista resumen por edificio
DROP VIEW IF EXISTS vw_BuildingSummary;

CREATE VIEW vw_BuildingSummary AS
SELECT 
    bd.id AS building_id,
    bd.name AS building_name,
    -- Período
    YEAR(s.sale_datetime) AS sale_year,
    MONTH(s.sale_datetime) AS sale_month,
    DATE_FORMAT(s.sale_datetime, '%Y-%m') AS period,
    -- Métricas
    COUNT(DISTINCT b.id) AS active_businesses,
    COUNT(DISTINCT s.id) AS total_sales,
    COALESCE(SUM(s.total_amount), 0) AS total_revenue,
    COALESCE(SUM(s.total_amount * c.sales_fee_percent / 100), 0) AS total_fees,
    COALESCE(SUM(c.base_monthly_rent), 0) AS total_rent,
    COALESCE(SUM(
        c.base_monthly_rent + (s.total_amount * c.sales_fee_percent / 100)
    ), 0) AS total_income_marketplace
FROM 
    Buildings bd
    INNER JOIN StoreSpaces ss ON bd.id = ss.building_id
    INNER JOIN Contracts c ON ss.id = c.storeSpace_id
    INNER JOIN Businesses b ON c.business_id = b.id
    LEFT JOIN Sales s ON c.id = s.contract_id
WHERE 
    ss.deleted = 0
    AND b.deleted = 0
    AND s.id IS NOT NULL
GROUP BY 
    bd.id, 
    bd.name, 
    YEAR(s.sale_datetime), 
    MONTH(s.sale_datetime),
    DATE_FORMAT(s.sale_datetime, '%Y-%m')
ORDER BY 
    sale_year DESC, 
    sale_month DESC, 
    building_name;