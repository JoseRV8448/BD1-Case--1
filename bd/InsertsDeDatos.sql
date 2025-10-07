-- 1. Tipos de transacción de inventario
INSERT INTO InventoryTransactionTypes (name) VALUES 
('SALE'),
('PURCHASE'),
('ADJUSTMENT'),
('RETURN'),
('DAMAGE'),
('TRANSFER'),
('INITIAL_STOCK');


-- 2. Estados de espacios
INSERT INTO SpaceStatus (name) VALUES 
('UNDER_RENOVATION'),
('RESERVED'),
('MAINTENANCE');

-- 3. Tipos de espacios
INSERT INTO SpaceTypes (name) VALUES 
('FOOD_STALL'),
('KIOSK'),
('RETAIL_STORE'),
('RESTAURANT'),
('CAFE'),
('CONVENIENCE_STORE');

-- 4. Tipos de descuento
INSERT INTO DiscountTypes (name, description, active) VALUES 
('Porcentaje', 'Descuento basado en porcentaje', 1),
('Monto_fijo', 'Descuento de monto fijo', 1),
('Compra_x_lleva_y', 'Promoción de compra x y lleva y', 1),
('Paquete', 'Descuento por paquete', 1);

-- 5. Estados de factura
INSERT INTO InvoiceStatus (name) VALUES 
('ISSUED'),
('VOIDED'),
('RETURNED');

-- 6. Tipos de negocio
INSERT INTO BusinessTypes (name) VALUES 
('GASTRONOMIC'),
('RETAIL'),
('SERVICE'),
('MIXED');

-- 7. Tipos de pago
INSERT INTO PaymentTypes (name) VALUES 
('CASH'),
('CREDIT_CARD'),
('DEBIT_CARD'),
('BANK_TRANSFER'),
('MOBILE_PAYMENT'),
('CHECK');


-- 8. Unidades de medida
INSERT INTO UnitOfMeasure (code, name) VALUES 
('UN', 'Unit'),
('KG', 'Kilogram'),
('LB', 'Pound'),
('L', 'Liter'),
('ML', 'Milliliter'),
('G', 'Gram'),
('OZ', 'Ounce'),
('DOZ', 'Dozen'),
('PK', 'Package'),
('BX', 'Box');

-- 9. Marcas comunes
INSERT INTO Brands (name) VALUES 
('Premium'),
('Economico'),
('Organico');


-- Niveles de log
INSERT INTO nv_logslevel (loglevelname, useraccounts_id) VALUES 
('Depuración', 1),
('Información', 1),
('Advertencia', 1),
('Error', 1),
('Crítico', 1);

INSERT INTO Roles (Id, name, description, created_at, updated_at) 
VALUES 
(1, 'Admin', 'Usuario con privilegios de administrador', '2025-09-30 04:01:28', '2025-09-30 04:01:28'),
(2, 'User', 'Usuario estándar con acceso limitado', '2025-09-30 04:01:28', '2025-09-30 04:01:28');

-- -------------------------------------------------------------------------------------------------------
-- Inserts
-- -------------------------------------------------------------------------------------------------------
-- 0. 1 marketplace (administrador)
INSERT INTO Marketplace (commercial_name, legal_name, tax_id, email, phone, created_at, deleted) 
VALUES ('MK1', 'Administrador Merkadit', '188590576', 'merkadit@gmail.com', '6424-8809', NOW(), 0);

-- 1. 2 edificios de ese marketplace
INSERT INTO Buildings (marketplace_id, name, created_at, code)
VALUES (1, 'Mall San Pedro', NOW(), 'MSP-A'), (1, 'Multiplaza Curridabat', NOW(), 'MPCB-B');

-- 2. Un local en el primer edificio y 2 en el segundo (requiere registrar spaceTypes y spaceStatus)
INSERT INTO SpaceTypes (name) VALUES ('GASTRONOMIC'), ('RETAIL'), ('TECH');
INSERT INTO SpaceStatus (name) VALUES ('AVAILABLE'),('NOT AVAILABLE'),('OCCUPIED');

