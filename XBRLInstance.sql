-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema XBRL2.1
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema XBRL2.1
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `XBRL2.1` ;
-- -----------------------------------------------------
-- Schema xbrlinstance
-- -----------------------------------------------------
USE `XBRL2.1` ;

-- -----------------------------------------------------
-- Table `XBRL2.1`.`Period`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Period` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(50) NULL COMMENT 'o tipo pode ser: instant, forever, period',
  `startDate` DATE NULL,
  `endDate` DATE NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Segment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Segment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `value` VARCHAR(200) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Entity`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Entity` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NULL,
  `schemaUrl` VARCHAR(200) NOT NULL,
  `Segment_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Entidade_Segmento1_idx` (`Segment_id` ASC),
  CONSTRAINT `fk_Entidade_Segmento1`
    FOREIGN KEY (`Segment_id`)
    REFERENCES `XBRL2.1`.`Segment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Scenario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Scenario` (
  `id` INT NOT NULL,
  `value` VARCHAR(200) NULL COMMENT 'Pode ser: Actual, Budgeted, Restated, pro forma...\n\nPag 71 do livro XBRL de Paulo Caetano.',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Unit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Unit` (
  `id` VARCHAR(10) NOT NULL,
  `value` VARCHAR(45) NULL COMMENT 'tipo de moeda, ex.: \"iso4217:BRL\" (sem aspas)\n',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`FootNote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`FootNote` (
  `id` INT NOT NULL,
  `description` VARCHAR(200) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Report` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `Unit_id` VARCHAR(10) NOT NULL,
  `FootNote_id` INT NULL,
  `Entity_idEntity` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Relatorio_Unit1_idx` (`Unit_id` ASC),
  INDEX `fk_Relatorio_Rodape1_idx` (`FootNote_id` ASC),
  CONSTRAINT `fk_Relatorio_Unit1`
    FOREIGN KEY (`Unit_id`)
    REFERENCES `XBRL2.1`.`Unit` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Relatorio_Rodape1`
    FOREIGN KEY (`FootNote_id`)
    REFERENCES `XBRL2.1`.`FootNote` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Context`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Context` (
  `id` VARCHAR(10) NOT NULL,
  `Entity_id` INT NOT NULL,
  `Period_id` INT NOT NULL,
  `Scenario_id` INT NULL,
  `Report_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Contexto_Entidade_idx` (`Entity_id` ASC),
  INDEX `fk_Contexto_Periodo1_idx` (`Period_id` ASC),
  INDEX `fk_Contexto_Cenario1_idx` (`Scenario_id` ASC),
  INDEX `fk_Contexto_Relatorio1_idx` (`Report_id` ASC),
  CONSTRAINT `fk_Contexto_Cenario1`
    FOREIGN KEY (`Scenario_id`)
    REFERENCES `XBRL2.1`.`Scenario` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contexto_Entidade`
    FOREIGN KEY (`Entity_id`)
    REFERENCES `XBRL2.1`.`Entity` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contexto_Periodo1`
    FOREIGN KEY (`Period_id`)
    REFERENCES `XBRL2.1`.`Period` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Contexto_Relatorio1`
    FOREIGN KEY (`Report_id`)
    REFERENCES `XBRL2.1`.`Report` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`RoleType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`RoleType` (
  `idRoleType` INT NOT NULL,
  `name` VARCHAR(100) NULL,
  `href` VARCHAR(100) NULL,
  `URI` VARCHAR(100) NULL,
  PRIMARY KEY (`idRoleType`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`linkType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`linkType` (
  `idlinkType` INT NOT NULL,
  `name` VARCHAR(45) NULL COMMENT 'extended or simple',
  PRIMARY KEY (`idlinkType`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Link`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Link` (
  `id` INT NOT NULL,
  `type` VARCHAR(200) NOT NULL,
  `href` VARCHAR(300) NOT NULL,
  `base` VARCHAR(200) NULL,
  `label` VARCHAR(100) NULL,
  `RoleType_idRoleType` INT NOT NULL,
  `linkType_idlinkType` INT NOT NULL,
  `FootNote_id` INT NOT NULL,
  `Report_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_SimpleLink_RoleType1_idx` (`RoleType_idRoleType` ASC),
  INDEX `fk_Link_linkType1_idx` (`linkType_idlinkType` ASC),
  INDEX `fk_Link_FootNote1_idx` (`FootNote_id` ASC),
  INDEX `fk_Link_Report1_idx` (`Report_id` ASC),
  CONSTRAINT `fk_SimpleLink_RoleType1`
    FOREIGN KEY (`RoleType_idRoleType`)
    REFERENCES `XBRL2.1`.`RoleType` (`idRoleType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Link_linkType1`
    FOREIGN KEY (`linkType_idlinkType`)
    REFERENCES `XBRL2.1`.`linkType` (`idlinkType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Link_FootNote1`
    FOREIGN KEY (`FootNote_id`)
    REFERENCES `XBRL2.1`.`FootNote` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Link_Report1`
    FOREIGN KEY (`Report_id`)
    REFERENCES `XBRL2.1`.`Report` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`ElementType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`ElementType` (
  `idType` INT NOT NULL,
  `value` VARCHAR(50) NULL,
  PRIMARY KEY (`idType`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Element`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Element` (
  `idElement` INT NOT NULL,
  `name` VARCHAR(150) NULL,
  `substitutionGroup` VARCHAR(50) NULL,
  `nillable` VARCHAR(20) NULL,
  `abstract` VARCHAR(20) NULL,
  `periodType` VARCHAR(20) NULL,
  `ElementType_idType` INT NOT NULL,
  PRIMARY KEY (`idElement`),
  INDEX `fk_Element_ElementType1_idx` (`ElementType_idType` ASC),
  CONSTRAINT `fk_Element_ElementType1`
    FOREIGN KEY (`ElementType_idType`)
    REFERENCES `XBRL2.1`.`ElementType` (`idType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `XBRL2.1`.`Fact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `XBRL2.1`.`Fact` (
  `idFact` INT NOT NULL,
  `value` VARCHAR(45) NULL,
  `Report_id` INT NOT NULL,
  `Element_idElement` INT NOT NULL,
  PRIMARY KEY (`idFact`),
  INDEX `fk_Fact_Report1_idx` (`Report_id` ASC),
  INDEX `fk_Fact_Element1_idx` (`Element_idElement` ASC),
  CONSTRAINT `fk_Fact_Report1`
    FOREIGN KEY (`Report_id`)
    REFERENCES `XBRL2.1`.`Report` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fact_Element1`
    FOREIGN KEY (`Element_idElement`)
    REFERENCES `XBRL2.1`.`Element` (`idElement`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
