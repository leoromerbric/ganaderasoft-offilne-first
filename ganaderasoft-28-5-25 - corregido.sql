/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.6.22-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ganaderasoft
-- ------------------------------------------------------
-- Server version	10.6.22-MariaDB-0ubuntu0.22.04.1

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
-- Table structure for table `Inventario_Bufalo`
--

DROP TABLE IF EXISTS `Inventario_Bufalo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Inventario_Bufalo` (
  `id_Inv_B` int(11) NOT NULL AUTO_INCREMENT,
  `id_Finca` int(11) NOT NULL,
  `Num_Becerro` int(11) DEFAULT NULL,
  `Num_Anojo` int(11) DEFAULT NULL,
  `Num_Bubilla` int(11) DEFAULT NULL,
  `Num_Bufalo` int(11) DEFAULT NULL,
  `Fecha_Inventario` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Inv_B`),
  KEY `id_Finca` (`id_Finca`),
  CONSTRAINT `Inventario_Bufalo_ibfk_1` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `afiliacion`
--

DROP TABLE IF EXISTS `afiliacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `afiliacion` (
  `id_Personal_P` bigint(20) unsigned NOT NULL,
  `id_Personal_T` bigint(20) unsigned NOT NULL,
  `id_Finca` int(11) NOT NULL,
  `Estado` varchar(9) DEFAULT NULL,
  `receptor_solicitud` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Personal_P`,`id_Personal_T`),
  KEY `FK_Trancriptor` (`id_Personal_T`),
  KEY `id_Finca` (`id_Finca`),
  CONSTRAINT `FK_Propietario` FOREIGN KEY (`id_Personal_P`) REFERENCES `propietario` (`id`),
  CONSTRAINT `FK_Trancriptor` FOREIGN KEY (`id_Personal_T`) REFERENCES `transcriptor` (`id`),
  CONSTRAINT `afiliacion_ibfk_1` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `animal`
--

DROP TABLE IF EXISTS `animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `animal` (
  `id_Animal` int(11) NOT NULL AUTO_INCREMENT,
  `id_Rebano` int(11) NOT NULL,
  `Nombre` varchar(25) DEFAULT NULL,
  `codigo_animal` varchar(20) DEFAULT NULL,
  `Sexo` char(1) DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `Procedencia` varchar(50) DEFAULT NULL,
  `archivado` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `fk_composicion_raza` int(11) NOT NULL,
  PRIMARY KEY (`id_Animal`),
  KEY `id_Rebano` (`id_Rebano`),
  KEY `fk_posee` (`fk_composicion_raza`),
  CONSTRAINT `Animal_ibfk_2` FOREIGN KEY (`id_Rebano`) REFERENCES `rebano` (`id_Rebano`),
  CONSTRAINT `fk_posee` FOREIGN KEY (`fk_composicion_raza`) REFERENCES `composicion_raza` (`id_Composicion`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `arbol_gen`
--

DROP TABLE IF EXISTS `arbol_gen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `arbol_gen` (
  `id_hijo` int(11) NOT NULL,
  `id_padre` int(11) NOT NULL,
  `tipo` varchar(5) NOT NULL,
  PRIMARY KEY (`id_hijo`,`id_padre`),
  KEY `fk_padre` (`id_padre`),
  CONSTRAINT `fk_hijo` FOREIGN KEY (`id_hijo`) REFERENCES `animal` (`id_Animal`),
  CONSTRAINT `fk_padre` FOREIGN KEY (`id_padre`) REFERENCES `animal` (`id_Animal`),
  CONSTRAINT `ck_tipo` CHECK (`tipo` in ('Madre','Padre'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cambios_animal`
--

DROP TABLE IF EXISTS `etapa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `etapa` (
  `etapa_id` int(11) NOT NULL AUTO_INCREMENT,
  `etapa_nombre` varchar(40) NOT NULL,
  `etapa_edad_ini` int(11) NOT NULL,
  `etapa_edad_fin` int(11) DEFAULT NULL,
  `etapa_fk_tipo_animal_id` int(11) NOT NULL,
  `etapa_sexo` char(1) NOT NULL,
  PRIMARY KEY (`etapa_id`),
  KEY `fk_etapas` (`etapa_fk_tipo_animal_id`),
  CONSTRAINT `fk_etapas` FOREIGN KEY (`etapa_fk_tipo_animal_id`) REFERENCES `tipo_animal` (`tipo_animal_id`),
  CONSTRAINT `ck_etapa_edad_diff` CHECK (`etapa_edad_fin` > `etapa_edad_ini`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etapa_animal`
--

DROP TABLE IF EXISTS `etapa_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `etapa_animal` (
  `etan_etapa_id` int(11) NOT NULL,
  `etan_animal_id` int(11) NOT NULL,
  `etan_fecha_ini` date NOT NULL,
  `etan_fecha_fin` date DEFAULT NULL,
  PRIMARY KEY (`etan_animal_id`, `etan_etapa_id`),
  KEY `fk_desarrolla` (`etan_animal_id`),
  CONSTRAINT `fk_crece` FOREIGN KEY (`etan_etapa_id`) REFERENCES `etapa` (`etapa_id`),
  CONSTRAINT `fk_desarrolla` FOREIGN KEY (`etan_animal_id`) REFERENCES `animal` (`id_Animal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `cambios_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cambios_animal` (
  `id_Cambio` int(11) NOT NULL AUTO_INCREMENT,
  `Fecha_Cambio` date DEFAULT NULL,
  `Etapa_Cambio` varchar(10) DEFAULT NULL,
  `Peso` float NOT NULL,
  `Altura` float NOT NULL,
  `Comentario` varchar(60) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `cambios_etapa_anid` int(11) NOT NULL,
  `cambios_etapa_etid` int(11) NOT NULL,
  PRIMARY KEY (`id_Cambio`),
  KEY `cambios_etapa_animal` (`cambios_etapa_anid`,`cambios_etapa_etid`),
  CONSTRAINT `cambios_etapa_animal` FOREIGN KEY (`cambios_etapa_anid`, `cambios_etapa_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `casa_comercial`
--

DROP TABLE IF EXISTS `casa_comercial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `casa_comercial` (
  `casa_id` int(11) NOT NULL AUTO_INCREMENT,
  `laboratorio` varchar(30) NOT NULL,
  `marca_comercial` varchar(25) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`casa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `composicion_raza`
--

DROP TABLE IF EXISTS `composicion_raza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `composicion_raza` (
  `id_Composicion` int(11) NOT NULL AUTO_INCREMENT,
  `Nombre` varchar(30) DEFAULT NULL,
  `Siglas` varchar(6) DEFAULT NULL,
  `Pelaje` varchar(80) DEFAULT NULL,
  `Proposito` varchar(15) DEFAULT NULL,
  `Tipo_Raza` varchar(12) DEFAULT NULL,
  `Origen` varchar(60) DEFAULT NULL,
  `Caracteristica_Especial` varchar(80) DEFAULT NULL,
  `Proporcion_Raza` varchar(7) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `fk_id_Finca` int(11) DEFAULT NULL,
  `fk_tipo_animal_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_Composicion`),
  KEY `fk_crea` (`fk_id_Finca`),
  KEY `fk_tiene_tipo` (`fk_tipo_animal_id`),
  CONSTRAINT `fk_crea` FOREIGN KEY (`fk_id_Finca`) REFERENCES `finca` (`id_Finca`),
  CONSTRAINT `fk_tiene_tipo` FOREIGN KEY (`fk_tipo_animal_id`) REFERENCES `tipo_animal` (`tipo_animal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cuerno`
--

DROP TABLE IF EXISTS `cuerno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cuerno` (
  `id_Cuernos` int(11) NOT NULL AUTO_INCREMENT,
  `fk_palpacion_id` int(11) NOT NULL,
  `cuerno_tamano` float DEFAULT NULL,
  `cuerno_medicion` varchar(2) DEFAULT NULL,
  `cuerno_lado` char(3) DEFAULT NULL,
  `iu_plano` varchar(3) DEFAULT NULL,
  `estado_sano` varchar(12) DEFAULT NULL,
  `patologia_nombre` varchar(40) DEFAULT NULL,
  `patologia_descripcion` varchar(80) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Cuernos`),
  KEY `fk_cuerno_palpacion` (`fk_palpacion_id`),
  CONSTRAINT `fk_cuerno_palpacion` FOREIGN KEY (`fk_palpacion_id`) REFERENCES `palpacion` (`palpacion_id`),
  CONSTRAINT `ck_IUPlano` CHECK (`iu_plano` in ('I','II','III','IV')),
  CONSTRAINT `ck_estado_sano` CHECK (`estado_sano` in ('Flacidos','Semitonicos','Tonicos'))
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dia_palpacion`
--

DROP TABLE IF EXISTS `dia_palpacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `dia_palpacion` (
  `dia_id` int(11) NOT NULL AUTO_INCREMENT,
  `dia_dias` varchar(6) NOT NULL,
  PRIMARY KEY (`dia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `diagnostico`
--

DROP TABLE IF EXISTS `diagnostico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnostico` (
  `diagnostico_id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnostico_descripcion` text DEFAULT NULL,
  `diagnostico_tipo` varchar(30) DEFAULT NULL,
  `diagnostico_fecha` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `fk_etapa_animal_anid` int(11) NOT NULL,
  `fk_etapa_animal_etid` int(11) NOT NULL,
  PRIMARY KEY (`diagnostico_id`),
  KEY `fk_etapa_animal` (`fk_etapa_animal_anid`,`fk_etapa_animal_etid`),
  CONSTRAINT `fk_etapa_animal` FOREIGN KEY (`fk_etapa_animal_anid`, `fk_etapa_animal_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dosis`
--

DROP TABLE IF EXISTS `dosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `dosis` (
  `dosis_vacuna_id` int(11) NOT NULL,
  `dosis_casa_id` int(11) NOT NULL,
  `dosis_id` int(11) NOT NULL AUTO_INCREMENT,
  `dosis_frecuencia` decimal(3,0) NOT NULL,
  `dosis_costo` decimal(20,2) DEFAULT NULL,
  `dosis_costo_frasco` decimal(20,2) DEFAULT NULL,
  `dosis_fecha_uso_ini` date NOT NULL,
  `dosis_fecha_uso_fin` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `dosis_etapa_animal_anid` int(11) NOT NULL,
  `dosis_etapa_animal_etid` int(11) NOT NULL,
  PRIMARY KEY (`dosis_id`,`dosis_vacuna_id`,`dosis_casa_id`),
  KEY `fk_etapa_animal_dosis` (`dosis_etapa_animal_etid`,`dosis_etapa_animal_anid`),
  KEY `fk_vacuna_casa` (`dosis_vacuna_id`,`dosis_casa_id`),
  CONSTRAINT `fk_etapa_animal_dosis` FOREIGN KEY (`dosis_etapa_animal_etid`, `dosis_etapa_animal_anid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`),
  CONSTRAINT `fk_vacuna_casa` FOREIGN KEY (`dosis_vacuna_id`, `dosis_casa_id`) REFERENCES `vacuna_casa` (`vc_vacuna_id`, `vc_casa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;


-- Table structure for table `estado_animal`
--

DROP TABLE IF EXISTS `estado_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_animal` (
  `esan_id` int(11) NOT NULL AUTO_INCREMENT,
  `esan_fecha_ini` date NOT NULL,
  `esan_fecha_fin` date DEFAULT NULL,
  `esan_fk_estado_id` int(11) NOT NULL,
  `esan_fk_id_animal` int(11) NOT NULL,
  PRIMARY KEY (`esan_id`),
  KEY `fk_se_siente` (`esan_fk_id_animal`),
  KEY `fk_estado` (`esan_fk_estado_id`),
  CONSTRAINT `fk_estado` FOREIGN KEY (`esan_fk_estado_id`) REFERENCES `estado_salud` (`estado_id`),
  CONSTRAINT `fk_se_siente` FOREIGN KEY (`esan_fk_id_animal`) REFERENCES `animal` (`id_Animal`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estado_salud`
--

DROP TABLE IF EXISTS `estado_salud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado_salud` (
  `estado_id` int(11) NOT NULL AUTO_INCREMENT,
  `estado_nombre` varchar(40) NOT NULL,
  PRIMARY KEY (`estado_id`),
  CONSTRAINT `check_estado_nombre` CHECK (`estado_nombre` regexp '^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ ]+$')
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etapa`
--


--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `finca`
--

DROP TABLE IF EXISTS `finca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `finca` (
  `id_Finca` int(11) NOT NULL AUTO_INCREMENT,
  `id_Propietario` bigint(20) unsigned NOT NULL,
  `Nombre` varchar(25) DEFAULT NULL,
  `Explotacion_Tipo` varchar(20) DEFAULT NULL,
  `archivado` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Finca`),
  KEY `id_Propietario` (`id_Propietario`),
  CONSTRAINT `Finca_ibfk_1` FOREIGN KEY (`id_Propietario`) REFERENCES `propietario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `foliculo`
--

DROP TABLE IF EXISTS `foliculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `foliculo` (
  `foliculo_id` int(11) NOT NULL AUTO_INCREMENT,
  `foliculo_nombre` varchar(50) NOT NULL,
  `foliculo_siglas` varchar(6) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`foliculo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hierro`
--

DROP TABLE IF EXISTS `hierro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hierro` (
  `id_Hierro` int(11) NOT NULL AUTO_INCREMENT,
  `identificador` varchar(10) DEFAULT NULL,
  `id_Finca` int(11) NOT NULL,
  `id_Propietario` bigint(20) unsigned NOT NULL,
  `Hierro_Imagen` blob DEFAULT NULL,
  `Hierro_QR` blob DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Hierro`),
  KEY `id_Finca` (`id_Finca`),
  KEY `id_Propietario` (`id_Propietario`),
  CONSTRAINT `Hierro_ibfk_1` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`),
  CONSTRAINT `Hierro_ibfk_2` FOREIGN KEY (`id_Propietario`) REFERENCES `propietario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `historico_aplicacion`
--

DROP TABLE IF EXISTS `historico_aplicacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `historico_aplicacion` (
  `id_ha` int(11) NOT NULL AUTO_INCREMENT,
  `ha_vacuna_id` int(11) NOT NULL,
  `ha_casa_id` int(11) NOT NULL,
  `ha_dosis_id` int(11) NOT NULL,
  `fecha_inyeccion` date NOT NULL,
  PRIMARY KEY (`id_ha`),
  KEY `fk_dosis` (`ha_dosis_id`,`ha_vacuna_id`,`ha_casa_id`),
  CONSTRAINT `fk_dosis` FOREIGN KEY (`ha_dosis_id`, `ha_vacuna_id`, `ha_casa_id`) REFERENCES `dosis` (`dosis_id`, `dosis_vacuna_id`, `dosis_casa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `indices_corporales`
--

DROP TABLE IF EXISTS `indices_corporales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `indices_corporales` (
  `id_Indice` int(11) NOT NULL AUTO_INCREMENT,
  `Anamorfosis` float DEFAULT NULL,
  `Corporal` float DEFAULT NULL,
  `Pelviano` float DEFAULT NULL,
  `Proporcionalidad` float DEFAULT NULL,
  `Dactilo_Toracico` float DEFAULT NULL,
  `Pelviano_Transversal` float DEFAULT NULL,
  `Pelviano_Longitudinal` float DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `indice_etapa_anid` int(11) NOT NULL,
  `indice_etapa_etid` int(11) NOT NULL,
  PRIMARY KEY (`id_Indice`),
  KEY `indice_etapa_animal` (`indice_etapa_anid`,`indice_etapa_etid`),
  CONSTRAINT `indice_etapa_animal` FOREIGN KEY (`indice_etapa_anid`, `indice_etapa_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventario_general`
--

DROP TABLE IF EXISTS `inventario_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario_general` (
  `id_Inv` int(11) NOT NULL AUTO_INCREMENT,
  `id_Finca` int(11) NOT NULL,
  `Num_Personal` int(11) DEFAULT NULL,
  `Fecha_Inventario` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Inv`),
  KEY `id_Finca` (`id_Finca`),
  CONSTRAINT `Inventario_General_ibfk_1` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `inventario_vacuno`
--

DROP TABLE IF EXISTS `inventario_vacuno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario_vacuno` (
  `id_Inv_V` int(11) NOT NULL AUTO_INCREMENT,
  `id_Finca` int(11) NOT NULL,
  `Num_Becerra` int(11) DEFAULT NULL,
  `Num_Mauta` int(11) DEFAULT NULL,
  `Num_Novilla` int(11) DEFAULT NULL,
  `Num_Vaca` int(11) DEFAULT NULL,
  `Num_Becerro` int(11) DEFAULT NULL,
  `Num_Maute` int(11) DEFAULT NULL,
  `Num_Torete` int(11) DEFAULT NULL,
  `Num_Toro` int(11) DEFAULT NULL,
  `Fecha_Inventario` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Inv_V`),
  KEY `id_Finca` (`id_Finca`),
  CONSTRAINT `Inventario_Vacuno_ibfk_1` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lactancia`
--

DROP TABLE IF EXISTS `lactancia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lactancia` (
  `lactancia_id` int(11) NOT NULL AUTO_INCREMENT,
  `lactancia_fecha_inicio` date DEFAULT NULL,
  `Lactancia_fecha_fin` date DEFAULT NULL,
  `lactancia_secado` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `lactancia_etapa_anid` int(11) NOT NULL,
  `lactancia_etapa_etid` int(11) NOT NULL,
  PRIMARY KEY (`lactancia_id`),
  KEY `lactancia_etapa_animal` (`lactancia_etapa_anid`,`lactancia_etapa_etid`),
  CONSTRAINT `lactancia_etapa_animal` FOREIGN KEY (`lactancia_etapa_anid`, `lactancia_etapa_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `leche`
--

DROP TABLE IF EXISTS `leche`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `leche` (
  `leche_id` int(11) NOT NULL AUTO_INCREMENT,
  `leche_fecha_pesaje` date DEFAULT NULL,
  `leche_pesaje_Total` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `leche_lactancia_id` int(11) NOT NULL,
  PRIMARY KEY (`leche_id`),
  KEY `fk_lactancia` (`leche_lactancia_id`),
  CONSTRAINT `fk_lactancia` FOREIGN KEY (`leche_lactancia_id`) REFERENCES `lactancia` (`lactancia_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medidas_corporales`
--

DROP TABLE IF EXISTS `medidas_corporales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `medidas_corporales` (
  `id_Medida` int(11) NOT NULL AUTO_INCREMENT,
  `Altura_HC` float DEFAULT NULL,
  `Altura_HG` float DEFAULT NULL,
  `Perimetro_PT` float DEFAULT NULL,
  `Perimetro_PCA` float DEFAULT NULL,
  `Longitud_LC` float DEFAULT NULL,
  `Longitud_LG` float DEFAULT NULL,
  `Anchura_AG` float DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `medida_etapa_anid` int(11) NOT NULL,
  `medida_etapa_etid` int(11) NOT NULL,
  PRIMARY KEY (`id_Medida`),
  KEY `medida_etapa_animal` (`medida_etapa_anid`,`medida_etapa_etid`),
  CONSTRAINT `medida_etapa_animal` FOREIGN KEY (`medida_etapa_anid`, `medida_etapa_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movimiento_rebano`
--

DROP TABLE IF EXISTS `movimiento_rebano`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimiento_rebano` (
  `id_Movimiento` int(11) NOT NULL AUTO_INCREMENT,
  `id_Finca` int(11) NOT NULL,
  `id_Rebano` int(11) NOT NULL,
  `Rebano_Destino` varchar(30) DEFAULT NULL,
  `id_Finca_Destino` int(11) NOT NULL,
  `id_Rebano_Destino` int(11) NOT NULL,
  `Comentario` varchar(40) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Movimiento`),
  KEY `id_Rebano` (`id_Rebano`),
  KEY `id_Finca` (`id_Finca`),
  CONSTRAINT `Movimiento_Rebano_ibfk_1` FOREIGN KEY (`id_Rebano`) REFERENCES `rebano` (`id_Rebano`),
  CONSTRAINT `Movimiento_Rebano_ibfk_2` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movimiento_rebano_animal`
--

DROP TABLE IF EXISTS `movimiento_rebano_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimiento_rebano_animal` (
  `id_Animal` int(11) NOT NULL,
  `id_Movimiento` int(11) NOT NULL,
  `Estado` varchar(9) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Animal`,`id_Movimiento`),
  KEY `FK_id_Movimiento_movimiento_rebano_animal` (`id_Movimiento`),
  CONSTRAINT `FK_id_Animal_movimiento_rebano_animal` FOREIGN KEY (`id_Animal`) REFERENCES `animal` (`id_Animal`),
  CONSTRAINT `FK_id_Movimiento_movimiento_rebano_animal` FOREIGN KEY (`id_Movimiento`) REFERENCES `movimiento_rebano` (`id_Movimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ovario`
--

DROP TABLE IF EXISTS `ovario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ovario` (
  `ovario_id` int(11) NOT NULL AUTO_INCREMENT,
  `ovario_medida` char(2) DEFAULT NULL,
  `ovario_tamano` decimal(6,2) DEFAULT NULL,
  `ovario_lado` char(3) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `ovario_palpacion_id` int(11) NOT NULL,
  PRIMARY KEY (`ovario_id`),
  KEY `fk_palpacion_ovario` (`ovario_palpacion_id`),
  CONSTRAINT `fk_palpacion_ovario` FOREIGN KEY (`ovario_palpacion_id`) REFERENCES `palpacion` (`palpacion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ovario_foliculo`
--

DROP TABLE IF EXISTS `ovario_foliculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ovario_foliculo` (
  `fovo_id` int(11) NOT NULL AUTO_INCREMENT,
  `fovo_tamano` decimal(6,2) NOT NULL,
  `fovo_ovario_fase` varchar(10) NOT NULL,
  `fovo_foliculo_id` int(11) NOT NULL,
  `fovo_ovario_id` int(11) NOT NULL,
  PRIMARY KEY (`fovo_id`),
  KEY `fk_foliculo` (`fovo_foliculo_id`),
  KEY `fk_ovario` (`fovo_ovario_id`),
  CONSTRAINT `fk_foliculo` FOREIGN KEY (`fovo_foliculo_id`) REFERENCES `foliculo` (`foliculo_id`),
  CONSTRAINT `fk_ovario` FOREIGN KEY (`fovo_ovario_id`) REFERENCES `ovario` (`ovario_id`),
  CONSTRAINT `ck_ovario_fase` CHECK (`fovo_ovario_fase` in ('Folicular','Luteal','SEP'))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `palpacion`
--

DROP TABLE IF EXISTS `palpacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `palpacion` (
  `palpacion_id` int(11) NOT NULL AUTO_INCREMENT,
  `id_Tecnico` int(11) DEFAULT NULL,
  `palpacion_tipo` varchar(11) DEFAULT NULL,
  `palpacion_fecha` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `palpacion_etapa_anid` int(11) NOT NULL,
  `palpacion_etapa_etid` int(11) NOT NULL,
  PRIMARY KEY (`palpacion_id`),
  KEY `palpacion_etapa_animal` (`palpacion_etapa_anid`,`palpacion_etapa_etid`),
  KEY `Palpacion_ibfk_2` (`id_Tecnico`),
  CONSTRAINT `Palpacion_ibfk_2` FOREIGN KEY (`id_Tecnico`) REFERENCES `personal_finca` (`id_Tecnico`),
  CONSTRAINT `palpacion_etapa_animal` FOREIGN KEY (`palpacion_etapa_anid`, `palpacion_etapa_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `personal_finca`
--

DROP TABLE IF EXISTS `personal_finca`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_finca` (
  `id_Tecnico` int(11) NOT NULL AUTO_INCREMENT,
  `id_Finca` int(11) NOT NULL,
  `Cedula` int(11) NOT NULL,
  `Nombre` varchar(25) NOT NULL,
  `Apellido` varchar(25) NOT NULL,
  `Telefono` varchar(15) NOT NULL,
  `Correo` varchar(40) NOT NULL,
  `Tipo_Trabajador` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Tecnico`),
  KEY `id_Finca` (`id_Finca`),
  CONSTRAINT `Personal_Finca_ibfk_1` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`)
) ENGINE=InnoDB AUTO_INCREMENT=1004 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `peso_corporal`
--

DROP TABLE IF EXISTS `peso_corporal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `peso_corporal` (
  `id_Peso` int(11) NOT NULL AUTO_INCREMENT,
  `Fecha_Peso` date DEFAULT NULL,
  `Peso` float DEFAULT NULL,
  `Comentario` varchar(40) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `peso_etapa_anid` int(11) NOT NULL,
  `peso_etapa_etid` int(11) NOT NULL,
  PRIMARY KEY (`id_Peso`),
  KEY `peso_etapa_animal` (`peso_etapa_anid`,`peso_etapa_etid`),
  CONSTRAINT `peso_etapa_animal` FOREIGN KEY (`peso_etapa_anid`, `peso_etapa_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prenez_dia`
--

DROP TABLE IF EXISTS `prenez_dia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `prenez_dia` (
  `prdi_id` int(11) NOT NULL AUTO_INCREMENT,
  `prdi_tamano` decimal(6,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `prdi_dia_id` int(11) NOT NULL,
  `prdi_palpacion_id` int(11) NOT NULL,
  PRIMARY KEY (`prdi_id`),
  KEY `fk_palpacion_prenez` (`prdi_palpacion_id`),
  KEY `fk_dia_palpacion` (`prdi_dia_id`),
  CONSTRAINT `fk_dia_palpacion` FOREIGN KEY (`prdi_dia_id`) REFERENCES `dia_palpacion` (`dia_id`),
  CONSTRAINT `fk_palpacion_prenez` FOREIGN KEY (`prdi_palpacion_id`) REFERENCES `palpacion` (`palpacion_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `propietario`
--

DROP TABLE IF EXISTS `propietario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `propietario` (
  `id` bigint(20) unsigned NOT NULL,
  `id_Personal` int(11) DEFAULT NULL,
  `Nombre` varchar(25) DEFAULT NULL,
  `Apellido` varchar(25) DEFAULT NULL,
  `Telefono` varchar(15) DEFAULT NULL,
  `archivado` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `Fk_Users_P` FOREIGN KEY (`id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rebano`
--

DROP TABLE IF EXISTS `rebano`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rebano` (
  `id_Rebano` int(11) NOT NULL AUTO_INCREMENT,
  `id_Finca` int(11) NOT NULL,
  `Nombre` varchar(25) NOT NULL,
  `archivado` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Rebano`),
  KEY `id_Finca` (`id_Finca`),
  CONSTRAINT `Rebano_ibfk_1` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `registro_celo`
--

DROP TABLE IF EXISTS `registro_celo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `registro_celo` (
  `celo_id` int(11) NOT NULL AUTO_INCREMENT,
  `celo_fecha` date NOT NULL,
  `celo_observacon` varchar(100) DEFAULT NULL,
  `celo_etapa_anid` int(11) NOT NULL,
  `celo_etapa_etid` int(11) NOT NULL,
  PRIMARY KEY (`celo_id`),
  KEY `celo_etapa_animal` (`celo_etapa_anid`,`celo_etapa_etid`),
  CONSTRAINT `celo_etapa_animal` FOREIGN KEY (`celo_etapa_anid`, `celo_etapa_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reproduccion_animal`
--

DROP TABLE IF EXISTS `reproduccion_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `reproduccion_animal` (
  `repro_id` int(11) NOT NULL AUTO_INCREMENT,
  `repro_fecha_reproduccion` date NOT NULL,
  `repro_tipo_reproduccion` varchar(8) DEFAULT NULL,
  `repro_observacion` varchar(60) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `repro_etapa_anid` int(11) NOT NULL,
  `repro_etapa_etid` int(11) NOT NULL,
  PRIMARY KEY (`repro_id`),
  KEY `repro_servicio_id` (`repro_etapa_anid`,`repro_etapa_etid`),
  CONSTRAINT `repro_servicio_id` FOREIGN KEY (`repro_etapa_anid`, `repro_etapa_etid`) REFERENCES `etapa_animal` (`etan_animal_id`, `etan_etapa_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `semen_toro`
--

DROP TABLE IF EXISTS `semen_toro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `semen_toro` (
  `semen_id` int(11) NOT NULL AUTO_INCREMENT,
  `id_Toro` int(11) NOT NULL,
  `semen_estado` tinyint(1) DEFAULT NULL,
  `semen_fecha` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`semen_id`),
  KEY `id_Toro` (`id_Toro`),
  CONSTRAINT `fk_semen_toro_animal` FOREIGN KEY (`id_Toro`) REFERENCES `animal` (`id_Animal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `servicio_animal`
--

DROP TABLE IF EXISTS `servicio_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio_animal` (
  `servicio_id` int(11) NOT NULL AUTO_INCREMENT,
  `servicio_id_Animal` int(11) NOT NULL,
  `servicio_semen_id` int(11) DEFAULT NULL,
  `servicio_id_Tecnico` int(11) DEFAULT NULL,
  `servicio_tipo` varchar(11) DEFAULT NULL,
  `servicio_fecha` date DEFAULT NULL,
  `servicio_observacion` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `servicio_celo_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`servicio_id`),
  KEY `FK_AnimalS` (`servicio_id_Animal`),
  KEY `FK_TecnicoS` (`servicio_id_Tecnico`),
  KEY `FK_ToroS` (`servicio_semen_id`),
  KEY `fk_celo` (`servicio_celo_id`),
  CONSTRAINT `FK_AnimalS` FOREIGN KEY (`servicio_id_Animal`) REFERENCES `animal` (`id_Animal`),
  CONSTRAINT `FK_TecnicoS` FOREIGN KEY (`servicio_id_Tecnico`) REFERENCES `personal_finca` (`id_Tecnico`),
  CONSTRAINT `FK_ToroS` FOREIGN KEY (`servicio_semen_id`) REFERENCES `semen_toro` (`semen_id`),
  CONSTRAINT `fk_celo` FOREIGN KEY (`servicio_celo_id`) REFERENCES `registro_celo` (`celo_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `terreno`
--

DROP TABLE IF EXISTS `terreno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `terreno` (
  `id_Terreno` int(11) NOT NULL AUTO_INCREMENT,
  `id_Finca` int(11) NOT NULL,
  `Superficie` float DEFAULT NULL,
  `Relieve` varchar(9) DEFAULT NULL,
  `Suelo_Textura` varchar(25) DEFAULT NULL,
  `ph_Suelo` char(2) DEFAULT NULL,
  `Precipitacion` float DEFAULT NULL,
  `Velocidad_Viento` float DEFAULT NULL,
  `Temp_Anual` varchar(4) DEFAULT NULL,
  `Temp_Min` varchar(4) DEFAULT NULL,
  `Temp_Max` varchar(4) DEFAULT NULL,
  `Radiacion` float DEFAULT NULL,
  `Fuente_Agua` varchar(25) DEFAULT NULL,
  `Caudal_Disponible` int(11) DEFAULT NULL,
  `Riego_Metodo` varchar(18) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_Terreno`),
  KEY `id_Finca` (`id_Finca`),
  CONSTRAINT `Terreno_ibfk_1` FOREIGN KEY (`id_Finca`) REFERENCES `finca` (`id_Finca`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tipo_animal`
--

DROP TABLE IF EXISTS `tipo_animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_animal` (
  `tipo_animal_id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_animal_nombre` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`tipo_animal_id`),
  CONSTRAINT `check_tipo_animal_nombre` CHECK (`tipo_animal_nombre` regexp '^[a-zA-Z0-9áéíóúÁÉÍÓÚñÑ ]+$')
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transcriptor`
--

DROP TABLE IF EXISTS `transcriptor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `transcriptor` (
  `id` bigint(20) unsigned NOT NULL,
  `id_Personal` int(11) DEFAULT NULL,
  `Tipo_Transcriptor` varchar(15) DEFAULT NULL,
  `Nombre` varchar(25) DEFAULT NULL,
  `Apellido` varchar(25) DEFAULT NULL,
  `Telefono` varchar(15) DEFAULT NULL,
  `archivado` tinyint(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_UsersT` FOREIGN KEY (`id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tratamiento`
--

DROP TABLE IF EXISTS `tratamiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tratamiento` (
  `tratamiento_id` int(11) NOT NULL AUTO_INCREMENT,
  `tratamiento_plan` varchar(255) DEFAULT NULL,
  `tratamiento_fecha_ini` date NOT NULL,
  `tratamiento_fecha_fin` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `tratamiento_diagnostico_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`tratamiento_id`),
  KEY `fk_tratamiento_diag` (`tratamiento_diagnostico_id`),
  CONSTRAINT `fk_tratamiento_diag` FOREIGN KEY (`tratamiento_diagnostico_id`) REFERENCES `diagnostico` (`diagnostico_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL DEFAULT 'user.png',
  `remember_token` varchar(100) DEFAULT NULL,
  `google_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type_user` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vacuna`
--

DROP TABLE IF EXISTS `vacuna`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vacuna` (
  `vacuna_id` int(11) NOT NULL AUTO_INCREMENT,
  `vacuna_nombre` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`vacuna_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vacuna_casa`
--

DROP TABLE IF EXISTS `vacuna_casa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vacuna_casa` (
  `vc_vacuna_id` int(11) NOT NULL,
  `vc_casa_id` int(11) NOT NULL,
  `dosis_cantidad` decimal(10,2) NOT NULL,
  PRIMARY KEY (`vc_vacuna_id`,`vc_casa_id`),
  KEY `fk_casa_comercializadora` (`vc_casa_id`),
  CONSTRAINT `fk_casa_comercializadora` FOREIGN KEY (`vc_casa_id`) REFERENCES `casa_comercial` (`casa_id`),
  CONSTRAINT `fk_vacuna` FOREIGN KEY (`vc_vacuna_id`) REFERENCES `vacuna` (`vacuna_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-29  0:11:37
