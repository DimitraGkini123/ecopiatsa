-- MariaDB dump 10.19  Distrib 10.4.28-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: ecopiatsa
-- ------------------------------------------------------
-- Server version	10.4.28-MariaDB

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
-- Table structure for table `drivers`
--

DROP TABLE IF EXISTS `drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drivers` (
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `ID` int(9) NOT NULL AUTO_INCREMENT,
  `username` varchar(30) NOT NULL,
  `password` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `telephone` int(20) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `car_number` int(10) NOT NULL,
  `car_model` varchar(40) NOT NULL,
  `car_colour` varchar(20) NOT NULL,
  `car_consumption` float NOT NULL,
  `car_year` int(6) NOT NULL,
  `id_pic` blob DEFAULT NULL,
  `license` blob DEFAULT NULL,
  `traffic_license` blob DEFAULT NULL,
  `ratings` int(6) DEFAULT NULL,
  `profile_pic` blob DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `car_number` (`car_number`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drivers`
--

LOCK TABLES `drivers` WRITE;
/*!40000 ALTER TABLE `drivers` DISABLE KEYS */;
INSERT INTO `drivers` VALUES ('valia','samara',3,'valia3','3','valval',3333,'0000-00-00',1245,'bshan','hshhs',44,2002,NULL,NULL,NULL,NULL,NULL),('dd','55',4,'1235','1234','fsjs',0,'0000-00-00',124,'hebas','bsbab',2,2002,NULL,NULL,NULL,NULL,NULL),('','',5,'','','',0,'0000-00-00',0,'','',0,0,NULL,NULL,NULL,NULL,NULL),('kostas','psarras',11,'kostaspsarras','20011008','kapoutsinos.psa@gmail.com',2147483647,'2001-10-08',7346,'Volkswagen Golf ','black',1.4,2002,NULL,NULL,NULL,NULL,NULL),('gshs','hshe',12,'bsbw','hdhe','hehw',8262,'0000-00-00',8392,'gsg','bsb',9,390,NULL,NULL,NULL,NULL,NULL),('maria','sabani',13,'maria4','4','mariasab',123,'0000-00-00',1235,'ford ','red',3.3,2002,NULL,NULL,NULL,NULL,NULL),('alexamdea','hshhad',17,'alex5','5','bshajs',516,'0000-00-00',555,'bshahs','hggg',3.3,2002,NULL,NULL,NULL,NULL,NULL),('alex','kouts',18,'alexaki','1234','alexandra',6789,'0000-00-00',6789,'asddf','hsjsh',5.6,6980,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `drivers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drivers_routes`
--

DROP TABLE IF EXISTS `drivers_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drivers_routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_street` varchar(255) DEFAULT NULL,
  `start_area` varchar(255) DEFAULT NULL,
  `start_country` varchar(255) DEFAULT NULL,
  `destination_street` varchar(255) DEFAULT NULL,
  `destination_area` varchar(255) DEFAULT NULL,
  `destination_country` varchar(255) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `day` varchar(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `hours` int(11) DEFAULT NULL,
  `minutes` int(11) DEFAULT NULL,
  `driver_id` int(11) DEFAULT NULL,
  `scheduled` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `driver_id` (`driver_id`),
  CONSTRAINT `drivers_routes_ibfk_1` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drivers_routes`
--

LOCK TABLES `drivers_routes` WRITE;
/*!40000 ALTER TABLE `drivers_routes` DISABLE KEYS */;
INSERT INTO `drivers_routes` VALUES (47,'Diogenous 38','Chalandri','Greece','airport','Departures','airport',3,'Saturday','2024-01-27',18,25,3,1),(48,'Agiou Georgiou 17','Chalandri','Greece','Dionisou 64','Marousi','Greece',2,'Wednesday','2024-01-31',14,10,17,0),(49,'Αγίου Γεωργίου 19','Χαλάνδρι','Ελλάδα','Κορίνης 12','Γαλάτσι','Ελλάδα',2,'Wednesday','2024-01-31',2,40,18,0),(50,'Diogenous 38','Chalandri','Greece','airport','Spata','airport',3,'Wednesday','2024-01-31',15,20,3,1),(51,'Diogenous 38','Chalandri','Greece','airport','Spata','airport',3,'Wednesday','2024-01-31',15,20,3,1);
/*!40000 ALTER TABLE `drivers_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_table`
--

DROP TABLE IF EXISTS `match_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `match_table` (
  `match_id` int(11) NOT NULL AUTO_INCREMENT,
  `passenger_id` int(11) NOT NULL,
  `driver_id` int(11) NOT NULL,
  `drivers_route_id` int(11) NOT NULL,
  `passengers_route_id` int(11) NOT NULL,
  `is_match` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`match_id`),
  KEY `passenger_id` (`passenger_id`),
  KEY `driver_id` (`driver_id`),
  KEY `drivers_route_id` (`drivers_route_id`),
  KEY `passengers_route_id` (`passengers_route_id`),
  CONSTRAINT `match_table_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `passenger_routes` (`passenger_id`),
  CONSTRAINT `match_table_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `drivers_routes` (`driver_id`),
  CONSTRAINT `match_table_ibfk_3` FOREIGN KEY (`drivers_route_id`) REFERENCES `drivers_routes` (`id`),
  CONSTRAINT `match_table_ibfk_4` FOREIGN KEY (`passengers_route_id`) REFERENCES `passenger_routes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_table`
--

LOCK TABLES `match_table` WRITE;
/*!40000 ALTER TABLE `match_table` DISABLE KEYS */;
INSERT INTO `match_table` VALUES (9,8,3,47,85,1),(10,8,3,47,85,1),(11,8,17,48,89,1),(12,36,3,47,96,1);
/*!40000 ALTER TABLE `match_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passenger_routes`
--

DROP TABLE IF EXISTS `passenger_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passenger_routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_street` varchar(255) DEFAULT NULL,
  `start_area` varchar(255) DEFAULT NULL,
  `start_country` varchar(255) DEFAULT NULL,
  `destination_street` varchar(255) DEFAULT NULL,
  `destination_area` varchar(255) DEFAULT NULL,
  `destination_country` varchar(255) DEFAULT NULL,
  `capacity` int(11) DEFAULT NULL,
  `day` varchar(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `hours` int(11) DEFAULT NULL,
  `minutes` int(11) DEFAULT NULL,
  `passenger_id` int(11) DEFAULT NULL,
  `scheduled` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `passenger_id` (`passenger_id`),
  CONSTRAINT `passenger_routes_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `passengers` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passenger_routes`
--

LOCK TABLES `passenger_routes` WRITE;
/*!40000 ALTER TABLE `passenger_routes` DISABLE KEYS */;
INSERT INTO `passenger_routes` VALUES (85,'Diogenous 38','Chalandri','Greece','airport','departures','airport',2,'Saturday','2024-01-27',18,50,8,1),(86,'Diogenous 38','Chalandri','Greece','airport','Departures','airport',3,'Saturday','2024-01-27',18,15,8,1),(87,'Diogenous 38','Chalandri','Greece','airport','Departures','airport',3,'Saturday','2024-01-27',18,0,8,1),(88,'Agiou Georgiou 17','Chalandri','Greece','airport','Departures','airport',2,'Saturday','2024-01-27',18,5,8,1),(89,'Agiou Georgiou 17','Chalandri','Greece','Chatziantoniou 11','Marousi','Greece',1,'Wednesday','2024-01-31',14,45,8,0),(94,'Agiou Georgiou 17','Chalandri','Greece','airport','Arrivals','airport',2,'Thursday','2024-01-25',12,55,8,1),(95,'Agiou Georgiou 17','Chalandri','Greece','airport','Arrivals','airport',2,'Friday','2024-01-26',23,50,36,1),(96,'Agiou Georgiou 17','Chalandri','Greece','airport','Departures','airport',1,'Saturday','2024-01-27',18,29,36,1);
/*!40000 ALTER TABLE `passenger_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passengers`
--

DROP TABLE IF EXISTS `passengers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passengers` (
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(15) NOT NULL,
  `email` varchar(50) NOT NULL,
  `telephone` int(20) NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `card_name` varchar(50) NOT NULL,
  `card_number` int(50) NOT NULL,
  `exp_date` varchar(7) NOT NULL,
  `cvv` int(4) NOT NULL,
  `id_pic` blob DEFAULT NULL,
  `ID` int(9) NOT NULL AUTO_INCREMENT,
  `ratings` int(6) DEFAULT NULL,
  `profile_pic` blob DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `unique_username` (`username`),
  UNIQUE KEY `unique_telephone` (`telephone`),
  UNIQUE KEY `unique_email` (`email`),
  UNIQUE KEY `unique_card_number` (`card_number`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passengers`
--

LOCK TABLES `passengers` WRITE;
/*!40000 ALTER TABLE `passengers` DISABLE KEYS */;
INSERT INTO `passengers` VALUES ('dimitra','gkini','dimitra1','1','dggini@gmail.com',2147483647,'0000-00-00','di',123456789,'1226',336,NULL,8,NULL,NULL),('alex','kouts','alex2','2','aaaa',12345,'0000-00-00','alex',33333,'1226',3,NULL,9,NULL,NULL),('','','','','',0,'0000-00-00','',0,'',0,NULL,10,NULL,NULL),('valia','s','valias','1234','valias@gmail.com',69872,'0000-00-00','lala',3194804,'679',8767,NULL,12,NULL,NULL),('vs','vs','vsvs','1234','vsvsv',828201,'0000-00-00','lala',64848,'5784',8757,NULL,13,NULL,NULL),('vs','vs','lala','1234','opa',8292,'0000-00-00','vs',2870,'36',123,NULL,14,NULL,NULL),('gu','g8h','hr6','gih','tug',7875,'0000-00-00','brb',328,'359',5582,NULL,16,NULL,NULL),('vs','vs','vs','1244','vs',245,'0000-00-00','vs',123,'123',123,NULL,26,NULL,NULL),('v','s','opa','123','vslala',7292,'0000-00-00','vsks',69781,'123',698,NULL,32,NULL,NULL),('bsba','hshab','vsha','123','babbs',1245,'0000-00-00','hshbd',12800,'122',222,NULL,33,NULL,NULL),('sfhnk','fhjku','yyy','3','fgkitf',45678,'0000-00-00','fghnvc',6987,'4444',333,NULL,35,NULL,NULL),('alexa','jfjdi','poi','9','hdjshshv ',56789,'0000-00-00','hsbhzns',64905,'6987',555,NULL,36,NULL,NULL),('alex','alex','alex','1','alex',1234,'0000-00-00','alex',16497,'698',587,NULL,37,NULL,NULL);
/*!40000 ALTER TABLE `passengers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-21 23:31:00
INSERT INTO passenger_routes (start_street, start_area, start_country, destination_street, destination_area, destination_country, capacity, day, date, hours, minutes, passenger_id, scheduled)
VALUES
('Syntagma Square', 'Athens', 'Greece', 'Acropolis Museum', 'Athens', 'Greece', 4, 'Monday', '2023-01-30', 14, 30, 16, 0),
('Aristotelous Square', 'Thessaloniki', 'Greece', 'White Tower', 'Thessaloniki', 'Greece', 3, 'Wednesday', '2023-02-15', 12, 45, 16, 1),
('Plaka', 'Athens', 'Greece', 'Navagio Beach', 'Zakynthos', 'Greece', 2, 'Friday', '2023-03-10', 10, 15, 13, 0),
('National Archaeological Museum', 'Athens', 'Greece', 'Monastiraki Square', 'Athens', 'Greece', 5, 'Tuesday', '2023-04-05', 16, 20, 13, 1),
('Mount Lycabettus', 'Athens', 'Greece', 'Omonia Square', 'Athens', 'Greece', 3, 'Thursday', '2023-04-20', 18, 10, 13, 0),
('Sounion Cape', 'Athens', 'Greece', 'Kifisia', 'Kifisia', 'Greece', 4, 'Saturday', '2023-05-08', 20, 30, 12, 1),
('Vouliagmeni Lake', 'Athens', 'Greece', 'Glyfada', 'Glyfada', 'Greece', 2, 'Monday', '2023-05-15', 22, 15, 10, 0),
('Temple of Poseidon', 'Sounion', 'Greece', 'Piraeus Port', 'Piraeus', 'Greece', 3, 'Wednesday', '2023-06-02', 14, 45, 8, 1),
('Elefsina', 'Athens', 'Greece', 'Marousi', 'Marousi', 'Greece', 4, 'Friday', '2023-06-17', 12, 30, 8, 0),
('Schinias Beach', 'Marathon', 'Greece', 'Nea Makri', 'Nea Makri', 'Greece', 3, 'Sunday', '2023-07-01', 10, 45, 10, 1);