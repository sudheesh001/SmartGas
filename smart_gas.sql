-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 18, 2015 at 12:29 PM
-- Server version: 5.6.20
-- PHP Version: 5.5.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `smart_gas`
--

-- --------------------------------------------------------

--
-- Table structure for table `Authentication`
--

CREATE TABLE IF NOT EXISTS `Authentication` (
  `index` int(11) NOT NULL,
  `username` varchar(1000) NOT NULL,
  `password` varchar(1000) NOT NULL,
  `userType` int(11) NOT NULL COMMENT '0 - User, 1 - Company, 2- Admin',
  `verified` int(11) NOT NULL COMMENT '0 - not Verified, 1 - Verified',
  `lastRecovery` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `CLOUD_Cylinders`
--

CREATE TABLE IF NOT EXISTS `CLOUD_Cylinders` (
  `CompanyId` int(11) NOT NULL,
  `CylinderId` int(11) NOT NULL,
  `NetWeight` int(11) NOT NULL,
  `GrossWeight` int(11) NOT NULL,
  `dateOfFilling` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Company`
--

CREATE TABLE IF NOT EXISTS `Company` (
  `companyId` int(11) NOT NULL,
  `companyName` varchar(1000) NOT NULL,
  `companyAddress` varchar(1000) NOT NULL,
  `quantityAvailable` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Delivery`
--

CREATE TABLE IF NOT EXISTS `Delivery` (
  `TransactionID` varchar(1000) NOT NULL,
  `TransactionStatus` int(11) NOT NULL COMMENT '0-Placed Order, 1-Shipped from location, 2-Reaching Today, 3-Delivered, -1 - Failed will retry, -2 - Failed, -3 - Deliivery back to warehouse.',
  `currentDeliveryLocation` varchar(1000) NOT NULL,
  `endDeliveryLocation` varchar(1000) NOT NULL,
  `dateOfDelivery` date NOT NULL,
  `receivedBy` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `LOCAL_GasCylinder`
--

CREATE TABLE IF NOT EXISTS `LOCAL_GasCylinder` (
  `cylinderID` varchar(1000) NOT NULL,
  `cylinderWeight` int(11) NOT NULL,
  `NetWeight` double NOT NULL,
  `GrossWeight` double NOT NULL,
  `currentWeight` double NOT NULL,
  `remindMeAt` date NOT NULL,
  `expectedCompletionDate` date NOT NULL,
  `autoReBook` int(11) NOT NULL COMMENT '1-Yes, 2-No'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Transactions`
--

CREATE TABLE IF NOT EXISTS `Transactions` (
  `TransactionID` varchar(100) NOT NULL,
  `TransactionDate` date NOT NULL,
  `Amount` double NOT NULL,
  `Quantity` int(11) NOT NULL,
  `OrderedBy` int(11) NOT NULL,
  `cylinderDetails` varchar(100) NOT NULL,
  `paymentMode` varchar(1000) NOT NULL COMMENT 'Mode=Cash On Delivery'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE IF NOT EXISTS `Users` (
  `index` int(11) NOT NULL,
  `firstName` varchar(100) NULL,
  `lastName` varchar(100) NULL,
  `username` varchar(100) NULL,
  `userEmail` varchar(100) NULL,
  `addressDetails` varchar(1000) NULL,
  `aadharCardNo` varchar(1000) NULL,
  `PANCardNo` varchar(100) NULL,
  `companyAffiliation` int(11) NULL,
  `currentQuantity` int(11) NULL,
  `gasAgencyAffiliation` varchar(1000) NULL,
  `phoneNumber` varchar(1000) NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