INSERT INTO StoreSpaces (building_id, code, space_type_id, space_status_id, size_m2, level_number, zone, notes, created_at, deleted)
VALUES 
	(1, 'A-01', 1, 1, 25.00, 1, 'Ala Este', 'Sin notas', NOW(), 0),
    (2, 'B-01', 2, 1, 25.00, 2, 'Segundo piso, ala Sur', 'Sin notas', NOW(), 0),
    (2, 'B-02', 1, 1, 25.00, 1, 'Food Court', 'Sin notas', NOW(), 0);

-- 3. 4-7 negocios por local (hay que insertar business types y 5 negocios por local)
	INSERT INTO BusinessTypes (name) VALUES ('Restaurant'),('Clothing Store'),('Electronics Shop'),('Bakery'),('Coffee Shop');
	-- Local A 
	INSERT INTO Businesses (business_type_id, legal_name, trade_name, tax_id, email, phone, created_at, deleted)
	VALUES
		(1, 'Tienda A1', 'Tienda A1', '877569932', 'a1@gmail.com', '6635-9976', NOW(), 0),
		(2, 'Tienda A2', 'Tienda A2', '991874923', 'a2@gmail.com', '0011-2233', NOW(), 0),
		(3, 'Tienda A3', 'Tienda A3', '881112223', 'a3@gmail.com', '2222-3333', NOW(), 0),
		(4, 'Tienda A4', 'Tienda A4', '882223334', 'a4@gmail.com', '3333-4444', NOW(), 0),
		(5, 'Tienda A5', 'Tienda A5', '883334445', 'a5@gmail.com', '4444-5555', NOW(), 0);
		
	-- Local B (5 negocios)
	INSERT INTO Businesses (business_type_id, legal_name, trade_name, tax_id, email, phone, created_at, deleted)
	VALUES
		(1, 'Tienda B1', 'Tienda B1', '884445556', 'b1@gmail.com', '5555-6666', NOW(), 0),
		(2, 'Tienda B2', 'Tienda B2', '885556667', 'b2@gmail.com', '6666-7777', NOW(), 0),
		(3, 'Tienda B3', 'Tienda B3', '886667778', 'b3@gmail.com', '7777-8888', NOW(), 0),
		(4, 'Tienda B4', 'Tienda B4', '887778889', 'b4@gmail.com', '8888-9999', NOW(), 0),
		(5, 'Tienda B5', 'Tienda B5', '888889990', 'b5@gmail.com', '9999-0000', NOW(), 0);

	-- Local C (5 negocios)
	INSERT INTO Businesses (business_type_id, legal_name, trade_name, tax_id, email, phone, created_at, deleted)
	VALUES
		(1, 'Tienda C1', 'Tienda C1', '889990001', 'c1@gmail.com', '1111-2222', NOW(), 0),
		(2, 'Tienda C2', 'Tienda C2', '890001112', 'c2@gmail.com', '2222-3333', NOW(), 0),
		(3, 'Tienda C3', 'Tienda C3', '891112223', 'c3@gmail.com', '3333-4444', NOW(), 0),
		(4, 'Tienda C4', 'Tienda C4', '892223334', 'c4@gmail.com', '4444-5555', NOW(), 0),
		(5, 'Tienda C5', 'Tienda C5', '893334445', 'c5@gmail.com', '5555-6666', NOW(), 0);

