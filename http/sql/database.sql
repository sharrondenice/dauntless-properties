-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema DB_NAME
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `DB_NAME` ;

-- -----------------------------------------------------
-- Schema DB_NAME
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DB_NAME` ;
USE `DB_NAME` ;

-- -----------------------------------------------------
-- Table `DB_NAME`.`locale_countries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`locale_countries` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`locale_countries` (
  `_id` VARCHAR(2) NOT NULL DEFAULT '',
  `code_A3` VARCHAR(3) NOT NULL DEFAULT '' COMMENT '// 3-char official ISO code to identify the country.',
  `code_N3` VARCHAR(3) NOT NULL DEFAULT '' COMMENT '// Numeric code to identify the country.',
  `region` VARCHAR(2) NOT NULL DEFAULT '',
  `lat` DOUBLE NOT NULL DEFAULT 0,
  `lon` DOUBLE NOT NULL DEFAULT 0,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `country_code_UNIQUE` (`_id` ASC))
ENGINE = MyISAM;


-- -----------------------------------------------------
-- Table `DB_NAME`.`locale_countries_descriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`locale_countries_descriptions` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`locale_countries_descriptions` (
  `_id` VARCHAR(2) NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  UNIQUE INDEX `country_code_UNIQUE` (`_id` ASC),
  PRIMARY KEY (`_id`),
  CONSTRAINT `fk_description_country_id`
    FOREIGN KEY (`_id`)
    REFERENCES `DB_NAME`.`locale_countries` (`_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`locale_states`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`locale_states` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`locale_states` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `state_code` VARCHAR(50) NOT NULL,
  `country_code` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `ID_UNIQUE` (`_id` ASC),
  INDEX `fk_state_country_code_idx` (`country_code` ASC),
  CONSTRAINT `fk_state_country_code`
    FOREIGN KEY (`country_code`)
    REFERENCES `DB_NAME`.`locale_countries_descriptions` (`_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`shared_owner_codes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`shared_owner_codes` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`shared_owner_codes` (
  `owner` CHAR(2) NOT NULL,
  `table` VARCHAR(50) NULL,
  `code` VARCHAR(50) NOT NULL,
  `icon` VARCHAR(100) NULL,
  PRIMARY KEY (`owner`),
  UNIQUE INDEX `owner_UNIQUE` (`owner` ASC))
ENGINE = InnoDB
COMMENT = '// Table storing a list of all object codes used throughout app.';


-- -----------------------------------------------------
-- Table `DB_NAME`.`shared_statuses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`shared_statuses` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`shared_statuses` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `owner` CHAR(2) NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `foreground` VARCHAR(20) NOT NULL DEFAULT '#00000' COMMENT 'Hex or RGB',
  `background` VARCHAR(20) NOT NULL DEFAULT '#FFFFFF' COMMENT 'Hex or RGB',
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `status_id_UNIQUE` (`_id` ASC),
  INDEX `fk_statuses_owner_idx` (`owner` ASC),
  CONSTRAINT `fk_statuses_owner`
    FOREIGN KEY (`owner`)
    REFERENCES `DB_NAME`.`shared_owner_codes` (`owner`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Table storing the statuses for users, projects, tasks and work items.';


-- -----------------------------------------------------
-- Table `DB_NAME`.`shared_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`shared_types` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`shared_types` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `owner` CHAR(2) NOT NULL,
  `title` TEXT NOT NULL,
  `icon` VARCHAR(100) NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `type_id_UNIQUE` (`_id` ASC),
  INDEX `fk_types_owner_idx` (`owner` ASC),
  CONSTRAINT `fk_types_owner`
    FOREIGN KEY (`owner`)
    REFERENCES `DB_NAME`.`shared_owner_codes` (`owner`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Table storing the statuses for users, projects, tasks and work items.';


-- -----------------------------------------------------
-- Table `DB_NAME`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`users` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`users` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `status_id` MEDIUMINT(8) NOT NULL DEFAULT 1,
  `type_id` MEDIUMINT(8) NOT NULL DEFAULT 21,
  `parent_id` MEDIUMINT(8) NULL DEFAULT NULL,
  `responsible_company_id` MEDIUMINT(8) NULL COMMENT '// Can only be null for type_ids of 20',
  `company_id` MEDIUMINT(8) NULL,
  `profession_id` MEDIUMINT(8) NULL DEFAULT 22,
  `access_key` VARCHAR(255) NULL COMMENT '// For on boarding new users',
  `password` VARCHAR(50) NULL,
  `salutation_type_id` MEDIUMINT(8) NULL,
  `username` VARCHAR(25) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `middle_name` VARCHAR(50) NULL,
  `dob` BIGINT(20) NULL,
  `description` TEXT NULL,
  `referral_type_id` MEDIUMINT(8) NULL,
  `date_last_login` BIGINT(20) NULL,
  `date_last_updated` BIGINT(20) NULL,
  `date_created` BIGINT(20) NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`_id` ASC),
  INDEX `fk_user_status_idx` (`status_id` ASC),
  INDEX `fk_user_type_idx` (`type_id` ASC),
  INDEX `fk_user_parent_idx` (`parent_id` ASC),
  INDEX `fk_user_company_idx` (`company_id` ASC),
  INDEX `fk_user_salutation_idx` (`salutation_type_id` ASC),
  INDEX `fk_user_referral_idx` (`referral_type_id` ASC),
  CONSTRAINT `fk_user_status`
    FOREIGN KEY (`status_id`)
    REFERENCES `DB_NAME`.`shared_statuses` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_type`
    FOREIGN KEY (`type_id`)
    REFERENCES `DB_NAME`.`shared_types` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_parent`
    FOREIGN KEY (`parent_id`)
    REFERENCES `DB_NAME`.`users` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_salutation`
    FOREIGN KEY (`salutation_type_id`)
    REFERENCES `DB_NAME`.`shared_types` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_referral`
    FOREIGN KEY (`referral_type_id`)
    REFERENCES `DB_NAME`.`shared_types` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`locale_states_descriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`locale_states_descriptions` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`locale_states_descriptions` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(50) NOT NULL,
  UNIQUE INDEX `ID_UNIQUE` (`_id` ASC),
  PRIMARY KEY (`_id`),
  CONSTRAINT `fk_description_state_id`
    FOREIGN KEY (`_id`)
    REFERENCES `DB_NAME`.`locale_states` (`_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`shared_profiles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`shared_profiles` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`shared_profiles` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `type_id` MEDIUMINT(8) NOT NULL DEFAULT 50 COMMENT 'Type of Address - Home, Work, Other, etc',
  `owner` CHAR(2) NOT NULL,
  `has_attachment` TINYINT(1) NOT NULL DEFAULT 0,
  `owner_id` MEDIUMINT(8) NOT NULL,
  `is_default` TINYINT(1) NOT NULL DEFAULT 0,
  `email` VARCHAR(50) NULL,
  `address1` VARCHAR(50) NULL,
  `address2` VARCHAR(50) NULL,
  `city` VARCHAR(50) NULL,
  `state_id` MEDIUMINT(8) NULL,
  `zip_code` VARCHAR(10) NULL,
  `work_phone` VARCHAR(20) NULL,
  `mobile_phone` VARCHAR(20) NULL,
  `fax` VARCHAR(20) NULL,
  `url` TEXT NULL,
  `date_last_updated` BIGINT(20) NULL,
  `date_created` BIGINT(20) NULL,
  PRIMARY KEY (`_id`),
  INDEX `fk_profile_state_idx` (`state_id` ASC),
  INDEX `fk_profile_type_idx` (`type_id` ASC),
  UNIQUE INDEX `profile_id_UNIQUE` (`_id` ASC),
  INDEX `fk_profile_owner_idx` (`owner` ASC),
  CONSTRAINT `fk_profile_state`
    FOREIGN KEY (`state_id`)
    REFERENCES `DB_NAME`.`locale_states` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_profile_type`
    FOREIGN KEY (`type_id`)
    REFERENCES `DB_NAME`.`shared_types` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_profile_owner`
    FOREIGN KEY (`owner`)
    REFERENCES `DB_NAME`.`shared_owner_codes` (`owner`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`system_settings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`system_settings` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`system_settings` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `owner` CHAR(2) NOT NULL,
  `user_id` MEDIUMINT(8) NULL,
  `responsible_company_id` MEDIUMINT(8) NULL,
  `is_global` TINYINT(1) NOT NULL DEFAULT 0,
  `setting_name` VARCHAR(50) NULL,
  `setting_value` TEXT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `setting_id_UNIQUE` (`_id` ASC),
  INDEX `fk_settings_user_idx` (`user_id` ASC),
  INDEX `fk_settings_owner_idx` (`owner` ASC),
  CONSTRAINT `fk_settings_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `DB_NAME`.`users` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_settings_owner`
    FOREIGN KEY (`owner`)
    REFERENCES `DB_NAME`.`shared_owner_codes` (`owner`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`system_type_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`system_type_permissions` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`system_type_permissions` (
  `_id` MEDIUMINT(8) NOT NULL,
  `user_type_id` MEDIUMINT(8) NOT NULL,
  `permission_key` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `default_id_UNIQUE` (`_id` ASC),
  INDEX `fk_default_user_type_idx` (`user_type_id` ASC),
  CONSTRAINT `fk_default_user_type`
    FOREIGN KEY (`user_type_id`)
    REFERENCES `DB_NAME`.`shared_types` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`system_settings_defaults`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`system_settings_defaults` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`system_settings_defaults` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `owner` CHAR(2) NOT NULL,
  `is_global` TINYINT(1) NULL DEFAULT 0,
  `setting_name` VARCHAR(50) NULL,
  `setting_value` TEXT NULL,
  `type` VARCHAR(50) NOT NULL,
  `options` TEXT NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `setting_id_UNIQUE` (`_id` ASC),
  INDEX `fk_settings_owner_idx` (`owner` ASC),
  UNIQUE INDEX `setting_name_UNIQUE` (`setting_name` ASC),
  CONSTRAINT `fk_settings_owner0`
    FOREIGN KEY (`owner`)
    REFERENCES `DB_NAME`.`shared_owner_codes` (`owner`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`users_onboarding`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`users_onboarding` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`users_onboarding` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `access_key` VARCHAR(255) NOT NULL,
  `granter_id` MEDIUMINT(8) NOT NULL DEFAULT 180,
  `type_id` MEDIUMINT(8) NOT NULL DEFAULT 350 COMMENT '// Uses AL type',
  `email` VARCHAR(75) NOT NULL COMMENT '// Dont delete responsible company ID, a user can work for multiple companies, like myself, and get paid different amounts for each company',
  `date_last_updated` BIGINT(20) NULL,
  `date_created` BIGINT(20) NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `rates_id_UNIQUE` (`_id` ASC),
  INDEX `fk_onboarding_granter_idx` (`granter_id` ASC),
  INDEX `fk_onboarding_type_idx` (`type_id` ASC),
  CONSTRAINT `fk_onboarding_granter_id`
    FOREIGN KEY (`granter_id`)
    REFERENCES `DB_NAME`.`users` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_onboarding_type_id`
    FOREIGN KEY (`type_id`)
    REFERENCES `DB_NAME`.`shared_types` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`properties`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`properties` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`properties` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `start_time` VARCHAR(50) NOT NULL,
  `end_time` VARCHAR(50) NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `description` TEXT NOT NULL,
  `image` TEXT NOT NULL,
  `date_last_updated` BIGINT(20) NULL,
  `date_created` BIGINT(20) NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `event_id_UNIQUE` (`_id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DB_NAME`.`properties_reservations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DB_NAME`.`properties_reservations` ;

CREATE TABLE IF NOT EXISTS `DB_NAME`.`properties_reservations` (
  `_id` MEDIUMINT(8) NOT NULL AUTO_INCREMENT,
  `responsible_user_id` MEDIUMINT(8) NULL,
  `property_id` MEDIUMINT(8) NOT NULL,
  `start_time` VARCHAR(50) NOT NULL,
  `end_time` VARCHAR(50) NOT NULL,
  `description` TEXT NOT NULL,
  `date_last_updated` BIGINT(20) NULL,
  `date_created` BIGINT(20) NULL,
  PRIMARY KEY (`_id`),
  UNIQUE INDEX `reservation_id_UNIQUE` (`_id` ASC),
  INDEX `fk_properties_reservations_user_id_idx` (`responsible_user_id` ASC),
  INDEX `fk_properties_reservations_property_id_idx` (`property_id` ASC),
  CONSTRAINT `fk_properties_reservations_user_id`
    FOREIGN KEY (`responsible_user_id`)
    REFERENCES `DB_NAME`.`users` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_properties_reservations_property_id`
    FOREIGN KEY (`property_id`)
    REFERENCES `DB_NAME`.`properties` (`_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`locale_countries`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AD', 'AND', '020', 'EU', 42.3, 1.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AE', 'ARE', '784', 'AS', 24, 54);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AF', 'AFG', '004', 'AS', 33, 65);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AG', 'ATG', '028', 'LA', 17.03, -61.48);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AI', 'AIA', '660', 'LA', 18.15, -63.1);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AL', 'ALB', '008', 'EU', 41, 20);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AM', 'ARM', '051', 'AS', 40, 45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AO', 'AGO', '024', 'AF', -12.3, 18.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AP', '', '', '', -2.81, 128.5);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AQ', 'ATA', '010', 'AN', -90, 0);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AR', 'ARG', '032', 'LA', -34, -64);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AS', 'ASM', '016', 'AU', -14.2, -170);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AT', 'AUT', '040', 'EU', 47.2, 13.2);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AU', 'AUS', '036', 'AU', -27, 133);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AW', 'ABW', '533', 'LA', 12.3, -69.58);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AX', 'ALA', '248', 'EU', 60.21, 20.16);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('AZ', 'AZE', '031', 'AS', 40.3, 47.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BA', 'BIH', '070', 'EU', 44, 18);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BB', 'BRB', '052', 'LA', 13.1, -59.32);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BD', 'BGD', '050', 'AS', 24, 90);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BE', 'BEL', '056', 'EU', 50.5, 4);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BF', 'BFA', '854', 'AF', 13, -2);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BG', 'BGR', '100', 'EU', 43, 25);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BH', 'BHR', '048', 'AS', 26, 50.33);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BI', 'BDI', '108', 'AF', -3.3, 30);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BJ', 'BEN', '204', 'AF', 9.3, 2.15);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BM', 'BMU', '060', 'LA', 32.2, -64.45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BN', 'BRN', '096', 'AS', 4.3, 114.4);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BO', 'BOL', '068', 'LA', -17, -65);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BR', 'BRA', '076', 'LA', -10, -55);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BS', 'BHS', '044', 'LA', 24.15, -76);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BT', 'BTN', '064', 'AS', 27.3, 90.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BV', 'BVT', '074', 'AN', -54.26, 3.24);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BW', 'BWA', '072', 'AF', -22, 24);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BY', 'BLR', '112', 'EU', 53, 28);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('BZ', 'BLZ', '084', 'LA', 17.15, -88.45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CA', 'CAN', '124', 'NA', 60, -95);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CC', 'CCK', '166', 'AU', -12.3, 96.5);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CF', 'CAF', '140', 'AF', 7, 21);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CG', 'COG', '178', 'AF', 0, 25);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CH', 'CHE', '756', 'EU', 47, 8);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CI', 'CIV', '384', 'AF', 7.64, -4.93);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CK', 'COK', '184', 'AU', -21.14, -159.46);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CL', 'CHL', '152', 'LA', -30, -71);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CM', 'CMR', '120', 'AF', 6, 12);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CN', 'CHN', '156', 'AS', 35, 105);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CO', 'COL', '170', 'LA', 4, -72);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CR', 'CRI', '188', 'LA', 10, -84);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CS', 'SCG', '891', 'EU', 43.57, 21.41);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CU', 'CUB', '192', 'LA', 21.3, -80);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CV', 'CPV', '132', 'AF', 16, -24);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CW', 'CUW', '531', 'LA', 12.18, -69);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CX', 'CXR', '162', 'AU', -10.3, 105.4);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CY', 'CYP', '196', 'EU', 35, 33);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('CZ', 'CZE', '203', 'EU', 49.45, 15.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('DE', 'DEU', '276', 'EU', 51, 9);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('DJ', 'DJI', '262', 'AF', 11.3, 43);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('DK', 'DNK', '208', 'EU', 56, 10);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('DM', 'DMA', '212', 'LA', 15.25, -61.2);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('DO', 'DOM', '214', 'LA', 19, -70.4);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('DZ', 'DZA', '012', 'AF', 28, 3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('EC', 'ECU', '218', 'LA', -2, -77.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('EE', 'EST', '233', 'EU', 59, 26);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('EG', 'EGY', '818', 'AF', 27, 30);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('EH', 'ESH', '732', 'AF', 24.3, -13);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ER', 'ERI', '232', 'AF', 15, 39);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ES', 'ESP', '724', 'EU', 40, -4);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ET', 'ETH', '210', 'AF', 8, 38);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('EU', '', '', '', 0, 0);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('FI', 'FIN', '246', 'EU', 64, 26);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('FJ', 'FJI', '242', 'AU', -18, 175);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('FK', 'FLK', '238', 'LA', -51.45, -59);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('FM', 'FSM', '583', 'AU', 6.55, 158.15);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('FO', 'FRO', '234', 'EU', 62, -7);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('FR', 'FRA', '250', 'EU', 46, 2);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('FX', 'FXX', '249', 'EU', 0, 0);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GA', 'GAB', '266', 'AF', -1, 11.45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GB', 'GBR', '826', 'EU', 54, -2);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GD', 'GRD', '308', 'LA', 12.07, -61.4);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GE', 'GEO', '268', 'AS', 42, 43.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GF', 'GUF', '254', 'LA', 4, -53);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GG', 'GGY', '831', 'EU', 49.27, 2.33);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GH', 'GHA', '288', 'AF', 8, -2);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GI', 'GIB', '292', 'EU', 36.8, -5.21);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GL', 'GRL', '304', 'NA', 72, -40);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GM', 'GMB', '270', 'AF', 13.28, -16.34);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GN', 'GIN', '324', 'AF', 11, -10);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GP', 'GLP', '312', 'LA', 16.15, -61.35);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GQ', 'GNQ', '226', 'AF', 2, 10);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GR', 'GRC', '300', 'EU', 39, 22);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GT', 'GTM', '320', 'LA', 15.3, -90.15);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GU', 'GUM', '316', 'AU', 13.28, 144.47);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GW', 'GNB', '624', 'AF', 12, -15);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('GY', 'GUY', '328', 'LA', 5, -59);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('HK', 'HKG', '344', 'AS', 22.15, 114.1);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('HM', 'HMD', '334', 'AU', -53.06, 72.31);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('HN', 'HND', '340', 'LA', 15, -86.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('HR', 'HRV', '191', 'EU', 45.1, 15.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('HT', 'HTI', '332', 'LA', 19, -72.25);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('HU', 'HUN', '348', 'EU', 47, 20);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ID', 'IDN', '360', 'AS', -5, 120);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IE', 'IRL', '372', 'EU', 53, -8);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IL', 'ISR', '376', 'AS', 31.3, 34.45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IM', 'IMN', '833', 'EU', 54.09, 4.29);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IN', 'IND', '356', 'AS', 20, 77);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IO', 'IOT', '086', 'AS', -6, 71.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IQ', 'IRQ', '368', 'AS', 33, 44);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IR', 'IRN', '364', 'AS', 32, 53);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IS', 'ISL', '352', 'EU', 65, -18);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('IT', 'ITA', '380', 'EU', 42.5, 12.5);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('JE', 'JEY', '832', 'EU', 49.11, 2.06);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('JM', 'JAM', '388', 'LA', 18.15, -77.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('JO', 'JOR', '400', 'AS', 31, 36);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('JP', 'JPN', '392', 'AS', 36, 138);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KE', 'KEN', '404', 'AF', 1, 38);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KG', 'KGZ', '417', 'AS', 41, 75);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KH', 'KHM', '116', 'AS', 13, 105);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KI', 'KIR', '296', 'AU', 1.25, 173);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KM', 'COM', '174', 'AF', -12.1, 44.15);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KN', 'KNA', '659', 'LA', 17.2, -62.45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KP', 'PRK', '408', 'AS', 40, 127);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KR', 'KOR', '410', 'AS', 37, 127.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KW', 'KWT', '414', 'AS', 29.3, 45.45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KY', 'CYM', '136', 'LA', 19.3, -80.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('KZ', 'KAZ', '398', 'AS', 48, 68);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LA', 'LAO', '418', 'AS', 18, 105);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LB', 'LBN', '422', 'AS', 33.5, 35.5);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LC', 'LCA', '662', 'LA', 13.53, -60.68);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LI', 'LIE', '438', 'EU', 47.16, 9.32);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LK', 'LKA', '144', 'AS', 7, 81);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LR', 'LBR', '430', 'AF', 6.3, -9.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LS', 'LSO', '426', 'AF', -29.3, 28.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LT', 'LTU', '440', 'EU', 56, 24);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LU', 'LUX', '442', 'EU', 49.45, 6.1);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LV', 'LVA', '428', 'EU', 57, 25);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('LY', 'LBY', '434', 'AF', 25, 17);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MA', 'MAR', '504', 'AF', 32, -5);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MC', 'MCO', '492', 'EU', 43.44, 7.24);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MD', 'MDA', '498', 'EU', 47, 29);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ME', 'MNE', '499', 'EU', 42.47, 19.28);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MG', 'MDG', '450', 'AF', -20, 47);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MH', 'MHL', '584', 'AU', 9, 168);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MK', 'MKD', '807', 'EU', 41.5, 22);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ML', 'MLI', '466', 'AF', 17, -4);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MM', 'MMR', '104', 'AS', 22, 98);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MN', 'MNG', '496', 'AS', 46, 105);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MO', 'MAC', '446', 'AS', 22.1, 113.33);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MP', 'MNP', '580', 'AU', 15.12, 145.45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MQ', 'MTQ', '474', 'LA', 14.4, -61);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MR', 'MRT', '478', 'AF', 20, -12);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MS', 'MSR', '500', 'LA', 16.45, -62.12);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MT', 'MLT', '470', 'EU', 35.5, 14.35);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MU', 'MUS', '480', 'AF', -20.17, 57.33);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MV', 'MDV', '462', 'AS', 3.15, 73);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MW', 'MWI', '454', 'AF', -13.3, 34);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MX', 'MEX', '484', 'LA', 23, -102);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MY', 'MYS', '458', 'AS', 2.3, 112.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('MZ', 'MOZ', '508', 'AF', -18.15, 35);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NA', 'NAM', '516', 'AF', -22, 17);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NC', 'NCL', '540', 'AU', -21.3, 165.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NE', 'NER', '562', 'AF', 16, 8);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NF', 'NFK', '574', 'AU', -29.02, 167.57);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NG', 'NGA', '566', 'AF', 10, 8);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NI', 'NIC', '558', 'LA', 13, -85);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NL', 'NLD', '528', 'EU', 52.3, 5.45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NO', 'NOR', '578', 'EU', 62, 10);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NP', 'NPL', '524', 'AS', 28, 84);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NR', 'NRU', '520', 'AU', -0.32, 166.55);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NU', 'NIU', '570', 'AU', -19.02, -169.52);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('NZ', 'NZL', '554', 'AU', -41, 174);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('OM', 'OMN', '512', 'AS', 21, 57);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PA', 'PAN', '591', 'LA', 9, -80);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PE', 'PER', '604', 'LA', -10, -76);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PF', 'PYF', '258', 'AU', -15, -140);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PG', 'PNG', '598', 'AS', -6, 147);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PH', 'PHL', '608', 'AS', 13, 122);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PK', 'PAK', '586', 'AS', 30, 70);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PL', 'POL', '616', 'EU', 52, 20);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PM', 'SPM', '666', 'NA', 46.5, -56.2);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PN', 'PCN', '612', 'AU', -25.04, -130.06);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PR', 'PRI', '630', 'LA', 18.15, -66.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PS', 'PSE', '275', 'AS', 31.89, 34.9);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PT', 'PRT', '620', 'EU', 39.3, -8);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PW', 'PLW', '585', 'AU', 7.3, 134.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('PY', 'PRY', '600', 'LA', -23, -58);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('QA', 'QAT', '634', 'AS', 25.3, 51.15);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('RE', 'REU', '638', 'AF', -21.06, 55.36);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('RO', 'ROU', '642', 'EU', 46, 25);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('RS', 'SRB', '688', 'EU', 44.02, 21.01);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('RU', 'RUS', '643', 'EU', 60, 100);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('RW', 'RWA', '646', 'AF', -2, 30);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SA', 'SAU', '682', 'AS', 25, 45);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SB', 'SLB', '090', 'AU', -8, 159);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SC', 'SYC', '690', 'AF', -4.35, 55.4);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SD', 'SDN', '736', 'AF', 15, 30);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SE', 'SWE', '752', 'EU', 62, 15);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SG', 'SGP', '702', 'AS', 1.22, 103.48);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SH', 'SHN', '654', 'AF', -15.56, -5.42);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SI', 'SVN', '705', 'EU', 46.07, 14.49);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SJ', 'SJM', '744', 'EU', 78, 20);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SK', 'SVK', '703', 'EU', 48.4, 19.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SL', 'SLE', '694', 'AF', 8.3, -11.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SM', 'SMR', '674', 'EU', 43.46, 12.25);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SN', 'SEN', '686', 'AF', 14, -14);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SO', 'SOM', '706', 'AF', 10, 49);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SR', 'SUR', '740', 'LA', 4, -56);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ST', 'STP', '678', 'AF', 1, 7);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SV', 'SLV', '222', 'LA', 13.5, -88.55);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SX', 'SXM', '534', 'LA', 18.07, -63.05);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SY', 'SYR', '760', 'AS', 35, 38);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('SZ', 'SWZ', '748', 'AF', -26.3, 31.3);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TC', 'TCA', '796', 'LA', 21.45, -71.35);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TD', 'TCD', '148', 'AF', 15, 19);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TF', 'ATF', '260', 'AN', -43, 67);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TG', 'TGO', '768', 'AF', 8, 1.1);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TH', 'THA', '764', 'AS', 15, 100);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TJ', 'TJK', '762', 'AS', 39, 71);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TK', 'TKL', '772', 'AU', -9, -172);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TL', 'TLS', '626', 'AS', -8.5, 125.55);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TM', 'TKM', '795', 'AS', 40, 60);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TN', 'TUN', '788', 'AF', 34, 9);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TO', 'TON', '776', 'AU', -20, -175);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TR', 'TUR', '792', 'EU', 39, 35);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TT', 'TTO', '780', 'LA', 11, -61);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TV', 'TUV', '798', 'AU', -8, 178);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TW', 'TWN', '158', 'AS', 23.3, 121);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('TZ', 'TZA', '834', 'AF', -6, 35);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('UA', 'UKR', '804', 'EU', 49, 32);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('UG', 'UGA', '800', 'AF', 1, 32);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('US', 'USA', '840', 'NA', 38, -97);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('UY', 'URY', '858', 'LA', -33, -56);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('UZ', 'UZB', '860', 'AS', 41, 64);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('VA', 'VAT', '336', 'EU', 41.54, 12.27);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('VC', 'VCT', '670', 'LA', 13.15, -61.12);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('VE', 'VEN', '862', 'LA', 8, -66);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('VG', 'VGB', '092', 'LA', 18.2, -64.5);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('VI', 'VIR', '850', 'LA', 18.2, -64.5);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('VN', 'VNM', '704', 'AS', 16, 106);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('VU', 'VUT', '548', 'AU', -16, 167);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('WF', 'WLF', '876', 'AU', -13.18, -176.12);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('WS', 'WSM', '685', 'AU', -13.35, -172.2);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('YE', 'YEM', '887', 'AS', 15, 48);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('YT', 'MYT', '175', 'AF', -12.5, 45.1);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ZA', 'ZAF', '710', 'AF', -29, 24);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ZM', 'ZMB', '894', 'AF', -15, 30);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ZR', 'ZAR', '180', 'AF', 0, 0);
