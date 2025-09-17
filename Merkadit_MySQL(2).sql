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
-- Table `Merkadit`.`BusinessTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`BusinessTypes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`BusinessTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
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
  `business_type_id` BIGINT NULL DEFAULT NULL,
  `legal_name` VARCHAR(190) NOT NULL,
  `trade_name` VARCHAR(190) NULL DEFAULT NULL,
  `tax_id` VARCHAR(60) NULL DEFAULT NULL,
  `email` VARCHAR(190) NULL DEFAULT NULL,
  `phone` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `Businesses_business_type_id` (`business_type_id` ASC) VISIBLE,
  CONSTRAINT `Businesses_business_type_id`
    FOREIGN KEY (`business_type_id`)
    REFERENCES `Merkadit`.`BusinessTypes` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


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
  `business_id` BIGINT NULL DEFAULT NULL,
  `is_active` TINYINT(1) NULL DEFAULT '1',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username` (`username` ASC) VISIBLE,
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  INDEX `business_id` (`business_id` ASC) VISIBLE,
  CONSTRAINT `business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`))
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
-- Table `Merkadit`.`Buildings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Buildings` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Buildings` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `address` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`POSTerminals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`POSTerminals` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`POSTerminals` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NOT NULL,
  `code` VARCHAR(60) NOT NULL,
  `is_active` TINYINT(1) NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `POS_business_id` (`business_id` ASC, `code` ASC) VISIBLE,
  CONSTRAINT `POS_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Shifts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Shifts` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Shifts` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `terminal_id` BIGINT NOT NULL,
  `opened_at` DATETIME NOT NULL,
  `closed_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `Shifts_user_id` (`user_id` ASC) VISIBLE,
  INDEX `Shifts_terminal_id` (`terminal_id` ASC) VISIBLE,
  CONSTRAINT `Shifts_terminal_id`
    FOREIGN KEY (`terminal_id`)
    REFERENCES `Merkadit`.`POSTerminals` (`id`),
  CONSTRAINT `Shifts_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
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
-- Table `Merkadit`.`Floors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Floors` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Floors` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `building_id` BIGINT NOT NULL,
  `level_number` INT NOT NULL,
  `name` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Zones_building_id` (`building_id` ASC, `level_number` ASC) VISIBLE,
  CONSTRAINT `Zones_building_id`
    FOREIGN KEY (`building_id`)
    REFERENCES `Merkadit`.`Buildings` (`id`))
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
-- Table `Merkadit`.`Zones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Zones` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Zones` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `floor_id` BIGINT NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Zones_floor_id` (`floor_id` ASC, `name` ASC) VISIBLE,
  CONSTRAINT `Zones_floor_id`
    FOREIGN KEY (`floor_id`)
    REFERENCES `Merkadit`.`Floors` (`id`))
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
  `floor_id` BIGINT NULL DEFAULT NULL,
  `zone_id` BIGINT NULL DEFAULT NULL,
  `space_type_id` BIGINT NOT NULL,
  `space_status_id` BIGINT NOT NULL,
  `code` VARCHAR(60) NOT NULL,
  `size_m2` DECIMAL(10,2) NULL DEFAULT NULL,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `StoreSpaces_building_id` (`building_id` ASC, `code` ASC) VISIBLE,
  INDEX `StoreSpaces_floor_id` (`floor_id` ASC) VISIBLE,
  INDEX `StoreSpaces_zone_id` (`zone_id` ASC) VISIBLE,
  INDEX `StoreSpaces_space_type_id` (`space_type_id` ASC) VISIBLE,
  INDEX `StoreSpaces_space_status_id` (`space_status_id` ASC) VISIBLE,
  CONSTRAINT `StoreSpaces_building_id`
    FOREIGN KEY (`building_id`)
    REFERENCES `Merkadit`.`Buildings` (`id`),
  CONSTRAINT `StoreSpaces_floor_id`
    FOREIGN KEY (`floor_id`)
    REFERENCES `Merkadit`.`Floors` (`id`),
  CONSTRAINT `StoreSpaces_space_status_id`
    FOREIGN KEY (`space_status_id`)
    REFERENCES `Merkadit`.`SpaceStatus` (`id`),
  CONSTRAINT `StoreSpaces_space_type_id`
    FOREIGN KEY (`space_type_id`)
    REFERENCES `Merkadit`.`SpaceTypes` (`id`),
  CONSTRAINT `StoreSpaces_zone_id`
    FOREIGN KEY (`zone_id`)
    REFERENCES `Merkadit`.`Zones` (`id`))
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
  `store_space_id` BIGINT NOT NULL,
  `contract_status_id` BIGINT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL DEFAULT NULL,
  `base_monthly_rent` DECIMAL(12,2) NOT NULL,
  `sales_fee_percent` DECIMAL(5,2) NOT NULL,
  `settlement_day` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Contracts_business_id` (`business_id` ASC, `store_space_id` ASC, `start_date` ASC) VISIBLE,
  INDEX `Contracts_store_space_id` (`store_space_id` ASC) VISIBLE,
  INDEX `Contracts_contract_status_id` (`contract_status_id` ASC) VISIBLE,
  CONSTRAINT `Contracts_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
  CONSTRAINT `Contracts_contract_status_id`
    FOREIGN KEY (`contract_status_id`)
    REFERENCES `Merkadit`.`ContractStatus` (`id`),
  CONSTRAINT `Contracts_store_space_id`
    FOREIGN KEY (`store_space_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`ContractFeeSchedules`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`ContractFeeSchedules` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`ContractFeeSchedules` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `effective_from` DATE NOT NULL,
  `sales_fee_percent` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `CFS_contract_id` (`contract_id` ASC, `effective_from` ASC) VISIBLE,
  CONSTRAINT `CFS_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`))
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
-- Table `Merkadit`.`ExpenseTypes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`ExpenseTypes` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`ExpenseTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
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
-- Table `Merkadit`.`Expenses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Expenses` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Expenses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `expense_type_id` BIGINT NOT NULL,
  `building_id` BIGINT NULL DEFAULT NULL,
  `store_space_id` BIGINT NULL DEFAULT NULL,
  `reporting_period_id` BIGINT NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  `incurred_on` DATE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `Expenses_expense_type_id` (`expense_type_id` ASC) VISIBLE,
  INDEX `Expenses_building_id` (`building_id` ASC) VISIBLE,
  INDEX `Expenses_store_space_id` (`store_space_id` ASC) VISIBLE,
  INDEX `Expenses_reporting_period_id` (`reporting_period_id` ASC) VISIBLE,
  CONSTRAINT `Expenses_building_id`
    FOREIGN KEY (`building_id`)
    REFERENCES `Merkadit`.`Buildings` (`id`),
  CONSTRAINT `Expenses_expense_type_id`
    FOREIGN KEY (`expense_type_id`)
    REFERENCES `Merkadit`.`ExpenseTypes` (`id`),
  CONSTRAINT `Expenses_reporting_period_id`
    FOREIGN KEY (`reporting_period_id`)
    REFERENCES `Merkadit`.`ReportingPeriods` (`id`),
  CONSTRAINT `Expenses_store_space_id`
    FOREIGN KEY (`store_space_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InventoryItems`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`InventoryItems` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`InventoryItems` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `quantity_on_hand` DECIMAL(14,3) NOT NULL DEFAULT '0.000',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `inventoryItems_business_id` (`business_id` ASC, `product_id` ASC) VISIBLE,
  INDEX `inventoryItems_product_id` (`product_id` ASC) VISIBLE,
  CONSTRAINT `inventoryItems_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
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
  `business_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `type_id` BIGINT NOT NULL,
  `quantity_delta` DECIMAL(14,3) NOT NULL,
  `reference_table` VARCHAR(60) NULL DEFAULT NULL,
  `reference_id` BIGINT NULL DEFAULT NULL,
  `occurred_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `inventoryTransaction_business_id` (`business_id` ASC, `product_id` ASC, `occurred_at` ASC) VISIBLE,
  INDEX `inventoryTransaction_product_id` (`product_id` ASC) VISIBLE,
  INDEX `inventoryTransaction_type_id` (`type_id` ASC) VISIBLE,
  CONSTRAINT `inventoryTransaction_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
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
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Meters`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Meters` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Meters` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `meter_number` VARCHAR(100) NOT NULL,
  `building_id` BIGINT NULL DEFAULT NULL,
  `store_space_id` BIGINT NULL DEFAULT NULL,
  `type` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `meter_number` (`meter_number` ASC) VISIBLE,
  INDEX `building_id` (`building_id` ASC) VISIBLE,
  INDEX `store_space_id` (`store_space_id` ASC) VISIBLE,
  CONSTRAINT `building_id`
    FOREIGN KEY (`building_id`)
    REFERENCES `Merkadit`.`Buildings` (`id`),
  CONSTRAINT `store_space_id`
    FOREIGN KEY (`store_space_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`MeterReadings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`MeterReadings` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`MeterReadings` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `meter_id` BIGINT NOT NULL,
  `reading_value` DECIMAL(12,3) NOT NULL,
  `reading_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `MR_meter_id` (`meter_id` ASC, `reading_at` ASC) VISIBLE,
  CONSTRAINT `MR_meter_id`
    FOREIGN KEY (`meter_id`)
    REFERENCES `Merkadit`.`Meters` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`OperationLogs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`OperationLogs` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`OperationLogs` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `operation_name` VARCHAR(120) NOT NULL,
  `user_id` BIGINT NULL DEFAULT NULL,
  `computer` VARCHAR(120) NULL DEFAULT NULL,
  `checksum` VARCHAR(120) NULL DEFAULT NULL,
  `payload` JSON NULL DEFAULT NULL,
  `success` TINYINT(1) NULL DEFAULT '1',
  `error_message` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `stack_trace` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `operation_name` (`operation_name` ASC, `created_at` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PaymentMethods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`PaymentMethods` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`PaymentMethods` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Payments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Payments` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Payments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NOT NULL,
  `payment_method_id` BIGINT NOT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  `paid_on` DATETIME NOT NULL,
  `reference` VARCHAR(120) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `Payments_business_id` (`business_id` ASC) VISIBLE,
  INDEX `Payments_payment_method_id` (`payment_method_id` ASC) VISIBLE,
  CONSTRAINT `Payments_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
  CONSTRAINT `Payments_payment_method_id`
    FOREIGN KEY (`payment_method_id`)
    REFERENCES `Merkadit`.`PaymentMethods` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Receivables`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Receivables` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Receivables` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NOT NULL,
  `contract_id` BIGINT NULL DEFAULT NULL,
  `reporting_period_id` BIGINT NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `amount_due` DECIMAL(14,2) NOT NULL,
  `due_date` DATE NULL DEFAULT NULL,
  `status` VARCHAR(40) NULL DEFAULT 'open',
  PRIMARY KEY (`id`),
  INDEX `Receivables_business_id` (`business_id` ASC) VISIBLE,
  INDEX `Receivables_contract_id` (`contract_id` ASC) VISIBLE,
  INDEX `Receivables_reporting_period_id` (`reporting_period_id` ASC) VISIBLE,
  CONSTRAINT `Receivables_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
  CONSTRAINT `Receivables_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`),
  CONSTRAINT `Receivables_reporting_period_id`
    FOREIGN KEY (`reporting_period_id`)
    REFERENCES `Merkadit`.`ReportingPeriods` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PaymentAllocations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`PaymentAllocations` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`PaymentAllocations` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `payment_id` BIGINT NOT NULL,
  `receivable_id` BIGINT NOT NULL,
  `amount_applied` DECIMAL(14,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `PA_payment_id` (`payment_id` ASC) VISIBLE,
  INDEX `PA_receivable_id` (`receivable_id` ASC) VISIBLE,
  CONSTRAINT `PA_payment_id`
    FOREIGN KEY (`payment_id`)
    REFERENCES `Merkadit`.`Payments` (`id`),
  CONSTRAINT `PA_receivable_id`
    FOREIGN KEY (`receivable_id`)
    REFERENCES `Merkadit`.`Receivables` (`id`))
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
  `business_id` BIGINT NOT NULL,
  `terminal_id` BIGINT NULL DEFAULT NULL,
  `customer_id` BIGINT NULL DEFAULT NULL,
  `invoice_status_id` BIGINT NULL DEFAULT NULL,
  `sale_datetime` DATETIME NOT NULL,
  `subtotal_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `discount_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `tax_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `total_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  INDEX `Sales_business_id` (`business_id` ASC, `sale_datetime` ASC) VISIBLE,
  INDEX `Sales_terminal_id` (`terminal_id` ASC) VISIBLE,
  INDEX `Sales_customer_id` (`customer_id` ASC) VISIBLE,
  INDEX `Sales_invoice_status_id` (`invoice_status_id` ASC) VISIBLE,
  CONSTRAINT `Sales_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`),
  CONSTRAINT `Sales_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Merkadit`.`Customers` (`id`),
  CONSTRAINT `Sales_invoice_status_id`
    FOREIGN KEY (`invoice_status_id`)
    REFERENCES `Merkadit`.`InvoiceStatus` (`id`),
  CONSTRAINT `Sales_terminal_id`
    FOREIGN KEY (`terminal_id`)
    REFERENCES `Merkadit`.`POSTerminals` (`id`))
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
  `business_id` BIGINT NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `valid_from` DATE NOT NULL,
  `valid_to` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `priceLists_business_id` (`business_id` ASC, `name` ASC, `valid_from` ASC) VISIBLE,
  CONSTRAINT `priceLists_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`))
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
  `unit_price` DECIMAL(12,2) NOT NULL,
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
  `invoice_status_id` BIGINT NULL DEFAULT NULL,
  `url` VARCHAR(255) NULL DEFAULT NULL,
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
  `base_monthly_rent` DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `RentSchedules_contract_id` (`contract_id` ASC, `effective_from` ASC) VISIBLE,
  CONSTRAINT `RentSchedules_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`))
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
  `settled_at` DATETIME NULL DEFAULT NULL,
  `total_sales_amount` DECIMAL(14,2) NULL DEFAULT '0.00',
  `fee_amount` DECIMAL(14,2) NULL DEFAULT '0.00',
  `rent_amount` DECIMAL(14,2) NULL DEFAULT '0.00',
  `adjustments_amount` DECIMAL(14,2) NULL DEFAULT '0.00',
  `total_due` DECIMAL(14,2) NULL DEFAULT '0.00',
  `is_settled` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Settlements_contract_id` (`contract_id` ASC, `period_year` ASC, `period_month` ASC) VISIBLE,
  CONSTRAINT `Settlements_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`SettlementLines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`SettlementLines` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`SettlementLines` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `settlement_id` BIGINT NOT NULL,
  `line_type` VARCHAR(40) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `SL_settlement_id` (`settlement_id` ASC) VISIBLE,
  CONSTRAINT `SL_settlement_id`
    FOREIGN KEY (`settlement_id`)
    REFERENCES `Merkadit`.`Settlements` (`id`))
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
-- Table `Merkadit`.`GeoAreas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`GeoAreas` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`GeoAreas` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `type` ENUM('country', 'state', 'city', 'district') NULL,
  `parent_id` BIGINT NULL,
  PRIMARY KEY (`id`),
  INDEX `parent_id_idx` (`parent_id` ASC) VISIBLE,
  CONSTRAINT `GeoAreas_parent_id`
    FOREIGN KEY (`parent_id`)
    REFERENCES `Merkadit`.`GeoAreas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`Addresses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`Addresses` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`Addresses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `geoarea_id` BIGINT NULL,
  `postal_code` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `geoarea_id_idx` (`geoarea_id` ASC) VISIBLE,
  CONSTRAINT `Adresses_geoarea_id`
    FOREIGN KEY (`geoarea_id`)
    REFERENCES `Merkadit`.`GeoAreas` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`AdressLines`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`AdressLines` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`AdressLines` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `address_id` BIGINT NULL,
  `line_number` INT NULL,
  `line_text` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `address_id_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `AdressLines_address_id`
    FOREIGN KEY (`address_id`)
    REFERENCES `Merkadit`.`Addresses` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Merkadit`.`AddressLinks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Merkadit`.`AddressLinks` ;