-- 4. Contratos para cada negocio asociando con su respectivo espacio físico 
	-- Catálogo de estados
    INSERT INTO ContractStatus (name) VALUES ('ACTIVE'), ('SUSPENDED'), ('TERMINATED')
	ON DUPLICATE KEY UPDATE name = VALUES(name);
    
    -- IDs de apoyo para los 3 locales y estado ACTIVE
    SELECT id INTO @sp_A  FROM StoreSpaces WHERE code='A-01';
	SELECT id INTO @sp_B1 FROM StoreSpaces WHERE code='B-01';
	SELECT id INTO @sp_B2 FROM StoreSpaces WHERE code='B-02';
    SELECT id INTO @st_active FROM ContractStatus WHERE name='ACTIVE';
    
    -- Ahora sí los contratos, 1 por negocio
	-- Local A
    INSERT INTO Contracts  (business_id, contract_status_id, storeSpace_id, start_date, end_date, base_monthly_rent, sales_fee_percent, settlement_day)
    VALUES
		((SELECT id FROM Businesses WHERE trade_name='Tienda A1'), @st_active, @sp_A, '2025-01-01', NULL, 300000, 5.00, 10),
		((SELECT id FROM Businesses WHERE trade_name='Tienda A2'), @st_active, @sp_A, '2025-02-01', NULL, 280000, 6.00, 15),
		((SELECT id FROM Businesses WHERE trade_name='Tienda A3'), @st_active, @sp_A, '2025-02-15', NULL, 250000, 5.00, 12),
		((SELECT id FROM Businesses WHERE trade_name='Tienda A4'), @st_active, @sp_A, '2025-03-01', NULL, 260000, 7.00, 20),
		((SELECT id FROM Businesses WHERE trade_name='Tienda A5'), @st_active, @sp_A, '2025-03-10', NULL, 270000, 8.00, 25);

	-- Local B
	INSERT INTO Contracts (business_id, contract_status_id, storeSpace_id, start_date, end_date, base_monthly_rent, sales_fee_percent, settlement_day)
	VALUES	
		((SELECT id FROM Businesses WHERE trade_name='Tienda B1'), @st_active, @sp_B1, '2025-01-20', NULL, 200000, 5.00, 10),
		((SELECT id FROM Businesses WHERE trade_name='Tienda B2'), @st_active, @sp_B1, '2025-02-05', NULL, 220000, 6.00, 15),
		((SELECT id FROM Businesses WHERE trade_name='Tienda B3'), @st_active, @sp_B1, '2025-02-25', NULL, 210000, 5.00, 12),
		((SELECT id FROM Businesses WHERE trade_name='Tienda B4'), @st_active, @sp_B1, '2025-03-01', NULL, 230000, 7.00, 20),
		((SELECT id FROM Businesses WHERE trade_name='Tienda B5'), @st_active, @sp_B1, '2025-03-05', NULL, 240000, 8.00, 25);
	
    -- Local C
    INSERT INTO Contracts (business_id, contract_status_id, storeSpace_id, start_date, end_date, base_monthly_rent, sales_fee_percent, settlement_day)
	VALUES
		((SELECT id FROM Businesses WHERE trade_name='Tienda C1'), @st_active, @sp_B2, '2025-01-15', NULL, 180000, 5.00, 10),
		((SELECT id FROM Businesses WHERE trade_name='Tienda C2'), @st_active, @sp_B2, '2025-02-01', NULL, 190000, 6.00, 15),
		((SELECT id FROM Businesses WHERE trade_name='Tienda C3'), @st_active, @sp_B2, '2025-02-20', NULL, 200000, 5.00, 12),
		((SELECT id FROM Businesses WHERE trade_name='Tienda C4'), @st_active, @sp_B2, '2025-03-01', NULL, 210000, 7.00, 20),
		((SELECT id FROM Businesses WHERE trade_name='Tienda C5'), @st_active, @sp_B2, '2025-03-08', NULL, 220000, 8.00, 25);