INSERT INTO `DB_NAME`.`locale_countries` (`_id`, `code_A3`, `code_N3`, `region`, `lat`, `lon`) VALUES ('ZW', 'ZWE', '716', 'AF', -20, 30);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`locale_countries_descriptions`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AD', 'Andorra');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AE', 'United Arab Emirates');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AF', 'Afghanistan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AG', 'Antigua and Barbuda');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AI', 'Anguilla');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AL', 'Albania');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AM', 'Armenia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AO', 'Angola');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AQ', 'Antarctica');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AR', 'Argentina');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AS', 'American Samoa');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AT', 'Austria');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AU', 'Australia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AW', 'Aruba');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AZ', 'Azerbaijan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BA', 'Bosnia and Herzegowina');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BB', 'Barbados');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BD', 'Bangladesh');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BE', 'Belgium');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BF', 'Burkina Faso');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BG', 'Bulgaria');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BH', 'Bahrain');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BI', 'Burundi');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BJ', 'Benin');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BM', 'Bermuda');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BN', 'Brunei Darussalam');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BO', 'Bolivia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BR', 'Brazil');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BS', 'Bahamas');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BT', 'Bhutan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BV', 'Bouvet Island');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BW', 'Botswana');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BY', 'Belarus');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('BZ', 'Belize');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CA', 'Canada');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CC', 'Cocos (Keeling) Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CF', 'Central African Republic');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CG', 'Congo');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CH', 'Switzerland');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CI', 'Cote D`ivoire');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CK', 'Cook Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CL', 'Chile');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CM', 'Cameroon');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CN', 'China');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CO', 'Colombia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CR', 'Costa Rica');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CU', 'Cuba');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CV', 'Cape Verde');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CX', 'Christmas Island');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CY', 'Cyprus');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CZ', 'Czech Republic');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('DE', 'Germany');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('DJ', 'Djibouti');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('DK', 'Denmark');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('DM', 'Dominica');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('DO', 'Dominican Republic');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('DZ', 'Algeria');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('EC', 'Ecuador');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('EE', 'Estonia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('EG', 'Egypt');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('EH', 'Western Sahara');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ER', 'Eritrea');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ES', 'Spain');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ET', 'Ethiopia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('FI', 'Finland');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('FJ', 'Fiji');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('FK', 'Falkland Islands (Malvinas)');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('FM', 'Micronesia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('FO', 'Faroe Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('FR', 'France');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('FX', 'France, Metropolitan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GA', 'Gabon');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GB', 'United Kingdom (Great Britain)');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GD', 'Grenada');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GE', 'Georgia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GF', 'French Guiana');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GH', 'Ghana');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GI', 'Gibraltar');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GL', 'Greenland');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GM', 'Gambia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GN', 'Guinea');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GP', 'Guadeloupe');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GQ', 'Equatorial Guinea');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GR', 'Greece');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GT', 'Guatemala');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GU', 'Guam');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GW', 'Guinea-Bissau');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GY', 'Guyana');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('HK', 'Hong Kong');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('HM', 'Heard and McDonald Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('HN', 'Honduras');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('HR', 'Croatia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('HT', 'Haiti');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('HU', 'Hungary');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ID', 'Indonesia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IE', 'Ireland');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IL', 'Israel');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IN', 'India');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IO', 'British Indian Ocean Territory');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IQ', 'Iraq');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IR', 'Islamic Republic of Iran');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IS', 'Iceland');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IT', 'Italy');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('IM', 'Isle of Man');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('JM', 'Jamaica');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('JO', 'Jordan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('JP', 'Japan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KE', 'Kenya');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KG', 'Kyrgyzstan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KH', 'Cambodia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KI', 'Kiribati');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KM', 'Comoros');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KN', 'St. Kitts and Nevis');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KP', 'Korea');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KR', 'Korea, Republic of');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KW', 'Kuwait');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KY', 'Cayman Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('KZ', 'Kazakhstan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LA', 'Laos');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LB', 'Lebanon');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LC', 'Saint Lucia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LI', 'Liechtenstein');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LK', 'Sri Lanka');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LR', 'Liberia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LS', 'Lesotho');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LT', 'Lithuania');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LU', 'Luxembourg');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LV', 'Latvia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('LY', 'Libyan Arab Jamahiriya');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MA', 'Morocco');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MC', 'Monaco');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MD', 'Moldova, Republic of');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MG', 'Madagascar');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MH', 'Marshall Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MK', 'Macedonia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ML', 'Mali');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MM', 'Myanmar');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MN', 'Mongolia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ME', 'Montenegro');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MO', 'Macau');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MP', 'Northern Mariana Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MQ', 'Martinique');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MR', 'Mauritania');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MS', 'Montserrat');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MT', 'Malta');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MU', 'Mauritius');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MV', 'Maldives');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MW', 'Malawi');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MX', 'Mexico');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MY', 'Malaysia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('MZ', 'Mozambique');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NA', 'Namibia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NC', 'New Caledonia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NE', 'Niger');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NF', 'Norfolk Island');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NG', 'Nigeria');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NI', 'Nicaragua');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NL', 'Netherlands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NO', 'Norway');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NP', 'Nepal');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NR', 'Nauru');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NU', 'Niue');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('NZ', 'New Zealand');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('OM', 'Oman');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PA', 'Panama');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PE', 'Peru');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PF', 'French Polynesia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PG', 'Papua New Guinea');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PH', 'Philippines');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PK', 'Pakistan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PL', 'Poland');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PM', 'St. Pierre and Miquelon');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PN', 'Pitcairn');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PR', 'Puerto Rico');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PS', 'Palestine Authority');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PT', 'Portugal');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PW', 'Palau');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('PY', 'Paraguay');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('QA', 'Qatar');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('RE', 'Reunion');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('RO', 'Romania');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('RU', 'Russian Federation');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('RW', 'Rwanda');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SA', 'Saudi Arabia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CS', 'Serbia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SB', 'Solomon Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SC', 'Seychelles');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SD', 'Sudan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SE', 'Sweden');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SG', 'Singapore');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SH', 'St. Helena');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SI', 'Slovenia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SJ', 'Svalbard and Jan Mayen Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SK', 'Slovakia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SL', 'Sierra Leone');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SM', 'San Marino');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SN', 'Senegal');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SO', 'Somalia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SR', 'Suriname');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ST', 'Sao Tome and Principe');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SV', 'El Salvador');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SY', 'Syrian Arab Republic');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SZ', 'Swaziland');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TC', 'Turks and Caicos Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TD', 'Chad');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TF', 'French Southern Territories');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TG', 'Togo');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TH', 'Thailand');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TJ', 'Tajikistan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TK', 'Tokelau');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TM', 'Turkmenistan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TN', 'Tunisia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TO', 'Tonga');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TL', 'East Timor');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TR', 'Turkey');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TT', 'Trinidad and Tobago');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TV', 'Tuvalu');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TW', 'Taiwan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('TZ', 'Tanzania, United Republic of');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('UA', 'Ukraine');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('UG', 'Uganda');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('US', 'United States');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('UY', 'Uruguay');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('UZ', 'Uzbekistan');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('VA', 'Vatican City State');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('VC', 'St. Vincent and the Grenadines');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('VE', 'Venezuela');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('VG', 'British Virgin Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('VI', 'United States Virgin Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('VN', 'Viet Nam');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('VU', 'Vanuatu');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('WF', 'Wallis And Futuna Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('WS', 'Samoa');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('YE', 'Yemen');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('YT', 'Mayotte');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ZA', 'South Africa');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ZM', 'Zambia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ZR', 'Zaire');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('ZW', 'Zimbabwe');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CD', 'Democratic Republic of Congo');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AP', 'Asia-Pacific');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('RS', 'Republic of Serbia');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('AX', 'Aland Islands');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('EU', 'Europe');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('GG', 'Guernsey');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('JE', 'Jersey');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('CW', 'Curaçao');
INSERT INTO `DB_NAME`.`locale_countries_descriptions` (`_id`, `title`) VALUES ('SX', 'Sint Maarten');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`locale_states`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (15, 'CA', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (13, 'AR', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (12, 'AZ', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (11, 'AK', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (10, 'AL', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (16, 'CO', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (17, 'CT', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (18, 'DE', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (19, 'DC', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (20, 'FL', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (21, 'GA', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (22, 'GU', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (23, 'HI', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (24, 'ID', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (25, 'IL', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (26, 'IN', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (27, 'IA', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (28, 'KS', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (29, 'KY', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (30, 'LA', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (31, 'ME', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (32, 'MD', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (33, 'MA', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (34, 'MI', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (35, 'MN', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (36, 'MS', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (37, 'MO', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (38, 'MT', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (39, 'NE', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (40, 'NV', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (41, 'NH', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (42, 'NJ', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (43, 'NM', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (44, 'NY', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (45, 'NC', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (46, 'ND', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (47, 'OH', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (48, 'OK', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (49, 'OR', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (50, 'PA', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (51, 'PR', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (52, 'RI', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (53, 'SC', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (54, 'SD', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (55, 'TN', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (56, 'TX', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (57, 'UT', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (58, 'VT', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (59, 'VI', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (60, 'VA', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (61, 'WA', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (62, 'WV', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (63, 'WI', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (64, 'WY', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (74, '01', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (66, '02', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (67, '03', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (68, '04', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (69, '06', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (70, '07', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (71, '08', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (72, '09', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (73, '10', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (75, '11', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (76, '12', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (77, '13', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (78, '14', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (79, '15', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (80, '16', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (81, '17', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (82, '18', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (83, '19', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (84, '2A', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (85, '21', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (86, '22', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (87, '23', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (88, '24', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (89, '25', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (90, '26', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (91, '91', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (92, '27', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (93, '28', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (94, '29', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (95, '30', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (96, '32', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (97, '33', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (98, '2B', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (99, '31', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (100, '43', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (101, '52', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (102, '87', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (103, '05', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (104, '92', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (105, '34', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (106, '35', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (107, '36', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (108, '37', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (109, '38', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (110, '39', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (111, '40', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (112, '41', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (113, '42', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (114, '44', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (115, '45', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (116, '46', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (117, '47', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (118, '48', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (119, '49', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (120, '50', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (121, '51', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (122, '75', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (123, '93', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (124, '80', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (125, '81', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (126, '82', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (127, '90', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (128, '95', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (129, '94', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (130, '83', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (131, '84', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (132, '85', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (133, '86', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (134, '88', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (135, '89', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (136, 'AB', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (137, 'BC', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (138, 'MB', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (139, 'NB', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (140, 'NL', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (141, 'NT', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (142, 'NS', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (143, 'NU', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (144, 'ON', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (145, 'PE', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (146, 'QC', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (147, 'SK', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (148, 'YT', 'CA');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (149, 'ACT', 'AU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (150, 'NSW', 'AU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (151, 'NT', 'AU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (152, 'QLD', 'AU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (153, 'SA', 'AU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (154, 'TAS', 'AU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (155, 'VIC', 'AU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (156, 'WA', 'AU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (157, 'DR', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (158, 'FL', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (159, 'FR', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (160, 'GE', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (161, 'GR', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (162, 'LI', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (163, 'NB', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (164, 'NH', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (165, 'OV', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (166, 'UT', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (167, 'ZE', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (168, 'ZH', 'NL');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (169, 'BAW', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (170, 'BAY', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (171, 'BER', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (172, 'BRG', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (173, 'BRE', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (174, 'HAM', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (175, 'HES', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (176, 'MEC', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (177, 'NDS', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (178, 'NRW', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (179, 'RHE', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (180, 'SAR', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (181, 'SAS', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (182, 'SAC', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (183, 'SCN', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (184, 'THE', 'DE');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (185, 'ABN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (186, 'ABNS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (187, 'ANG', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (188, 'AGS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (189, 'ARY', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (190, 'BEDS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (191, 'BERKS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (192, 'BLA', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (193, 'BRI', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (194, 'BSTL', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (195, 'BUCKS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (196, 'CAE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (197, 'CAMBS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (198, 'CDF', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (199, 'CARM', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (200, 'CDGN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (201, 'CHES', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (202, 'CLACK', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (203, 'CON', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (204, 'CORN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (205, 'DNBG', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (206, 'DERBY', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (207, 'DVN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (208, 'DOR', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (209, 'DGL', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (210, 'DUND', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (211, 'DHM', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (212, 'ARYE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (213, 'DUNBE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (214, 'LOTE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (215, 'RENE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (216, 'ERYS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (217, 'SXE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (218, 'EDIN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (219, 'ESX', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (220, 'FALK', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (221, 'FFE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (222, 'FLINT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (223, 'GLAS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (224, 'GLOS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (225, 'LDN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (226, 'MCH', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (227, 'GDD', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (228, 'HANTS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (229, 'HWR', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (230, 'HERTS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (231, 'HLD', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (232, 'IVER', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (233, 'IOW', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (234, 'KNT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (235, 'LANCS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (236, 'LEICS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (237, 'LINCS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (238, 'MSY', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (239, 'MERT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (240, 'MLOT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (241, 'MMOUTH', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (242, 'MORAY', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (243, 'NPRTAL', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (244, 'NEWPT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (245, 'NOR', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (246, 'ARYN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (247, 'LANN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (248, 'YSN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (249, 'NHM', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (250, 'NLD', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (251, 'NOT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (252, 'ORK', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (253, 'OFE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (254, 'PEM', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (255, 'PERTH', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (256, 'PWS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (257, 'REN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (258, 'RHON', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (259, 'RUT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (260, 'BOR', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (261, 'SHET', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (262, 'SPE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (263, 'SOM', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (264, 'ARYS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (265, 'LANS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (266, 'YKS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (267, 'SFD', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (268, 'STIR', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (269, 'SFK', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (270, 'SRY', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (271, 'SWAN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (272, 'TORF', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (273, 'TWR', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (274, 'VGLAM', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (275, 'WARKS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (276, 'WDUN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (277, 'WLOT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (278, 'WMD', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (279, 'SXW', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (280, 'YSW', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (281, 'WIL', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (282, 'WLT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (283, 'WORCS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (284, 'WRX', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (285, 'GR', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (286, 'BE', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (287, 'VS', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (288, 'VD', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (289, 'TI', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (290, 'SG', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (291, 'ZH', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (292, 'FR', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (293, 'LU', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (294, 'AG', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (295, 'UR', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (296, 'TG', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (297, 'SZ', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (298, 'JU', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (299, 'NE', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (300, 'SO', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (301, 'GL', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (302, 'BL', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (303, 'OW', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (304, 'SH', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (305, 'GE', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (306, 'NW', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (307, 'AR', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (308, 'ZG', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (309, 'AI', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (310, 'BS', 'CH');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (385, 'AG', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (386, 'AL', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (387, 'AN', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (388, 'AO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (389, 'AR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (390, 'AP', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (391, 'AT', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (392, 'AV', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (393, 'BA', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (394, 'BL', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (395, 'BN', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (396, 'BG', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (397, 'BI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (398, 'BO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (399, 'BZ', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (400, 'BS', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (401, 'BR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (402, 'CA', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (403, 'CL', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (404, 'CB', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (405, 'CI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (406, 'CE', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (407, 'CT', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (408, 'CZ', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (409, 'CH', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (410, 'CO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (411, 'CS', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (412, 'CR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (413, 'KR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (414, 'CN', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (415, 'EN', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (416, 'FE', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (417, 'FI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (418, 'FG', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (419, 'FC', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (420, 'FR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (421, 'GE', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (422, 'GO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (423, 'GR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (424, 'IM', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (425, 'IS', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (426, 'SP', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (427, 'AQ', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (428, 'LT', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (429, 'LE', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (430, 'LC', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (431, 'LI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (432, 'LO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (433, 'LU', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (434, 'MC', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (435, 'MN', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (436, 'MS', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (437, 'MT', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (438, 'ME', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (439, 'MI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (440, 'MO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (441, 'NA', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (442, 'NO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (443, 'NU', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (444, 'OT', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (445, 'OR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (446, 'PD', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (447, 'PA', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (448, 'PR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (449, 'PV', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (450, 'PG', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (451, 'PU', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (452, 'PE', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (453, 'PC', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (454, 'PI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (455, 'PT', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (456, 'PN', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (457, 'PZ', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (458, 'PO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (459, 'RG', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (460, 'RA', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (461, 'RC', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (462, 'RE', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (463, 'RI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (464, 'RN', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (465, 'RM', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (466, 'RO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (467, 'SA', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (468, 'VS', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (469, 'SS', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (470, 'SV', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (471, 'SI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (472, 'SR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (473, 'SO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (474, 'TA', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (475, 'TE', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (476, 'TR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (477, 'TO', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (478, 'OG', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (479, 'TP', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (480, 'TN', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (481, 'TV', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (482, 'TS', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (483, 'UD', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (484, 'VA', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (485, 'VE', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (486, 'VB', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (487, 'VC', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (488, 'VR', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (489, 'VV', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (490, 'VI', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (491, 'VT', 'IT');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (492, 'ANT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (493, 'ARM', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (494, 'DOW', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (495, 'FER', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (496, 'LDY', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (497, 'TYR', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (498, 'MP', 'US');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (499, 'AVN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (500, 'CLV', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (501, 'CMA', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (502, 'MDX', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (503, 'IOS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (504, 'HUM', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (505, 'SYK', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (506, 'BAN', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (507, 'BEW', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (508, 'CAI', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (509, 'DFS', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (510, 'INV', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (511, 'KCD', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (512, 'NAI', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (513, 'PEE', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (514, 'ROX', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (515, 'SEL', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (516, 'STI', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (517, 'SUT', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (518, 'WIG', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (519, 'CWD', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (520, 'DFD', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (521, 'MER', 'GB');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (522, 'AD', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (523, 'AL', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (524, 'BA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (525, 'BU', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (526, 'DA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (527, 'IN', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (528, 'KB', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (529, 'KL', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (530, 'KC', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (531, 'KR', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (532, 'KO', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (533, 'ME', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (534, 'MO', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (535, 'SA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (536, 'SE', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (537, 'TA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (538, 'TY', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (539, 'UD', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (540, 'KK', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (541, 'CE', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (542, 'CU', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (543, 'ALT', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (544, 'KDA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (545, 'KIA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (546, 'PER', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (547, 'PRI', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (548, 'STA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (549, 'KHA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (550, 'AMU', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (551, 'ARK', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (552, 'AST', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (553, 'BEL', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (554, 'BRY', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (555, 'VLA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (556, 'VGG', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (557, 'VLG', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (558, 'VOR', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (559, 'IVA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (560, 'IRK', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (561, 'KGD', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (562, 'KLU', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (564, 'KEM', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (565, 'KIR', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (566, 'KOS', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (567, 'KGN', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (568, 'KRS', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (569, 'LEN', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (570, 'LIP', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (571, 'MAG', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (572, 'MOS', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (573, 'MUR', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (574, 'NIZ', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (575, 'NGR', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (576, 'NVS', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (577, 'OMS', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (578, 'ORE', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (579, 'ORL', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (580, 'PNZ', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (581, 'PSK', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (582, 'ROS', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (583, 'RYA', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (584, 'SAM', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (585, 'SAR', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (586, 'SAK', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (587, 'SVE', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (588, 'SMO', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (589, 'TAM', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (590, 'TVE', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (591, 'TOM', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (592, 'TUL', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (593, 'TYU', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (594, 'ULY', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (595, 'CHE', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (597, 'YAR', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (598, 'MOW', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (599, 'SPE', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (600, 'YEV', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (603, 'NEN', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (605, 'KHM', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (606, 'CHU', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (607, 'YAN', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (608, 'ZAB', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (609, 'KAM', 'RU');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (610, '53', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (611, '54', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (612, '55', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (613, '56', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (614, '57', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (615, '58', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (616, '59', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (617, '60', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (618, '61', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (619, '62', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (620, '63', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (621, '64', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (622, '65', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (623, '66', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (624, '67', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (625, '68', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (626, '69', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (627, '70', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (628, '71', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (629, '72', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (630, '73', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (631, '74', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (632, '76', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (633, '77', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (634, '78', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (635, '79', 'FR');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (636, 'C', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (637, 'VI', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (638, 'AB', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (639, 'A', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (640, 'AL', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (641, 'O', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (642, 'AV', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (643, 'BA', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (644, 'PM', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (645, 'B', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (646, 'BU', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (647, 'CC', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (648, 'CA', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (649, 'S', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (650, 'CS', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (651, 'CE', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (652, 'CR', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (653, 'CO', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (654, 'CU', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (655, 'GI', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (656, 'GR', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (657, 'GU', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (658, 'SS', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (659, 'H', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (660, 'HU', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (661, 'J', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (662, 'LO', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (663, 'GC', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (664, 'LE', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (665, 'L', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (666, 'LU', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (667, 'M', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (668, 'MA', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (669, 'ML', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (670, 'MU', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (671, 'NA', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (672, 'OR', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (673, 'P', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (674, 'PO', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (675, 'SA', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (676, 'TF', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (677, 'SG', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (678, 'SE', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (679, 'SO', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (680, 'T', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (681, 'TE', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (682, 'TO', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (683, 'V', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (684, 'VA', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (685, 'BI', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (686, 'ZA', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (687, 'Z', 'ES');
INSERT INTO `DB_NAME`.`locale_states` (`_id`, `state_code`, `country_code`) VALUES (688, 'SF', 'BG');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`shared_owner_codes`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('A', 'shared_profiles', 'profile', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('B', NULL, 'frequency', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('C', 'companies', 'companies', 'glyphicons glyphicons-building');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('D', NULL, 'work category', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('E', NULL, 'commit', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('F', 'shared_media', 'attachment', 'glyphicons glyphicons-paperclip');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('G', 'commerce_payments', 'payment', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('H', 'projects_products_releases', 'project product release', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('I', 'posts', 'post', 'glyphicons glyphicons-bullhorn');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('J', 'projects_products', 'project product', 'glyphicons glyphicons-package');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('K', NULL, 'workaround', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('L', NULL, 'venue', 'glyphicons glyphicons-map-marker');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('M', 'shared_comments', 'comment', 'glyphicons glyphicons-conversation');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('N', 'events', 'event', 'glyphicons glyphicons-calendar');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('O', 'submissions', 'submission', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('P', 'projects', 'project', 'glyphicons glyphicons-briefcase');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('Q', NULL, 'system', 'glyphicons glyphicons-server');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('R', NULL, 'resource', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('S', 'projects_statements', 'statement', 'glyphicons glyphicons-money');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('T', 'projects_missions', 'mission', 'glyphicons glyphicons-target');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('U', 'users', 'user', 'glyphicons glyphicons-user');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('V', 'companies_deliverables', 'deliverable', 'fa fa-truck');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('W', 'projects_work', 'work', 'glyphicons glyphicons-settings');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('X', 'projects_sprints', 'sprint', 'glyphicons glyphicons-person-running');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('Y', NULL, 'reproducibility', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('Z', NULL, 'severity', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AA', 'system_apis', 'api', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AB', 'users_worklog', 'work log', 'glyphicons glyphicons-history');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AC', 'workflows', 'workflows', 'glyphicons glyphicons-flowchart');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AD', NULL, 'salutation', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AE', NULL, 'referral', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AF', 'shared_social', 'social media', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AG', NULL, 'authorization', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AH', 'projects_contracts', 'contract', 'glyphicons glyphicons-handshake');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AI', NULL, 'form', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AJ', NULL, 'email', 'glyphicons glyphicons-send');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AK', 'workflows_transitions', 'transition', 'glyphicons glyphicons-transfer');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AL', 'users_worklog_hours', 'work log hours type', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AM', 'users_pay_rates|company_pay_rates', 'company/user pay rate', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AN', NULL, 'design', 'glyphicons glyphicons-pictures');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AO', 'professions', 'profession', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AP', 'professions_responsibilities', 'responsibility', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AQ', NULL, 'duration', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AR', NULL, 'post to', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AS', 'commerce_orders', 'orders', 'glyphicons glyphicons-shopping-cart');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AT', 'shared_discounts', 'discounts', 'glyphicons glyphicons-sampler');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AU', 'properties', 'property', 'glyphicons glyphicons-home');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AV', 'system_settings', 'settings', NULL);
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('AW', 'properties_reservations', 'reservation', 'glyphicons glyphicons-book-open');
INSERT INTO `DB_NAME`.`shared_owner_codes` (`owner`, `table`, `code`, `icon`) VALUES ('ZZ', NULL, 'All', NULL);

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`shared_statuses`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (-1, 'ZZ', 'Deleted', '#FFFFFF', '#000000');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (1, 'U', 'Active', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (2, 'U', 'Disabled', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (3, 'U', 'Pending', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (10, 'C', 'Active', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (11, 'C', 'Disabled', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (20, 'P', 'Idea', '#FFFFFF', '#19c395');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (21, 'P', 'Requested', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (22, 'P', 'Approved', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (23, 'P', 'Planning', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (24, 'P', 'Current', '#FFFFFF', '#008000');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (25, 'P', 'OnHold', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (26, 'P', 'Dead', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (28, 'P', 'Complete', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (30, 'T', 'New', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (31, 'T', 'Open', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (32, 'T', 'Complete', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (40, 'W', 'New', '#FFFFFF', '#19c395');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (41, 'W', 'Investigating', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (42, 'W', 'Confirmed', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (43, 'W', 'In-Work', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (44, 'W', 'Ready to Test', '#FFFFFF', '#fc3644');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (45, 'W', 'Testing', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (46, 'W', 'Postponed', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (47, 'W', 'Complete', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (48, 'W', 'Fixed', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (49, 'W', 'Duplicate', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (50, 'W', 'Re-Work', '#FFFFFF', '#fc3644');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (51, 'W', 'OBE', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (52, 'W', 'Will Not Fix', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (53, 'W', 'Not an Issue', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (54, 'W', 'Ready to Verify', '#FFFFFF', '#fc3644');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (55, 'W', 'Verifying', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (70, 'V', 'Active', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (71, 'V', 'Discontinued', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (90, 'N', 'Pending', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (91, 'N', 'Confirmed', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (92, 'N', 'Canceled', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (93, 'N', 'No Show', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (94, 'N', 'Done', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (95, 'N', 'Paid', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (96, 'N', 'Running Late', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (100, 'S', 'Generated', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (101, 'S', 'Issued', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (102, 'S', 'Paid', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (103, 'S', 'Accepted', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (110, 'O', 'Submitted', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (111, 'O', 'Scheduled', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (112, 'O', 'Followed-Up', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (113, 'O', 'Converted', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (114, 'O', 'Declined', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (120, 'J', 'Active', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (121, 'J', 'Discontinued', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (130, 'X', 'Planned', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (131, 'X', 'Started', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (132, 'X', 'Completed', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (140, 'I', 'Published', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (141, 'I', 'Private', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (142, 'I', 'Draft', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (143, 'I', 'Pending Review', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (150, 'H', 'Unreleased', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (151, 'H', 'Released', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (160, 'AB', 'Created', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (161, 'AB', 'Updated', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (162, 'AB', 'Submitted', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (163, 'AB', 'Approved', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (164, 'AB', 'Returned', '#FFFFFF', '#fc3644');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (165, 'AB', 'Rejected', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (170, 'AH', 'Draft', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (171, 'AH', 'Out for Signature', '#FFFFFF', '#fc3644');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (172, 'AH', 'Filed', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (175, 'AI', 'Active', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (176, 'AI', 'Disabled', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (180, 'AM', 'Active', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (181, 'AM', 'In-Active', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (190, 'AS', 'Pending Payment', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (191, 'AS', 'Processing', '#FFFFFF', '#5974d9');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (192, 'AS', 'On-Hold', '#FFFFFF', '#f07612');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (193, 'AS', 'Completed', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (194, 'AS', 'Cancelled', '#FFFFFF', '#fc3644');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (195, 'AS', 'Refunded', '#FFFFFF', '#777777');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (196, 'AS', 'Failed', '#FFFFFF', '#fc3644');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (200, 'AT', 'Active', '#FFFFFF', '#7bbd6b');
INSERT INTO `DB_NAME`.`shared_statuses` (`_id`, `owner`, `title`, `foreground`, `background`) VALUES (201, 'AT', 'Deactivated', '#FFFFFF', '#777777');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`shared_types`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (1, 'P', 'Sequential', 'NULL', 'A sequential project is one whose actions must be performed in a certain order. The bake a cake project is a sequential project; you cant bake the cake before you buy the ingredients and you cant buy the ingredients before you find a recipe.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (2, 'P', 'Parallel', 'NULL', 'A parallel project is a project whose actions can be completed in any order. For example, a pay bills project whose actions are pay rent, pay cell phone bill, pay water bill, etc. This project would be considered parallel because it doesnt matter what order you pay your bills in; it just matters that they all are completed.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (3, 'P', 'Single Action List', 'NULL', 'A single action list is a special kind of project that usually consists of projects with only one step to complete or an assortment of related actions (like, buy groceries). Often times, it is helpful to create a miscellaneous project to keep things organized.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (10, 'R', 'Owner', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (11, 'R', 'Investigator', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (12, 'R', 'Manager', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (13, 'R', 'Developer', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (14, 'R', 'Stakeholder', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (15, 'R', 'Vendor', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (20, 'U', 'Professional', 'NULL', 'Professionals are the business owners of a company and have admin access.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (21, 'U', 'Client', 'NULL', 'A person using your products and/or services for personal or professional gain.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (22, 'U', 'Colleague', 'NULL', 'A person with whom one works, in profession or business.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (23, 'U', 'Assistant', 'NULL', 'A person who helps in particular work.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (24, 'U', 'Resource', 'NULL', 'A person with materials, money, staff, and other assets necessary for effective operation.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (25, 'U', 'Lead', 'NULL', 'A team lead is someone who provides guidance, instruction, direction and leadership to a group of other individuals (the team) for the purpose of achieving a key result or group of aligned results.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (26, 'U', 'Vendor', 'NULL', 'A person offering something for sale.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (27, 'U', 'Stakeholder', 'NULL', 'An external member of the Scrum Team with a specific interest in and knowledge of a product that is required for incremental discovery. Represented by the Product Owner and actively engaged with the Scrum Team at Sprint Review.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (28, 'U', 'Developer', 'NULL', 'A person that develops products, tangible or intangible, for a business.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (29, 'U', 'Quality Manager', 'NULL', 'A person who plays a crucial role in business by ensuring that products meet certain standards of quality.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (30, 'U', 'Tester', 'NULL', 'A person who tests something, especially a new product. A person who tests a product or service for defects.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (31, 'U', 'Product Owner', 'NULL', 'A member of the Scrum Team accountable for maximizing the value of a product, primarily by incrementally managing and expressing business and functional expectations for a product to the Development Team(s).');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (32, 'U', 'Scrum Master', 'NULL', 'A member of the Scrum Team accountable for guiding, coaching, teaching and assisting a Scrum Team and its environments in a proper understanding and use of Scrum.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (33, 'U', 'Project Manager', 'NULL', 'A person in overall charge of the planning and execution of a particular project.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (34, 'U', 'Contractor', 'NULL', 'A person that undertakes a contract to provide materials or labor to perform a service or do a job.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (35, 'M', 'Comment', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (36, 'M', 'Testimonial', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (37, 'M', 'Attachment', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (45, 'F', 'Document', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (46, 'F', 'Image', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (47, 'F', 'Audio', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (48, 'F', 'Video', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (50, 'A', 'Billing', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (51, 'A', 'Shipping', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (52, 'A', 'Other', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (60, 'C', 'Analysis', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (61, 'C', 'Sales', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (62, 'C', 'Marketing', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (63, 'C', 'Development', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (64, 'C', 'Design', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (65, 'C', 'Consulting', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (66, 'C', 'Other Industry', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (67, 'C', 'Restaurant', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (68, 'C', 'Small Business', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (69, 'C', 'Retail', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (70, 'B', 'Hourly', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (71, 'B', 'Daily', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (72, 'B', 'Weekly', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (73, 'B', 'Monthly', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (74, 'B', 'Yearly', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (75, 'B', 'One-Time', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (80, 'D', 'Environment', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (81, 'D', 'General', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (82, 'D', 'Security', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (83, 'D', 'User Interface', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (84, 'D', 'Code', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (100, 'V', 'Product', 'glyphicons glyphicons-package', 'A product is a tangible resource that can be shipped.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (101, 'V', 'Service', 'glyphicons glyphicons-donate', 'A service is an intangible resource that is delivered as work provided.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (102, 'V', 'Appointment', 'glyphicons glyphicons-calendar', 'An appointment is a paid event.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (120, 'G', 'Check', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (121, 'G', 'Cash', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (122, 'G', 'PayPal', 'social social-paypal primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (123, 'G', 'Stripe', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (124, 'G', 'Square', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (125, 'G', 'Authorize.NET', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (130, 'S', 'Invoice', 'NULL', 'A list of products sent or services provided.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (131, 'S', 'Proposal', 'NULL', 'A list of products sent or services that can be provided.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (132, 'S', 'Retainer', 'NULL', 'A fee paid in advance in order to secure or keep their services when required.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (140, 'Y', 'Always', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (141, 'Y', 'Sometimes', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (142, 'Y', 'Random', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (143, 'Y', 'Have Not Tried', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (144, 'Y', 'Unable to Reproduce', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (145, 'Y', 'N/A', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (150, 'Z', 'Trivial', 'fa fa-warning default', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (151, 'Z', 'Text', 'fa fa-warning default', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (152, 'Z', 'Tweak', 'fa fa-warning info', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (153, 'Z', 'Minor', 'fa fa-warning warning', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (154, 'Z', 'Major', 'fa fa-warning danger', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (155, 'Z', 'Crash', 'fa fa-warning danger', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (156, 'Z', 'Block', 'fa fa-warning danger', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (160, 'W', 'Bug', 'fa fa-bug', 'Have you discovered a bug in the application, or is something not working as expected?');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (161, 'W', 'Feature', 'fa fa-star', 'Are you missing some specific feature, or is your favourite part of the application a bit lacking?');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (162, 'W', 'Enhancement', 'fa fa-wrench', 'Have you found something that is working in a way that could be improved?');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (163, 'W', 'Task', 'fa fa-tasks', 'Submit an internal task');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (164, 'W', 'User Story', 'fa fa-code', 'Doing it Agile-style. Issue type perfectly suited for entering user stories');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (165, 'W', 'Idea', 'fa fa-lightbulb-o', 'Express yourself - share your ideas with the rest of the team!');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (166, 'W', 'Documentation', 'fa fa-book', 'Submit a request for user documentation changes.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (175, 'H', 'Alpha', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (176, 'H', 'Beta', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (177, 'H', 'Release Candidate', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (178, 'H', 'Final Release', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (200, 'K', 'Not Specified', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (201, 'K', 'Yes', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (202, 'K', 'No', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (210, 'O', 'Consultation', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (211, 'O', 'Contact Form', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (220, 'T', 'In-Active', 'NULL', 'Work items that are new or backlogged are added to inactive tasks (Scrum: Product Backlog).');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (221, 'T', 'Active', 'NULL', 'Work items that are billed or part of a release are added to active tasks (Scrum: Release Backlog).');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (230, 'I', 'Standard', 'glyphicons glyphicons-pushpin', 'A standard blog post or article.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (231, 'I', 'Image', 'glyphicons glyphicons-camping', 'A single image. The first <img /> tag in the post could be considered the image. Alternatively, if the post consists only of a URL, that will be the image URL and the title of the post (post_title) will be the title attribute for the image.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (232, 'I', 'Video', 'glyphicons glyphicons-facetime-video', 'A single video or video playlist. The first <video /> tag or object/embed in the post content could be considered the video. Alternatively, if the post consists only of a URL, that will be the video URL. May also contain the video as an attachment to the post, if video support is enabled on the blog (like via a plugin).');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (233, 'I', 'Link', 'glyphicons glyphicons-paperclip', 'A link to another site. Themes may wish to use the first <a href=””> tag in the post content as the external link for that post. An alternative approach could be if the post consists only of a URL, then that will be the URL and the title (post_title) will be the name attached to the anchor for it.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (234, 'I', 'Quote', 'glyphicons glyphicons-quote', 'A quotation. Probably will contain a blockquote holding the quote content. Alternatively, the quote may be just the content, with the source/author being the title.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (235, 'I', 'Audio', 'glyphicons glyphicons-voice', 'An audio file or playlist. Could be used for Podcasting.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (240, 'L', 'Phone', 'fa fa-phone', 'The event will be conducted via phone. Ensure a valid phone number is captured.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (241, 'L', 'Video', 'fa fa-video-camera', 'The event will be conducted via video. Ensure video conference information is included in description.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (242, 'L', 'On-Site', 'fa fa-paper-plane', 'The event will be conducted on location. Ensure a valid location is supplied.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (243, 'L', 'Off-Site', 'fa fa-plane', 'The event will be conducted off site. Ensure a valid address is supplied.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (250, 'AA', 'WordPress', 'social social-wordpress info', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (251, 'AA', 'Facebook', 'social social-facebook primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (252, 'AA', 'Twitter', 'social social-twitter info', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (253, 'AA', 'Instagram', 'social social-instagram primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (254, 'AA', 'LinkedIn', 'social social-linked-in primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (255, 'AA', 'Google+', 'social social-google-plus primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (260, 'AA', 'Adobe Sign', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (265, 'AA', 'PayPal', 'social social-paypal primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (266, 'AA', 'Square', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (267, 'AA', 'Authorize.NET', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (268, 'AA', 'Stripe', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (275, 'AA', 'Google Calendar', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (276, 'AA', 'iCalendar', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (280, 'AA', 'Github', 'social social-github primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (281, 'AA', 'Bitbucket', 'social social-bitbucket primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (290, 'AB', 'Time Log', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (300, 'AD', 'Mr.', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (301, 'AD', 'Ms.', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (302, 'AD', 'Mrs.', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (303, 'AD', 'Dr.', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (310, 'AE', 'Call', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (311, 'AE', 'Email', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (312, 'AE', 'Web', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (313, 'AE', 'Advertising', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (314, 'AE', 'Existing Client', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (315, 'AE', 'By Recommendation', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (316, 'AE', 'Show/Exhibition', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (317, 'AE', 'CRM Form', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (318, 'AE', 'Callback', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (319, 'AE', 'Other', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (330, 'AF', 'Facebook', 'fab fa-facebook', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (331, 'AF', 'Twitter', 'fab fa-twitter', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (332, 'AF', 'Instagram', 'fab fa-instagram', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (333, 'AF', 'LinkedIn', 'fab fa-linkedin', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (334, 'AF', 'Google-Plus', 'fab fa-google-plus', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (335, 'AF', 'Skype', 'fab fa-skype', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (336, 'AF', 'SnapChat', 'fab fa-snapchat', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (337, 'AF', 'Github', 'fab fa-github', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (338, 'AF', 'Bitbucket', 'fab fa-bitbucket', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (350, 'AL', 'Regular Hours', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (351, 'AL', 'Overtime', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (352, 'AL', 'Sick', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (353, 'AL', 'Vacation', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (354, 'AL', 'Holiday', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (355, 'AL', 'Other', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (360, 'N', 'Conference', 'NULL', 'Conferences are popular and important business events.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (361, 'N', 'Seminar', 'NULL', 'Seminars educational events for the training of managers and employees.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (362, 'N', 'Meeting', 'NULL', 'Meetings are common business events in large companies, perfect to discuss operational and financial strategies');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (363, 'N', 'Team Building', 'NULL', 'Team Building Events are key to develop and motivate teams in companies and divisions.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (364, 'N', 'Trade Show', 'NULL', 'Trade Shows are exhibitions where companies can present and demonstrate their latest products.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (365, 'N', 'Business Dinner', 'NULL', 'Business Dinners are a long-standing corporate tradition to conclude fiscal years, celebrate new milestones or to get in contact with key customers.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (366, 'N', 'Golf Event', 'NULL', 'Golf Events are golf tournaments or retreats. Those events aim to acquire new customers, to increase customer loyalty or to motivate employees.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (367, 'N', 'Press Conference', 'NULL', 'Press Conferences are perfect business events to promote new products, launch marketing campaigns or to inform the shareholders and public about financial issues.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (368, 'N', 'Networking Event', 'NULL', 'Networking Events are personal marketing galas. Such events are great opportunities for contact establishment and personal marketing.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (369, 'N', 'Incentive Travel', 'NULL', 'Incentive Travel are perfect to reward and to motivate employees or to increase customer loyalty and retention.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (370, 'N', 'Opening Ceremony', 'NULL', 'Opening Ceremonies are held to start conventions, annual meetings and other events that last for two or more days.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (371, 'N', 'Product Launch', 'NULL', 'Product Launches are critical for the successful market introduction of some products.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (372, 'N', 'Theme Party', 'NULL', 'Theme Parties are events that devote to a special topic. Popular events are casino nights or Halloween parties.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (373, 'N', 'VIP Event', 'NULL', 'VIP Events are used to increase customer loyalty.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (374, 'N', 'Trade Fair', 'NULL', 'Trade Fairs are a great opportunity to present your latest products to customers and business partners.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (375, 'N', 'Shareholder Meeting', 'NULL', 'Shareholder Meetings are yearly and obligatory events to inform a corporations shareholders about company issues and to elect the Board of Directors.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (376, 'N', 'Award Ceremony', 'NULL', 'Award Ceremonies are great events to honor and motivate key staff or to acquire and retain customers.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (377, 'N', 'Incentive Event', 'NULL', 'Incentive Events motivate employees or close the ties to customers.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (378, 'N', 'Board Meeting', 'NULL', 'Board Meetings focus on strategic goals and visions.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (379, 'N', 'Executive Retreat', 'NULL', 'Executive Retreats are escapes from stressful work schedules and the day-to-day business.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (380, 'N', 'Family Event', 'NULL', 'Family Events are great opportunities to assemble whole families. Family events include birthdays, weddings, etc.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (400, 'AQ', 'Minutes', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (401, 'AQ', 'Hours', 'NULL', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (430, 'AR', 'WordPress', 'social social-wordpress info', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (431, 'AR', 'Facebook', 'social social-facebook primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (432, 'AR', 'Twitter', 'social social-twitter info', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (433, 'AR', 'Instagram', 'social social-instagram primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (434, 'AR', 'LinkedIn', 'social social-linked-in primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (435, 'AR', 'Google+', 'social social-google-plus primary', 'NULL');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (450, 'AT', 'Catalog', NULL, 'Promotion is applied to all deliverables.');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (451, 'AT', 'Order', NULL, 'Promotion is applied to orders on checkout');
INSERT INTO `DB_NAME`.`shared_types` (`_id`, `owner`, `title`, `icon`, `description`) VALUES (452, 'AT', 'Statement', NULL, 'Promotion is applied to statements only (invoices and/or proposals)');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`locale_states_descriptions`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (10, 'Alabama');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (11, 'Alaska');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (12, 'Arizona');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (13, 'Arkansas');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (15, 'California');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (16, 'Colorado');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (17, 'Connecticut');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (18, 'Delaware');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (19, 'District of Columbia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (20, 'Florida');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (21, 'Georgia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (22, 'Guam');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (23, 'Hawaii');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (24, 'Idaho');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (25, 'Illinois');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (26, 'Indiana');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (27, 'Iowa');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (28, 'Kansas');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (29, 'Kentucky');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (30, 'Louisiana');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (31, 'Maine');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (32, 'Maryland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (33, 'Massachusetts');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (34, 'Michigan');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (35, 'Minnesota');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (36, 'Mississippi');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (37, 'Missouri');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (38, 'Montana');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (39, 'Nebraska');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (40, 'Nevada');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (41, 'New Hampshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (42, 'New Jersey');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (43, 'New Mexico');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (44, 'New York');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (45, 'North Carolina');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (46, 'North Dakota');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (47, 'Ohio');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (48, 'Oklahoma');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (49, 'Oregon');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (50, 'Pennsylvania');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (51, 'Puerto Rico');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (52, 'Rhode Island');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (53, 'South Carolina');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (54, 'South Dakota');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (55, 'Tennessee');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (56, 'Texas');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (57, 'Utah');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (58, 'Vermont');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (59, 'Virgin Islands');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (60, 'Virginia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (61, 'Washington');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (62, 'West Virginia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (63, 'Wisconsin');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (64, 'Wyoming');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (66, 'Aisne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (67, 'Allier');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (68, 'Alpes-de-Haute-Provence');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (69, 'Alpes-Maritimes');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (70, 'Ardèche');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (71, 'Ardennes');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (72, 'Ariège');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (73, 'Aube');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (74, 'Ain');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (75, 'Aude');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (76, 'Aveyron');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (77, 'Bouches-du-Rhône');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (78, 'Calvados');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (79, 'Cantal');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (80, 'Charente');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (81, 'Charente-Maritime');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (82, 'Cher');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (83, 'Corrèze');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (84, 'Corse-du-Sud');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (85, 'Côte-d`Or');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (86, 'Côtes-d`Armor');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (87, 'Creuse');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (88, 'Dordogne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (89, 'Doubs');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (90, 'Drôme');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (91, 'Essonne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (92, 'Eure');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (93, 'Eure-et-Loir');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (94, 'Finistère');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (95, 'Gard');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (96, 'Gers');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (97, 'Gironde');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (98, 'Haute-Corse');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (99, 'Haute-Garonne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (100, 'Haute-Loire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (101, 'Haute-Marne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (102, 'Haute-Vienne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (103, 'Hautes-Alpes');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (104, 'Hauts-de-Seine');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (105, 'Hérault');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (106, 'Ille-et-Vilaine');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (107, 'Indre');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (108, 'Indre-et-Loire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (109, 'Isère');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (110, 'Jura');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (111, 'Landes');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (112, 'Loir-et-Cher');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (113, 'Loire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (114, 'Loire-Atlantique');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (115, 'Loiret');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (116, 'Lot');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (117, 'Lot-et-Garonne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (118, 'Lozère');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (119, 'Maine-et-Loire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (120, 'Manche');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (121, 'Marne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (122, 'Paris');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (123, 'Seine-Saint-Denis');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (124, 'Somme');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (125, 'Tarn');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (126, 'Tarn-et-Garonne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (127, 'Territoire de Belfort');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (128, 'Val-d`Oise');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (129, 'Val-de-Marne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (130, 'Var');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (131, 'Vaucluse');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (132, 'Vendée');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (133, 'Vienne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (134, 'Vosges');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (135, 'Yonne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (136, 'Alberta');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (137, 'British Columbia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (138, 'Manitoba');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (139, 'New Brunswick');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (140, 'Newfoundland and Labrador');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (141, 'Northwest Territories');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (142, 'Nova Scotia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (143, 'Nunavut');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (144, 'Ontario');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (145, 'Prince Edward Island');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (146, 'Quebec');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (147, 'Saskatchewan');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (148, 'Yukon');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (149, 'Australian Capital Territory');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (150, 'New South Wales');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (151, 'Northern Territory');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (152, 'Queensland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (153, 'South Australia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (154, 'Tasmania');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (155, 'Victoria');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (156, 'Western Australia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (157, 'Drenthe');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (158, 'Flevoland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (159, 'Friesland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (160, 'Gelderland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (161, 'Groningen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (162, 'Limburg');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (163, 'Noord Brabant');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (164, 'Noord Holland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (165, 'Overijssel');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (166, 'Utrecht');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (167, 'Zeeland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (168, 'Zuid Holland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (169, 'Baden-Württemberg');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (170, 'Bayern');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (171, 'Berlin');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (172, 'Branderburg');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (173, 'Bremen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (174, 'Hamburg');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (175, 'Hessen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (176, 'Mecklenburg-Vorpommern');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (177, 'Niedersachsen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (178, 'Nordrhein-Westfalen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (179, 'Rheinland-Pfalz');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (180, 'Saarland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (181, 'Sachsen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (182, 'Sachsen-Anhalt');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (183, 'Schleswig-Holstein');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (184, 'Thüringen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (185, 'Aberdeen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (186, 'Aberdeenshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (187, 'Anglesey');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (188, 'Angus');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (189, 'Argyll and Bute');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (190, 'Bedfordshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (191, 'Berkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (192, 'Blaenau Gwent');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (193, 'Bridgend');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (194, 'Bristol');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (195, 'Buckinghamshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (196, 'Caerphilly');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (197, 'Cambridgeshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (198, 'Cardiff');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (199, 'Carmarthenshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (200, 'Ceredigion');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (201, 'Cheshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (202, 'Clackmannanshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (203, 'Conwy');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (204, 'Cornwall');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (205, 'Denbighshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (206, 'Derbyshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (207, 'Devon');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (208, 'Dorset');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (209, 'Dumfries and Galloway');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (210, 'Dundee');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (211, 'Durham');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (212, 'East Ayrshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (213, 'East Dunbartonshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (214, 'East Lothian');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (215, 'East Renfrewshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (216, 'East Riding of Yorkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (217, 'East Sussex');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (218, 'Edinburgh');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (219, 'Essex');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (220, 'Falkirk');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (221, 'Fife');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (222, 'Flintshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (223, 'Glasgow');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (224, 'Gloucestershire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (225, 'Greater London');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (226, 'Greater Manchester');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (227, 'Gwynedd');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (228, 'Hampshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (229, 'Herefordshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (230, 'Hertfordshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (231, 'Highlands');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (232, 'Inverclyde');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (233, 'Isle of Wight');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (234, 'Kent');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (235, 'Lancashire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (236, 'Leicestershire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (237, 'Lincolnshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (238, 'Merseyside');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (239, 'Merthyr Tydfil');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (240, 'Midlothian');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (241, 'Monmouthshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (242, 'Moray');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (243, 'Neath Port Talbot');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (244, 'Newport');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (245, 'Norfolk');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (246, 'North Ayrshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (247, 'North Lanarkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (248, 'North Yorkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (249, 'Northamptonshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (250, 'Northumberland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (251, 'Nottinghamshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (252, 'Orkney Islands');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (253, 'Oxfordshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (254, 'Pembrokeshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (255, 'Perth and Kinross');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (256, 'Powys');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (257, 'Renfrewshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (258, 'Rhondda Cynon Taff');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (259, 'Rutland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (260, 'Scottish Borders');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (261, 'Shetland Islands');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (262, 'Shropshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (263, 'Somerset');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (264, 'South Ayrshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (265, 'South Lanarkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (266, 'Yorkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (267, 'Staffordshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (268, 'Stirling');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (269, 'Suffolk');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (270, 'Surrey');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (271, 'Swansea');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (272, 'Torfaen');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (273, 'Tyne and Wear');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (274, 'Vale of Glamorgan');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (275, 'Warwickshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (276, 'West Dunbartonshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (277, 'West Lothian');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (278, 'West Midlands');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (279, 'West Sussex');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (280, 'West Yorkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (281, 'Western Isles');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (282, 'Wiltshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (283, 'Worcestershire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (284, 'Wrexham');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (285, 'Grisons');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (286, 'Berne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (287, 'Valais');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (288, 'Vaud');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (289, 'Tessin');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (290, 'Saint-Gall');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (291, 'Zurich');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (292, 'Fribourg');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (293, 'Lucerne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (294, 'Argovie');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (295, 'Uri');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (296, 'Thurgovie');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (297, 'Schwytz');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (298, 'Jura');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (299, 'Neuchâtel');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (300, 'Soleure');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (301, 'Glaris');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (302, 'Bâle-Campagne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (303, 'Obwald');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (304, 'Schaffhouse');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (305, 'Genève');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (306, 'Nidwald');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (307, 'Appenzell Rhodes-Extérieures');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (308, 'Zoug');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (309, 'Appenzell Rhodes-Intérieures');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (310, 'Bâle-Ville');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (385, 'Agrigento');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (386, 'Alessandria');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (387, 'Ancona');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (388, 'Aosta');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (389, 'Arezzo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (390, 'Ascoli Piceno');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (391, 'Asti');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (392, 'Avellino');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (393, 'Bari');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (394, 'Belluno');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (395, 'Benevento');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (396, 'Bergamo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (397, 'Biella');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (398, 'Bologna');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (399, 'Bolzano');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (400, 'Brescia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (401, 'Brindisi');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (402, 'Cagliari');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (403, 'Caltanissetta');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (404, 'Campobasso');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (405, 'Carbonia-Iglesias');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (406, 'Caserta');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (407, 'Catania');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (408, 'Catanzaro');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (409, 'Chieti');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (410, 'Como');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (411, 'Cosenza');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (412, 'Cremona');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (413, 'Crotone');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (414, 'Cuneo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (415, 'Enna');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (416, 'Ferrara');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (417, 'Firenze');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (418, 'Foggia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (419, 'Forli-Cesena');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (420, 'Frosinone');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (421, 'Genova');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (422, 'Gorizia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (423, 'Grosseto');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (424, 'Imperia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (425, 'Isernia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (426, 'La Spezia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (427, 'L`Aquila');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (428, 'Latina');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (429, 'Lecce');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (430, 'Lecco');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (431, 'Livorno');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (432, 'Lodi');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (433, 'Lucca');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (434, 'Macerata');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (435, 'Mantova');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (436, 'Massa-Carrara');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (437, 'Matera');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (438, 'Messina');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (439, 'Milano');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (440, 'Modena');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (441, 'Napoli');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (442, 'Novara');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (443, 'Nuoro');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (444, 'Olbia-Tempio');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (445, 'Oristano');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (446, 'Padova');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (447, 'Palermo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (448, 'Parma');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (449, 'Pavia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (450, 'Perugia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (451, 'Pesaro e Urbino');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (452, 'Pescara');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (453, 'Piacenza');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (454, 'Pisa');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (455, 'Pistoia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (456, 'Pordenone');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (457, 'Potenza');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (458, 'Prato');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (459, 'Ragusa');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (460, 'Ravenna');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (461, 'Reggio Calabria');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (462, 'Reggio Emilia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (463, 'Rieti');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (464, 'Rimini');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (465, 'Roma');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (466, 'Rovigo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (467, 'Salerno');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (468, 'Medio Campidano');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (469, 'Sassari');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (470, 'Savona');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (471, 'Siena');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (472, 'Siracusa');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (473, 'Sondrio');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (474, 'Taranto');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (475, 'Teramo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (476, 'Terni');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (477, 'Torino');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (478, 'Ogliastra');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (479, 'Trapani');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (480, 'Trento');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (481, 'Treviso');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (482, 'Trieste');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (483, 'Udine');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (484, 'Varese');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (485, 'Venezia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (486, 'Verbano-Cusio-Ossola');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (487, 'Vercelli');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (488, 'Verona');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (489, 'Vibo Valentia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (490, 'Vicenza');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (491, 'Viterbo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (492, 'County Antrim');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (493, 'County Armagh');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (494, 'County Down');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (495, 'County Fermanagh');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (496, 'County Londonderry');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (497, 'County Tyrone');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (498, 'Northern Mariana Islands');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (499, 'Avon');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (500, 'Cleveland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (501, 'Cumbria');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (502, 'Middlesex');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (503, 'Isles of Scilly');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (504, 'Humberside');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (505, 'South Yorkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (506, 'Banffshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (507, 'Berwickshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (508, 'Caithness');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (509, 'Dumfries-shire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (510, 'Inverness-shire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (511, 'Kincardineshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (512, 'Nairnshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (513, 'Peebles-shire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (514, 'Roxburghshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (515, 'Selkirkshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (516, 'Stirlingshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (517, 'Sutherland');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (518, 'Wigtownshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (519, 'Clwyd');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (520, 'Dyfed');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (521, 'Merionethshire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (522, 'Respublika Adygeja');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (523, 'Respublika Altaj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (524, 'Respublika Bashkortostan');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (525, 'Respublika Burjatija');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (526, 'Respublika Dagestan');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (527, 'Respublika Ingushetija');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (528, 'Kabardino-Balkarskaja Respublika');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (529, 'Respublika Kalmykija');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (530, 'Karachaevo-Cherkesskaja respublika');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (531, 'Respublika Karelija');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (532, 'Respublika Komi');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (533, 'Respublika Marij Jel');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (534, 'Respublika Mordovija');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (535, 'Respublika Saha (Jakutija)');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (536, 'Respublika Severnaja Osetija-Alanija');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (537, 'Respublika Tatarstan');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (538, 'Respublika Tyva');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (539, 'Udmurtskaja Respublika');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (540, 'Respublika Hakasija');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (541, 'Chechenskaja respublika');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (542, 'Chuvashskaja Respublika');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (543, 'Altajskij kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (544, 'Krasnodarskij kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (545, 'Krasnojarskij kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (546, 'Permskij kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (547, 'Primorskij kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (548, 'Stavropol`skij kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (549, 'Habarovskij kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (550, 'Amurskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (551, 'Arhangel`skaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (552, 'Astrahanskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (553, 'Belgorodskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (554, 'Brjanskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (555, 'Vladimirskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (556, 'Volgogradskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (557, 'Vologodskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (558, 'Voronezhskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (559, 'Ivanovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (560, 'Irkutskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (561, 'Kaliningradskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (562, 'Kaluzhskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (564, 'Kemerovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (565, 'Kirovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (566, 'Kostromskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (567, 'Kurganskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (568, 'Kurskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (569, 'Leningradskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (570, 'Lipeckaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (571, 'Magadanskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (572, 'Moskovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (573, 'Murmanskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (574, 'Nizhegorodskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (575, 'Novgorodskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (576, 'Novosibirskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (577, 'Omskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (578, 'Orenburgskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (579, 'Orlovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (580, 'Penzenskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (581, 'Pskovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (582, 'Rostovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (583, 'Rjazanskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (584, 'Samarskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (585, 'Saratovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (586, 'Sahalinskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (587, 'Sverdlovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (588, 'Smolenskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (589, 'Tambovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (590, 'Tverskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (591, 'Tomskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (592, 'Tul`skaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (593, 'Tjumenskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (594, 'Ul`janovskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (595, 'Cheljabinskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (597, 'Jaroslavskaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (598, 'Moskva');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (599, 'Sankt-Peterburg');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (600, 'Evrejskaja avtonomnaja oblast`');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (603, 'Neneckij avtonomnyj okrug');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (605, 'Hanty-Mansijskij avtonomnyj okrug - Jugra');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (606, 'Chukotskij avtonomnyj okrug');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (607, 'Jamalo-Neneckij avtonomnyj okrug');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (608, 'Zabaykal`skiy kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (609, 'Kamchatskiy kraj');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (610, 'Mayenne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (611, 'Meurthe-et-Moselle');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (612, 'Meuse');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (613, 'Morbihan');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (614, 'Moselle');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (615, 'Nièvre');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (616, 'Nord');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (617, 'Oise');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (618, 'Orne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (619, 'Pas-de-Calais');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (620, 'Puy-de-Dôme');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (621, 'Pyrénées-Atlantiques');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (622, 'Hautes-Pyrénées');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (623, 'Pyrénées-Orientales');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (624, 'Bas-Rhin');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (625, 'Haut-Rhin');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (626, 'Rhône');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (627, 'Haute-Saône');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (628, 'Saône-et-Loire');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (629, 'Sarthe');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (630, 'Savoie');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (631, 'Haute-Savoie');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (632, 'Seine-Maritime');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (633, 'Seine-et-Marne');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (634, 'Yvelines');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (635, 'Deux-Sèvres');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (636, 'A Coruña');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (637, 'Álava');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (638, 'Albacete');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (639, 'Alicante');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (640, 'Almería');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (641, 'Asturias');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (642, 'Ávila');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (643, 'Badajoz');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (644, 'Baleares');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (645, 'Barcelona');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (646, 'Burgos');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (647, 'Cáceres');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (648, 'Cádiz');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (649, 'Cantabria');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (650, 'Castellón');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (651, 'Ceuta');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (652, 'Ciudad Real');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (653, 'Córdoba');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (654, 'Cuenca');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (655, 'Girona');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (656, 'Granada');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (657, 'Guadalajara');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (658, 'Guipúzcoa');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (659, 'Huelva');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (660, 'Huesca');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (661, 'Jaén');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (662, 'La Rioja');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (663, 'Las Palmas');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (664, 'León');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (665, 'Lleida');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (666, 'Lugo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (667, 'Madrid');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (668, 'Málaga');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (669, 'Melilla');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (670, 'Murcia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (671, 'Navarra');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (672, 'Ourense');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (673, 'Palencia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (674, 'Pontevedra');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (675, 'Salamanca');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (676, 'Santa Cruz de Tenerife');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (677, 'Segovia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (678, 'Sevilla');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (679, 'Soria');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (680, 'Tarragona');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (681, 'Teruel');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (682, 'Toledo');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (683, 'Valencia');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (684, 'Valladolid');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (685, 'Vizcaya');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (686, 'Zamora');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (687, 'Zaragoza');
INSERT INTO `DB_NAME`.`locale_states_descriptions` (`_id`, `title`) VALUES (688, 'Sofia');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`system_settings`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (1, 'Q', NULL, 1, 1, 'show_countries', 'true');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (2, 'Q', NULL, 1, 0, 'lang_code', 'en');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (3, 'Q', NULL, 1, 0, 'default_country', 'US');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (4, 'Q', NULL, 1, 1, 'time_format', 'hh:mm A');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (5, 'Q', NULL, 1, 1, 'date_format', 'MM/DD/YYYY');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (6, 'Q', NULL, 1, 1, 'hours_format', 'hh:[00]');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (7, 'Q', NULL, 1, 1, 'mins_interval', '30');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (20, 'AN', NULL, 1, 1, 'blurb', '<strong>Property</strong> Management System');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (21, 'AN', NULL, 1, 0, 'default_page_size', '25');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (22, 'AN', NULL, 1, 0, 'theme', 'theme-zero');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (23, 'AN', NULL, 1, 0, 'left_menu_collapsed', 'false');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (24, 'AN', NULL, 1, 0, 'layout_horizontal', 'false');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (30, 'S', NULL, 1, 1, 'tax', '0.00');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (31, 'S', NULL, 1, 1, 'company_code', 'SD');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (32, 'S', NULL, 1, 1, 'seperator', '-');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (33, 'S', NULL, 1, 1, 'max_gen_chars', '9');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (34, 'S', NULL, 1, 1, 'include_numbers', 'true');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (35, 'S', NULL, 1, 1, 'include_letters', 'false');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (40, 'AC', NULL, 1, 1, 'work_workflow_id', '1');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (41, 'AC', NULL, 1, 1, 'worklog_workflow_id', '2');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (50, 'V', NULL, 1, 1, 'sku_prefix_first', 'company');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (51, 'V', NULL, 1, 1, 'sku_prefix_second', 'deliverable_name');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (52, 'V', NULL, 1, 1, 'sku_prefix_third', 'deliverable_id');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (53, 'V', NULL, 1, 1, 'sku_prefix_last', 'auto_gen');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (54, 'V', NULL, 1, 1, 'sku_seperator', '-');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (55, 'V', NULL, 1, 1, 'sku_autogen_type', 'numbers');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (56, 'V', NULL, 1, 1, 'sku_autogen_max', '3');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (57, 'V', NULL, 1, 1, 'sku_company_max', '3');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (58, 'V', NULL, 1, 1, 'sku_product_max', '3');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (59, 'V', NULL, 1, 1, 'sku_category_max', '3');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (100, 'AN', 1, NULL, 0, 'theme', 'theme-zero');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (101, 'AN', 1, NULL, 0, 'default_page_size', '50');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (102, 'AN', 1, NULL, 0, 'left_menu_collapsed', 'true');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (103, 'AN', 1, NULL, 0, 'layout_horizontal', 'false');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (104, 'C', 1, NULL, 0, 'current_company_id', '1');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (105, 'Q', 1, NULL, 0, 'lang_code', 'en');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (106, 'Q', 1, NULL, 0, 'default_country', 'US');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (200, 'AN', 8, NULL, 0, 'theme', 'theme-zero');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (201, 'AN', 8, NULL, 0, 'default_page_size', '50');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (202, 'AN', 8, NULL, 0, 'left_menu_collapsed', 'true');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (203, 'AN', 8, NULL, 0, 'layout_horizontal', 'false');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (204, 'C', 8, NULL, 0, 'current_company_id', '1');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (205, 'Q', 8, NULL, 0, 'lang_code', 'en');
INSERT INTO `DB_NAME`.`system_settings` (`_id`, `owner`, `user_id`, `responsible_company_id`, `is_global`, `setting_name`, `setting_value`) VALUES (206, 'Q', 8, NULL, 0, 'default_country', 'US');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`system_type_permissions`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (1, 20, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (2, 20, 'C.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (3, 20, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (4, 20, 'F.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (5, 20, 'G.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (6, 20, 'H.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (7, 20, 'I.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (8, 20, 'J.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (9, 20, 'M.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (10, 20, 'N.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (11, 20, 'O.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (12, 20, 'P.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (13, 20, 'Q.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (14, 20, 'S.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (15, 20, 'T.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (16, 20, 'U.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (17, 20, 'V.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (18, 20, 'W.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (19, 20, 'X.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (20, 20, 'AA.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (21, 20, 'AB.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (22, 20, 'AC.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (23, 20, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (24, 20, 'AH.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (25, 20, 'AI.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (26, 20, 'AJ.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (27, 20, 'AM.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (28, 21, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (29, 21, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (30, 21, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (31, 21, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (32, 21, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (33, 21, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (34, 21, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (35, 21, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (36, 21, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (37, 21, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (38, 21, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (39, 21, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (40, 22, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (41, 22, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (42, 22, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (43, 22, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (44, 22, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (45, 22, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (46, 22, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (47, 22, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (48, 22, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (49, 22, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (50, 22, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (51, 22, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (52, 23, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (53, 23, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (54, 23, 'I.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (55, 23, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (56, 23, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (57, 23, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (58, 23, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (59, 23, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (60, 23, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (61, 23, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (62, 23, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (63, 23, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (64, 24, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (65, 24, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (66, 24, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (67, 24, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (68, 24, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (69, 24, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (70, 24, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (71, 24, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (72, 24, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (73, 24, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (74, 24, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (75, 24, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (76, 25, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (77, 25, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (78, 25, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (79, 25, 'H.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (80, 25, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (81, 25, 'J.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (82, 25, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (83, 25, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (84, 25, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (85, 25, 'P.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (86, 25, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (87, 25, 'T.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (88, 25, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (89, 25, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (90, 25, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (91, 25, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (92, 25, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (93, 26, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (94, 26, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (95, 26, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (96, 26, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (97, 26, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (98, 26, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (99, 26, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (100, 26, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (101, 26, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (102, 26, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (103, 26, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (104, 26, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (105, 27, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (106, 27, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (107, 27, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (108, 27, 'H.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (109, 27, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (110, 27, 'J.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (111, 27, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (112, 27, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (113, 27, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (114, 27, 'P.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (115, 27, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (116, 27, 'T.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (117, 27, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (118, 27, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (119, 27, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (120, 27, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (121, 27, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (122, 28, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (123, 28, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (124, 28, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (125, 28, 'H.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (126, 28, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (127, 28, 'J.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (128, 28, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (129, 28, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (130, 28, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (131, 28, 'P.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (132, 28, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (133, 28, 'T.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (134, 28, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (135, 28, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (136, 28, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (137, 28, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (138, 28, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (139, 29, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (140, 29, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (141, 29, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (142, 29, 'H.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (143, 29, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (144, 29, 'J.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (145, 29, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (146, 29, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (147, 29, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (148, 29, 'P.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (149, 29, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (150, 29, 'T.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (151, 29, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (152, 29, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (153, 29, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (154, 29, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (155, 29, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (156, 30, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (157, 30, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (158, 30, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (159, 30, 'H.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (160, 30, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (161, 30, 'J.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (162, 30, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (163, 30, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (164, 30, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (165, 30, 'P.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (166, 30, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (167, 30, 'T.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (168, 30, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (169, 30, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (170, 30, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (171, 30, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (172, 30, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (173, 31, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (174, 31, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (175, 31, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (176, 31, 'H.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (177, 31, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (178, 31, 'J.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (179, 31, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (180, 31, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (181, 31, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (182, 31, 'P.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (183, 31, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (184, 31, 'T.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (185, 31, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (186, 31, 'X.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (187, 31, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (188, 31, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (189, 31, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (190, 32, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (191, 32, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (192, 32, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (193, 32, 'H.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (194, 32, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (195, 32, 'J.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (196, 32, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (197, 32, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (198, 32, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (199, 32, 'P.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (200, 32, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (201, 32, 'T.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (202, 32, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (203, 32, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (204, 32, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (205, 32, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (206, 32, 'AH.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (207, 33, 'A.R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (208, 33, 'E.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (209, 33, 'F.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (210, 33, 'H.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (211, 33, 'I.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (212, 33, 'J.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (213, 33, 'M.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (214, 33, 'N.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (215, 33, 'O.C:R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (216, 33, 'P.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (217, 33, 'S.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (218, 33, 'T.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (219, 33, 'W.C:R:U');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (220, 33, 'X.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (221, 33, 'AB.R');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (222, 33, 'AF.C:R:U:D');
INSERT INTO `DB_NAME`.`system_type_permissions` (`_id`, `user_type_id`, `permission_key`) VALUES (223, 33, 'AH.R');

COMMIT;


-- -----------------------------------------------------
-- Data for table `DB_NAME`.`system_settings_defaults`
-- -----------------------------------------------------
START TRANSACTION;
USE `DB_NAME`;
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (1, 'Q', 1, 'show_countries', 'true', 'CHECKBOX', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (2, 'Q', 0, 'lang_code', 'en', 'CALLBACK', 'CDemo::getCurrencies');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (3, 'Q', 0, 'default_country', 'US', 'CALLBACK', 'CDemo::getCountries');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (4, 'Q', 1, 'time_format', 'hh:mm A', 'SELECT', 'hh:mm A,hh:mm:ss A,HH:mm A,HH:mm:ss A');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (5, 'Q', 1, 'date_format', 'MM/DD/YYYY', 'SELECT', 'DD.MM.YYYY,DD/MM/YYYY,MM.DD.YYYY,MM/DD/YYYY,YYYY/MM/DD');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (6, 'Q', 1, 'hours_format', 'hh:[00]', 'SELECT', 'hh:[00], HH:[00]');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (7, 'Q', 1, 'mins_interval', '30', 'SELECT', '5, 10, 15, 30');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (20, 'AN', 1, 'blurb', '<strong>Business</strong> Management System', 'TEXT', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (21, 'AN', 0, 'default_page_size', '25', 'SELECT', '5, 10, 25, 50, 100');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (22, 'AN', 0, 'theme', 'theme-eleven', 'SELECT', 'theme-zero, theme-one, theme-two, theme-three, theme-four, theme-five, theme-six, theme-seven, theme-eight, theme-nine, theme-ten, theme-eleven');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (23, 'AN', 0, 'left_menu_collapsed', 'false', 'CHECKBOX', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (24, 'AN', 0, 'layout_horizontal', 'false', 'CHECKBOX', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (30, 'S', 1, 'tax', '0.00', 'TEXT', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (31, 'S', 1, 'company_code', '', 'TEXT', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (32, 'S', 1, 'seperator', '-', 'CALLBACK', 'CDemo::getSeperators');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (33, 'S', 1, 'max_gen_chars', '9', 'TEXT', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (34, 'S', 1, 'include_numbers', 'true', 'CHECKBOX', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (35, 'S', 1, 'include_letters', 'false', 'CHECKBOX', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (40, 'AC', 1, 'work_workflow_id', '1', 'CALLBACK', 'CDemo::getWorkFlows');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (41, 'AC', 1, 'worklog_workflow_id', '2', 'CALLBACK', 'CDemo::getWorkFlows');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (50, 'V', 1, 'sku_prefix_first', 'company', 'CALLBACK', 'CDemo::getPrefixTypes');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (51, 'V', 1, 'sku_prefix_second', 'deliverable_name', 'CALLBACK', 'CDemo::getPrefixTypes');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (52, 'V', 1, 'sku_prefix_third', 'deliverable_id', 'CALLBACK', 'CDemo::getPrefixTypes');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (53, 'V', 1, 'sku_prefix_last', 'auto_gen', 'CALLBACK', 'CDemo::getPrefixTypes');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (54, 'V', 1, 'sku_seperator', '-', 'CALLBACK', 'CDemo::getSeperators');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (55, 'V', 1, 'sku_autogen_type', 'numbers', 'CALLBACK', 'CDemo::getAutogenTypes');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (56, 'V', 1, 'sku_autogen_max', '3', 'TEXT', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (57, 'V', 1, 'sku_company_max', '3', 'TEXT', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (58, 'V', 1, 'sku_product_max', '3', 'TEXT', 'NULL');
INSERT INTO `DB_NAME`.`system_settings_defaults` (`_id`, `owner`, `is_global`, `setting_name`, `setting_value`, `type`, `options`) VALUES (59, 'V', 1, 'sku_category_max', '3', 'TEXT', 'NULL');

COMMIT;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
