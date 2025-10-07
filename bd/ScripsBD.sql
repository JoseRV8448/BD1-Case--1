-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema Merkadit
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Merkadit
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Merkadit` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `Merkadit` ;

-- -----------------------------------------------------
-- Table `Merkadit`.`nv_countries`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_countries` (
  `countryid` INT NOT NULL AUTO_INCREMENT,
  `countryname` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`countryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_states`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_states` (
  `stateid` INT NOT NULL AUTO_INCREMENT,
  `statename` VARCHAR(30) NOT NULL,
  `nv_countries_countryid` INT NOT NULL,
  PRIMARY KEY (`stateid`),
  INDEX `fk_nv_states_nv_countries1_idx` (`nv_countries_countryid` ASC) VISIBLE,
  CONSTRAINT `fk_nv_states_nv_countries1`
    FOREIGN KEY (`nv_countries_countryid`)
    REFERENCES `Merkadit`.`nv_countries` (`countryid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_cities` (
  `cityid` INT NOT NULL AUTO_INCREMENT,
  `cityname` VARCHAR(30) NOT NULL,
  `nv_states_stateid` INT NOT NULL,
  PRIMARY KEY (`cityid`),
  INDEX `fk_nv_cities_nv_states1_idx` (`nv_states_stateid` ASC) VISIBLE,
  CONSTRAINT `fk_nv_cities_nv_states1`
    FOREIGN KEY (`nv_states_stateid`)
    REFERENCES `Merkadit`.`nv_states` (`stateid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`Addresses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `address1` VARCHAR(60) NOT NULL,
  `address2` VARCHAR(60) NULL DEFAULT NULL,
  `zipcode` VARCHAR(8) NOT NULL,
  `geolocation` POINT NOT NULL,
  `nv_cities_cityid` INT NOT NULL,
  PRIMARY KEY (`id`),
  SPATIAL INDEX `locationindex` (`geolocation`) VISIBLE,
  INDEX `fk_Addresses_nv_cities1_idx` (`nv_cities_cityid` ASC) VISIBLE,
  CONSTRAINT `fk_Addresses_nv_cities1`
    FOREIGN KEY (`nv_cities_cityid`)
    REFERENCES `Merkadit`.`nv_cities` (`cityid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`UserAccounts`
-- -----------------------------------------------------
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
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Addresses_has_UserAccounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`Addresses_has_UserAccounts` (
  `Addressid` BIGINT NOT NULL,
  `UserAccountid` BIGINT NOT NULL,
  `delete` BIT(1) NOT NULL DEFAULT b'1',
  `createaddress` DATE NOT NULL,
  `deleteaddress` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`Addressid`, `UserAccountid`),
  INDEX `fk_Addresses_has_UserAccounts_UserAccounts1_idx` (`UserAccountid` ASC) VISIBLE,
  INDEX `fk_Addresses_has_UserAccounts_Addresses1_idx` (`Addressid` ASC) VISIBLE,
  CONSTRAINT `fk_Addresses_has_UserAccounts_Addresses1`
    FOREIGN KEY (`Addressid`)
    REFERENCES `Merkadit`.`Addresses` (`id`),
  CONSTRAINT `fk_Addresses_has_UserAccounts_UserAccounts1`
    FOREIGN KEY (`UserAccountid`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`AuditTrails`
-- -----------------------------------------------------
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
CREATE TABLE IF NOT EXISTS `Merkadit`.`Brands` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`BusinessTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`BusinessTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Businesses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`Businesses` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_type_id` BIGINT NOT NULL,
  `legal_name` VARCHAR(190) NOT NULL,
  `trade_name` VARCHAR(190) NOT NULL,
  `tax_id` VARCHAR(60) NOT NULL,
  `email` VARCHAR(190) NOT NULL,
  `phone` VARCHAR(60) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `Businesses_business_type_id` (`business_type_id` ASC) VISIBLE,
  CONSTRAINT `Businesses_business_type_id`
    FOREIGN KEY (`business_type_id`)
    REFERENCES `Merkadit`.`BusinessTypes` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`ProductCategories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`ProductCategories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  `created_at` DATETIME NOT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `parent_id` BIGINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC, `parent_id` ASC) VISIBLE,
  INDEX `productCategory_parent_id` (`parent_id` ASC) VISIBLE,
  CONSTRAINT `productCategory_parent_id`
    FOREIGN KEY (`parent_id`)
    REFERENCES `Merkadit`.`ProductCategories` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`UnitOfMeasure`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`UnitOfMeasure` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(30) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `code` (`code` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`Products` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NOT NULL,
  `category_id` BIGINT NULL DEFAULT NULL,
  `brand_id` BIGINT NULL DEFAULT NULL,
  `uom_id` BIGINT NULL DEFAULT NULL,
  `sku` VARCHAR(100) NOT NULL,
  `name` VARCHAR(190) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `Active` BIT(1) NOT NULL DEFAULT b'1',
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
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Barcodes`
-- -----------------------------------------------------
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
CREATE TABLE IF NOT EXISTS `Merkadit`.`Marketplace` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `commercial_name` VARCHAR(100) NOT NULL,
  `legal_name` VARCHAR(150) NOT NULL,
  `tax_id` INT NOT NULL,
  `email` VARCHAR(60) NOT NULL,
  `phone` VARCHAR(45) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Buildings`
-- -----------------------------------------------------
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
    REFERENCES `Merkadit`.`Marketplace` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`SpaceStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`SpaceStatus` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`SpaceTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`SpaceTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`StoreSpaces`
-- -----------------------------------------------------
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
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
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
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`POSTerminals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`POSTerminals` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(60) NOT NULL,
  `is_active` TINYINT(1) NULL DEFAULT '1',
  `storeSpace_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `POS_storeSpace_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `POS_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Shifts`
-- -----------------------------------------------------
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
  CONSTRAINT `Shifts_posted_by_userId`
    FOREIGN KEY (`posted_by_userId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`),
  CONSTRAINT `Shifts_terminal_id`
    FOREIGN KEY (`terminal_id`)
    REFERENCES `Merkadit`.`POSTerminals` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`CashDrawerSessions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`CashDrawerSessions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `shift_id` BIGINT NOT NULL,
  `opening_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `closing_amount` DECIMAL(14,2) NULL DEFAULT NULL,
  `opened_at` DATETIME NOT NULL,
  `closed_at` DATETIME NULL DEFAULT NULL,
  `variance_amount` DECIMAL(14,2) NOT NULL,
  `notes` VARCHAR(200) NULL DEFAULT NULL,
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
CREATE TABLE IF NOT EXISTS `Merkadit`.`ContractStatus` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Contracts`
-- -----------------------------------------------------
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
    REFERENCES `Merkadit`.`StoreSpaces` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 22
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`ContractFeeRules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`ContractFeeRules` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `product_category_id` BIGINT NOT NULL,
  `fee_percent` DECIMAL(5,2) NOT NULL,
  `effective_from` DATETIME NOT NULL,
  `effective_to` DATETIME NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `CFR_contract_id_idx` (`contract_id` ASC) VISIBLE,
  INDEX `CFR_product_category_id_idx` (`product_category_id` ASC) VISIBLE,
  CONSTRAINT `CFR_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`),
  CONSTRAINT `CFR_product_category_id`
    FOREIGN KEY (`product_category_id`)
    REFERENCES `Merkadit`.`ProductCategories` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`ContractSpaces`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`ContractSpaces` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `storeSpace_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_contract_space` (`contract_id` ASC, `storeSpace_id` ASC) VISIBLE,
  INDEX `CS_contract_id_idx` (`contract_id` ASC) VISIBLE,
  INDEX `CS_storeSpace_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `CS_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`),
  CONSTRAINT `CS_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`Customers` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(190) NULL DEFAULT NULL,
  `email` VARCHAR(190) NULL DEFAULT NULL,
  `phone` VARCHAR(60) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`DiscountTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`DiscountTypes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `active` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Discounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`Discounts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Businesses_id` BIGINT NOT NULL,
  `code` VARCHAR(20) NULL DEFAULT NULL,
  `name` VARCHAR(30) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `discount_percentage` DECIMAL(5,2) NULL DEFAULT NULL,
  `discount_amount` DECIMAL(12,2) NULL DEFAULT NULL,
  `min_purchase_amount` DECIMAL(12,2) NULL DEFAULT NULL,
  `max_discount_amount` DECIMAL(12,2) NULL DEFAULT NULL,
  `valid_from` DATETIME NULL DEFAULT NULL,
  `valid_to` DATETIME NULL DEFAULT NULL,
  `max_uses_per_customer` INT NULL DEFAULT NULL,
  `active` BIT(1) NOT NULL DEFAULT b'1',
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
    REFERENCES `Merkadit`.`Businesses` (`id`),
  CONSTRAINT `fk_Discounts_Customers1`
    FOREIGN KEY (`Customers_id`)
    REFERENCES `Merkadit`.`Customers` (`id`),
  CONSTRAINT `fk_Discounts_DiscountTypes1`
    FOREIGN KEY (`DiscountTypes_id`)
    REFERENCES `Merkadit`.`DiscountTypes` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`DiscountProducts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`DiscountProducts` (
  `Discounts_id` INT NOT NULL,
  `id` INT NOT NULL,
  `Products_id` BIGINT NOT NULL,
  PRIMARY KEY (`Discounts_id`, `id`, `Products_id`),
  INDEX `fk_Discounts_has_Products_Products1_idx` (`Products_id` ASC) VISIBLE,
  INDEX `fk_Discounts_has_Products_Discounts1_idx` (`Discounts_id` ASC, `id` ASC) VISIBLE,
  CONSTRAINT `fk_Discounts_has_Products_Discounts1`
    FOREIGN KEY (`Discounts_id` , `id`)
    REFERENCES `Merkadit`.`Discounts` (`id` , `DiscountTypes_id`),
  CONSTRAINT `fk_Discounts_has_Products_Products1`
    FOREIGN KEY (`Products_id`)
    REFERENCES `Merkadit`.`Products` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InvoiceStatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`InvoiceStatus` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` ENUM('ISSUED', 'VOIDED', 'RETURNED') NOT NULL DEFAULT 'ISSUED',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Sales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`Sales` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `business_id` BIGINT NULL DEFAULT NULL,
  `pos_terminal_id` BIGINT NULL DEFAULT NULL,
  `customer_id` BIGINT NULL DEFAULT NULL,
  `contract_id` BIGINT NULL DEFAULT NULL,
  `invoice_status_id` BIGINT NULL DEFAULT NULL,
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
  CONSTRAINT `Sales_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`),
  CONSTRAINT `Sales_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `Merkadit`.`Customers` (`id`),
  CONSTRAINT `Sales_invoice_status_id`
    FOREIGN KEY (`invoice_status_id`)
    REFERENCES `Merkadit`.`InvoiceStatus` (`id`),
  CONSTRAINT `Sales_pos_terminal_id`
    FOREIGN KEY (`pos_terminal_id`)
    REFERENCES `Merkadit`.`POSTerminals` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 495
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`DiscountUsage`
-- -----------------------------------------------------
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
    REFERENCES `Merkadit`.`Discounts` (`id` , `DiscountTypes_id`),
  CONSTRAINT `fk_Discounts_has_Sales_Sales1`
    FOREIGN KEY (`Sales_id`)
    REFERENCES `Merkadit`.`Sales` (`id`),
  CONSTRAINT `fk_DiscountUsage_Customers1`
    FOREIGN KEY (`Customers_id`)
    REFERENCES `Merkadit`.`Customers` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`FinancialTransactions`
-- -----------------------------------------------------
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
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `txn_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `source` VARCHAR(45) NOT NULL,
  `building_id` BIGINT NOT NULL,
  `business_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `FT_building_id` (`building_id` ASC) VISIBLE,
  INDEX `FT_business_id` (`business_id` ASC) VISIBLE,
  CONSTRAINT `FT_building_id`
    FOREIGN KEY (`building_id`)
    REFERENCES `Merkadit`.`Buildings` (`id`),
  CONSTRAINT `FT_business_id`
    FOREIGN KEY (`business_id`)
    REFERENCES `Merkadit`.`Businesses` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`FinancialTransactionLines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`FinancialTransactionLines` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `financialTransaction_id` BIGINT NOT NULL,
  `account` ENUM('RENT', 'FEE', 'EXPENSE', 'RECEIVABLE', 'OTHER') NOT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `category_code` VARCHAR(45) NULL DEFAULT NULL,
  `vendor` VARCHAR(120) NULL DEFAULT NULL,
  `invoice_no` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `FTL_financialTransaction_id_idx` (`financialTransaction_id` ASC) VISIBLE,
  INDEX `FTL_category` (`category_code` ASC) INVISIBLE,
  INDEX `FTL_account` (`account` ASC) INVISIBLE,
  INDEX `FTL_vendor` (`vendor` ASC) INVISIBLE,
  INDEX `FTL_invoice` (`invoice_no` ASC) VISIBLE,
  CONSTRAINT `FTL_financialTransaction_id`
    FOREIGN KEY (`financialTransaction_id`)
    REFERENCES `Merkadit`.`FinancialTransactions` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 21
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InventoryItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`InventoryItems` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `storeSpace_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `quantity_on_hand` DECIMAL(14,3) NOT NULL DEFAULT '0.000',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `inventoryItems_product_id` (`product_id` ASC) VISIBLE,
  INDEX `inventoryItems_storeSpace_id_idx` (`storeSpace_id` ASC) VISIBLE,
  CONSTRAINT `inventoryItems_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `Merkadit`.`Products` (`id`),
  CONSTRAINT `inventoryItems_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InventoryTransactionTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`InventoryTransactionTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 22
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`InventoryTransactions`
-- -----------------------------------------------------
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
  CONSTRAINT `inventoryTransaction_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `Merkadit`.`Products` (`id`),
  CONSTRAINT `inventoryTransaction_storeSpace_id`
    FOREIGN KEY (`storeSpace_id`)
    REFERENCES `Merkadit`.`StoreSpaces` (`id`),
  CONSTRAINT `inventoryTransaction_type_id`
    FOREIGN KEY (`type_id`)
    REFERENCES `Merkadit`.`InventoryTransactionTypes` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 15
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Investments`
-- -----------------------------------------------------
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
-- Table `Merkadit`.`nv_logslevel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_logslevel` (
  `loglevelid` INT NOT NULL AUTO_INCREMENT,
  `loglevelname` VARCHAR(30) NOT NULL,
  `UserAccounts_id` BIGINT NOT NULL,
  PRIMARY KEY (`loglevelid`),
  INDEX `fk_nv_logslevel_UserAccounts1_idx` (`UserAccounts_id` ASC) VISIBLE,
  CONSTRAINT `fk_nv_logslevel_UserAccounts1`
    FOREIGN KEY (`UserAccounts_id`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`OperationLogs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`OperationLogs` (
  `operationlogid` BIGINT NOT NULL AUTO_INCREMENT,
  `operation_name` VARCHAR(120) NOT NULL,
  `computer` VARCHAR(120) NULL DEFAULT NULL,
  `checksum` VARCHAR(120) NULL DEFAULT NULL,
  `payload` JSON NULL DEFAULT NULL,
  `success` TINYINT(1) NULL DEFAULT '1',
  `error_message` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `stack_trace` TEXT NULL DEFAULT NULL,
  `loglevelid` INT NOT NULL,
  PRIMARY KEY (`operationlogid`),
  INDEX `operation_name` (`operation_name` ASC, `created_at` ASC) VISIBLE,
  INDEX `fk_OperationLogs_nv_logslevel1_idx` (`loglevelid` ASC) VISIBLE,
  CONSTRAINT `fk_OperationLogs_nv_logslevel1`
    FOREIGN KEY (`loglevelid`)
    REFERENCES `Merkadit`.`nv_logslevel` (`loglevelid`))
ENGINE = InnoDB
AUTO_INCREMENT = 25
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PaymentTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`PaymentTypes` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PaymentFromCustomers`
-- -----------------------------------------------------
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
AUTO_INCREMENT = 20
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Permissions`
-- -----------------------------------------------------
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
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`PriceListItems`
-- -----------------------------------------------------
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
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Receipts`
-- -----------------------------------------------------
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
AUTO_INCREMENT = 20
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`RentSchedules`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`RentSchedules` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `effective_from` DATE NOT NULL,
  `effective_to` DATETIME NOT NULL,
  `base_monthly_rent` DECIMAL(12,2) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
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
CREATE TABLE IF NOT EXISTS `Merkadit`.`Roles` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`RolePermissions`
-- -----------------------------------------------------
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
CREATE TABLE IF NOT EXISTS `Merkadit`.`SaleLines` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `sale_id` BIGINT NOT NULL,
  `product_id` BIGINT NOT NULL,
  `quantity` DECIMAL(14,3) NOT NULL,
  `unit_price` DECIMAL(12,2) NOT NULL,
  `discount_amount` DECIMAL(12,2) NOT NULL DEFAULT '0.00',
  `line_total` DECIMAL(14,2) NOT NULL,
  `unit_price_atSale` DECIMAL(14,2) NULL DEFAULT NULL,
  `tax_atSale` DECIMAL(14,2) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
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
AUTO_INCREMENT = 493
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`SaleLineDiscounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`SaleLineDiscounts` (
  `Discounts_id` INT NOT NULL,
  `Discounts_DiscountTypes_id` INT NOT NULL,
  `SaleLines_id` BIGINT NOT NULL,
  `discount_amount` DECIMAL(12,2) NOT NULL,
  `discount_percentage_applied` DECIMAL(5,2) NULL DEFAULT NULL,
  PRIMARY KEY (`Discounts_id`, `Discounts_DiscountTypes_id`, `SaleLines_id`),
  INDEX `fk_Discounts_has_SaleLines_SaleLines1_idx` (`SaleLines_id` ASC) VISIBLE,
  INDEX `fk_Discounts_has_SaleLines_Discounts1_idx` (`Discounts_id` ASC, `Discounts_DiscountTypes_id` ASC) VISIBLE,
  CONSTRAINT `fk_Discounts_has_SaleLines_Discounts1`
    FOREIGN KEY (`Discounts_id` , `Discounts_DiscountTypes_id`)
    REFERENCES `Merkadit`.`Discounts` (`id` , `DiscountTypes_id`),
  CONSTRAINT `fk_Discounts_has_SaleLines_SaleLines1`
    FOREIGN KEY (`SaleLines_id`)
    REFERENCES `Merkadit`.`SaleLines` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`Settlements`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`Settlements` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT NOT NULL,
  `period_year` INT NOT NULL,
  `period_month` INT NOT NULL,
  `settled_at` DATETIME NULL DEFAULT NULL,
  `total_sales_amount` DECIMAL(14,2) UNSIGNED ZEROFILL NOT NULL DEFAULT '000000000000.00',
  `fee_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `rent_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `adjustments_amount` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `total_due` DECIMAL(14,2) NOT NULL DEFAULT '0.00',
  `is_settled` BIT(1) NOT NULL DEFAULT b'0',
  `post_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `posted_by_userId` BIGINT NOT NULL,
  `computer` VARCHAR(120) NOT NULL,
  `checksum` VARCHAR(120) NOT NULL,
  `settlement_month` DATE GENERATED ALWAYS AS (date_format(concat(`period_year`,_utf8mb4'-',lpad(`period_month`,2,_utf8mb4'0'),_utf8mb4'-01'),_utf8mb4'%Y-%m-%d')) STORED,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `Settlements_contract_id` (`contract_id` ASC, `period_year` ASC, `period_month` ASC) VISIBLE,
  INDEX `Settlements_posted_by_userId_idx` (`posted_by_userId` ASC) VISIBLE,
  CONSTRAINT `Settlements_contract_id`
    FOREIGN KEY (`contract_id`)
    REFERENCES `Merkadit`.`Contracts` (`id`),
  CONSTRAINT `Settlements_posted_by_userId`
    FOREIGN KEY (`posted_by_userId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`SettlementAdjustments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`SettlementAdjustments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `settlement_id` BIGINT NOT NULL,
  `type` ENUM('DEBIT', 'CREDIT') NOT NULL,
  `amount` DECIMAL(14,2) NOT NULL,
  `reason` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by_userId` BIGINT NULL DEFAULT NULL,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
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
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`UserAffiliations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`UserAffiliations` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `userId` BIGINT NOT NULL,
  `entity_type` ENUM('BUSINESS', 'MARKETPLACE') NOT NULL,
  `entity_id` BIGINT NOT NULL,
  `roleId` BIGINT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `deleted` BIT(1) NOT NULL DEFAULT b'0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `valid_from` DATETIME NOT NULL,
  `valid_to` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_UA_idx` (`userId` ASC, `entity_type` ASC, `entity_id` ASC, `roleId` ASC) VISIBLE,
  INDEX `UA_userId_idx` (`userId` ASC) VISIBLE,
  INDEX `UA_roleId_idx` (`roleId` ASC) VISIBLE,
  INDEX `UA_entity_idx` (`entity_type` ASC, `entity_id` ASC) VISIBLE,
  CONSTRAINT `UA_roleId`
    FOREIGN KEY (`roleId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`),
  CONSTRAINT `UA_userId`
    FOREIGN KEY (`userId`)
    REFERENCES `Merkadit`.`UserAccounts` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`UserRoles`
-- -----------------------------------------------------
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
-- Table `Merkadit`.`nv_logsources`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_logsources` (
  `logsourceid` INT NOT NULL AUTO_INCREMENT,
  `sourcename` VARCHAR(30) NOT NULL,
  `operationlogid` BIGINT NOT NULL,
  PRIMARY KEY (`logsourceid`),
  INDEX `fk_nv_logsources_OperationLogs1_idx` (`operationlogid` ASC) VISIBLE,
  CONSTRAINT `fk_nv_logsources_OperationLogs1`
    FOREIGN KEY (`operationlogid`)
    REFERENCES `Merkadit`.`OperationLogs` (`operationlogid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `Merkadit`.`nv_logtypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`nv_logtypes` (
  `logtypeid` INT NOT NULL AUTO_INCREMENT,
  `logtypename` VARCHAR(30) NOT NULL,
  `OperationLogid` BIGINT NOT NULL,
  PRIMARY KEY (`logtypeid`),
  INDEX `fk_nv_logtypes_OperationLogs1_idx` (`OperationLogid` ASC) VISIBLE,
  CONSTRAINT `fk_nv_logtypes_OperationLogs1`
    FOREIGN KEY (`OperationLogid`)
    REFERENCES `Merkadit`.`OperationLogs` (`operationlogid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `Merkadit` ;

-- -----------------------------------------------------
-- Placeholder table for view `Merkadit`.`vw_BusinessReport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`vw_BusinessReport` (`business_id` INT, `business_name` INT, `legal_business_name` INT, `business_type` INT, `store_space_id` INT, `store_space_code` INT, `building_name` INT, `building_id` INT, `contract_id` INT, `fee_percentage` INT, `monthly_rent` INT, `sale_year` INT, `sale_month` INT, `period` INT, `total_sales_count` INT, `total_items_sold` INT, `subtotal_amount` INT, `discount_amount` INT, `tax_amount` INT, `total_sales_amount` INT, `fee_amount` INT, `rent_amount` INT, `total_due_marketplace` INT, `total_to_business` INT, `settlement_status` INT, `settlement_id` INT, `settlement_date` INT, `first_sale_date` INT, `last_sale_date` INT);

-- -----------------------------------------------------
-- Placeholder table for view `Merkadit`.`vw_TopProducts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Merkadit`.`vw_TopProducts` (`id` INT);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
