-- ========================================
-- CONSULTAS
-- ========================================

-- 1. Reporte de negocios del mes actual
SELECT 
    business_name AS 'Negocio',
    store_space_code AS 'Local',
    building_name AS 'Edificio',
    total_sales_count AS 'Ventas',
    total_items_sold AS 'Items',
    CONCAT('₡', FORMAT(total_sales_amount, 2)) AS 'Total Ventas',
    CONCAT(fee_percentage, '%') AS 'Comisión',
    CONCAT('₡', FORMAT(fee_amount, 2)) AS 'Monto Comisión',
    CONCAT('₡', FORMAT(rent_amount, 2)) AS 'Renta',
    CONCAT('₡', FORMAT(total_due_marketplace, 2)) AS 'Total a Marketplace',
    CONCAT('₡', FORMAT(total_to_business, 2)) AS 'Recibe Negocio',
    settlement_status AS 'Estado'
FROM 
    vw_BusinessReport
WHERE 
    sale_year = YEAR(CURDATE())
    AND sale_month = MONTH(CURDATE())
ORDER BY
    total_sales_amount DESC;


-- 2. Top 10 productos del mes
SELECT 
    product_name AS 'Producto',
    business_name AS 'Negocio',
    category_name AS 'Categoría',
    total_quantity_sold AS 'Cantidad Vendida',
    CONCAT('₡', FORMAT(total_revenue, 2)) AS 'Ingreso Total',
    ranking_by_quantity AS 'Ranking'
FROM 
    vw_TopProducts
WHERE 
    sale_year = YEAR(CURDATE())
    AND sale_month = MONTH(CURDATE())
ORDER BY 
    total_quantity_sold DESC
LIMIT 10;


-- 3. Resumen por edificio del mes actual
SELECT 
    building_name AS 'Edificio',
    active_businesses AS 'Negocios Activos',
    total_sales AS 'Ventas Totales',
    CONCAT('₡', FORMAT(total_revenue, 2)) AS 'Ingresos',
    CONCAT('₡', FORMAT(total_fees, 2)) AS 'Comisiones',
    CONCAT('₡', FORMAT(total_rent, 2)) AS 'Rentas',
    CONCAT('₡', FORMAT(total_income_marketplace, 2)) AS 'Total Marketplace'
FROM 
    vw_BuildingSummary
WHERE 
    sale_year = YEAR(CURDATE())
    AND sale_month = MONTH(CURDATE())
ORDER BY
    total_revenue DESC;


-- 4. Histórico de negocio (últimos 6 meses)
SELECT 
    business_name AS 'Negocio',
    period AS 'Período',
    total_sales_count AS 'Ventas',
    CONCAT('₡', FORMAT(total_sales_amount, 2)) AS 'Total',
    settlement_status AS 'Estado Liquidación'
FROM 
    vw_BusinessReport
WHERE 
    sale_year = YEAR(CURDATE())
    AND sale_month >= MONTH(DATE_SUB(CURDATE(), INTERVAL 6 MONTH))
ORDER BY 
    business_name, 
    sale_year DESC, 
    sale_month DESC;


-- 5. Comparación mensual por negocio (año actual)
SELECT 
    business_name AS 'Negocio',
    building_name AS 'Edificio',
    sale_month AS 'Mes',
    total_sales_count AS 'Ventas',
    CONCAT('₡', FORMAT(total_sales_amount, 2)) AS 'Monto',
    CONCAT('₡', FORMAT(fee_amount, 2)) AS 'Comisión',
    CONCAT('₡', FORMAT(total_to_business, 2)) AS 'Neto Negocio'
FROM 
    vw_BusinessReport
WHERE 
    sale_year = YEAR(CURDATE())
ORDER BY 
    business_name,
    sale_month DESC;


-- 6. Productos top por categoría (mes actual)
SELECT 
    category_name AS 'Categoría',
    product_name AS 'Producto',
    business_name AS 'Negocio',
    total_quantity_sold AS 'Cantidad',
    CONCAT('₡', FORMAT(total_revenue, 2)) AS 'Ingreso',
    ranking_by_quantity AS 'Ranking'
FROM 
    vw_TopProducts
WHERE 
    sale_year = YEAR(CURDATE())
    AND sale_month = MONTH(CURDATE())
    AND ranking_by_quantity <= 5
ORDER BY 
    category_name,
    ranking_by_quantity;


-- 7. Evolución mensual por edificio (últimos 4 meses)
SELECT 
    building_name AS 'Edificio',
    period AS 'Período',
    active_businesses AS 'Negocios',
    total_sales AS 'Ventas',
    CONCAT('₡', FORMAT(total_revenue, 2)) AS 'Ingresos',
    CONCAT('₡', FORMAT(total_income_marketplace, 2)) AS 'Total Marketplace'
FROM 
    vw_BuildingSummary
WHERE 
    (sale_year = YEAR(CURDATE()) AND sale_month >= MONTH(DATE_SUB(CURDATE(), INTERVAL 4 MONTH)))
    OR (sale_year = YEAR(DATE_SUB(CURDATE(), INTERVAL 4 MONTH)) 
        AND sale_month >= MONTH(DATE_SUB(CURDATE(), INTERVAL 4 MONTH)))
ORDER BY 
    building_name,
    sale_year DESC,
    sale_month DESC;