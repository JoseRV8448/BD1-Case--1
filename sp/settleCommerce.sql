USE Merkadit;

DELIMITER //

DROP PROCEDURE IF EXISTS settleCommerce//

CREATE PROCEDURE settleCommerce(
    IN p_commerce_name VARCHAR(190),
    IN p_local_name VARCHAR(150),
    IN p_posted_by_userId BIGINT,
    IN p_computer VARCHAR(120)
)
proc_label: BEGIN
    DECLARE v_business_id BIGINT;
    DECLARE v_storeSpace_id BIGINT;
    DECLARE v_contract_id BIGINT;
    DECLARE v_building_id BIGINT;
    DECLARE v_year INT;
    DECLARE v_month INT;
    DECLARE v_already_settled INT DEFAULT 0;
    DECLARE v_total_sales DECIMAL(14,2) DEFAULT 0.00;
    DECLARE v_fee_percent DECIMAL(5,2);
    DECLARE v_fee_amount DECIMAL(14,2) DEFAULT 0.00;
    DECLARE v_rent_amount DECIMAL(14,2) DEFAULT 0.00;
    DECLARE v_total_due DECIMAL(14,2) DEFAULT 0.00;
    DECLARE v_business_gets DECIMAL(14,2) DEFAULT 0.00;
    DECLARE v_settlement_id BIGINT;
    DECLARE v_checksum VARCHAR(120);
    DECLARE v_ft_marketplace_id BIGINT;  -- FIX: Nueva variable
    DECLARE v_ft_business_id BIGINT;     -- FIX: Nueva variable
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'ERROR: Ocurrió un problema al liquidar el comercio' AS mensaje;
    END;
    
    START TRANSACTION;
    SET v_checksum = MD5(CONCAT(p_commerce_name, p_local_name, NOW()));
    SET v_year = YEAR(CURDATE());
    SET v_month = MONTH(CURDATE());
    
    -- Validar comercio
    SELECT id INTO v_business_id 
    FROM Businesses 
    WHERE trade_name = p_commerce_name AND deleted = 0 
    LIMIT 1;
    
    IF v_business_id IS NULL THEN
        ROLLBACK;
        SELECT CONCAT('ERROR: No se encontró el comercio: ', p_commerce_name) AS mensaje;
        LEAVE proc_label;
    END IF;
    
    -- Validar local
    SELECT id, building_id INTO v_storeSpace_id, v_building_id 
    FROM StoreSpaces 
    WHERE code = p_local_name AND deleted = 0 
    LIMIT 1;
    
    IF v_storeSpace_id IS NULL THEN
        ROLLBACK;
        SELECT CONCAT('ERROR: No se encontró el local: ', p_local_name) AS mensaje;
        LEAVE proc_label;
    END IF;
    
    -- Validar contrato
    SELECT id, sales_fee_percent, base_monthly_rent 
    INTO v_contract_id, v_fee_percent, v_rent_amount
    FROM Contracts 
    WHERE business_id = v_business_id 
      AND storeSpace_id = v_storeSpace_id 
      AND start_date <= CURDATE() 
      AND (end_date IS NULL OR end_date >= CURDATE())  -- FIX: Validar contrato vigente
    ORDER BY start_date DESC
    LIMIT 1;
    
    IF v_contract_id IS NULL THEN
        ROLLBACK;
        SELECT 'ERROR: No se encontró contrato activo para este comercio y local' AS mensaje;
        LEAVE proc_label;
    END IF;
    
    -- Verificar si ya fue liquidado
    SELECT COUNT(*) INTO v_already_settled 
    FROM Settlements 
    WHERE contract_id = v_contract_id 
      AND period_year = v_year 
      AND period_month = v_month 
      AND is_settled = 1;
      
    IF v_already_settled > 0 THEN
        ROLLBACK;
        SELECT CONCAT('ERROR: Ya fue liquidado este mes (', v_month, '/', v_year, ')') AS mensaje;
        LEAVE proc_label;
    END IF;
    
    -- Calcular ventas del mes
    SELECT COALESCE(SUM(total_amount), 0) INTO v_total_sales 
    FROM Sales 
    WHERE business_id = v_business_id 
      AND contract_id = v_contract_id 
      AND YEAR(sale_datetime) = v_year 
      AND MONTH(sale_datetime) = v_month;
    
    -- Calcular montos
    SET v_fee_amount = ROUND(v_total_sales * (v_fee_percent / 100), 2);
    SET v_total_due = v_fee_amount + v_rent_amount;
    SET v_business_gets = v_total_sales - v_total_due;
    
    -- Insertar liquidación
    INSERT INTO Settlements (
        contract_id, period_year, period_month, settled_at, 
        total_sales_amount, fee_amount, rent_amount, adjustments_amount, 
        total_due, is_settled, post_time, posted_by_userId, computer, checksum
    )
    VALUES (
        v_contract_id, v_year, v_month, NOW(), 
        v_total_sales, v_fee_amount, v_rent_amount, 0.00, 
        v_total_due, 1, NOW(), p_posted_by_userId, p_computer, v_checksum
    );
    
    SET v_settlement_id = LAST_INSERT_ID();
    
    -- FIX: Transacción financiera MARKETPLACE (dinero que entra)
    INSERT INTO FinancialTransactions (
        direction, actor_type, actor_id, source_type, source_id, 
        total, post_time, posted_by_userId, computer, checksum, 
        txn_date, source, building_id, business_id, deleted
    )
    VALUES (
        'IN', 'MARKETPLACE', 1, 'SETTLEMENT', v_settlement_id, 
        v_total_due, NOW(), p_posted_by_userId, p_computer, v_checksum, 
        NOW(), 'SETTLEMENT', v_building_id, v_business_id, 0
    );
    
    SET v_ft_marketplace_id = LAST_INSERT_ID();  -- FIX: Capturar ID inmediatamente
    
    -- FIX: Líneas de transacción para MARKETPLACE
    INSERT INTO FinancialTransactionLines (
        financialTransaction_id, account, amount, created_at, deleted
    )
    VALUES 
        (v_ft_marketplace_id, 'RENT', v_rent_amount, NOW(), 0),
        (v_ft_marketplace_id, 'FEE', v_fee_amount, NOW(), 0);
    
    -- FIX: Transacción financiera BUSINESS (dinero que recibe el negocio)
    INSERT INTO FinancialTransactions (
        direction, actor_type, actor_id, source_type, source_id, 
        total, post_time, posted_by_userId, computer, checksum, 
        txn_date, source, building_id, business_id, deleted
    )
    VALUES (
        'IN', 'BUSINESS', v_business_id, 'SETTLEMENT', v_settlement_id, 
        v_business_gets, NOW(), p_posted_by_userId, p_computer, v_checksum, 
        NOW(), 'SETTLEMENT', v_building_id, v_business_id, 0
    );
    
    SET v_ft_business_id = LAST_INSERT_ID();  -- FIX: Capturar ID
    
    -- Log de operación
    INSERT INTO OperationLogs (
        operation_name, computer, checksum, success, created_at, loglevelid
    )
    VALUES (
        'settleCommerce', p_computer, v_checksum, 1, NOW(), 2
    );
    
    COMMIT;
    
    -- Resultado exitoso
    SELECT 
        v_settlement_id AS settlement_id, 
        p_commerce_name AS comercio, 
        p_local_name AS local, 
        v_total_sales AS ventas_totales,
        v_fee_amount AS comision, 
        v_rent_amount AS renta, 
        v_total_due AS total_a_pagar, 
        v_business_gets AS negocio_recibe, 
        'Liquidación exitosa' AS mensaje;
END//

DELIMITER ;
