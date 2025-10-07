USE Merkadit;

DELIMITER //

DROP PROCEDURE IF EXISTS registerSale//

CREATE PROCEDURE registerSale(
    IN p_product_name VARCHAR(190),
    IN p_store_name VARCHAR(190),
    IN p_quantity DECIMAL(14,3),
    IN p_amount_paid DECIMAL(14,2),
    IN p_payment_method VARCHAR(60),
    IN p_payment_confirmation VARCHAR(120),
    IN p_reference_number VARCHAR(120),
    IN p_invoice_number VARCHAR(100),
    IN p_customer_name VARCHAR(190),
    IN p_discount_applied DECIMAL(12,2),
    IN p_posted_by_userId BIGINT,
    IN p_computer VARCHAR(120),
    OUT p_sale_id BIGINT
)
proc_label: BEGIN
    DECLARE v_product_id BIGINT;
    DECLARE v_business_id BIGINT;
    DECLARE v_storeSpace_id BIGINT;
    DECLARE v_contract_id BIGINT;
    DECLARE v_pos_terminal_id BIGINT;
    DECLARE v_customer_id BIGINT;
    DECLARE v_payment_type_id BIGINT;
    DECLARE v_current_stock DECIMAL(14,3);
    DECLARE v_unit_price DECIMAL(12,2);
    DECLARE v_subtotal DECIMAL(14,2);
    DECLARE v_tax DECIMAL(14,2);
    DECLARE v_total DECIMAL(14,2);
    DECLARE v_line_total DECIMAL(14,2);
    DECLARE v_checksum VARCHAR(120);
    DECLARE v_invoice_status_id BIGINT DEFAULT 1;
    DECLARE v_inv_trans_type_id BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_sale_id = NULL;
        ROLLBACK;
    END;

    START TRANSACTION;
    
    -- Inicializar a NULL
    SET p_sale_id = NULL;
    SET v_checksum = MD5(CONCAT(p_product_name, NOW(), p_posted_by_userId));

    -- Validar producto
    SELECT id, business_id INTO v_product_id, v_business_id 
    FROM Products 
    WHERE name = p_product_name AND Active = 1 
    LIMIT 1;

    IF v_product_id IS NULL THEN
        ROLLBACK;
        LEAVE proc_label;
    END IF;

    -- Obtener storeSpace desde contrato vigente
    SELECT c.storeSpace_id INTO v_storeSpace_id 
    FROM Contracts c 
    WHERE c.business_id = v_business_id 
      AND c.start_date <= CURDATE() 
      AND (c.end_date IS NULL OR c.end_date >= CURDATE())
    ORDER BY c.start_date DESC
    LIMIT 1;

    IF v_storeSpace_id IS NULL THEN
        ROLLBACK;
        LEAVE proc_label;
    END IF;

    -- Obtener contrato vigente
    SELECT id INTO v_contract_id 
    FROM Contracts 
    WHERE business_id = v_business_id 
      AND storeSpace_id = v_storeSpace_id 
      AND start_date <= CURDATE() 
      AND (end_date IS NULL OR end_date >= CURDATE())
    ORDER BY start_date DESC
    LIMIT 1;

    IF v_contract_id IS NULL THEN
        ROLLBACK;
        LEAVE proc_label;
    END IF;

    -- Obtener terminal POS (opcional)
    SELECT id INTO v_pos_terminal_id 
    FROM POSTerminals 
    WHERE storeSpace_id = v_storeSpace_id AND is_active = 1 
    LIMIT 1;

    -- Verificar stock
    SELECT quantity_on_hand INTO v_current_stock 
    FROM InventoryItems 
    WHERE storeSpace_id = v_storeSpace_id AND product_id = v_product_id 
    LIMIT 1;

    IF v_current_stock IS NULL OR v_current_stock < p_quantity THEN
        ROLLBACK;
        LEAVE proc_label;
    END IF;

    -- Obtener precio
    SELECT pli.selling_price INTO v_unit_price 
    FROM PriceListItems pli 
    INNER JOIN PriceLists pl ON pl.id = pli.price_list_id 
    WHERE pli.product_id = v_product_id 
      AND pl.storeSpace_id = v_storeSpace_id 
      AND (pl.valid_to IS NULL OR pl.valid_to >= CURDATE())
    ORDER BY pl.valid_from DESC 
    LIMIT 1;

    IF v_unit_price IS NULL THEN
        ROLLBACK;
        LEAVE proc_label;
    END IF;

    -- Calcular totales
    SET v_subtotal = ROUND(v_unit_price * p_quantity, 2);
    SET v_line_total = v_subtotal - COALESCE(p_discount_applied, 0);
    SET v_tax = ROUND(v_line_total * 0.13, 2);
    SET v_total = v_line_total + v_tax;

    -- Validar pago
    IF p_amount_paid < v_total THEN
        ROLLBACK;
        LEAVE proc_label;
    END IF;

    -- Manejar cliente (opcional)
    IF p_customer_name IS NOT NULL AND TRIM(p_customer_name) != '' THEN
        SELECT id INTO v_customer_id 
        FROM Customers 
        WHERE name = p_customer_name 
        LIMIT 1;

        IF v_customer_id IS NULL THEN
            INSERT INTO Customers (name) VALUES (p_customer_name);
            SET v_customer_id = LAST_INSERT_ID();
        END IF;
    END IF;

    -- Tipo de pago
    SELECT id INTO v_payment_type_id 
    FROM PaymentTypes 
    WHERE name = p_payment_method 
    LIMIT 1;

    IF v_payment_type_id IS NULL THEN
        ROLLBACK;
        LEAVE proc_label;
    END IF;

    -- Estado de factura
    SELECT id INTO v_invoice_status_id 
    FROM InvoiceStatus 
    WHERE name = 'ISSUED' 
    LIMIT 1;

    IF v_invoice_status_id IS NULL THEN
        INSERT INTO InvoiceStatus (name) VALUES ('ISSUED');
        SET v_invoice_status_id = LAST_INSERT_ID();
    END IF;

    -- Insertar venta
    INSERT INTO Sales (
        business_id, pos_terminal_id, customer_id, contract_id, invoice_status_id, 
        business_day, sale_datetime, subtotal_amount, discount_amount, tax_amount, 
        total_amount, post_time, posted_by_userId, computer, checksum
    )
    VALUES (
        v_business_id, v_pos_terminal_id, v_customer_id, v_contract_id, v_invoice_status_id, 
        CURDATE(), NOW(), v_subtotal, COALESCE(p_discount_applied, 0), v_tax, 
        v_total, NOW(), p_posted_by_userId, p_computer, v_checksum
    );

    -- CRÍTICO: Asignar el ID de la venta
    SET p_sale_id = LAST_INSERT_ID();

    -- Insertar línea de venta
    INSERT INTO SaleLines (
        sale_id, product_id, quantity, unit_price, discount_amount, 
        line_total, created_at, deleted
    )
    VALUES (
        p_sale_id, v_product_id, p_quantity, v_unit_price, COALESCE(p_discount_applied, 0), 
        v_line_total, NOW(), 0
    );

    -- Insertar pago
    INSERT INTO PaymentFromCustomers (
        sale_id, payment_type_id, amount, confirmation_code, external_reference
    )
    VALUES (
        p_sale_id, v_payment_type_id, p_amount_paid, p_payment_confirmation, p_reference_number
    );

    -- Insertar recibo
    INSERT INTO Receipts (
        sale_id, number, issued_at, invoice_status_id, 
        post_time, posted_by_userId, computer, checksum
    )
    VALUES (
        p_sale_id, p_invoice_number, NOW(), v_invoice_status_id, 
        NOW(), p_posted_by_userId, p_computer, v_checksum
    );

    -- Actualizar inventario
    UPDATE InventoryItems 
    SET quantity_on_hand = quantity_on_hand - p_quantity, 
        updated_at = NOW()
    WHERE storeSpace_id = v_storeSpace_id AND product_id = v_product_id;

    -- Tipo de transacción de inventario
    SELECT id INTO v_inv_trans_type_id 
    FROM InventoryTransactionTypes 
    WHERE name = 'SALE' 
    LIMIT 1;

    IF v_inv_trans_type_id IS NULL THEN
        INSERT INTO InventoryTransactionTypes (name) VALUES ('SALE');
        SET v_inv_trans_type_id = LAST_INSERT_ID();
    END IF;

    -- Registrar transacción de inventario
    INSERT INTO InventoryTransactions (
        storeSpace_id, product_id, type_id, quantity_delta, 
        reference_table, reference_id, occurred_at, post_time, 
        posted_by_userId, computer, checksum
    )
    VALUES (
        v_storeSpace_id, v_product_id, v_inv_trans_type_id, -p_quantity, 
        'Sales', p_sale_id, NOW(), NOW(), 
        p_posted_by_userId, p_computer, v_checksum
    );

    -- Log de operación
    INSERT INTO OperationLogs (
        operation_name, computer, checksum, success, created_at, loglevelid
    )
    VALUES (
        'registerSale', p_computer, v_checksum, 1, NOW(), 2
    );

    COMMIT;

END//

DELIMITER ;