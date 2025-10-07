
-- Añadir ventas por los últimos 4 meses
DELIMITER //
DROP PROCEDURE IF EXISTS generate_sales_for_month//
CREATE PROCEDURE generate_sales_for_month(
    IN p_business_id     BIGINT,
    IN p_pos_terminal_id BIGINT,
    IN p_storeSpace_id   BIGINT,
    IN p_product_id      BIGINT,
    IN p_unit_price      DECIMAL(12,2),
    IN p_year            INT,
    IN p_month           INT,
    IN p_sales_count     INT
)
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_qty INT;
    DECLARE v_sale_dt DATETIME;
    DECLARE v_sale_id BIGINT;

    DECLARE v_month_start DATE;
    DECLARE v_month_end   DATE;
    DECLARE v_days INT;

    DECLARE v_stock DECIMAL(14,3);

    DECLARE v_contract_id BIGINT;
    DECLARE v_invoice_status_id BIGINT DEFAULT NULL;
    DECLARE v_user_id BIGINT DEFAULT 1;
    DECLARE v_customer_id BIGINT DEFAULT NULL;

    DECLARE v_subtotal DECIMAL(14,2);
    DECLARE v_discount DECIMAL(14,2);
    DECLARE v_tax      DECIMAL(14,2);
    DECLARE v_total    DECIMAL(14,2);

    -- Calcular inicio y fin del mes
    SET v_month_start = STR_TO_DATE(CONCAT(p_year,'-',LPAD(p_month,2,'0'),'-01'), '%Y-%m-%d');
    SET v_month_end   = LAST_DAY(v_month_start);
    SET v_days        = DATEDIFF(v_month_end, v_month_start) + 1;

    sales_loop: WHILE v_done < p_sales_count DO
        -- Fecha y cantidad aleatorias
        SET v_sale_dt = TIMESTAMP(
            DATE_ADD(v_month_start, INTERVAL FLOOR(RAND()*v_days) DAY), 
            SEC_TO_TIME(FLOOR(RAND()*86400))
        );
        SET v_qty = 1 + FLOOR(RAND()*5);

        -- Verificar stock disponible
        SELECT quantity_on_hand INTO v_stock
        FROM InventoryItems
        WHERE storeSpace_id = p_storeSpace_id 
          AND product_id = p_product_id
        LIMIT 1;  -- Agregar LIMIT por seguridad

        IF v_stock IS NULL OR v_stock <= 0 THEN
            SET v_done = v_done + 1; 
            ITERATE sales_loop;
        END IF;
        
        IF v_qty > v_stock THEN 
            SET v_qty = FLOOR(v_stock); 
        END IF;
        
        IF v_qty = 0 THEN 
            SET v_done = v_done + 1; 
            ITERATE sales_loop; 
        END IF;

        -- Buscar contrato vigente (CORREGIDO: agregado LIMIT 1)
        SELECT c.id INTO v_contract_id
        FROM Contracts c 
        WHERE c.business_id = p_business_id 
          AND c.storeSpace_id = p_storeSpace_id 
          AND (c.end_date IS NULL OR c.end_date >= DATE(v_sale_dt)) 
          AND c.start_date <= DATE(v_sale_dt)
        ORDER BY c.start_date DESC
        LIMIT 1;  -- FIX: Tomar solo el contrato más reciente

        -- Si no hay contrato, saltar esta venta
        IF v_contract_id IS NULL THEN
            SET v_done = v_done + 1;
            ITERATE sales_loop;
        END IF;

        -- Estado de factura (CORREGIDO: agregado LIMIT 1)
        SELECT id INTO v_invoice_status_id 
        FROM InvoiceStatus 
        WHERE name = 'ISSUED'
        LIMIT 1;  -- FIX: Tomar solo un estado
        
        IF v_invoice_status_id IS NULL THEN 
            SET v_invoice_status_id = 1; 
        END IF;

        -- Calcular importes
        SET v_subtotal = ROUND(p_unit_price * v_qty, 2);
        SET v_discount = 0.00;
        SET v_tax      = ROUND(v_subtotal * 0.13, 2);
        SET v_total    = v_subtotal - v_discount + v_tax;

        -- Insertar encabezado de venta
        INSERT INTO Sales (
            business_id, pos_terminal_id, customer_id, contract_id,invoice_status_id, business_day, sale_datetime, 
            subtotal_amount, discount_amount, tax_amount, total_amount, post_time, posted_by_userId, computer, 
            checksum
        )
        VALUES (p_business_id, p_pos_terminal_id, v_customer_id, v_contract_id, v_invoice_status_id,
            DATE(v_sale_dt), v_sale_dt, v_subtotal, v_discount, v_tax, v_total, v_sale_dt, v_user_id, 'SEED', 
            SHA2(CONCAT(p_business_id, p_product_id, UNIX_TIMESTAMP(v_sale_dt), v_total), 256)
        );

        SET v_sale_id = LAST_INSERT_ID();

        -- Insertar detalle de venta
        INSERT INTO SaleLines (
            sale_id, product_id,quantity, unit_price, discount_amount, line_total, unit_price_atSale, tax_atSale, created_at
        )
        VALUES (
            v_sale_id, p_product_id, v_qty, p_unit_price, 0.00, v_subtotal, p_unit_price, v_tax, NOW()
        );

        -- Descontar del inventario
        UPDATE InventoryItems
        SET quantity_on_hand = quantity_on_hand - v_qty,
            updated_at = NOW()
        WHERE storeSpace_id = p_storeSpace_id 
          AND product_id = p_product_id;

        SET v_done = v_done + 1;
    END WHILE sales_loop;
END//

DELIMITER ;

DELIMITER ;
-- A1 vende en A-01
CALL generate_sales_for_month(@biz_A1, @pos_A,  @sp_A,  @prod_a, @price_a, 2025, 9, 60);
CALL generate_sales_for_month(@biz_A1, @pos_A,  @sp_A,  @prod_a, @price_a, 2025, 8, 55);
CALL generate_sales_for_month(@biz_A1, @pos_A,  @sp_A,  @prod_a, @price_a, 2025, 7, 67);
CALL generate_sales_for_month(@biz_A1, @pos_A,  @sp_A,  @prod_a, @price_a, 2025, 6, 52);

-- B1 vende en B-01
CALL generate_sales_for_month(@biz_B1, @pos_B1, @sp_B1, @prod_b, @price_b, 2025, 9, 58);
CALL generate_sales_for_month(@biz_B1, @pos_B1, @sp_B1, @prod_b, @price_b, 2025, 8, 62);
CALL generate_sales_for_month(@biz_B1, @pos_B1, @sp_B1, @prod_b, @price_b, 2025, 7, 50);
CALL generate_sales_for_month(@biz_B1, @pos_B1, @sp_B1, @prod_b, @price_b, 2025, 6, 69);
