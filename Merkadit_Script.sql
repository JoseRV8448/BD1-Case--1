-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Merkadit
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `Merkadit` ;

-- -----------------------------------------------------
-- Schema Merkadit
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Merkadit` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `Merkadit` ;

-- -----------------------------------------------------
-- Table `Merkadit`.`UserAccounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`UserAccounts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`UserAccounts` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(100) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `email` VARCHAR(190) NULL DEFAULT NULL,
  `full_name` VARCHAR(190) NULL DEFAULT NULL,
  `is_active` TINYINT(1) NULL DEFAULT '1',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`AuditTrails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`AuditTrails` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`AuditTrails` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `table_name` VARCHAR(120) NOT NULL,
  `record_id` BIGINT NOT NULL,
  `action` VARCHAR(20) NOT NULL,
  `user_id` BIGINT NULL DEFAULT NULL,
  `old_values` JSON NULL DEFAULT NULL,
  `new_values` JSON NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `table_name` (`table_name` ASC, `record_id` ASC, `created_at` ASC) VISIBLE,
  INDEX `AuditTrailsuser_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `AuditTrailsuser_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Brands`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Brands` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Brands` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`BusinessTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`BusinessTypes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`BusinessTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Businesses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Businesses` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Businesses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_type_id` BIGINT NOT NULL,
  `legal_name` VARCHAR(190) NOT NULL,
  `trade_name` VARCHAR(190) NOT NULL,
  `tax_id` VARCHAR(60) NOT NULL,
  `email` VARCHAR(190) NOT NULL,
  `phone` VARCHAR(60) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `Businesses_business_type_id` (`business_type_id` ASC) VISIBLE,
  CONSTRAINT `Businesses_business_type_id`
    FOREIGN KEY (`business_type_id`)
    REFERENCES `Merkadit`.`BusinessTypes` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`ProductCategories`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`ProductCategories` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`ProductCategories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `parent_id` BIGINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC, `parent_id` ASC) VISIBLE,
  INDEX `productCategory_parent_id` (`parent_id` ASC) VISIBLE,
  CONSTRAINT `productCategory_parent_id`
    FOREIGN KEY (`parent_id`)
    REFERENCES `Merkadit`.`ProductCategories` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`UnitOfMeasure`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`UnitOfMeasure` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`UnitOfMeasure` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(30) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `code` (`code` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Products` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Products` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NOT NULL,
  `category_id` BIGINT NULL DEFAULT NULL,
  `brand_id` BIGINT NULL DEFAULT NULL,
  `uom_id` BIGINT NULL DEFAULT NULL,
  `sku` VARCHAR(100) NOT NULL,
  `name` VARCHAR(190) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `Active` BIT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `product_business_id` (`business_id` ASC, `sku` ASC) VISIBLE,
  INDEX `product_category_id` (`category_id` ASC) VISIBLE,
  INDEX `product_brand_id` (`brand_id` ASC) VISIBLE,
  INDEX `product_uom_id` (`uom_id` ASC) VISIBLE,
  CONSTRAINT `product_brand_id`
    FOREIGN KEY (`brand_id`)
    REFERENCES `Merkadit`.`Brands` (`id`),
  CONSTRAINT `product_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
  CONSTRAINT `product_category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `Merkadit`.`ProductCategories` (`id`),
  CONSTRAINT `product_uom_id`
    FOREIGN KEY (`uom_id`)
    REFERENCES `Merkadit`.`UnitOfMeasure` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Barcodes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Barcodes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Barcodes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `product_id` BIGINT NOT NULL,
  `barcode` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `barcode` (`barcode` ASC) VISIBLE,
  INDEX `barcodes_product_id` (`product_id` ASC) VISIBLE,
  CONSTRAINT `barcodes_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `Merkadit`.`Products` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Marketplace`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Marketplace` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Marketplace` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `commercial_name` VARCHAR(100) NOT NULL,
  `legal_name` VARCHAR(150) NOT NULL,
  `tax_id` INT NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`Buildings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Buildings` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Buildings` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `marketPlace_id` BIGINT NOT NULL,
  `code` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Buildings_marketPlace_id_idx` (`marketPlace_id` ASC) VISIBLE,
  CONSTRAINT `Buildings_marketPlace_id`
    FOREIGN KEY (`marketPlace_id`)
    REFERENCES `Merkadit`.`Marketplace` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`SpaceStatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`SpaceStatus` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`SpaceStatus` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`SpaceTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`SpaceTypes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`SpaceTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`StoreSpaces`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`StoreSpaces` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`StoreSpaces` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `building_id` BIGINT NOT NULL,
  `space_type_id` BIGINT NOT NULL,
  `space_status_id` BIGINT NOT NULL,
  `code` VARCHAR(60) NOT NULL,
  `size_m2` DECIMAL(10,2) NULL DEFAULT NULL,
  `level_number` INT NOT NULL,
  `zone` VARCHAR(120) NOT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `StoreSpaces_building_id` (`building_id` ASC, `code` ASC) VISIBLE,
  INDEX `StoreSpaces_space_type_id` (`space_type_id` ASC) VISIBLE,
  INDEX `StoreSpaces_space_status_id` (`space_status_id` ASC) VISIBLE,
  CONSTRAINT `StoreSpaces_building_id`
    FOREIGN KEY (`building_id`)
    REFERENCES `Merkadit`.`Buildings` (`id`),
  CONSTRAINT `StoreSpaces_space_status_id`
    FOREIGN KEY (`space_status_id`)
    REFERENCES `Merkadit`.`SpaceStatus` (`id`),
  CONSTRAINT `StoreSpaces_space_type_id`
    FOREIGN KEY (`space_type_id`)
    REFERENCES `Merkadit`.`SpaceTypes` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`POSTerminals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`POSTerminals` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`POSTerminals` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(60) NOT NULL,
  `is_active` TINYINT(1) NULL DEFAULT '1',
  `storeSpace_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `POS_storeSpace_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `POS_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Shifts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Shifts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Shifts` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `terminal_id` BIGINT NOT NULL,
  `opened_at` DATETIME NOT NULL,
  `closed_at` DATETIME NULL DEFAULT NULL,
  `post_time` DATETIME NOT NULL,
  `posted_by_userId` BIGINT NOT NULL,
  `computer` VARCHAR(120) NOT NULL,
  `checksum` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Shifts_terminal_id` (`terminal_id` ASC) VISIBLE,
  INDEX `Shifts_posted_by_userId_idx` (`posted_by_userId` ASC) VISIBLE,
  CONSTRAINT `Shifts_terminal_id`
    FOREIGN KEY (`terminal_id`)
    REFERENCES `Merkadit`.`POSTerminals` (`id`),
  CONSTRAINT `Shifts_posted_by_userId`
    FOREIGN KEY (`posted_by_userId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`CashDrawerSessions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`CashDrawerSessions` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`CashDrawerSessions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `shift_id` BIGINT NOT NULL,
  `opening_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `closing_amount` DECIMAL(14,2) NULL DEFAULT NULL,
  `opened_at` DATETIME NOT NULL,
  `closed_at` DATETIME NULL DEFAULT NULL,
  `variance_amount` DECIMAL(14,2) NOT NULL,
  `notes` VARCHAR(200) NULL,
  PRIMARY KEY (`id`),
  INDEX `CDS_shift_id` (`shift_id` ASC) VISIBLE,
  CONSTRAINT `CDS_shift_id`
    FOREIGN KEY (`shift_id`)
    REFERENCES `Merkadit`.`Shifts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`ContractStatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`ContractStatus` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`ContractStatus` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Contracts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Contracts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Contracts` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NOT NULL,
  `contract_status_id` BIGINT NOT NULL,
  `storeSpace_id` BIGINT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  `base_monthly_rent` DECIMAL(12,2) NOT NULL,
  `sales_fee_percent` DECIMAL(5,2) NOT NULL,
  `settlement_day` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Contracts_business_id` (`business_id` ASC, `start_date` ASC) VISIBLE,
  INDEX `Contracts_contract_status_id` (`contract_status_id` ASC) VISIBLE,
  INDEX `Contracts_storeSpace_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `Contracts_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
  CONSTRAINT `Contracts_contract_status_id`
    FOREIGN KEY (`contract_status_id`)
    REFERENCES `Merkadit`.`ContractStatus` (`id`),
  CONSTRAINT `Contracts_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Customers` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Customers` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NULL DEFAULT NULL,
  `email` VARCHAR(190) NULL DEFAULT NULL,
  `phone` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InventoryItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`InventoryItems` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`InventoryItems` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `storeSpace_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `quantity_on_hand` DECIMAL(14,3) NOT NULL DEFAULT '0.000',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `inventoryItems_product_id` (`product_id` ASC) VISIBLE,
  INDEX `inventoryItems_storeSpace_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `inventoryItems_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`),
  CONSTRAINT `inventoryItems_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `Merkadit`.`Products` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InventoryTransactionTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`InventoryTransactionTypes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`InventoryTransactionTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InventoryTransactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`InventoryTransactions` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`InventoryTransactions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `storeSpace_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `type_id` BIGINT NOT NULL,
  `quantity_delta` DECIMAL(14,3) NOT NULL,
  `reference_table` VARCHAR(60) NULL DEFAULT NULL,
  `reference_id` BIGINT NULL DEFAULT NULL,
  `occurred_at` DATETIME NOT NULL,
  `post_time` TIMESTAMP NOT NULL,
  `posted_by_userId` BIGINT NOT NULL,
  `computer` VARCHAR(120) NOT NULL,
  `checksum` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `inventoryTransaction_product_id` (`product_id` ASC) VISIBLE,
  INDEX `inventoryTransaction_type_id` (`type_id` ASC) VISIBLE,
  INDEX `inventoryTransaction_storeSpace_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `inventoryTransaction_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`),
  CONSTRAINT `inventoryTransaction_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `Merkadit`.`Products` (`id`),
  CONSTRAINT `inventoryTransaction_type_id`
    FOREIGN KEY (`type_id`)
    REFERENCES `Merkadit`.`InventoryTransactionTypes` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Investments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Investments` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Investments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `building_id` BIGINT NULL DEFAULT NULL,
  `description` VARCHAR(255) NOT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  `incurred_on` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Investments_building_id` (`building_id` ASC) VISIBLE,
  CONSTRAINT `Investments_building_id`
    FOREIGN KEY (`building_id`)
    REFERENCES `Merkadit`.`Buildings` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InvoiceStatus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`InvoiceStatus` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`InvoiceStatus` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` ENUM('ISSUED', 'VOIDED', 'RETURNED') NOT NULL DEFAULT 'ISSUED',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_logslevel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`nv_logslevel` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_logslevel` (
  `loglevelid` INT NOT NULL AUTO_INCREMENT,
  `loglevelname` VARCHAR(30) NOT NULL,
  `UserAccounts_id` BIGINT NOT NULL,
  PRIMARY KEY (`loglevelid`),
  INDEX `fk_nv_logslevel_UserAccounts1_idx` (`UserAccounts_id` ASC) VISIBLE,
  CONSTRAINT `fk_nv_logslevel_UserAccounts1`
    FOREIGN KEY (`UserAccounts_id`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`OperationLogs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`OperationLogs` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`OperationLogs` (
  `operationlogid` BIGINT NOT NULL AUTO_INCREMENT,
  `operation_name` VARCHAR(120) NOT NULL,
  `computer` VARCHAR(120) NULL DEFAULT NULL,
  `checksum` VARCHAR(120) NULL DEFAULT NULL,
  `payload` JSON NULL DEFAULT NULL,
  `success` TINYINT(1) NULL DEFAULT '1',
  `error_message` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `stack_trace` TEXT NULL,
  `loglevelid` INT NOT NULL,
  PRIMARY KEY (`operationlogid`),
  INDEX `operation_name` (`operation_name` ASC, `created_at` ASC) VISIBLE,
  INDEX `fk_OperationLogs_nv_logslevel1_idx` (`loglevelid` ASC) VISIBLE,
  CONSTRAINT `fk_OperationLogs_nv_logslevel1`
    FOREIGN KEY (`loglevelid`)
    REFERENCES `Merkadit`.`nv_logslevel` (`loglevelid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PaymentTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`PaymentTypes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`PaymentTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Sales`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Sales` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Sales` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NULL,
  `pos_terminal_id` BIGINT NULL,
  `customer_id` BIGINT NULL,
  `contract_id` BIGINT NULL,
  `invoice_status_id` BIGINT NULL,
  `business_day` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `sale_datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `subtotal_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `discount_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `tax_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `total_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `post_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `posted_by_userId` BIGINT NOT NULL,
  `computer` VARCHAR(120) NOT NULL,
  `checksum` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Sales_business_id` (`business_id` ASC, `sale_datetime` ASC) VISIBLE,
  INDEX `Sales_pos_terminal_id` (`pos_terminal_id` ASC) VISIBLE,
  INDEX `Sales_customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `Sales_invoice_status_id` (`invoice_status_id` ASC) VISIBLE,
  INDEX `Sales_contract_day` (`contract_id` ASC, `business_day` ASC) VISIBLE,
  CONSTRAINT `Sales_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
  CONSTRAINT `Sales_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Merkadit`.`Customers` (`id`),
  CONSTRAINT `Sales_invoice_status_id`
    FOREIGN KEY (`invoice_status_id`)
    REFERENCES `Merkadit`.`InvoiceStatus` (`id`),
  CONSTRAINT `Sales_pos_terminal_id`
    FOREIGN KEY (`pos_terminal_id`)
    REFERENCES `Merkadit`.`POSTerminals` (`id`),
  CONSTRAINT `Sales_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PaymentFromCustomers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`PaymentFromCustomers` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`PaymentFromCustomers` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `sale_id` BIGINT NOT NULL,
  `payment_type_id` BIGINT NOT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  `confirmation_code` VARCHAR(120) NULL DEFAULT NULL,
  `external_reference` VARCHAR(120) NULL DEFAULT NULL,
  `PaymentFromCustomerscol` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `PFC_sale_id` (`sale_id` ASC) VISIBLE,
  INDEX `PFC_payment_type_id` (`payment_type_id` ASC) VISIBLE,
  CONSTRAINT `PFC_payment_type_id`
    FOREIGN KEY (`payment_type_id`)
    REFERENCES `Merkadit`.`PaymentTypes` (`id`),
  CONSTRAINT `PFC_sale_id`
    FOREIGN KEY (`sale_id`)
    REFERENCES `Merkadit`.`Sales` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Permissions` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Permissions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `code` (`code` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PriceLists`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`PriceLists` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`PriceLists` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `storeSpace_id` BIGINT NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `valid_from` DATE NOT NULL,
  `valid_to` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `priceLists_business_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `priceLists_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PriceListItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`PriceListItems` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`PriceListItems` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `price_list_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `cost_price` DECIMAL(12,2) NOT NULL,
  `selling_price` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `price_list_id` (`price_list_id` ASC, `product_id` ASC) VISIBLE,
  INDEX `PriceListItem_product_id` (`product_id` ASC) VISIBLE,
  CONSTRAINT `PriceListItem_price_list_id`
    FOREIGN KEY (`price_list_id`)
    REFERENCES `Merkadit`.`PriceLists` (`id`),
  CONSTRAINT `PriceListItem_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `Merkadit`.`Products` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Receipts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Receipts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Receipts` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `sale_id` BIGINT NOT NULL,
  `number` VARCHAR(100) NOT NULL,
  `issued_at` DATETIME NOT NULL,
  `invoice_status_id` BIGINT NOT NULL,
  `url` VARCHAR(255) NULL DEFAULT NULL,
  `post_time` DATETIME NOT NULL,
  `posted_by_userId` BIGINT NOT NULL,
  `computer` VARCHAR(120) NOT NULL,
  `checksum` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `number` (`number` ASC) VISIBLE,
  INDEX `Receipts_sale_id` (`sale_id` ASC) VISIBLE,
  INDEX `Receipts_invoice_status_id` (`invoice_status_id` ASC) VISIBLE,
  CONSTRAINT `Receipts_invoice_status_id`
    FOREIGN KEY (`invoice_status_id`)
    REFERENCES `Merkadit`.`InvoiceStatus` (`id`),
  CONSTRAINT `Receipts_sale_id`
    FOREIGN KEY (`sale_id`)
    REFERENCES `Merkadit`.`Sales` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`RentSchedules`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`RentSchedules` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`RentSchedules` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `effective_from` DATE NOT NULL,
  `effective_to` DATETIME NOT NULL,
  `base_monthly_rent` DECIMAL(12,2) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `RentSchedules_contract_id` (`contract_id` ASC, `effective_from` ASC) VISIBLE,
  CONSTRAINT `RentSchedules_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`ReportingPeriods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`ReportingPeriods` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`ReportingPeriods` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `period_year` INT NOT NULL,
  `period_month` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `period_year` (`period_year` ASC, `period_month` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Roles` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Roles` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`RolePermissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`RolePermissions` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`RolePermissions` (
  `role_id` BIGINT NOT NULL,
  `permission_id` BIGINT NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  INDEX `fk_RolePermission_permission_id` (`permission_id` ASC) VISIBLE,
  CONSTRAINT `fk_RolePermission_permission_id`
    FOREIGN KEY (`permission_id`)
    REFERENCES `Merkadit`.`Permissions` (`id`),
  CONSTRAINT `fk_RolePermission_role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `Merkadit`.`Roles` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`SaleLines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`SaleLines` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`SaleLines` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `sale_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `quantity` DECIMAL(14,3) NOT NULL,
  `unit_price` DECIMAL(12,2) NOT NULL,
  `discount_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `line_total` DECIMAL(14,2) NOT NULL,
  `unit_price_atSale` DECIMAL(14,2) NULL,
  `tax_atSale` DECIMAL(14,2) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `saleLines_sale_id` (`sale_id` ASC) VISIBLE,
  INDEX `saleLines_product_id` (`product_id` ASC) VISIBLE,
  CONSTRAINT `saleLines_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `Merkadit`.`Products` (`id`),
  CONSTRAINT `saleLines_sale_id`
    FOREIGN KEY (`sale_id`)
    REFERENCES `Merkadit`.`Sales` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Settlements`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Settlements` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Settlements` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `period_year` INT NOT NULL,
  `period_month` INT NOT NULL,
  `settled_at` DATETIME NULL,
  `total_sales_amount` DECIMAL(14,2) ZEROFILL NOT NULL DEFAULT '0.00',
  `fee_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `rent_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `adjustments_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `total_due` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `is_settled` BIT NOT NULL DEFAULT 0,
  `post_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `posted_by_userId` BIGINT NOT NULL,
  `computer` VARCHAR(120) NOT NULL,
  `checksum` VARCHAR(120) NOT NULL,
  `settlement_month` DATE GENERATED ALWAYS AS (DATE_FORMAT(post_time, '%Y-%m-01')) STORED,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Settlements_contract_id` (`contract_id` ASC, `period_year` ASC, `period_month` ASC) VISIBLE,
  INDEX `Settlements_posted_by_userId_idx` (`posted_by_userId` ASC) VISIBLE,
  UNIQUE INDEX `Settlements_contract_mont` (`contract_id` ASC) VISIBLE,
  CONSTRAINT `Settlements_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`),
  CONSTRAINT `Settlements_posted_by_userId`
    FOREIGN KEY (`posted_by_userId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`UserRoles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`UserRoles` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`UserRoles` (
  `user_id` BIGINT NOT NULL,
  `role_id` BIGINT NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  INDEX `UserRolesr_role_id` (`role_id` ASC) VISIBLE,
  CONSTRAINT `UserRolesr_role_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `Merkadit`.`Roles` (`id`),
  CONSTRAINT `UserRolesr_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_countries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`nv_countries` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_countries` (
  `countryid` INT NOT NULL AUTO_INCREMENT,
  `countryname` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`countryid`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_states`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`nv_states` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_states` (
  `stateid` INT NOT NULL AUTO_INCREMENT,
  `statename` VARCHAR(30) NOT NULL,
  `nv_countries_countryid` INT NOT NULL,
  PRIMARY KEY (`stateid`),
  INDEX `fk_nv_states_nv_countries1_idx` (`nv_countries_countryid` ASC) VISIBLE,
  CONSTRAINT `fk_nv_states_nv_countries1`
    FOREIGN KEY (`nv_countries_countryid`)
    REFERENCES `Merkadit`.`nv_countries` (`countryid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_cities`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`nv_cities` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_cities` (
  `cityid` INT NOT NULL AUTO_INCREMENT,
  `cityname` VARCHAR(30) NOT NULL,
  `nv_states_stateid` INT NOT NULL,
  PRIMARY KEY (`cityid`),
  INDEX `fk_nv_cities_nv_states1_idx` (`nv_states_stateid` ASC) VISIBLE,
  CONSTRAINT `fk_nv_cities_nv_states1`
    FOREIGN KEY (`nv_states_stateid`)
    REFERENCES `Merkadit`.`nv_states` (`stateid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`Addresses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Addresses` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Addresses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `address1` VARCHAR(60) NOT NULL,
  `address2` VARCHAR(60) NULL,
  `zipcode` VARCHAR(8) NOT NULL,
  `geolocation` POINT NOT NULL,
  `nv_cities_cityid` INT NOT NULL,
  PRIMARY KEY (`id`),
  SPATIAL INDEX `locationindex` (`geolocation`) VISIBLE,
  INDEX `fk_Addresses_nv_cities1_idx` (`nv_cities_cityid` ASC) VISIBLE,
  CONSTRAINT `fk_Addresses_nv_cities1`
    FOREIGN KEY (`nv_cities_cityid`)
    REFERENCES `Merkadit`.`nv_cities` (`cityid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`DiscountTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`DiscountTypes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`DiscountTypes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `active` BIT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`Discounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Discounts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Discounts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Businesses_id` BIGINT NOT NULL,
  `code` VARCHAR(20) NULL,
  `name` VARCHAR(30) NOT NULL,
  `description` VARCHAR(255) NULL,
  `discount_percentage` DECIMAL(5,2) NULL,
  `discount_amount` DECIMAL(12,2) NULL,
  `min_purchase_amount` DECIMAL(12,2) NULL,
  `max_discount_amount` DECIMAL(12,2) NULL,
  `valid_from` DATETIME NULL,
  `valod_to` DATETIME NULL,
  `max_uses_per_customer` INT NULL,
  `active` BIT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DiscountTypes_id` INT NOT NULL,
  `Customers_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`, `DiscountTypes_id`),
  INDEX `fk_Discounts_Businesses1_idx` (`Businesses_id` ASC) VISIBLE,
  INDEX `fk_Discounts_DiscountTypes1_idx` (`DiscountTypes_id` ASC) VISIBLE,
  INDEX `fk_Discounts_Customers1_idx` (`Customers_id` ASC) VISIBLE,
  CONSTRAINT `fk_Discounts_Businesses1`
    FOREIGN KEY (`Businesses_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Discounts_DiscountTypes1`
    FOREIGN KEY (`DiscountTypes_id`)
    REFERENCES `Merkadit`.`DiscountTypes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Discounts_Customers1`
    FOREIGN KEY (`Customers_id`)
    REFERENCES `Merkadit`.`Customers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`DiscountProducts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`DiscountProducts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`DiscountProducts` (
  `Discounts_id` INT NOT NULL,
  `id` INT NOT NULL,
  `Products_id` BIGINT NOT NULL,
  PRIMARY KEY (`Discounts_id`, `id`, `Products_id`),
  INDEX `fk_Discounts_has_Products_Products1_idx` (`Products_id` ASC) VISIBLE,
  INDEX `fk_Discounts_has_Products_Discounts1_idx` (`Discounts_id` ASC, `id` ASC) VISIBLE,
  CONSTRAINT `fk_Discounts_has_Products_Discounts1`
    FOREIGN KEY (`Discounts_id` , `id`)
    REFERENCES `Merkadit`.`Discounts` (`id` , `DiscountTypes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Discounts_has_Products_Products1`
    FOREIGN KEY (`Products_id`)
    REFERENCES `Merkadit`.`Products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`DiscountUsage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`DiscountUsage` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`DiscountUsage` (
  `Discounts_id` INT NOT NULL,
  `id` INT NOT NULL,
  `Sales_id` BIGINT NOT NULL,
  `Customers_id` BIGINT NOT NULL,
  `discount_amount_applied` DECIMAL(12,2) NOT NULL,
  `used_at` DATETIME NOT NULL,
  PRIMARY KEY (`Discounts_id`, `id`, `Sales_id`),
  INDEX `fk_Discounts_has_Sales_Sales1_idx` (`Sales_id` ASC) VISIBLE,
  INDEX `fk_Discounts_has_Sales_Discounts1_idx` (`Discounts_id` ASC, `id` ASC) VISIBLE,
  INDEX `fk_DiscountUsage_Customers1_idx` (`Customers_id` ASC) VISIBLE,
  CONSTRAINT `fk_Discounts_has_Sales_Discounts1`
    FOREIGN KEY (`Discounts_id` , `id`)
    REFERENCES `Merkadit`.`Discounts` (`id` , `DiscountTypes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Discounts_has_Sales_Sales1`
    FOREIGN KEY (`Sales_id`)
    REFERENCES `Merkadit`.`Sales` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_DiscountUsage_Customers1`
    FOREIGN KEY (`Customers_id`)
    REFERENCES `Merkadit`.`Customers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`SaleLineDiscounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`SaleLineDiscounts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`SaleLineDiscounts` (
  `Discounts_id` INT NOT NULL,
  `Discounts_DiscountTypes_id` INT NOT NULL,
  `SaleLines_id` BIGINT NOT NULL,
  `discount_amount` DECIMAL(12,2) NOT NULL,
  `discount_percentage_applied` DECIMAL(5,2) NULL,
  PRIMARY KEY (`Discounts_id`, `Discounts_DiscountTypes_id`, `SaleLines_id`),
  INDEX `fk_Discounts_has_SaleLines_SaleLines1_idx` (`SaleLines_id` ASC) VISIBLE,
  INDEX `fk_Discounts_has_SaleLines_Discounts1_idx` (`Discounts_id` ASC, `Discounts_DiscountTypes_id` ASC) VISIBLE,
  CONSTRAINT `fk_Discounts_has_SaleLines_Discounts1`
    FOREIGN KEY (`Discounts_id` , `Discounts_DiscountTypes_id`)
    REFERENCES `Merkadit`.`Discounts` (`id` , `DiscountTypes_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Discounts_has_SaleLines_SaleLines1`
    FOREIGN KEY (`SaleLines_id`)
    REFERENCES `Merkadit`.`SaleLines` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`ContractSpaces`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`ContractSpaces` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`ContractSpaces` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `storeSpace_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `CS_contract_id_idx` (`contract_id` ASC) VISIBLE,
  INDEX `CS_storeSpace_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `CS_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CS_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`ContractFeeRules`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`ContractFeeRules` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`ContractFeeRules` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `product_category_id` BIGINT NOT NULL,
  `fee_percent` DECIMAL(5,2) NOT NULL,
  `effective_from` DATETIME NOT NULL,
  `effective_to` DATETIME NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `CFR_contract_id_idx` (`contract_id` ASC) VISIBLE,
  INDEX `CFR_product_category_id_idx` (`product_category_id` ASC) VISIBLE,
  CONSTRAINT `CFR_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CFR_product_category_id`
    FOREIGN KEY (`product_category_id`)
    REFERENCES `Merkadit`.`ProductCategories` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`FinancialTransactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`FinancialTransactions` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`FinancialTransactions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `direction` ENUM('IN', 'OUT') NOT NULL,
  `actor_type` ENUM('BUSINESS', 'MARKETPLACE') NOT NULL,
  `actor_id` BIGINT NOT NULL,
  `source_type` ENUM('SALE', 'SETTLEMENT', 'ADJUSTMENT') NOT NULL,
  `source_id` BIGINT NOT NULL,
  `total` DECIMAL(14,2) NOT NULL,
  `post_time` DATETIME NOT NULL,
  `posted_by_userId` BIGINT NOT NULL,
  `computer` VARCHAR(120) NOT NULL,
  `checksum` VARCHAR(120) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  `txn_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `source` VARCHAR(45) NOT NULL,
  `building_id` BIGINT NOT NULL,
  `business_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`FinancialTransactionLines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`FinancialTransactionLines` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`FinancialTransactionLines` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `financialTransaction_id` BIGINT NOT NULL,
  `account` ENUM('RENT', 'FEE', 'EXPENSE', 'RECEIVABLE', 'OTHER') NOT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL,
  `deleted_at` DATETIME NULL,
  `category_code` VARCHAR(45) NULL,
  `vendor` VARCHAR(120) NULL,
  `invoice_no` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `FTL_financialTransaction_id_idx` (`financialTransaction_id` ASC) VISIBLE,
  INDEX `FTL_category` (`category_code` ASC) INVISIBLE,
  INDEX `FTL_account` (`account` ASC) INVISIBLE,
  INDEX `FTL_vendor` (`vendor` ASC) INVISIBLE,
  INDEX `FTL_invoice` (`invoice_no` ASC) VISIBLE,
  CONSTRAINT `FTL_financialTransaction_id`
    FOREIGN KEY (`financialTransaction_id`)
    REFERENCES `Merkadit`.`FinancialTransactions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`UserAffiliations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`UserAffiliations` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`UserAffiliations` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `entity_type` ENUM('BUSINESS', 'MARKETPLACE') NOT NULL,
  `entity_id` BIGINT NOT NULL,
  `roleId` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  `valid_from` DATETIME NOT NULL,
  `valid_to` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `UA_userId_idx` (`userId` ASC) VISIBLE,
  INDEX `UA_roleId_idx` (`roleId` ASC) VISIBLE,
  UNIQUE INDEX `uq_UA_idx` (`userId` ASC, `entity_type` ASC, `entity_id` ASC, `roleId` ASC) VISIBLE,
  INDEX `UA_entity_idx` (`entity_type` ASC, `entity_id` ASC) VISIBLE,
  CONSTRAINT `UA_userId`
    FOREIGN KEY (`userId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `UA_roleId`
    FOREIGN KEY (`roleId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`Addresses_has_UserAccounts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Addresses_has_UserAccounts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Addresses_has_UserAccounts` (
  `Addressid` BIGINT NOT NULL,
  `UserAccountid` BIGINT NOT NULL,
  `delete` BIT(1) NOT NULL DEFAULT 1,
  `createaddress` DATE NOT NULL,
  `deleteaddress` DATE NULL,
  PRIMARY KEY (`Addressid`, `UserAccountid`),
  INDEX `fk_Addresses_has_UserAccounts_UserAccounts1_idx` (`UserAccountid` ASC) VISIBLE,
  INDEX `fk_Addresses_has_UserAccounts_Addresses1_idx` (`Addressid` ASC) VISIBLE,
  CONSTRAINT `fk_Addresses_has_UserAccounts_Addresses1`
    FOREIGN KEY (`Addressid`)
    REFERENCES `Merkadit`.`Addresses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Addresses_has_UserAccounts_UserAccounts1`
    FOREIGN KEY (`UserAccountid`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_logtypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`nv_logtypes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_logtypes` (
  `logtypeid` INT NOT NULL AUTO_INCREMENT,
  `logtypename` VARCHAR(30) NOT NULL,
  `OperationLogid` BIGINT NOT NULL,
  PRIMARY KEY (`logtypeid`),
  INDEX `fk_nv_logtypes_OperationLogs1_idx` (`OperationLogid` ASC) VISIBLE,
  CONSTRAINT `fk_nv_logtypes_OperationLogs1`
    FOREIGN KEY (`OperationLogid`)
    REFERENCES `Merkadit`.`OperationLogs` (`operationlogid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_logsources`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`nv_logsources` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_logsources` (
  `logsourceid` INT NOT NULL AUTO_INCREMENT,
  `sourcename` VARCHAR(30) NOT NULL,
  `operationlogid` BIGINT NOT NULL,
  PRIMARY KEY (`logsourceid`),
  INDEX `fk_nv_logsources_OperationLogs1_idx` (`operationlogid` ASC) VISIBLE,
  CONSTRAINT `fk_nv_logsources_OperationLogs1`
    FOREIGN KEY (`operationlogid`)
    REFERENCES `Merkadit`.`OperationLogs` (`operationlogid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`SettlementAdjustments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`SettlementAdjustments` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`SettlementAdjustments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `settlement_id` BIGINT NOT NULL,
  `type` ENUM('DEBIT', 'CREDIT') NOT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  `reason` VARCHAR(255) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_userId` BIGINT NULL,
  `updated_at` TIMESTAMP NULL,
  `deleted` BIT NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `SA_settlement_id_idx` (`settlement_id` ASC) VISIBLE,
  INDEX `SA_userId_idx` (`created_by_userId` ASC) VISIBLE,
  CONSTRAINT `SA_settlement_id`
    FOREIGN KEY (`settlement_id`)
    REFERENCES `Merkadit`.`Settlements` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `SA_userId`
    FOREIGN KEY (`created_by_userId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

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
        

	INSERT INTO Brands (name) VALUES ('Genérico');
    INSERT INTO UnitOfMeasure (code, name) VALUES ('UND', 'Unidad');
    
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
	IN p_month           INT,  -- 1..12
	IN p_sales_count     INT   -- 50..70
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
	DECLARE v_user_id BIGINT DEFAULT 1;           -- si no hay usuarios, usa 1
	DECLARE v_customer_id BIGINT DEFAULT NULL;    -- cliente opcional

	DECLARE v_subtotal DECIMAL(14,2);
	DECLARE v_discount DECIMAL(14,2);
	DECLARE v_tax      DECIMAL(14,2);
	DECLARE v_total    DECIMAL(14,2);

	/* mes */
	SET v_month_start = STR_TO_DATE(CONCAT(p_year,'-',LPAD(p_month,2,'0'),'-01'), '%Y-%m-%d');
	SET v_month_end   = LAST_DAY(v_month_start);
	SET v_days        = DATEDIFF(v_month_end, v_month_start) + 1;

	sales_loop: WHILE v_done < p_sales_count DO
    /* fecha y cantidad */
    SET v_sale_dt = TIMESTAMP(DATE_ADD(v_month_start, INTERVAL FLOOR(RAND()*v_days) DAY), SEC_TO_TIME(FLOOR(RAND()*86400)));
    SET v_qty = 1 + FLOOR(RAND()*5);

    /* stock */
    SELECT quantity_on_hand INTO v_stock
    FROM InventoryItems
    WHERE storeSpace_id = p_storeSpace_id AND product_id = p_product_id;

    IF v_stock IS NULL OR v_stock <= 0 THEN
      SET v_done = v_done + 1; ITERATE sales_loop;
    END IF;
    IF v_qty > v_stock THEN SET v_qty = v_stock; END IF;
    IF v_qty = 0 THEN SET v_done = v_done + 1; ITERATE sales_loop; END IF;

    /* contrato vigente para ese negocio/espacio */
	SELECT c.id
      INTO v_contract_id
    FROM Contracts c WHERE c.business_id   = p_business_id AND c.storeSpace_id = p_storeSpace_id AND (c.end_date IS NULL OR c.end_date >= DATE(v_sale_dt)) AND c.start_date <= DATE(v_sale_dt)
		ORDER BY c.start_date DESC;

		/* estado de factura (toma cualquiera válido del catálogo si existe) */
		SELECT id INTO v_invoice_status_id FROM InvoiceStatus ORDER BY id;
		IF v_invoice_status_id IS NULL THEN SET v_invoice_status_id = 1; END IF;

		/* importes */
		SET v_subtotal = ROUND(p_unit_price * v_qty, 2);
		SET v_discount = 0.00;
		SET v_tax      = ROUND(v_subtotal * 0.13, 2);    -- ajusta tasa si aplica otra
		SET v_total    = v_subtotal - v_discount + v_tax;

		/* encabezado: llena TODAS las columnas NOT NULL que ves en tu tabla */
		INSERT INTO Sales (business_id, pos_terminal_id, customer_id, contract_id,invoice_status_id, business_day, sale_datetime, subtotal_amount, discount_amount, tax_amount, total_amount, 
		post_time, posted_by_userId, computer, checksum)
		VALUES (p_business_id, p_pos_terminal_id, v_customer_id, v_contract_id, v_invoice_status_id,
		DATE(v_sale_dt), v_sale_dt, v_subtotal, v_discount, v_tax, v_total, v_sale_dt, v_user_id, 'SEED', SHA2(CONCAT(p_business_id, p_product_id, UNIX_TIMESTAMP(v_sale_dt), v_total), 256));

		SET v_sale_id = LAST_INSERT_ID();

		/* detalle: columnas NOT NULL según tu tabla */
		INSERT INTO SaleLines (sale_id, product_id,quantity, unit_price, discount_amount, line_total, unit_price_atSale, tax_atSale, created_at)
		VALUES (v_sale_id, p_product_id, v_qty, p_unit_price, 0.00, v_subtotal, p_unit_price, v_tax, NOW());

		/* descontar stock */
		UPDATE InventoryItems
		SET quantity_on_hand = quantity_on_hand - v_qty
		WHERE storeSpace_id = p_storeSpace_id AND product_id = p_product_id;

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