CREATE TABLE IF NOT EXISTS `Merkadit`.`AddressLinks` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `entity_id` BIGINT NOT NULL,
  `primary` BIT NOT NULL,
  `valid_from` DATETIME NULL,
  `valid_to` DATETIME NULL,
  `address_id` BIGINT NULL,
  `entity_type` ENUM('building', 'storespace', 'business', 'person', 'customer', 'supplier', 'administrator') NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `address_id_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `AdressLinks_address_id`
    FOREIGN KEY (`address_id`)
    REFERENCES `Merkadit`.`Addresses` (`id`)
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
  `DiscountTypes_id` INT NOT NULL,
  `code` VARCHAR(20) NULL,
  `name` VARCHAR(30) NOT NULL,
  `description` VARCHAR(255) NULL,
  `discount_percentage` DECIMAL(5,2) NULL,
  `discount_amount` DECIMAL(12,2) NULL,
  `min_purchase_amount` DECIMAL(12,2) NULL,
  `max_discount_amount` DECIMAL(12,2) NULL,
  `valid_from` DATETIME NULL,
  `max_uses_per_customer` INT NULL,
  `active` BIT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `SaleLines_id` BIGINT NOT NULL,
  `Sales_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Discounts_Businesses1_idx` (`Businesses_id` ASC) VISIBLE,
  INDEX `fk_Discounts_DiscountTypes1_idx` (`DiscountTypes_id` ASC) VISIBLE,
  INDEX `fk_Discounts_SaleLines1_idx` (`SaleLines_id` ASC) VISIBLE,
  INDEX `fk_Discounts_Sales1_idx` (`Sales_id` ASC) VISIBLE,
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
  CONSTRAINT `fk_Discounts_SaleLines1`
    FOREIGN KEY (`SaleLines_id`)
    REFERENCES `Merkadit`.`SaleLines` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Discounts_Sales1`
    FOREIGN KEY (`Sales_id`)
    REFERENCES `Merkadit`.`Sales` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
