-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 20, 2015 at 07:58 AM
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
  `sno` varchar(10) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `userType` varchar(50) NOT NULL,
  `verified` varchar(10) NOT NULL,
  `lastRecovery` varchar(10) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `userEmail` varchar(100) NOT NULL,
  `addressDetails` varchar(100) NOT NULL,
  `aadharCardNo` varchar(100) NOT NULL,
  `panCardNo` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for the cylinders the user owns
--

CREATE TABLE IF NOT EXISTS `UserCylinders` (
  `sno` varchar(10) NOT NULL,
  `cylID` varchar(100) NOT NULL,
  `Weight` varchar(100) NOT NULL,
  `currentWeight` varchar(100) NOT NULL,
  `dateOfFilling` date NOT NULL,
  `dateOfCompletion` date NOT NULL,
  `avgConsumption` varchar(10) NOT NULL,
  `days` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Cylinders`
--

CREATE TABLE IF NOT EXISTS `Cylinders` (
  `vsno` varchar(100) NOT NULL,
  `cylID` varchar(100) NOT NULL,
  `Weight` varchar(10) NOT NULL,
  `dateOfFilling` date NOT NULL,
  `esno` varchar(100) NOT NULL,
  `status` varchar(100) NOT NULL COMMENT '''Warehouse'' , ''Assigned'', ''ToDeliver'''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Delivered`
--

CREATE TABLE IF NOT EXISTS `Delivered` (
  `trackingID` varchar(100) NOT NULL,
  `cylID` varchar(100) NOT NULL,
  `Weight` varchar(100) NOT NULL,
  `currentWeight` varchar(100) NOT NULL,
  `autoBook` varchar(100) NOT NULL,
  `vsno` varchar(100) NOT NULL,
  `sno` varchar(100) NOT NULL,
  `lastUpdateToCloud` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Employees`
--

CREATE TABLE IF NOT EXISTS `Employees` (
  `vsno` varchar(10) NOT NULL,
  `esno` varchar(10) NOT NULL,
  `ename` varchar(100) NOT NULL,
  `occupation` varchar(100) NOT NULL,
  `ephone` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Tracking`
--

CREATE TABLE IF NOT EXISTS `Tracking` (
  `trackingID` varchar(100) NOT NULL,
  `sno` varchar(100) NOT NULL,
  `cylID` varchar(100) NOT NULL,
  `esno` varchar(100) NOT NULL COMMENT 'Who has been assigned to deliver',
  `dateOfShipping` date NOT NULL,
  `dateOfDelivery` date NOT NULL,
  `actualDeliverydate` date NOT NULL,
  `vsno` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `Vendors`
--

CREATE TABLE IF NOT EXISTS `Vendors` (
  `vsno` varchar(100) NOT NULL,
  `vname` varchar(100) NOT NULL,
  `vaddress` varchar(1000) NOT NULL,
  `noOfCylinders` varchar(100) NOT NULL,
  `vusername` varchar(100) NOT NULL,
  `vpassword` varchar(500) NOT NULL,
  `vemail` varchar(50) NOT NULL,
  `vtype` varchar(50) NOT NULL,
  `vverified` varchar(10) NOT NULL,
  `vphoto` varchar(1000) NOT NULL,
  `vwebsite` varchar(100) NOT NULL,
  `vphone` varchar(100) NOT NULL,
  `vmanagerName` varchar(100) NOT NULL,
  `vmanagerPhone` varchar(100) NOT NULL,
  `vemployees` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
