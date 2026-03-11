-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: Genealogie
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Individu`
--

DROP TABLE IF EXISTS `Individu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Individu` (
  `id_individu` int NOT NULL AUTO_INCREMENT,
  `date_naissance` date DEFAULT NULL,
  `date_deces` date DEFAULT NULL,
  PRIMARY KEY (`id_individu`),
  CONSTRAINT `Individu_chk_1` CHECK (((`date_deces` is null) or (`date_naissance` is null) or (`date_deces` >= `date_naissance`)))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Individu`
--

LOCK TABLES `Individu` WRITE;
/*!40000 ALTER TABLE `Individu` DISABLE KEYS */;
INSERT INTO `Individu` VALUES (1,'1903-10-01','2012-12-12'),(2,'1903-10-01','1999-01-01'),(4,'1911-11-11',NULL),(5,'1930-12-24',NULL),(6,'1940-06-30',NULL),(7,'1920-03-03','1955-04-18'),(8,'1940-06-30',NULL),(9,'1920-06-06','1987-07-07'),(10,'1968-10-10',NULL),(11,'1968-10-10',NULL),(12,'1969-10-10',NULL),(13,'1973-10-10','2004-02-13'),(14,NULL,NULL),(15,'1970-10-10',NULL),(16,'1901-01-01',NULL),(17,NULL,NULL);
/*!40000 ALTER TABLE `Individu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Individu_Nom`
--

DROP TABLE IF EXISTS `Individu_Nom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Individu_Nom` (
  `id_individu` int NOT NULL,
  `id_nom` int NOT NULL,
  PRIMARY KEY (`id_individu`,`id_nom`),
  KEY `id_nom` (`id_nom`),
  CONSTRAINT `Individu_Nom_ibfk_1` FOREIGN KEY (`id_individu`) REFERENCES `Individu` (`id_individu`) ON DELETE CASCADE,
  CONSTRAINT `Individu_Nom_ibfk_2` FOREIGN KEY (`id_nom`) REFERENCES `Nom` (`id_nom`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Individu_Nom`
--

LOCK TABLES `Individu_Nom` WRITE;
/*!40000 ALTER TABLE `Individu_Nom` DISABLE KEYS */;
INSERT INTO `Individu_Nom` VALUES (1,1),(1,2),(2,3),(2,4),(4,6),(5,7),(6,8),(8,10),(9,11),(10,12),(11,13),(12,14),(13,15),(14,16),(15,17),(16,18),(17,19);
/*!40000 ALTER TABLE `Individu_Nom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Individu_Prenom`
--

DROP TABLE IF EXISTS `Individu_Prenom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Individu_Prenom` (
  `id_individu` int NOT NULL,
  `id_prenom` int NOT NULL,
  PRIMARY KEY (`id_individu`,`id_prenom`),
  KEY `id_prenom` (`id_prenom`),
  CONSTRAINT `Individu_Prenom_ibfk_1` FOREIGN KEY (`id_individu`) REFERENCES `Individu` (`id_individu`) ON DELETE CASCADE,
  CONSTRAINT `Individu_Prenom_ibfk_2` FOREIGN KEY (`id_prenom`) REFERENCES `Prenom` (`id_prenom`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Individu_Prenom`
--

LOCK TABLES `Individu_Prenom` WRITE;
/*!40000 ALTER TABLE `Individu_Prenom` DISABLE KEYS */;
INSERT INTO `Individu_Prenom` VALUES (1,1),(2,2),(4,4),(5,5),(2,6),(6,7),(7,8),(8,9),(9,10),(10,11),(10,12),(10,13),(11,14),(11,15),(11,16),(12,17),(12,18),(12,19),(13,20),(13,21),(13,22),(14,23),(15,26),(16,27),(17,28),(15,29);
/*!40000 ALTER TABLE `Individu_Prenom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Nom`
--

DROP TABLE IF EXISTS `Nom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Nom` (
  `id_nom` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  PRIMARY KEY (`id_nom`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nom`
--

LOCK TABLES `Nom` WRITE;
/*!40000 ALTER TABLE `Nom` DISABLE KEYS */;
INSERT INTO `Nom` VALUES (1,'Lowblow'),(2,'Lahblah'),(3,'Lowblow'),(4,'Lahblah'),(5,'Lowblow'),(6,'de Taxi du Poet'),(7,'Lowblow'),(8,'Lowblow'),(9,'X'),(10,'Lowblow'),(11,'Lowblow'),(12,'Lahblah'),(13,'Lahblah'),(14,'Lahblah'),(15,'Lahblah'),(16,'Lahblah'),(17,'Lahblah'),(18,'Lowblow'),(19,'Skydancer');
/*!40000 ALTER TABLE `Nom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Parents_Enfants`
--

DROP TABLE IF EXISTS `Parents_Enfants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Parents_Enfants` (
  `id_parent` int NOT NULL,
  `id_enfant` int NOT NULL,
  `id_relation` int NOT NULL,
  PRIMARY KEY (`id_parent`,`id_enfant`,`id_relation`),
  KEY `id_enfant` (`id_enfant`),
  KEY `id_relation` (`id_relation`),
  CONSTRAINT `Parents_Enfants_ibfk_1` FOREIGN KEY (`id_parent`) REFERENCES `Individu` (`id_individu`) ON DELETE CASCADE,
  CONSTRAINT `Parents_Enfants_ibfk_2` FOREIGN KEY (`id_enfant`) REFERENCES `Individu` (`id_individu`) ON DELETE CASCADE,
  CONSTRAINT `Parents_Enfants_ibfk_3` FOREIGN KEY (`id_relation`) REFERENCES `Type_Relation` (`id_relation`),
  CONSTRAINT `Parents_Enfants_chk_1` CHECK ((`id_parent` <> `id_enfant`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Parents_Enfants`
--

LOCK TABLES `Parents_Enfants` WRITE;
/*!40000 ALTER TABLE `Parents_Enfants` DISABLE KEYS */;
INSERT INTO `Parents_Enfants` VALUES (17,2,1),(16,4,1),(2,6,1),(4,6,2),(4,7,1),(5,7,1),(6,7,1),(16,7,1),(5,9,1),(2,10,2),(6,10,1),(2,13,2),(6,13,1),(10,14,2),(12,14,2),(15,14,1);
/*!40000 ALTER TABLE `Parents_Enfants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Prenom`
--

DROP TABLE IF EXISTS `Prenom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Prenom` (
  `id_prenom` int NOT NULL AUTO_INCREMENT,
  `prenom` varchar(255) NOT NULL,
  PRIMARY KEY (`id_prenom`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Prenom`
--

LOCK TABLES `Prenom` WRITE;
/*!40000 ALTER TABLE `Prenom` DISABLE KEYS */;
INSERT INTO `Prenom` VALUES (1,'Marie'),(2,'Marie'),(3,'Bob'),(4,'Jean-Chrysostome'),(5,'Eude-Edmon'),(6,'Chantal'),(7,'Eugénie'),(8,'Thierry-Kevin'),(9,'Eugénie'),(10,'Fanny'),(11,'River'),(12,'Willow'),(13,'Moonbeam'),(14,'River'),(15,'Willow'),(16,'Moonbeam'),(17,'Zephyr'),(18,'Rainbow'),(19,'Sunshine'),(20,'Juniper'),(21,'Sage'),(22,'Harmony'),(23,'Blaža'),(24,'Luna'),(25,'Starflower'),(26,'Seraphina'),(27,'Bob'),(28,'Orion'),(29,'Belinda');
/*!40000 ALTER TABLE `Prenom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Relations`
--

DROP TABLE IF EXISTS `Relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Relations` (
  `id_individu1` int NOT NULL,
  `id_individu2` int NOT NULL,
  `id_relation` int NOT NULL,
  PRIMARY KEY (`id_individu1`,`id_individu2`,`id_relation`),
  KEY `id_individu2` (`id_individu2`),
  KEY `id_relation` (`id_relation`),
  CONSTRAINT `Relations_ibfk_1` FOREIGN KEY (`id_individu1`) REFERENCES `Individu` (`id_individu`) ON DELETE CASCADE,
  CONSTRAINT `Relations_ibfk_2` FOREIGN KEY (`id_individu2`) REFERENCES `Individu` (`id_individu`) ON DELETE CASCADE,
  CONSTRAINT `Relations_ibfk_3` FOREIGN KEY (`id_relation`) REFERENCES `Type_Relation` (`id_relation`),
  CONSTRAINT `Relations_chk_1` CHECK ((`id_individu1` <> `id_individu2`)),
  CONSTRAINT `Relations_chk_2` CHECK ((`id_individu1` < `id_individu2`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Relations`
--

LOCK TABLES `Relations` WRITE;
/*!40000 ALTER TABLE `Relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `Relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Type_Relation`
--

DROP TABLE IF EXISTS `Type_Relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Type_Relation` (
  `id_relation` int NOT NULL AUTO_INCREMENT,
  `nom_relation` varchar(50) NOT NULL,
  PRIMARY KEY (`id_relation`),
  UNIQUE KEY `nom_relation` (`nom_relation`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Type_Relation`
--

LOCK TABLES `Type_Relation` WRITE;
/*!40000 ALTER TABLE `Type_Relation` DISABLE KEYS */;
INSERT INTO `Type_Relation` VALUES (2,'adoptif'),(1,'biologique'),(3,'conjoint');
/*!40000 ALTER TABLE `Type_Relation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-11 11:59:27
