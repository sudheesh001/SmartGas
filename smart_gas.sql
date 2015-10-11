-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 19, 2015 at 03:31 PM
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
  `vphoto` varchar(10) NOT NULL,
  `vwebsite` varchar(100) NOT NULL,
  `vphone` varchar(100) NOT NULL,
  `vmanagerName` varchar(100) NOT NULL,
  `vmanagerPhone` varchar(100) NOT NULL,
  `vemployees` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
