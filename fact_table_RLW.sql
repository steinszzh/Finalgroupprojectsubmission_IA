/*First drop database it if exists*/
DROP DATABASE `Stock_Covid19`;

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS=0;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

/*Now create the database and tell mysql to use this database*/
CREATE DATABASE  IF NOT EXISTS `Stock_Covid19` ;
USE `Stock_Covid19`;

/*drop the date dimension if it exists otherwise create it*/
DROP TABLE IF EXISTS `date_dim`;
create table `date_dim` (
`date_key` INT NOT NULL auto_increment PRIMARY KEY, 
`date_string` VARCHAR(100),
`day` int, 
`week` int,
`month` int,
`year` int,
`quarter` int,
`Week_Ending` VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

/*next drop the location table if it exists and then create it*/
DROP TABLE IF EXISTS `location_dim`;
create table `location_dim` (
`location_id` int AUTO_INCREMENT primary key,
`state` varchar(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

/*Drop the unemployment table if it exists and then create it*/
DROP TABLE IF EXISTS `unemp_dim`;
CREATE TABLE `unemp_dim`(
`unemp_id` INT AUTO_INCREMENT PRIMARY KEY,
`state` VARCHAR(100),
`Week_End` VARCHAR(100),
`Initial_Claims` INT,
`Unemp_Rate` FLOAT,
`Total_Claims` int
)ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

/*Drop the covid19 dimension for coronavirus case data and then create it*/
DROP TABLE IF EXISTS `covid19_dim`;
create table `covid19_dim` (
`covid_key` INT AUTO_INCREMENT PRIMARY KEY,
`case_number` int,
`deaths` INT,
`state` VARCHAR(100),
`week_ending` VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

/*drop the stock data table if it exists and then create it*/
DROP TABLE IF EXISTS `sp_dim`;
create table `sp_dim` (
`sp_id` int AUTO_INCREMENT primary key, 
`date_string` VARCHAR(100),
`day_performance` float,
`week_end` VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

/*now create the fact table*/
DROP TABLE IF EXISTS `fact_table`;
create table `fact_table` (
/*`date_key` int,
`location_key` int,
`covid19_key` int,
`unemp_key` int,
`sp_key` int,*/
`Week_Ending` VARCHAR(100),
`state` VARCHAR(100),
`Total_Unemp` INT,
`Initial_Claims` INT,
`case_number` int,
`death_number` INT,
`avg_performance` float
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

/*now add primary keys and foreign keys*/
ALTER TABLE fact_table
ADD COLUMN
date_key INT NOT NULL,
ADD COLUMN
location_key INT NOT NULL,
ADD COLUMN
covid19_key INT NOT NULL,
ADD COLUMN
sp_key INT NOT NULL,
ADD COLUMN
unemp_key INT NOT NULL;
ALTER TABLE fact_table
ADD FOREIGN KEY (date_key) REFERENCES `date_dim`(`date_key`),
ADD FOREIGN KEY (location_key) REFERENCES `location_dim`(`location_id`),
ADD FOREIGN KEY (covid19_key) REFERENCES `covid19_dim`(`covid_key`),
ADD FOREIGN KEY (sp_key) REFERENCES sp_dim(sp_id),
ADD FOREIGN KEY (unemp_key) REFERENCES unemp_dim(unemp_id);