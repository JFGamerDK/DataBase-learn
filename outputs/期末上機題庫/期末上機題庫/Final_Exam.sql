/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.11-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: final_db_41043241
-- ------------------------------------------------------
-- Server version	10.11.11-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `CrsCode` varchar(4) NOT NULL,
  `CrsName` char(20) DEFAULT NULL,
  `DeptId` varchar(2) DEFAULT NULL,
  `Descr` char(100) DEFAULT NULL,
  PRIMARY KEY (`CrsCode`),
  UNIQUE KEY `DeptId` (`DeptId`,`CrsName`),
  CONSTRAINT `course_ibfk_1` FOREIGN KEY (`DeptId`) REFERENCES `department` (`DeptId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES
('1025','真空與鍍膜技術','26','本課程介紹真空原理、設備運作與鍍膜技術，涵蓋PVD與CVD等應用，培養學生在半導體與光電產業中的實務技能。'),
('1037','光電元件製程實習','26','本課程實作光電元件製程流程，涵蓋光罩設計、光蝕刻、薄膜沉積與封裝等，強化學生光電製造的實務能力。'),
('1746','模糊理論與應用','40','本課程介紹模糊理論基本概念與推理方法，並探討其在控制、決策與人工智慧等領域的實際應用。'),
('1990','微處理機實習','43','本課程透過實作訓練學生操作微處理機，學習指令編寫、硬體控制與周邊介面應用，強化系統整合能力。'),
('1993','資料庫系統','43','本課程重視理論與實務，培養學生具備資料庫系統設計、開發與管理能力，熟悉實務操作與應用。'),
('433','半導體元件','40','本課程介紹半導體元件的物理原理、結構與特性，涵蓋二極體、電晶體等元件，培養學生分析與應用能力。');
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `DeptId` varchar(2) NOT NULL,
  `Name` char(20) NOT NULL,
  PRIMARY KEY (`DeptId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES
('26','光電系'),
('40','電子系'),
('43','資工系');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `professor`
--

DROP TABLE IF EXISTS `professor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `professor` (
  `ProfId` int(11) NOT NULL,
  `Name` char(20) NOT NULL,
  `DeptId` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`ProfId`),
  KEY `DeptId` (`DeptId`),
  CONSTRAINT `professor_ibfk_1` FOREIGN KEY (`DeptId`) REFERENCES `department` (`DeptId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `professor`
--

LOCK TABLES `professor` WRITE;
/*!40000 ALTER TABLE `professor` DISABLE KEYS */;
INSERT INTO `professor` VALUES
(401,'麥黨烙','43'),
(402,'梁詠珊','43'),
(403,'王小花','40'),
(404,'黃大頭','26'),
(405,'張懷賢','26');
/*!40000 ALTER TABLE `professor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `StdId` int(11) NOT NULL,
  `Name` char(20) NOT NULL,
  `Address` char(50) DEFAULT NULL,
  `Status` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`StdId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES
(41026201,'王大明','雲林縣西螺鎮建興路319號','A'),
(41040202,'林剛懷','新北市土城區員林街64巷2弄18號','B'),
(41043203,'賈克林','桃園市八德區大智路55號1樓','C');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teaching`
--

DROP TABLE IF EXISTS `teaching`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `teaching` (
  `ProfId` int(11) DEFAULT NULL,
  `CrsCode` varchar(4) NOT NULL,
  `Semester` varchar(5) NOT NULL,
  PRIMARY KEY (`CrsCode`,`Semester`),
  KEY `ProfId` (`ProfId`),
  CONSTRAINT `teaching_ibfk_1` FOREIGN KEY (`CrsCode`) REFERENCES `course` (`CrsCode`),
  CONSTRAINT `teaching_ibfk_2` FOREIGN KEY (`ProfId`) REFERENCES `professor` (`ProfId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teaching`
--

LOCK TABLES `teaching` WRITE;
/*!40000 ALTER TABLE `teaching` DISABLE KEYS */;
INSERT INTO `teaching` VALUES
(401,'1990','2025A'),
(402,'1993','2025B'),
(403,'1746','2025B'),
(403,'433','2024B'),
(404,'1037','2024A'),
(405,'1025','2025B');
/*!40000 ALTER TABLE `teaching` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transcript`
--

DROP TABLE IF EXISTS `transcript`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `transcript` (
  `StudId` int(11) NOT NULL,
  `CrsCode` varchar(4) NOT NULL,
  `Semester` varchar(5) NOT NULL,
  `Grade` char(1) DEFAULT NULL,
  PRIMARY KEY (`StudId`,`CrsCode`,`Semester`),
  KEY `CrsCode` (`CrsCode`,`Semester`),
  CONSTRAINT `transcript_ibfk_1` FOREIGN KEY (`StudId`) REFERENCES `student` (`StdId`),
  CONSTRAINT `transcript_ibfk_2` FOREIGN KEY (`CrsCode`) REFERENCES `course` (`CrsCode`),
  CONSTRAINT `transcript_ibfk_3` FOREIGN KEY (`CrsCode`, `Semester`) REFERENCES `teaching` (`CrsCode`, `Semester`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transcript`
--

LOCK TABLES `transcript` WRITE;
/*!40000 ALTER TABLE `transcript` DISABLE KEYS */;
INSERT INTO `transcript` VALUES
(41026201,'1025','2025B',''),
(41026201,'1993','2025B',''),
(41040202,'1746','2025B',''),
(41040202,'1993','2025B',''),
(41043203,'1990','2025A',''),
(41043203,'1993','2025B','');
/*!40000 ALTER TABLE `transcript` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-16 14:58:56