-- 5. Inventario para 3 negocios aleatorios con diferentes productos y categorías
	-- Primero hay q insertar categorías de productos
    INSERT INTO ProductCategories (name, created_at, deleted)
	VALUES
		('Bebidas', NOW(), 0),
		('Comida', NOW(), 0),
		('Accesorios', NOW(), 0);
        

    -- IDs auxiliares
	SET @cat_beb:=(SELECT id FROM ProductCategories WHERE name='Bebidas');
    SET @cat_com:=(SELECT id FROM ProductCategories WHERE name='Comidas');
    SET @cat_acc:=(SELECT id FROM ProductCategories WHERE name='Accesorios');
    SET @brand:=(SELECT id FROM Brands WHERE name='Genérico');
    SET @uom:=(SELECT id FROM UnitOfMeasure WHERE name='Unidad');
    
    SET @biz_A1:=(SELECT id FROM Businesses WHERE trade_name='Tienda A1');
    SET @biz_B1:=(SELECT id FROM Businesses WHERE trade_name='Tienda B1');
    SET @biz_c1:=(SELECT id FROM Businesses WHERE trade_name='Tienda C1');
    
    -- Terminales por local
	SET @pos_A:=(SELECT id FROM POSTerminals WHERE storeSpace_id = @sp_A);
	SET @pos_B1:=(SELECT id FROM POSTerminals WHERE storeSpace_id = @sp_B1);
    
	INSERT INTO POSTerminals (code, is_active, storeSpace_id)
	VALUES 
		('A01-T1', 1, @sp_A),
		('B01-T1', 1, @sp_B1);

    
	INSERT INTO Products (business_id, category_id, brand_id, uom_id, sku, name, description, active)
	VALUES
		(@biz_A1, @cat_beb, @brand, @uom, 'A1-BEB-001', 'Refresco Cola', 'Bebida 355 ml', 1),
		(@biz_B1, @cat_com, @brand, @uom, 'B1-COM-001', 'Hamburguesa', 'Clásica 120 g', 1),
		(@biz_C1, @cat_acc, @brand, @uom, 'C1-ACC-001', 'Llavero souvenir', 'Metal grabado', 1);
	
    SET @prod_a := (SELECT id FROM Products WHERE sku='A1-BEB-001');
	SET @prod_b := (SELECT id FROM Products WHERE sku='B1-COM-001');
	SET @prod_c := (SELECT id FROM Products WHERE sku='C1-ACC-001');

	-- Una lista de precios por local
	INSERT INTO PriceLists (storeSpace_id, name, valid_from)
	VALUES
		(@sp_A , 'Lista A-01',  DATE_SUB(CURDATE(), INTERVAL 6 MONTH)),
		(@sp_B1, 'Lista B-01',  DATE_SUB(CURDATE(), INTERVAL 6 MONTH)),
		(@sp_B2, 'Lista B-02',  DATE_SUB(CURDATE(), INTERVAL 6 MONTH));

	SET @pl_A:=(SELECT id FROM PriceLists WHERE storeSpace_id=@sp_A  ORDER BY valid_from DESC);
	SET @pl_B1:=(SELECT id FROM PriceLists WHERE storeSpace_id=@sp_B1 ORDER BY valid_from DESC);
	SET @pl_B2:=(SELECT id FROM PriceLists WHERE storeSpace_id=@sp_B2 ORDER BY valid_from DESC);
    
    -- Ítems de la lista con costos/precios de venta
	INSERT INTO PriceListItems (price_list_id, product_id, cost_price, selling_price)
	VALUES
		(@pl_A , @prod_a, 700.00, 1200.00),
		(@pl_B1, @prod_b, 1500.00, 2500.00),
		(@pl_B2, @prod_c, 800.00, 1500.00);

	-- Para usar luego en ventas
	SET @price_a := (SELECT selling_price FROM PriceListItems WHERE product_id=@prod_a ORDER BY price_list_id DESC LIMIT 1);
	SET @price_b := (SELECT selling_price FROM PriceListItems WHERE product_id=@prod_b ORDER BY price_list_id DESC LIMIT 1);
	SET @price_c := (SELECT selling_price FROM PriceListItems WHERE product_id=@prod_c ORDER BY price_list_id DESC LIMIT 1);
    
	-- Stock inicial alto en el local correspondiente
	INSERT INTO InventoryItems (storeSpace_id, product_id, quantity_on_hand, created_at, deleted)
	VALUES
		(@sp_A , @prod_a, 2000, NOW(), 0),
		(@sp_B1, @prod_b, 2000, NOW(), 0),
		(@sp_B2, @prod_c, 2000, NOW(), 0);
