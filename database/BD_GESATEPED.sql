CREATE DATABASE  IF NOT EXISTS `bd_gesateped` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `bd_gesateped`;
-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: localhost    Database: bd_gesateped
-- ------------------------------------------------------
-- Server version	5.7.3-m13-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tb_actividad`
--

DROP TABLE IF EXISTS `tb_actividad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_actividad` (
  `num_proc` int(11) NOT NULL COMMENT 'Numero de proceso.',
  `num_activ` int(11) NOT NULL COMMENT 'Numero de actividad.',
  `nom_activ` varchar(100) NOT NULL COMMENT 'Nombre de actividad.',
  `fec_ini_ejec_activ` datetime NOT NULL COMMENT 'Fecha inicio de ejecucion de actividad en formato dd/mm/yyyy hh24:mi:ss.',
  `fec_fin_ejec_activ` datetime DEFAULT NULL COMMENT 'Fecha fin de ejecucion de actividad en formato dd/mm/yyyy hh24:mi:ss.',
  `msg_inf_activ` varchar(300) DEFAULT NULL COMMENT 'Mensaje informativo de la actividad.',
  `err_tec_activ` varchar(250) DEFAULT NULL COMMENT 'Error tecnico de actividad.',
  `est_activ` varchar(7) DEFAULT NULL COMMENT 'Estado de actividad (SUCCESS: Satisfactorio, ERROR: Error).',
  PRIMARY KEY (`num_proc`,`num_activ`),
  CONSTRAINT `fk_proc_act` FOREIGN KEY (`num_proc`) REFERENCES `tb_proceso` (`num_proc`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la actividad del proceso batch.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_actividad`
--

LOCK TABLES `tb_actividad` WRITE;
/*!40000 ALTER TABLE `tb_actividad` DISABLE KEYS */;
INSERT INTO `tb_actividad` VALUES (1,1,'Selección de pedidos a procesar','2018-08-05 12:49:06','2018-08-05 12:49:06',NULL,NULL,'SUCCESS'),(1,2,'Agrupación de pedidos por bodega','2018-08-05 12:49:06','2018-08-05 12:49:06',NULL,NULL,'SUCCESS'),(1,3,'Distribución de pedidos a unidades','2018-08-05 12:49:06','2018-08-05 12:49:15',NULL,NULL,'SUCCESS'),(1,4,'Generación de reporte hoja de ruta','2018-08-05 12:49:15','2018-08-05 12:49:15',NULL,NULL,'SUCCESS');
/*!40000 ALTER TABLE `tb_actividad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_bodega`
--

DROP TABLE IF EXISTS `tb_bodega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_bodega` (
  `cod_bod` varchar(10) NOT NULL COMMENT 'Codigo de bodega.',
  `nom_bod` varchar(80) NOT NULL COMMENT 'Nombre de bodega.',
  `dir_bod` varchar(100) NOT NULL COMMENT 'Direccion de bodega.',
  `email_bod` varchar(50) NOT NULL COMMENT 'Correo electronico de bodega o nodo.',
  `cod_dist` varchar(10) NOT NULL COMMENT 'Codigo de distrito.',
  PRIMARY KEY (`cod_bod`),
  UNIQUE KEY `nom_bod_UNIQUE` (`nom_bod`),
  KEY `fk_bod_dist_idx` (`cod_dist`),
  CONSTRAINT `fk_bod_dist` FOREIGN KEY (`cod_dist`) REFERENCES `tb_distrito` (`cod_dist`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena informacion de la bodega.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_bodega`
--

LOCK TABLES `tb_bodega` WRITE;
/*!40000 ALTER TABLE `tb_bodega` DISABLE KEYS */;
INSERT INTO `tb_bodega` VALUES ('BOD0000001','Bodega Lurín','Almacen Sodimac','hbravocoronel@gmail.com','DIST000018'),('NOD0000002','Nodo San Miguel','Av. de la Marina 2355','hbravocoronel@gmail.com','DIST000035'),('NOD0000003','Nodo Angamos','Av. Tomás Marsano 961','hbravocoronel@gmail.com','DIST000040');
/*!40000 ALTER TABLE `tb_bodega` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_bodega_zona`
--

DROP TABLE IF EXISTS `tb_bodega_zona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_bodega_zona` (
  `cod_bod` varchar(10) NOT NULL COMMENT 'Codigo de bodega.',
  `cod_zon` varchar(10) NOT NULL COMMENT 'Codigo de zona.',
  PRIMARY KEY (`cod_bod`,`cod_zon`),
  KEY `fk_bod_zon_zon_idx` (`cod_zon`),
  CONSTRAINT `fk_bod_zon_bod` FOREIGN KEY (`cod_bod`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_bod_zon_zon` FOREIGN KEY (`cod_zon`) REFERENCES `tb_zona` (`cod_zon`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de las zonas de despacho de las bodegas.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_bodega_zona`
--

LOCK TABLES `tb_bodega_zona` WRITE;
/*!40000 ALTER TABLE `tb_bodega_zona` DISABLE KEYS */;
INSERT INTO `tb_bodega_zona` VALUES ('BOD0000001','ZON0000001'),('BOD0000001','ZON0000002'),('BOD0000001','ZON0000003'),('BOD0000001','ZON0000004'),('NOD0000002','ZON0000004'),('BOD0000001','ZON0000005'),('NOD0000003','ZON0000005'),('BOD0000001','ZON0000006');
/*!40000 ALTER TABLE `tb_bodega_zona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_chofer`
--

DROP TABLE IF EXISTS `tb_chofer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_chofer` (
  `num_brev_chof` varchar(10) NOT NULL COMMENT 'Numero de brevete del chofer.',
  `nom_chof` varchar(50) NOT NULL COMMENT 'Nombre del chofer.',
  `ape_chof` varchar(50) NOT NULL COMMENT 'Apellido del chofer.',
  `telf_chof` varchar(9) NOT NULL COMMENT 'Telefono del chofer.',
  `email_chof` varchar(50) NOT NULL COMMENT 'Email del chofer.',
  `flag_activ_chof` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Flag de activacion de chofer.',
  `cod_prv` varchar(10) NOT NULL COMMENT 'Codigo de proveedor.',
  PRIMARY KEY (`num_brev_chof`),
  KEY `fk_chof_prov_idx` (`cod_prv`),
  CONSTRAINT `fk_chof_prov` FOREIGN KEY (`cod_prv`) REFERENCES `tb_proveedor` (`cod_prv`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del chofer.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_chofer`
--

LOCK TABLES `tb_chofer` WRITE;
/*!40000 ALTER TABLE `tb_chofer` DISABLE KEYS */;
INSERT INTO `tb_chofer` VALUES ('Q22390922','Lorenzo','Meza Martinez','923311939','lmeza@gmail.com',1,'PRV0000001'),('Q30221825','Joycer','Cayllahua Roe','984702760','carlogermanb@gmail.com',1,'PRV0000002'),('Q33401077','Michael','Juape Montoya','994657387','mmontoya@gmail.com',1,'PRV0000001'),('Q40723053','Juan','Carrillo Fernandez','962329330','hbravocoronel@gmail.com',1,'PRV0000002'),('Q55121522','Edgar','Rosales Jurado','980903374','lisbethma20@gmail.com',1,'PRV0000002'),('Q71436309','Orlando','Montes Garay','941455441','obonarriva@gmail.com',1,'PRV0000002'),('Q76281109','José','Lino Laos','942209885','jlinolaos@gmail.com',1,'PRV0000001'),('Q99221165','Marcos','Suarez Rodriguez','992504328','rmunozdev@gmail.com',1,'PRV0000002');
/*!40000 ALTER TABLE `tb_chofer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_cliente`
--

DROP TABLE IF EXISTS `tb_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_cliente` (
  `cod_cli` varchar(10) NOT NULL COMMENT 'Codigo de cliente.',
  `nom_cli` varchar(50) NOT NULL COMMENT 'Nombre del cliente.',
  `ape_cli` varchar(50) NOT NULL COMMENT 'Apellido del cliente.',
  `num_dni_cli` varchar(8) NOT NULL COMMENT 'Numero de DNI del cliente.',
  `telf_cli` varchar(9) NOT NULL COMMENT 'Telefono del cliente.',
  `email_cli` varchar(50) NOT NULL COMMENT 'Email del cliente.',
  `dir_cli` varchar(100) NOT NULL COMMENT 'Direccion del cliente.',
  `cod_dist` varchar(10) NOT NULL COMMENT 'Codigo del distrito.',
  PRIMARY KEY (`cod_cli`),
  UNIQUE KEY `num_dni_cli_UNIQUE` (`num_dni_cli`),
  KEY `fk_cli_dis_idx` (`cod_dist`),
  CONSTRAINT `fk_cli_dist` FOREIGN KEY (`cod_dist`) REFERENCES `tb_distrito` (`cod_dist`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del cliente.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_cliente`
--

LOCK TABLES `tb_cliente` WRITE;
/*!40000 ALTER TABLE `tb_cliente` DISABLE KEYS */;
INSERT INTO `tb_cliente` VALUES ('CLI0000001','Harry','Bravo Coronel','40604841','962329330','hbravocoronel@gmail.com','Calle Sara Sara 157','DIST000035'),('CLI0000002','Omar','Bonarriva Tenorio','40395894','941455441','obonarriva@gmai.com','Av. Alameda del Corregidor 1590','DIST000013'),('CLI0000003','Roberto','Martinez Rivas','56895900','980903374','rmunozdev@gmail.com','Calle Monte Bello 150','DIST000039'),('CLI0000004','Nataly','Mercedes Fuentes','34568938','957484939','cloclo1683@gmail.com','Av. Javier Prado Este 6596','DIST000013'),('CLI0000005','Moises','Milano Cespedes','45883958','985738847','carlob28@gmail.com','Av. San Borja Nte. 886','DIST000029'),('CLI0000006','Melissa','Fernandez Gonzales','57738590','948577488','meli57@gmail.com','Av. Universitaria 1921','DIST000023'),('CLI0000007','Sandra','Mendoza Gil','47264774','958599480','sandrmend@gmail.com','Av. de la Marina 2500','DIST000035'),('CLI0000008','Pedro','Meza Cachique','58673990','984883758','pedromar@gmail.com','Calle Los Laureles 587','DIST000030'),('CLI0000009','Juan','Gil Lazaro','48489361','994994985','jgillazaro@gmail.com','Calle Francisco Masias 370','DIST000030'),('CLI0000010','Monica','Pasapera Linch','86940384','929384858','monipasapera@gmail.com','Av. Alfredo Mendiola 5500','DIST000016'),('CLI0000011','Edgar','Rosales Jurado','74883883','958859499','edgarjurado@gmail.com','Av. Javier Prado Este 2050','DIST000029'),('CLI0000012','Lidia','Ramos Laos','48838883','948499489','lidiaramos@gmail.com','Av. Gral. Salaverry 2255','DIST000030'),('CLI0000013','Marcos','Meza Morales','49495828','984884738','marcosmeza@gmail.com','Av. de la Marina 2000','DIST000035'),('CLI0000014','Lisardo','Garate Coronel','38488484','948857284','lisardogarate@gmail.com','Av. Nicolás de Ayllón 3012','DIST000036'),('CLI0000015','Selena','Aguilar Urbina','39929488','926473784','selenaaguilar@gmail.com','Av. Rep. de Venezuela 2379','DIST000046'),('CLI0000016','Renzo','Paredes Klu','74783883','947738621','renzoparedes@gmail.com','Av. Gral. Salaverry 2020','DIST000012'),('CLI0000017','Karin','Ramos Peralta','88838477','984663721','karinramos@gmail.com','Av. Rep. de Venezuela 5415','DIST000035'),('CLI0000018','Olga','Elera Mezones','84884938','977384828','olgaelera@gmail.com','Avenida Benavides 495','DIST000020'),('CLI0000019','Luis','Romario Meza','93884727','988377261','luisromario@gmail.com','Av. Arequipa 4651','DIST000020'),('CLI0000020','Roxana','Delgado Delgado','88377482','988475555','roxanadelgado@gmail.com','Jirón Junin 355','DIST000020'),('CLI0000021','Karina','Romario Paredes','93884883','994839948','karinaroma@gmail.com','Av. Rafael Escardo 309','DIST000035'),('CLI0000022','Rolando','Martinez Manrique','94884988','839883783','rolandmanrique@gmail.com','Av. Separadora Industrial 791','DIST000002'),('CLI0000023','Lorenzo','Puquio Lamas','93998593','984993882','lorenzolamas@gmail.com','Av. Las Leyendas 580','DIST000035'),('CLI0000024','Luisa','Salas Mezones','99399849','929383892','luisasalas@gmail.com','Calle Las Begonias 577','DIST000030'),('CLI0000025','Paola','Ascacibar Coronel','83948939','847758477','paosasca@gmail.com','Calle las Camelias 530','DIST000030'),('CLI0000026','Roberto','Egustiza Polanski','87377288','928839381','robertpolan@gmail.com','Av. Tupac Amaru 280','DIST000050'),('CLI0000027','Iris','Loza Hernandez','83847729','983862626','irisloza@gmail.com','Av. Riva Agüero 114','DIST000050'),('CLI0000028','Henry','Longa Jimenez','73626672','938272778','henrylonga@gmail.com','Av. Nicolás de Ayllón 4706','DIST000050'),('CLI0000029','Vanessa','Blas Cayllahua','87382900','949299484','vane2838@gmail.com','Manuel Ascencio Segura 268','DIST000015'),('CLI0000030','Patty','Arias Velasquez','37473888','948588493','pattyarias@gmail.com','Av. Petit Thouars 1370','DIST000050'),('CLI0000031','Rossmery','Bonaz Blas','84883900','988583778','rossmeryblas@gmail.com','Av. de la Marina 2500','DIST000035'),('CLI0000032','María','Zuñiga Gil','93837474','847838838','marizuniga@gmail.com','Ignacio Mariategui 105','DIST000003'),('CLI0000033','Maritza','Ponce Larco','89848377','988466378','maritzalarco@gmail.com','Av. Antonio José de Sucre 175','DIST000019'),('CLI0000034','Pedro','Armendariz Loayza','99488377','857748839','pedroarmendariz@gmail.com','Av. Universitaria 1921','DIST000023'),('CLI0000035','Luisa','Lamas Ruiz','95884937','995884773','luisalamas@gmail.com','Av. Gral. Salaverry 2370','DIST000012'),('CLI0000036','Renzo','Gallardo Durán','94985938','994884893','renzogallardo@gmail.com','Av. Las Leyendas 580','DIST000035');
/*!40000 ALTER TABLE `tb_cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_controller_tienda`
--

DROP TABLE IF EXISTS `tb_controller_tienda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_controller_tienda` (
  `cod_contr_tiend` varchar(10) NOT NULL COMMENT 'Codigo de controller de tienda.',
  `nom_contr_tiend` varchar(50) NOT NULL COMMENT 'Nombre del controller de tienda.',
  `ape_contr_tiend` varchar(50) NOT NULL COMMENT 'Apellido del controller de tienda.',
  `telf_contr_tiend` varchar(9) NOT NULL COMMENT 'Telefono del controller de tienda.',
  `email_contr_tiend` varchar(50) NOT NULL COMMENT 'Email del controller de tienda.',
  PRIMARY KEY (`cod_contr_tiend`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del controller de tienda.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_controller_tienda`
--

LOCK TABLES `tb_controller_tienda` WRITE;
/*!40000 ALTER TABLE `tb_controller_tienda` DISABLE KEYS */;
INSERT INTO `tb_controller_tienda` VALUES ('CTI0000001','Silvia','Kcomt Li','962329330','hbravocoronel@gmail.com'),('CTI0000002','Pedro','Huanco Molina','957483959','pedrohuanc23@gmail.com'),('CTI0000003','Karen','Aguilar Avila','958478389','karenagui374@gmail.com'),('CTI0000004','Lorenzo','Giraldo Coronel','948583758','lorenzo375@gmail.com'),('CTI0000005','Ronaldo','Rosales Jurado','932336377','ronald758@gmail.com');
/*!40000 ALTER TABLE `tb_controller_tienda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_cuadrilla`
--

DROP TABLE IF EXISTS `tb_cuadrilla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_cuadrilla` (
  `cod_cuad` varchar(10) NOT NULL COMMENT 'Codigo de cuadrilla.',
  `nom_cuad` varchar(50) NOT NULL COMMENT 'Nombre de cuadrilla.',
  `fec_ini_asig_cuad` date NOT NULL COMMENT 'Fecha inicial de asignacion de cuadrilla en formato dd/mm/yyyy.',
  `fec_fin_asig_cuad` date NOT NULL COMMENT 'Fecha final de asignacion de cuadrilla en formato dd/mm/yyyy.',
  PRIMARY KEY (`cod_cuad`),
  UNIQUE KEY `nom_cuad_UNIQUE` (`nom_cuad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la cuadrilla.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_cuadrilla`
--

LOCK TABLES `tb_cuadrilla` WRITE;
/*!40000 ALTER TABLE `tb_cuadrilla` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_cuadrilla` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_cubicacion_pedido`
--

DROP TABLE IF EXISTS `tb_cubicacion_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_cubicacion_pedido` (
  `cod_bod` varchar(10) NOT NULL COMMENT 'Codigo de bodega.',
  `cod_ped` varchar(10) NOT NULL,
  `cod_prod` varchar(15) NOT NULL COMMENT 'Codigo de producto.',
  `area_bod` varchar(15) NOT NULL COMMENT 'Area de la bodega.',
  `pasi_area` varchar(15) NOT NULL COMMENT 'Pasillo del area.',
  `lado_pasi` varchar(15) NOT NULL COMMENT 'Lado del pasillo.',
  `altu_lado` varchar(15) NOT NULL COMMENT 'Altura del lado.',
  `prof_altu` varchar(15) NOT NULL COMMENT 'Profundidad de la altura.',
  PRIMARY KEY (`cod_bod`,`cod_prod`,`cod_ped`),
  KEY `fk_cub_det_ped_idx` (`cod_ped`,`cod_prod`),
  CONSTRAINT `fk_cub_bod` FOREIGN KEY (`cod_bod`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_cub_det_ped` FOREIGN KEY (`cod_ped`, `cod_prod`) REFERENCES `tb_detalle_pedido` (`cod_ped`, `cod_prod`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la ubicacion del producto de un pedido en la bodega.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_cubicacion_pedido`
--

LOCK TABLES `tb_cubicacion_pedido` WRITE;
/*!40000 ALTER TABLE `tb_cubicacion_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_cubicacion_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_departamento`
--

DROP TABLE IF EXISTS `tb_departamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_departamento` (
  `cod_dep` varchar(10) NOT NULL COMMENT 'Codigo de departamento.',
  `nom_dep` varchar(100) NOT NULL COMMENT 'Nombre de departamento.',
  PRIMARY KEY (`cod_dep`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del departamento.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_departamento`
--

LOCK TABLES `tb_departamento` WRITE;
/*!40000 ALTER TABLE `tb_departamento` DISABLE KEYS */;
INSERT INTO `tb_departamento` VALUES ('DEP0000001','Lima');
/*!40000 ALTER TABLE `tb_departamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_detalle_hoja_ruta`
--

DROP TABLE IF EXISTS `tb_detalle_hoja_ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_detalle_hoja_ruta` (
  `cod_hoj_rut` varchar(10) NOT NULL COMMENT 'Codigo de hoja de ruta.',
  `cod_ped` varchar(10) NOT NULL COMMENT 'Codigo de pedido.',
  `ord_desp_ped` int(11) DEFAULT NULL COMMENT 'Orden de despacho de pedido.',
  `tiemp_prom_desp` int(11) DEFAULT NULL COMMENT 'Tiempo promedio de despacho en minutos.',
  `fec_estim_part` datetime DEFAULT NULL COMMENT 'Fecha estimada de partida en formato dd/mm/yyyy hh24:mi:ss.',
  `tiemp_estim_lleg` int(11) DEFAULT NULL COMMENT 'Tiempo estimado de llegada en minutos.',
  `fec_estim_lleg` datetime DEFAULT NULL COMMENT 'Fecha estimada de llegada en formato dd/mm/yyyy hh24:mi:ss.',
  `distancia_estim` int(11) DEFAULT NULL COMMENT 'Distancia estimada en metros.',
  `fec_pact_desp` datetime DEFAULT NULL COMMENT 'Fecha pactada de despacho en formato dd/mm/yyyy hh24:mi:ss.',
  `fec_no_cump_desp` datetime DEFAULT NULL COMMENT 'Fecha de no cumplimiento de despacho en formato dd/mm/yyyy hh24:mi:ss.',
  `lat_gps_desp_ped` decimal(10,7) DEFAULT NULL COMMENT 'Latitud GPS de despacho de pedido.',
  `long_gps_desp_ped` decimal(10,7) DEFAULT NULL COMMENT 'Longitud GPS de despacho de pedido.',
  `fot_desp_ped` mediumblob COMMENT 'Foto de despacho del pedido.',
  `cod_vent_hor` varchar(10) DEFAULT NULL COMMENT 'Codigo de ventana horaria.',
  `cod_mot_ped` varchar(10) DEFAULT NULL COMMENT 'Codigo de motivo de pedido en caso de no cumplimiento de despacho de pedido.',
  PRIMARY KEY (`cod_hoj_rut`,`cod_ped`),
  KEY `fk_det_hoj_rut_ped_idx` (`cod_ped`),
  KEY `fk_det_hoj_rut_vent_hor_idx` (`cod_vent_hor`),
  KEY `fk_det_hoj_rut_mot_ped_idx` (`cod_mot_ped`),
  CONSTRAINT `fk_det_hoj_rut_hoj_rut` FOREIGN KEY (`cod_hoj_rut`) REFERENCES `tb_hoja_ruta` (`cod_hoj_rut`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_det_hoj_rut_mot_ped` FOREIGN KEY (`cod_mot_ped`) REFERENCES `tb_motivo_pedido` (`cod_mot_ped`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_det_hoj_rut_ped` FOREIGN KEY (`cod_ped`) REFERENCES `tb_pedido` (`cod_ped`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_det_hoj_rut_vent_hor` FOREIGN KEY (`cod_vent_hor`) REFERENCES `tb_ventana_horaria` (`cod_vent_hor`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del detalle de hoja de ruta.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_detalle_hoja_ruta`
--

LOCK TABLES `tb_detalle_hoja_ruta` WRITE;
/*!40000 ALTER TABLE `tb_detalle_hoja_ruta` DISABLE KEYS */;
INSERT INTO `tb_detalle_hoja_ruta` VALUES ('HRU0000001','PED0000035',2,30,'2018-08-06 08:30:00',20,'2018-08-06 08:50:42',11874,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000001','PED0000036',1,30,'2018-08-06 07:49:12',10,'2018-08-06 08:00:00',3685,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000001','PED0000037',4,30,'2018-08-06 10:14:22',15,'2018-08-06 10:29:35',5011,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000001','PED0000038',3,30,'2018-08-06 09:20:42',23,'2018-08-06 09:44:22',10537,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000001','PED0000039',5,30,'2018-08-06 10:59:35',5,'2018-08-06 11:05:31',1812,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000002','PED0000001',7,30,'2018-08-06 12:38:27',6,'2018-08-06 13:44:57',1066,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000002','PED0000006',9,30,'2018-08-06 13:53:59',10,'2018-08-06 15:04:55',2446,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000002','PED0000008',12,30,'2018-08-06 16:08:02',13,'2018-08-06 17:21:10',3678,NULL,NULL,NULL,NULL,NULL,'VHL0000003',NULL),('HRU0000002','PED0000010',5,30,'2018-08-06 10:49:45',16,'2018-08-06 11:06:43',10395,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000002','PED0000014',1,30,'2018-08-06 07:14:01',45,'2018-08-06 08:00:00',38890,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000002','PED0000015',6,30,'2018-08-06 11:36:43',31,'2018-08-06 13:08:27',14091,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000002','PED0000022',11,30,'2018-08-06 15:25:05',12,'2018-08-06 16:38:02',5333,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000002','PED0000023',3,30,'2018-08-06 09:18:48',14,'2018-08-06 09:32:50',2928,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000002','PED0000024',8,30,'2018-08-06 13:14:57',9,'2018-08-06 14:23:59',2027,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000002','PED0000029',4,30,'2018-08-06 10:02:50',16,'2018-08-06 10:19:45',4252,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000002','PED0000030',2,30,'2018-08-06 08:30:00',18,'2018-08-06 08:48:48',5668,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000002','PED0000032',10,30,'2018-08-06 14:34:55',20,'2018-08-06 15:55:05',5215,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000003','PED0000002',1,30,'2018-08-06 07:12:25',47,'2018-08-06 08:00:00',38529,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000003','PED0000003',11,30,'2018-08-06 15:15:10',12,'2018-08-06 16:27:12',3127,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000003','PED0000004',2,30,'2018-08-06 08:30:00',15,'2018-08-06 08:45:22',5378,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000003','PED0000005',10,30,'2018-08-06 14:39:40',5,'2018-08-06 15:45:10',1420,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000003','PED0000007',7,30,'2018-08-06 12:24:46',5,'2018-08-06 13:30:37',1072,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000003','PED0000009',4,30,'2018-08-06 10:10:57',15,'2018-08-06 10:26:40',5660,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000003','PED0000011',9,30,'2018-08-06 13:55:46',13,'2018-08-06 15:09:40',6402,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000003','PED0000012',5,30,'2018-08-06 10:56:40',11,'2018-08-06 11:08:29',3363,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000003','PED0000013',6,30,'2018-08-06 11:38:29',16,'2018-08-06 11:54:46',5392,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000003','PED0000021',8,30,'2018-08-06 13:00:37',25,'2018-08-06 14:25:46',12794,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000003','PED0000031',3,30,'2018-08-06 09:15:22',25,'2018-08-06 09:40:57',8658,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000004','PED0000016',3,30,'2018-08-06 09:12:13',39,'2018-08-06 09:51:36',21089,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000004','PED0000017',5,30,'2018-08-06 11:22:21',45,'2018-08-06 13:07:27',16787,NULL,NULL,NULL,NULL,NULL,'VHL0000002',NULL),('HRU0000004','PED0000018',1,30,'2018-08-06 07:22:15',37,'2018-08-06 08:00:00',31004,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000004','PED0000019',4,30,'2018-08-06 10:21:36',30,'2018-08-06 10:52:21',11530,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL),('HRU0000004','PED0000020',2,30,'2018-08-06 08:30:00',12,'2018-08-06 08:42:13',7500,NULL,NULL,NULL,NULL,NULL,'VHL0000001',NULL);
/*!40000 ALTER TABLE `tb_detalle_hoja_ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_detalle_pedido`
--

DROP TABLE IF EXISTS `tb_detalle_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_detalle_pedido` (
  `cod_ped` varchar(10) NOT NULL COMMENT 'Codigo de pedido.',
  `cod_prod` varchar(15) NOT NULL COMMENT 'Codigo de producto.',
  `cant_prod` int(11) NOT NULL COMMENT 'Cantidad de producto.',
  `cant_prod_defect` int(11) DEFAULT NULL COMMENT 'Cantidad de productos defectuosos.',
  `obs_prod_defect` varchar(200) DEFAULT NULL COMMENT 'Observacion de productos defectuosos.',
  `cant_prod_no_ubic` int(11) DEFAULT NULL COMMENT 'Cantidad de productos no ubicados.',
  `cod_bod` varchar(10) NOT NULL COMMENT 'Codigo de bodega.',
  PRIMARY KEY (`cod_ped`,`cod_prod`),
  KEY `fk_det_ped_prod_idx` (`cod_prod`),
  KEY `fk_det_ped_bod_idx` (`cod_bod`),
  CONSTRAINT `fk_det_ped_bod` FOREIGN KEY (`cod_bod`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_det_ped_ped` FOREIGN KEY (`cod_ped`) REFERENCES `tb_pedido` (`cod_ped`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_det_ped_prod` FOREIGN KEY (`cod_prod`) REFERENCES `tb_producto` (`cod_prod`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del detalle del pedido.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_detalle_pedido`
--

LOCK TABLES `tb_detalle_pedido` WRITE;
/*!40000 ALTER TABLE `tb_detalle_pedido` DISABLE KEYS */;
INSERT INTO `tb_detalle_pedido` VALUES ('PED0000001','SKU123024-7',1,NULL,NULL,NULL,'BOD0000001'),('PED0000001','SKU186193-X',1,NULL,NULL,NULL,'BOD0000001'),('PED0000001','SKU204759-4',1,NULL,NULL,NULL,'BOD0000001'),('PED0000002','SKU263525-9',2,NULL,NULL,NULL,'BOD0000001'),('PED0000003','SKU243076-2',3,NULL,NULL,NULL,'BOD0000001'),('PED0000003','SKU247198-1',1,NULL,NULL,NULL,'BOD0000001'),('PED0000004','SKU204759-4',2,NULL,NULL,NULL,'BOD0000001'),('PED0000005','SKU204759-4',3,NULL,NULL,NULL,'BOD0000001'),('PED0000005','SKU205201-6',2,NULL,NULL,NULL,'BOD0000001'),('PED0000006','SKU224538-8',1,NULL,NULL,NULL,'BOD0000001'),('PED0000006','SKU226800-0',1,NULL,NULL,NULL,'BOD0000001'),('PED0000006','SKU228298-4',5,NULL,NULL,NULL,'BOD0000001'),('PED0000007','SKU254078-9',1,NULL,NULL,NULL,'BOD0000001'),('PED0000007','SKU260978-9',3,NULL,NULL,NULL,'BOD0000001'),('PED0000008','SKU186193-X',1,NULL,NULL,NULL,'BOD0000001'),('PED0000009','SKU204759-4',3,NULL,NULL,NULL,'BOD0000001'),('PED0000010','SKU263525-9',1,NULL,NULL,NULL,'BOD0000001'),('PED0000010','SKU8285-6',5,NULL,NULL,NULL,'BOD0000001'),('PED0000011','SKU135154-0',1,NULL,NULL,NULL,'BOD0000001'),('PED0000011','SKU224538-8',2,NULL,NULL,NULL,'BOD0000001'),('PED0000012','SKU184460-1',1,NULL,NULL,NULL,'BOD0000001'),('PED0000013','SKU234330-4',1,NULL,NULL,NULL,'BOD0000001'),('PED0000013','SKU247198-1',1,NULL,NULL,NULL,'BOD0000001'),('PED0000013','SKU254078-9',1,NULL,NULL,NULL,'BOD0000001'),('PED0000013','SKU267241-3',1,NULL,NULL,NULL,'BOD0000001'),('PED0000014','SKU123024-7',1,NULL,NULL,NULL,'BOD0000001'),('PED0000015','SKU205201-6',3,NULL,NULL,NULL,'BOD0000001'),('PED0000016','SKU228298-4',8,NULL,NULL,NULL,'BOD0000001'),('PED0000016','SKU243076-2',1,NULL,NULL,NULL,'BOD0000001'),('PED0000017','SKU184460-1',1,NULL,NULL,NULL,'BOD0000001'),('PED0000017','SKU186193-X',1,NULL,NULL,NULL,'BOD0000001'),('PED0000018','SKU247198-1',20,NULL,NULL,NULL,'BOD0000001'),('PED0000019','SKU263525-9',10,NULL,NULL,NULL,'BOD0000001'),('PED0000020','SKU135154-0',1,NULL,NULL,NULL,'BOD0000001'),('PED0000021','SKU247198-1',1,NULL,NULL,NULL,'BOD0000001'),('PED0000022','SKU264890-3',2,NULL,NULL,NULL,'BOD0000001'),('PED0000023','SKU263525-9',1,1,'No enciende',NULL,'BOD0000001'),('PED0000024','SKU234330-4',2,1,'Tiene una abolladura',NULL,'BOD0000001'),('PED0000025','SKU243076-2',3,NULL,NULL,NULL,'BOD0000001'),('PED0000026','SKU254078-9',2,NULL,NULL,NULL,'BOD0000001'),('PED0000027','SKU254274-9',1,NULL,NULL,NULL,'BOD0000001'),('PED0000028','SKU226800-0',2,NULL,NULL,NULL,'BOD0000001'),('PED0000029','SKU267241-3',3,NULL,NULL,NULL,'BOD0000001'),('PED0000030','SKU224538-8',2,NULL,NULL,NULL,'BOD0000001'),('PED0000031','SKU135154-0',1,NULL,'Tiene una abolladura',NULL,'BOD0000001'),('PED0000032','SKU263525-9',1,NULL,'No enciende',NULL,'BOD0000001'),('PED0000033','SKU226800-0',1,NULL,NULL,NULL,'BOD0000001'),('PED0000034','SKU205201-6',1,1,'Esta raspado',NULL,'BOD0000001'),('PED0000035','SKU234330-4',1,NULL,NULL,NULL,'NOD0000002'),('PED0000036','SKU247198-1',1,NULL,NULL,NULL,'NOD0000002'),('PED0000037','SKU260978-9',1,NULL,NULL,NULL,'NOD0000002'),('PED0000038','SKU267241-3',2,NULL,NULL,NULL,'NOD0000002'),('PED0000039','SKU264890-3',1,NULL,NULL,NULL,'NOD0000002');
/*!40000 ALTER TABLE `tb_detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_distrito`
--

DROP TABLE IF EXISTS `tb_distrito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_distrito` (
  `cod_dist` varchar(10) NOT NULL COMMENT 'Codigo de distrito.',
  `nom_dist` varchar(100) NOT NULL COMMENT 'Nombre de distrito.',
  `cod_prov` varchar(10) NOT NULL COMMENT 'Codigo de provincia.',
  `cod_zon` varchar(10) NOT NULL COMMENT 'Codigo de zona.',
  PRIMARY KEY (`cod_dist`),
  KEY `fk_dis_zon_cob_idx` (`cod_zon`),
  KEY `fk_dis_prov_idx` (`cod_prov`),
  CONSTRAINT `fk_dist_prov` FOREIGN KEY (`cod_prov`) REFERENCES `tb_provincia` (`cod_prov`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_dist_zon` FOREIGN KEY (`cod_zon`) REFERENCES `tb_zona` (`cod_zon`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del distrito.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_distrito`
--

LOCK TABLES `tb_distrito` WRITE;
/*!40000 ALTER TABLE `tb_distrito` DISABLE KEYS */;
INSERT INTO `tb_distrito` VALUES ('DIST000001','Ancón','PROV000001','ZON0000001'),('DIST000002','Ate','PROV000001','ZON0000002'),('DIST000003','Barranco','PROV000001','ZON0000004'),('DIST000004','Breña','PROV000001','ZON0000003'),('DIST000005','Carabayllo','PROV000001','ZON0000001'),('DIST000006','Chaclacayo','PROV000001','ZON0000002'),('DIST000007','Chorrillos','PROV000001','ZON0000005'),('DIST000008','Cieneguilla','PROV000001','ZON0000002'),('DIST000009','Comas','PROV000001','ZON0000001'),('DIST000010','El Agustino','PROV000001','ZON0000002'),('DIST000011','Independencia','PROV000001','ZON0000001'),('DIST000012','Jesús María','PROV000001','ZON0000004'),('DIST000013','La Molina','PROV000001','ZON0000004'),('DIST000014','La Victoria','PROV000001','ZON0000003'),('DIST000015','Lince','PROV000001','ZON0000004'),('DIST000016','Los Olivos','PROV000001','ZON0000001'),('DIST000017','Chosica','PROV000001','ZON0000002'),('DIST000018','Lurín','PROV000001','ZON0000005'),('DIST000019','Magdalena del Mar','PROV000001','ZON0000004'),('DIST000020','Miraflores','PROV000001','ZON0000004'),('DIST000021','Pachacamac','PROV000001','ZON0000005'),('DIST000022','Pucusana','PROV000001','ZON0000005'),('DIST000023','Pueblo Libre','PROV000001','ZON0000004'),('DIST000024','Puente Piedra','PROV000001','ZON0000001'),('DIST000025','Punta Hermosa','PROV000001','ZON0000005'),('DIST000026','Punta Negra','PROV000001','ZON0000005'),('DIST000027','Rímac','PROV000001','ZON0000003'),('DIST000028','San Bartolo','PROV000001','ZON0000005'),('DIST000029','San Borja','PROV000001','ZON0000004'),('DIST000030','San Isidro','PROV000001','ZON0000004'),('DIST000031','San Juan de Lurigancho','PROV000001','ZON0000002'),('DIST000032','San Juan de Miraflores','PROV000001','ZON0000005'),('DIST000033','San Luis','PROV000001','ZON0000003'),('DIST000034','San Martin de Porres','PROV000001','ZON0000001'),('DIST000035','San Miguel','PROV000001','ZON0000004'),('DIST000036','Santa Anita','PROV000001','ZON0000002'),('DIST000037','Santa María del Mar','PROV000001','ZON0000005'),('DIST000038','Santa Rosa','PROV000001','ZON0000001'),('DIST000039','Santiago de Surco','PROV000001','ZON0000004'),('DIST000040','Surquillo','PROV000001','ZON0000004'),('DIST000041','Villa El Salvador','PROV000001','ZON0000005'),('DIST000042','Villa María Del Triunfo','PROV000001','ZON0000005'),('DIST000043','Ventanilla','PROV000001','ZON0000003'),('DIST000044','La Punta','PROV000001','ZON0000006'),('DIST000045','Carmen de la Legua Reynoso','PROV000001','ZON0000006'),('DIST000046','Bellavista','PROV000001','ZON0000006'),('DIST000047','Callao','PROV000001','ZON0000006'),('DIST000048','La Perla','PROV000001','ZON0000006'),('DIST000049','Mi Perú','PROV000001','ZON0000006'),('DIST000050','Cercado de Lima','PROV000001','ZON0000003');
/*!40000 ALTER TABLE `tb_distrito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_familia_producto`
--

DROP TABLE IF EXISTS `tb_familia_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_familia_producto` (
  `cod_fam_prod` varchar(10) NOT NULL COMMENT 'Codigo de familia de producto.',
  `nom_fam_prod` varchar(50) NOT NULL COMMENT 'Nombre de familia de producto.',
  PRIMARY KEY (`cod_fam_prod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la familia de producto.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_familia_producto`
--

LOCK TABLES `tb_familia_producto` WRITE;
/*!40000 ALTER TABLE `tb_familia_producto` DISABLE KEYS */;
INSERT INTO `tb_familia_producto` VALUES ('FPR0000001','Construcción y Acabados'),('FPR0000002','Herramientas y Maquinarias'),('FPR0000003','Gasfitería y Electricidad'),('FPR0000004','Electrohogar, Baño y Cocina'),('FPR0000005','Calefacción y Ventilación'),('FPR0000006','Muebles y Decoración'),('FPR0000007','Organización y Limpieza'),('FPR0000008','Tecnología y Seguridad'),('FPR0000009','Automóvil'),('FPR0000010','Aire Libre y Jardín');
/*!40000 ALTER TABLE `tb_familia_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_hoja_ruta`
--

DROP TABLE IF EXISTS `tb_hoja_ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_hoja_ruta` (
  `cod_hoj_rut` varchar(10) NOT NULL COMMENT 'Codigo de hoja de ruta.',
  `fec_gen_hoj_rut` datetime NOT NULL COMMENT 'Fecha de generacion de hoja de ruta en formato dd/mm/yyyy hh24:mi:ss.',
  `fec_desp_hoj_rut` date NOT NULL COMMENT 'Fecha de despacho de hoja de ruta en formato dd/mm/yyyy.',
  `cod_bod` varchar(10) NOT NULL COMMENT 'Codigo de bodega.',
  `cod_unid_chof` varchar(10) NOT NULL COMMENT 'codigo de unidad con chofer.',
  `cod_cuad` varchar(10) DEFAULT NULL COMMENT 'Codigo de cuadrilla.',
  PRIMARY KEY (`cod_hoj_rut`),
  KEY `fk_hoj_rut_bod_idx` (`cod_bod`),
  KEY `fk_hoj_rut_cuad_idx` (`cod_cuad`),
  KEY `fk_hoj_rut_unid_idx` (`cod_unid_chof`),
  CONSTRAINT `fk_hoj_rut_bod` FOREIGN KEY (`cod_bod`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_hoj_rut_cuad` FOREIGN KEY (`cod_cuad`) REFERENCES `tb_cuadrilla` (`cod_cuad`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_hoj_rut_unid_chof` FOREIGN KEY (`cod_unid_chof`) REFERENCES `tb_unidad_chofer` (`cod_unid_chof`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la hoja de ruta.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_hoja_ruta`
--

LOCK TABLES `tb_hoja_ruta` WRITE;
/*!40000 ALTER TABLE `tb_hoja_ruta` DISABLE KEYS */;
INSERT INTO `tb_hoja_ruta` VALUES ('HRU0000001','2018-08-05 12:49:15','2018-08-06','NOD0000002','UCH0000008',NULL),('HRU0000002','2018-08-05 12:49:15','2018-08-06','BOD0000001','UCH0000001',NULL),('HRU0000003','2018-08-05 12:49:15','2018-08-06','BOD0000001','UCH0000007',NULL),('HRU0000004','2018-08-05 12:49:15','2018-08-06','BOD0000001','UCH0000006',NULL);
/*!40000 ALTER TABLE `tb_hoja_ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_kardex`
--

DROP TABLE IF EXISTS `tb_kardex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_kardex` (
  `cod_bod` varchar(10) NOT NULL COMMENT 'Codigo de bodega.',
  `cod_prod` varchar(15) NOT NULL COMMENT 'Codigo de producto.',
  `stk_min` int(11) NOT NULL COMMENT 'Stock minimo del producto.',
  `stk_act` int(11) NOT NULL COMMENT 'Stock actual del producto.',
  `fec_act_reg` datetime NOT NULL COMMENT 'Fecha actual de registro en formato dd/mm/yyyy hh24:mi:ss.',
  PRIMARY KEY (`cod_bod`,`cod_prod`),
  KEY `fk_kard_prod_idx` (`cod_prod`),
  CONSTRAINT `fk_kard_bod` FOREIGN KEY (`cod_bod`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_kard_prod` FOREIGN KEY (`cod_prod`) REFERENCES `tb_producto` (`cod_prod`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del kardex (existencia de los productos en bodega).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_kardex`
--

LOCK TABLES `tb_kardex` WRITE;
/*!40000 ALTER TABLE `tb_kardex` DISABLE KEYS */;
INSERT INTO `tb_kardex` VALUES ('BOD0000001','SKU123024-7',80,120,'2018-07-27 10:00:00'),('BOD0000001','SKU135154-0',100,300,'2018-07-27 10:00:00'),('BOD0000001','SKU157217-2',70,80,'2018-07-27 10:00:00'),('BOD0000001','SKU184460-1',30,28,'2018-07-27 10:00:00'),('BOD0000001','SKU186193-X',120,200,'2018-07-27 10:00:00'),('BOD0000001','SKU204759-4',200,170,'2018-07-27 10:00:00'),('BOD0000001','SKU205201-6',120,300,'2018-07-27 10:00:00'),('BOD0000001','SKU221909-3',35,0,'2018-07-27 10:00:00'),('BOD0000001','SKU224538-8',50,130,'2018-07-27 10:00:00'),('BOD0000001','SKU226800-0',34,50,'2018-07-27 10:00:00'),('BOD0000001','SKU228298-4',56,20,'2018-07-27 10:00:00'),('BOD0000001','SKU234330-4',15,0,'2018-07-27 10:00:00'),('BOD0000001','SKU243076-2',45,0,'2018-07-27 10:00:00'),('BOD0000001','SKU247198-1',100,200,'2018-07-27 10:00:00'),('BOD0000001','SKU254078-9',150,400,'2018-07-27 10:00:00'),('BOD0000001','SKU254274-9',95,130,'2018-07-27 10:00:00'),('BOD0000001','SKU260978-9',130,180,'2018-07-27 10:00:00'),('BOD0000001','SKU263525-9',240,400,'2018-07-27 10:00:00'),('BOD0000001','SKU264890-3',300,500,'2018-07-27 10:00:00'),('BOD0000001','SKU267241-3',210,210,'2018-07-27 10:00:00'),('BOD0000001','SKU8285-6',190,190,'2018-07-27 10:00:00'),('NOD0000002','SKU123024-7',80,120,'2018-07-27 10:00:00'),('NOD0000002','SKU135154-0',100,300,'2018-07-27 10:00:00'),('NOD0000002','SKU157217-2',70,80,'2018-07-27 10:00:00'),('NOD0000002','SKU184460-1',30,28,'2018-07-27 10:00:00'),('NOD0000002','SKU186193-X',120,200,'2018-07-27 10:00:00'),('NOD0000002','SKU204759-4',200,170,'2018-07-27 10:00:00'),('NOD0000002','SKU205201-6',120,300,'2018-07-27 10:00:00'),('NOD0000002','SKU221909-3',35,0,'2018-07-27 10:00:00'),('NOD0000002','SKU224538-8',50,130,'2018-07-27 10:00:00'),('NOD0000002','SKU226800-0',34,50,'2018-07-27 10:00:00'),('NOD0000002','SKU228298-4',56,20,'2018-07-27 10:00:00'),('NOD0000002','SKU234330-4',15,0,'2018-07-27 10:00:00'),('NOD0000002','SKU243076-2',45,0,'2018-07-27 10:00:00'),('NOD0000002','SKU247198-1',100,200,'2018-07-27 10:00:00'),('NOD0000002','SKU254078-9',150,400,'2018-07-27 10:00:00'),('NOD0000002','SKU254274-9',95,130,'2018-07-27 10:00:00'),('NOD0000002','SKU260978-9',130,180,'2018-07-27 10:00:00'),('NOD0000002','SKU263525-9',240,400,'2018-07-27 10:00:00'),('NOD0000002','SKU264890-3',300,500,'2018-07-27 10:00:00'),('NOD0000002','SKU267241-3',210,210,'2018-07-27 10:00:00'),('NOD0000002','SKU8285-6',190,190,'2018-07-27 10:00:00');
/*!40000 ALTER TABLE `tb_kardex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_motivo_pedido`
--

DROP TABLE IF EXISTS `tb_motivo_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_motivo_pedido` (
  `cod_mot_ped` varchar(10) NOT NULL COMMENT 'Codigo de motivo de pedido.',
  `desc_mot_ped` varchar(100) NOT NULL COMMENT 'Descripcion de motivo de pedido.',
  `cat_mot_ped` varchar(4) NOT NULL COMMENT 'Categoria de motivo de pedido (NATE: No atendido, REPR: Reprogramacion, CANC: Cancelacion).',
  PRIMARY KEY (`cod_mot_ped`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del motivo de pedido.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_motivo_pedido`
--

LOCK TABLES `tb_motivo_pedido` WRITE;
/*!40000 ALTER TABLE `tb_motivo_pedido` DISABLE KEYS */;
INSERT INTO `tb_motivo_pedido` VALUES ('MPE0000001','Reprogramación a solicitud del cliente','REPR'),('MPE0000002','Incumplimiento de entrega','REPR'),('MPE0000003','Intercambio de productos defectuosos','REPR'),('MPE0000004','Cancelación a solicitud del cliente','CANC'),('MPE0000005','Incumplimiento de entrega','CANC'),('MPE0000006','Productos defectuosos','CANC'),('MPE0000007','Cliente no se encuentra en domicilio','NCUM');
/*!40000 ALTER TABLE `tb_motivo_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_movimiento_producto`
--

DROP TABLE IF EXISTS `tb_movimiento_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_movimiento_producto` (
  `fec_mov_prod` datetime NOT NULL COMMENT 'Fecha de movimiento de producto en formato dd/mm/yyyy hh24:mi:ss.',
  `cod_prv` varchar(10) DEFAULT NULL COMMENT 'Codigo de proveedor que abastece de productos a bodega.',
  `cod_bod_abast` varchar(10) DEFAULT NULL COMMENT 'Codigo de bodega que abastece de productos a nodos.',
  `cod_bod_recep` varchar(10) NOT NULL COMMENT 'Codigo de bodega o nodo que recibe los productos.',
  `cod_prod` varchar(10) NOT NULL COMMENT 'Codigo de producto.',
  `oper_mov_prod` varchar(3) NOT NULL COMMENT 'Operacion de movimiento de producto (+: adiciona producto, -: substrae producto, +/-: adiciona y substrae producto).',
  `cant_mov_prod` int(11) NOT NULL COMMENT 'Cantidad de movimiento de producto.',
  PRIMARY KEY (`fec_mov_prod`),
  KEY `fk_mov_comp_prod_prv_idx` (`cod_prv`),
  KEY `fk_mov_comp_prod_bod_idx` (`cod_bod_recep`),
  KEY `fk_mov_comp_prod_prod_idx` (`cod_prod`),
  KEY `fk_mov_prod_bod_abast_idx` (`cod_bod_abast`),
  CONSTRAINT `fk_mov_prod_bod_abast` FOREIGN KEY (`cod_bod_abast`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_mov_prod_bod_recep` FOREIGN KEY (`cod_bod_recep`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_mov_prod_prod` FOREIGN KEY (`cod_prod`) REFERENCES `tb_producto` (`cod_prod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_mov_prod_prv` FOREIGN KEY (`cod_prv`) REFERENCES `tb_proveedor` (`cod_prv`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena informacion del movimiento de productos.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_movimiento_producto`
--

LOCK TABLES `tb_movimiento_producto` WRITE;
/*!40000 ALTER TABLE `tb_movimiento_producto` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_movimiento_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_parametro`
--

DROP TABLE IF EXISTS `tb_parametro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_parametro` (
  `cod_param` int(11) NOT NULL COMMENT 'Codigo de parametro.',
  `nom_param` varchar(20) NOT NULL COMMENT 'Nombre de parametro.',
  `desc_param` varchar(100) NOT NULL COMMENT 'Descripcion de parametro.',
  `val_param` varchar(100) NOT NULL COMMENT 'Valor de parametro.',
  PRIMARY KEY (`cod_param`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de parametros de configuracion.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_parametro`
--

LOCK TABLES `tb_parametro` WRITE;
/*!40000 ALTER TABLE `tb_parametro` DISABLE KEYS */;
INSERT INTO `tb_parametro` VALUES (1,'HOR_EJEC_PROC','Hora de ejecucion de proceso batch','18:00'),(2,'HOR_SAL_UNID_BOD','Hora de salida de unidades de la bodega','08:00'),(3,'TIEMP_PROM_DESP','Tiempo promedio de despacho en minutos','30'),(4,'FACT_PES_CARG','Factor de peso de carga','0.80'),(5,'FACT_VOL_CARG','Factor de volumen de carga','0.80'),(6,'RUT_GEN_HOJ_RUT','Ruta de generación de hoja de ruta','D:/Sodimac/HojaRuta'),(7,'FACT_STOCK_MIN','Factor de stock mínimo de productos','0.20');
/*!40000 ALTER TABLE `tb_parametro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_pedido`
--

DROP TABLE IF EXISTS `tb_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pedido` (
  `cod_ped` varchar(10) NOT NULL COMMENT 'Codigo de pedido.',
  `cod_cli` varchar(10) DEFAULT NULL COMMENT 'Codigo de cliente.',
  `cod_tiend_desp` varchar(10) DEFAULT NULL COMMENT 'Codigo de tienda a despachar (aplicado para reposicion o retiro en tienda).',
  `fec_sol_ped` datetime NOT NULL COMMENT 'Fecha de solicitud del pedido en formato dd/mm/yyyy hh24:mi:ss.',
  `num_reserv_ped` int(11) DEFAULT NULL COMMENT 'Numero de reserva del pedido es el numero de operacion bancaria del pago realizado por el cliente.',
  `fec_vent_ped` datetime DEFAULT NULL COMMENT 'Fecha de venta del pedido en formato dd/mm/yyyy.',
  `num_verif_ped` int(11) NOT NULL COMMENT 'Numero de verificacion del pedido es usado para confirmar que el pedido se ha despachado en el domicilio del cliente o en la tienda.',
  `fec_desp_ped` date NOT NULL COMMENT 'Fecha de despacho del pedido a domicilio del cliente o tienda en formato dd/mm/yyyy.',
  `dir_desp_ped` varchar(100) NOT NULL COMMENT 'Dirección de despacho del pedido.',
  `cod_dist_desp_ped` varchar(10) NOT NULL COMMENT 'Codigo de distrito de despacho de pedido.',
  `fec_ret_tiend` date DEFAULT NULL COMMENT 'Fecha de retiro en tienda del pedido por parte del cliente en formato dd/mm/yyyy.',
  `fec_recoj_tiend` datetime DEFAULT NULL COMMENT 'Fecha de recojo en tienda del pedido por parte del cliente en formato dd/mm/yyyy hh24:mi:ss.',
  `fec_repro_ped` date DEFAULT NULL COMMENT 'Fecha de reprogramacion del pedido en formato dd/mm/yyyy.',
  `fec_canc_ped` datetime DEFAULT NULL COMMENT 'Fecha de cancelacion de pedido en formato dd/mm/yyyy hh24:mi:ss.',
  `fec_devo_ped` date DEFAULT NULL COMMENT 'Fecha de devolucion de productos del pedido a tienda o recogiendolo a domiclio del cliente en formato dd/mm/yyyy.',
  `cod_tiend_devo` varchar(10) DEFAULT NULL COMMENT 'Codigo de tienda donde el cliente devolvera los productos del pedido.',
  `cod_mot_ped` varchar(10) DEFAULT NULL COMMENT 'Codigo de motivo de pedido en caso de reprogramacion o cancelacion de pedido.',
  `cod_pick` varchar(10) DEFAULT NULL COMMENT 'Codigo de pickeador que prepara el pedido.',
  PRIMARY KEY (`cod_ped`),
  UNIQUE KEY `num_verif_ped_UNIQUE` (`num_verif_ped`),
  UNIQUE KEY `num_res_ped_UNIQUE` (`num_reserv_ped`),
  KEY `fk_ped_tiend_idx` (`cod_tiend_devo`),
  KEY `fk_ped_cli_idx` (`cod_cli`),
  KEY `fk_ped_mot_ped_idx` (`cod_mot_ped`),
  KEY `fk_ped_pick_idx` (`cod_pick`),
  KEY `fk_ped_tiend_desp_idx` (`cod_tiend_desp`),
  KEY `fk_ped_dist_idx` (`cod_dist_desp_ped`),
  CONSTRAINT `fk_ped_cli` FOREIGN KEY (`cod_cli`) REFERENCES `tb_cliente` (`cod_cli`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_dist` FOREIGN KEY (`cod_dist_desp_ped`) REFERENCES `tb_distrito` (`cod_dist`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_mot_ped` FOREIGN KEY (`cod_mot_ped`) REFERENCES `tb_motivo_pedido` (`cod_mot_ped`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_pick` FOREIGN KEY (`cod_pick`) REFERENCES `tb_pickeador` (`cod_pick`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_tiend_desp` FOREIGN KEY (`cod_tiend_desp`) REFERENCES `tb_tienda` (`cod_tiend`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_tiend_devo` FOREIGN KEY (`cod_tiend_devo`) REFERENCES `tb_tienda` (`cod_tiend`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del pedido.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_pedido`
--

LOCK TABLES `tb_pedido` WRITE;
/*!40000 ALTER TABLE `tb_pedido` DISABLE KEYS */;
INSERT INTO `tb_pedido` VALUES ('PED0000001','CLI0000001',NULL,'2018-08-01 12:48:41',88939,'2018-08-01 12:48:41',23475,'2018-08-06','Calle Sara Sara 157','DIST000035',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000002','CLI0000002',NULL,'2018-08-01 12:48:41',78385,'2018-08-01 12:48:41',84995,'2018-08-06','Av. Alameda del Corregidor 1590','DIST000013',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000003','CLI0000003',NULL,'2018-08-01 12:48:41',63628,'2018-08-01 12:48:41',97959,'2018-08-06','Calle Monte Bello 150','DIST000039',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000004','CLI0000004',NULL,'2018-08-01 12:48:41',86937,'2018-08-01 12:48:41',39958,'2018-08-06','Av. Javier Prado Este 6596','DIST000013',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000005','CLI0000005',NULL,'2018-08-01 12:48:41',19384,'2018-08-01 12:48:41',82849,'2018-08-06','Av. San Borja Nte. 886','DIST000029',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000006','CLI0000006',NULL,'2018-08-01 12:48:41',84758,'2018-08-01 12:48:41',96984,'2018-08-06','Av. Universitaria 1921','DIST000023',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000007','CLI0000007',NULL,'2018-08-01 12:48:41',92564,'2018-08-01 12:48:41',49948,'2018-08-06','Av. de la Marina 2500','DIST000035',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000008','CLI0000008',NULL,'2018-08-01 12:48:41',88367,'2018-08-01 12:48:41',69394,'2018-08-06','Calle Los Laureles 587','DIST000030',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000009','CLI0000009',NULL,'2018-08-01 12:48:41',99584,'2018-08-01 12:48:41',83885,'2018-08-06','Calle Francisco Masias 370','DIST000030',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000010','CLI0000010',NULL,'2018-08-01 12:48:41',54255,'2018-08-01 12:48:41',58594,'2018-08-06','Av. Alfredo Mendiola 5500','DIST000016',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000011','CLI0000011',NULL,'2018-08-01 12:48:41',44543,'2018-08-01 12:48:41',54343,'2018-08-06','Av. Javier Prado Este 2050','DIST000029',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000012','CLI0000012',NULL,'2018-08-01 12:48:41',45465,'2018-08-01 12:48:41',56544,'2018-08-06','Av. Gral. Salaverry 2255','DIST000030',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000013','CLI0000013',NULL,'2018-08-01 12:48:41',43344,'2018-08-01 12:48:41',46777,'2018-08-06','Av. de la Marina 2000','DIST000035',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000014','CLI0000014',NULL,'2018-08-01 12:48:41',67788,'2018-08-01 12:48:41',78865,'2018-08-06','Av. Nicolás de Ayllón 3012','DIST000036',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000015','CLI0000015',NULL,'2018-08-01 12:48:41',99899,'2018-08-01 12:48:41',99887,'2018-08-06','Av. Rep. de Venezuela 2379','DIST000046',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000016',NULL,'TIE0000001','2018-08-01 12:48:41',NULL,'2018-08-01 12:48:41',47738,'2018-08-06','Av. Industrial 3515 Urb. Auxiliar Panamericana Nte.','DIST000011','2018-08-07',NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000017',NULL,'TIE0000002','2018-08-01 12:48:41',NULL,'2018-08-01 12:48:41',95884,'2018-08-06','Av Tomás Marsano 961','DIST000040','2018-08-07',NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000018',NULL,'TIE0000003','2018-08-01 12:48:41',NULL,'2018-08-01 12:48:41',95995,'2018-08-06','Av. Circunvalación 1803','DIST000032',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000019',NULL,'TIE0000004','2018-08-01 12:48:41',NULL,'2018-08-01 12:48:41',78844,'2018-08-06','Av. Oscar R. Benavides 3866','DIST000046',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000020',NULL,'TIE0000005','2018-08-01 12:48:41',NULL,'2018-08-01 12:48:41',82516,'2018-08-06','Av. Javier Prado Este 4200','DIST000039',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000021','CLI0000018',NULL,'2018-08-01 12:48:41',77483,'2018-08-01 12:48:41',27362,'2018-08-02','Avenida Benavides 495','DIST000020',NULL,NULL,'2018-08-06',NULL,NULL,NULL,'MPE0000001',NULL),('PED0000022','CLI0000019',NULL,'2018-08-01 12:48:41',89473,'2018-08-01 12:48:41',32837,'2018-08-02','Av. Arequipa 4651','DIST000020',NULL,NULL,'2018-08-06',NULL,NULL,NULL,'MPE0000002',NULL),('PED0000023','CLI0000020',NULL,'2018-08-01 12:48:41',95838,'2018-08-01 12:48:41',58484,'2018-08-02','Jirón Junin 355','DIST000020',NULL,NULL,'2018-08-06',NULL,'2018-08-06',NULL,'MPE0000003',NULL),('PED0000024','CLI0000021',NULL,'2018-08-01 12:48:41',83847,'2018-08-01 12:48:41',22322,'2018-08-02','Av. Rafael Escardo 309','DIST000035',NULL,NULL,'2018-08-06',NULL,'2018-08-06',NULL,'MPE0000003',NULL),('PED0000025','CLI0000022',NULL,'2018-08-01 12:48:41',44533,'2018-08-01 12:48:41',56332,'2018-08-06','Av. Separadora Industrial 791','DIST000002',NULL,NULL,'2018-08-09',NULL,NULL,NULL,'MPE0000001',NULL),('PED0000026','CLI0000023',NULL,'2018-08-01 12:48:41',43434,'2018-08-01 12:48:41',44532,'2018-08-06','Av. Las Leyendas 580','DIST000035',NULL,NULL,'2018-08-09',NULL,NULL,NULL,'MPE0000001',NULL),('PED0000027','CLI0000024',NULL,'2018-08-01 12:48:41',55656,'2018-08-01 12:48:41',45453,'2018-08-06','Calle Las Begonias 577','DIST000030',NULL,NULL,NULL,'2018-08-03 12:48:41',NULL,NULL,'MPE0000004',NULL),('PED0000028','CLI0000025',NULL,'2018-08-01 12:48:41',34343,'2018-08-01 12:48:41',43222,'2018-08-06','Calle las Camelias 530','DIST000030',NULL,NULL,NULL,'2018-08-03 12:48:41',NULL,NULL,'MPE0000004',NULL),('PED0000029','CLI0000026',NULL,'2018-08-01 12:48:41',34322,'2018-08-01 12:48:41',34399,'2018-08-02','Av. Tupac Amaru 280','DIST000050',NULL,NULL,NULL,'2018-08-03 12:48:41','2018-08-06',NULL,'MPE0000004',NULL),('PED0000030','CLI0000027',NULL,'2018-08-01 12:48:41',58837,'2018-08-01 12:48:41',12213,'2018-08-02','Av. Riva Agüero 114','DIST000050',NULL,NULL,NULL,'2018-08-03 12:48:41','2018-08-06',NULL,'MPE0000004',NULL),('PED0000031','CLI0000028',NULL,'2018-08-01 12:48:41',78864,'2018-08-01 12:48:41',53324,'2018-08-02','Av. Nicolás de Ayllón 4706','DIST000050',NULL,NULL,NULL,'2018-08-03 12:48:41','2018-08-06',NULL,'MPE0000006',NULL),('PED0000032','CLI0000029',NULL,'2018-08-01 12:48:41',43323,'2018-08-01 12:48:41',35522,'2018-08-02','Manuel Ascencio Segura 268','DIST000015',NULL,NULL,NULL,'2018-08-03 12:48:41','2018-08-06',NULL,'MPE0000006',NULL),('PED0000033','CLI0000030',NULL,'2018-08-01 12:48:41',45345,'2018-08-01 12:48:41',66654,'2018-08-02','Av. Petit Thouars 1370','DIST000050',NULL,NULL,NULL,'2018-08-03 12:48:41','2018-08-06','TIE0000005','MPE0000004',NULL),('PED0000034','CLI0000031',NULL,'2018-08-01 12:48:41',56644,'2018-08-01 12:48:41',12311,'2018-08-02','Av. de la Marina 2500','DIST000035',NULL,NULL,NULL,'2018-08-03 12:48:41','2018-08-06','TIE0000004','MPE0000006',NULL),('PED0000035','CLI0000032',NULL,'2018-08-01 12:48:41',84783,'2018-08-01 12:48:41',85849,'2018-08-06','Ignacio Mariategui 105','DIST000003',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000036','CLI0000033',NULL,'2018-08-01 12:48:41',85949,'2018-08-01 12:48:41',96857,'2018-08-06','Av. Antonio José de Sucre 175','DIST000019',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000037','CLI0000034',NULL,'2018-08-01 12:48:41',83884,'2018-08-01 12:48:41',48839,'2018-08-06','Av. Universitaria 1921','DIST000023',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000038','CLI0000035',NULL,'2018-08-01 12:48:41',99578,'2018-08-01 12:48:41',49502,'2018-08-06','Av. Gral. Salaverry 2370','DIST000012',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),('PED0000039','CLI0000036',NULL,'2018-08-01 12:48:41',64657,'2018-08-01 12:48:41',32636,'2018-08-06','Av. Las Leyendas 580','DIST000035',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `tb_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_pickeador`
--

DROP TABLE IF EXISTS `tb_pickeador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_pickeador` (
  `cod_pick` varchar(10) NOT NULL COMMENT 'Codigo de pickeador.',
  `nom_pick` varchar(50) NOT NULL COMMENT 'Nombre de pickeador.',
  `ape_pick` varchar(50) NOT NULL COMMENT 'Apellido de pickeador.',
  `fec_nac_pick` date NOT NULL COMMENT 'Fecha de nacimiento de pickeador en formato dd/mm/yyyy.',
  `fec_ing_pick` date NOT NULL COMMENT 'Fecha de ingreso de pickeador en formato dd/mm/yyyy.',
  `cod_cuad` varchar(10) NOT NULL COMMENT 'Codigo de cuadrilla.',
  PRIMARY KEY (`cod_pick`),
  KEY `fk_pick_cuad_idx` (`cod_cuad`),
  CONSTRAINT `fk_pick_cuad` FOREIGN KEY (`cod_cuad`) REFERENCES `tb_cuadrilla` (`cod_cuad`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del pickeador.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_pickeador`
--

LOCK TABLES `tb_pickeador` WRITE;
/*!40000 ALTER TABLE `tb_pickeador` DISABLE KEYS */;
/*!40000 ALTER TABLE `tb_pickeador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_proceso`
--

DROP TABLE IF EXISTS `tb_proceso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_proceso` (
  `num_proc` int(11) NOT NULL COMMENT 'Numero de proceso.',
  `nom_proc` varchar(20) NOT NULL COMMENT 'Nombre del proceso (GEN_HOJ_RUT: Generacion de hoja de ruta, NOT_UNID_REQ: Notificacion de unidades requeridas, NOT_VENT_HOR: Notificacion de ventana horaria, GEN_PED: Generacion de pedidos, GEN_CUB_PED: Generacion de cubicacion de pedidos, NOT_ABA_PROD: Notificacion de abastecimiento de productos).',
  `fec_ini_ejec_proc` datetime NOT NULL COMMENT 'Fecha inicio de ejecucion de proceso en formato dd/mm/yyyy hh24:mi:ss.',
  `fec_fin_ejec_proc` datetime DEFAULT NULL COMMENT 'Fecha fin de ejecucion de proceso en formato dd/mm/yyyy hh24:mi:ss.',
  `est_proc` varchar(7) DEFAULT NULL COMMENT 'Estado del proceso (SUCCESS: Satisfactorio, ERROR: Error).',
  PRIMARY KEY (`num_proc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del proceso batch.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_proceso`
--

LOCK TABLES `tb_proceso` WRITE;
/*!40000 ALTER TABLE `tb_proceso` DISABLE KEYS */;
INSERT INTO `tb_proceso` VALUES (1,'GEN_HOJ_RUT','2018-08-05 12:49:06','2018-08-05 12:49:15','SUCCESS');
/*!40000 ALTER TABLE `tb_proceso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_producto`
--

DROP TABLE IF EXISTS `tb_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_producto` (
  `cod_prod` varchar(15) NOT NULL COMMENT 'Codigo de producto.',
  `nom_prod` varchar(150) NOT NULL COMMENT 'Nombre de producto.',
  `marc_prod` varchar(50) NOT NULL COMMENT 'Marca de producto.',
  `prec_unit_prod` decimal(9,2) NOT NULL COMMENT 'Precio unitario de producto en soles.',
  `vol_prod` decimal(12,6) NOT NULL COMMENT 'Volumen de producto en metros cubicos.',
  `pes_prod` decimal(12,2) NOT NULL COMMENT 'Peso de producto en kilos.',
  `cod_tip_prod` varchar(10) NOT NULL COMMENT 'Codigo de tipo de producto.',
  PRIMARY KEY (`cod_prod`),
  KEY `fk_prod_tip_prod_idx` (`cod_tip_prod`),
  CONSTRAINT `fk_prod_tip_prod` FOREIGN KEY (`cod_tip_prod`) REFERENCES `tb_tipo_producto` (`cod_tip_prod`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del producto.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_producto`
--

LOCK TABLES `tb_producto` WRITE;
/*!40000 ALTER TABLE `tb_producto` DISABLE KEYS */;
INSERT INTO `tb_producto` VALUES ('SKU123024-7','Rowa press 30','Rowa',4019.00,0.005000,6.00,'TPR0000024'),('SKU135154-0','Tractor LTH1842 18HP','Husqvarna',9999.90,0.150000,185.00,'TPR0000006'),('SKU157217-2','Tanque 25000 L','Rotoplas',22599.90,25.000000,400.00,'TPR0000015'),('SKU184460-1','Trompo Mezclador con Motor Kohler','Maker',4799.00,0.135000,225.00,'TPR0000009'),('SKU186193-X','Carretilla 5.5 Pies Cúbicos','Badacc',199.90,0.155700,20.00,'TPR0000009'),('SKU204759-4','Grupo Electrógeno Gasolina 7.2 KVA','Yamaha',6899.90,0.008500,94.00,'TPR0000011'),('SKU205201-6','Colchón Royal Prince Organic King','Paraíso',2109.00,0.010000,5.00,'TPR0000021'),('SKU221909-3','Cortador de Concreto 13 HP','Bosch',3499.90,0.057800,195.00,'TPR0000009'),('SKU224538-8','Horno microondas 20L OGKE2701','Oster',209.00,0.006500,4.00,'TPR0000018'),('SKU226800-0','Caja de Herramienta 2 en 1','Bauker',129.90,0.003500,2.00,'TPR0000007'),('SKU228298-4','Piedra Rumi 60.96x30x48cm 1.11m2','Gallos Mármol',212.12,0.012500,5.00,'TPR0000003'),('SKU234330-4','Vinera 12 botellas WZC12AEPWX','Whirlpool',299.00,0.015000,12.00,'TPR0000018'),('SKU243076-2','Puerta Granada Tornillo 85 cm','Dimfer',799.90,0.011000,25.00,'TPR0000002'),('SKU247198-1','Refrigeradora 600L RF28JBEDBSG','Samsung',6499.00,0.630000,173.00,'TPR0000018'),('SKU254078-9','Cocina a gas 5 quemadores PRO565','Bosch',2399.00,0.318000,50.00,'TPR0000018'),('SKU254274-9','Seccional Bellagio blanco','Producto Exclusivo',1699.90,0.034500,46.00,'TPR0000021'),('SKU260978-9','Dormitorio Daguvas 2 plazas','El Cisne',1699.00,0.015200,34.00,'TPR0000021'),('SKU263525-9','Refrigeradora Instaview 697LT NT GM87SXD','LG',6699.00,0.630000,163.00,'TPR0000018'),('SKU264890-3','Lavaseca F2011VRDS 20/11 Kg','LG',3899.00,0.518000,102.00,'TPR0000018'),('SKU267241-3','Televisor Smart LED Ultra HD 50\'\' UN50MU6103GXPE','Samsung',1599.00,0.004500,13.00,'TPR0000018'),('SKU8285-6','Techo de Polipropileno Tejaforte Rojo 1.15 x 0.76 m','Fibraforte',180.00,0.016500,3.00,'TPR0000001');
/*!40000 ALTER TABLE `tb_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_proveedor`
--

DROP TABLE IF EXISTS `tb_proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_proveedor` (
  `cod_prv` varchar(10) NOT NULL COMMENT 'Codigo de proveedor.',
  `raz_soc_prv` varchar(100) NOT NULL COMMENT 'Razon social del proveedor.',
  `num_ruc_prv` varchar(11) NOT NULL COMMENT 'Numero de RUC del proveedor.',
  `telf_prv` varchar(10) NOT NULL COMMENT 'Telefono del proveedor.',
  `email_prv` varchar(50) NOT NULL COMMENT 'Email del proveedor.',
  `tip_prv` varchar(4) NOT NULL COMMENT 'Tipo de Proveedor (UNID: Proveedor de unidades, MERC: Proveedor de mercaderia)',
  PRIMARY KEY (`cod_prv`),
  UNIQUE KEY `num_ruc_UNIQUE` (`num_ruc_prv`),
  UNIQUE KEY `raz_soc_prv_UNIQUE` (`raz_soc_prv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del proveedor.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_proveedor`
--

LOCK TABLES `tb_proveedor` WRITE;
/*!40000 ALTER TABLE `tb_proveedor` DISABLE KEYS */;
INSERT INTO `tb_proveedor` VALUES ('PRV0000001','Transportes Parinas S.A.C.','10406048417','3375519','transparina@gmail.com','UNID'),('PRV0000002','A y D Transportes','10337099223','4642514','aydtransporte@gmail.com','UNID'),('PRV0000003','Transporte Wili Puerta','10294433112','3613388','wilipuerta@gmail.com','UNID'),('PRV0000004','Mabe','10293849388','4383949','mabe@gmail.com','MERC'),('PRV0000005','LG','10939948299','4837849','lg@gmail.com','MERC'),('PRV0000006','Samsung','10939984822','5848389','samsung@gmail.com','MERC');
/*!40000 ALTER TABLE `tb_proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_provincia`
--

DROP TABLE IF EXISTS `tb_provincia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_provincia` (
  `cod_prov` varchar(10) NOT NULL COMMENT 'Codigo de proveedor.',
  `nom_prov` varchar(100) NOT NULL COMMENT 'Nombre de proveedor.',
  `cod_dep` varchar(10) NOT NULL COMMENT 'Codigo de departamento.',
  PRIMARY KEY (`cod_prov`),
  KEY `fk_prov_dep_idx` (`cod_dep`),
  CONSTRAINT `fk_prov_dep` FOREIGN KEY (`cod_dep`) REFERENCES `tb_departamento` (`cod_dep`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la provincia.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_provincia`
--

LOCK TABLES `tb_provincia` WRITE;
/*!40000 ALTER TABLE `tb_provincia` DISABLE KEYS */;
INSERT INTO `tb_provincia` VALUES ('PROV000001','Lima','DEP0000001');
/*!40000 ALTER TABLE `tb_provincia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_tienda`
--

DROP TABLE IF EXISTS `tb_tienda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_tienda` (
  `cod_tiend` varchar(10) NOT NULL COMMENT 'Codigo de la tienda.',
  `nom_tiend` varchar(80) NOT NULL COMMENT 'nombre de la tienda.',
  `dir_tiend` varchar(100) NOT NULL COMMENT 'Direccion de la tienda.',
  `cod_contr_tienda` varchar(45) NOT NULL COMMENT 'Codigo de controller de tienda.',
  `cod_dist` varchar(10) NOT NULL COMMENT 'Codigo de distrito.',
  PRIMARY KEY (`cod_tiend`),
  UNIQUE KEY `nom_tiend_UNIQUE` (`nom_tiend`),
  KEY `fk_tiend_dis_idx` (`cod_dist`),
  KEY `fk_tiend_contr_tiend_idx` (`cod_contr_tienda`),
  CONSTRAINT `fk_tiend_contr_tiend` FOREIGN KEY (`cod_contr_tienda`) REFERENCES `tb_controller_tienda` (`cod_contr_tiend`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tiend_dist` FOREIGN KEY (`cod_dist`) REFERENCES `tb_distrito` (`cod_dist`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la tienda.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_tienda`
--

LOCK TABLES `tb_tienda` WRITE;
/*!40000 ALTER TABLE `tb_tienda` DISABLE KEYS */;
INSERT INTO `tb_tienda` VALUES ('TIE0000001','Tienda Mega Plaza','Av. Industrial 3515 Urb. Auxiliar Panamericana Nte.','CTI0000001','DIST000011'),('TIE0000002','Tienda Angamos','Av Tomás Marsano 961','CTI0000002','DIST000040'),('TIE0000003','Tienda Atocongo','Av. Circunvalación 1803','CTI0000003','DIST000032'),('TIE0000004','Tienda Bellavista','Av. Oscar R. Benavides 3866','CTI0000004','DIST000046'),('TIE0000005','Tienda Jockey Plaza','Av. Javier Prado Este 4200','CTI0000005','DIST000039');
/*!40000 ALTER TABLE `tb_tienda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_tipo_producto`
--

DROP TABLE IF EXISTS `tb_tipo_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_tipo_producto` (
  `cod_tip_prod` varchar(10) NOT NULL COMMENT 'Codigo de tipo de producto.',
  `nom_tip_prod` varchar(50) NOT NULL COMMENT 'Nombre de tipo de producto.',
  `cod_fam_prod` varchar(10) NOT NULL COMMENT 'Codigo de familia de producto.',
  PRIMARY KEY (`cod_tip_prod`),
  UNIQUE KEY `nom_tip_prod_UNIQUE` (`nom_tip_prod`),
  KEY `fk_tip_prod_fam_prod_idx` (`cod_fam_prod`),
  CONSTRAINT `fk_tip_prod_fam_prod` FOREIGN KEY (`cod_fam_prod`) REFERENCES `tb_familia_producto` (`cod_fam_prod`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de tipo de producto.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_tipo_producto`
--

LOCK TABLES `tb_tipo_producto` WRITE;
/*!40000 ALTER TABLE `tb_tipo_producto` DISABLE KEYS */;
INSERT INTO `tb_tipo_producto` VALUES ('TPR0000001','Materiales de Construcción','FPR0000001'),('TPR0000002','Puertas, Ventanas y Cerraduras','FPR0000001'),('TPR0000003','Pisos y Acabados','FPR0000001'),('TPR0000004','Pinturas','FPR0000001'),('TPR0000005','Fijaciones y Adhesivos','FPR0000001'),('TPR0000006','Herramientas Eléctricas','FPR0000002'),('TPR0000007','Herramientas Manuales','FPR0000002'),('TPR0000008','Herramientas Mecánicas','FPR0000002'),('TPR0000009','Herramientas para Construcción','FPR0000002'),('TPR0000010','Herramientas por Especialidad','FPR0000002'),('TPR0000011','Grupo Electrógeno','FPR0000002'),('TPR0000012','Soldaduras y Complementos','FPR0000002'),('TPR0000013','Electricidad','FPR0000003'),('TPR0000014','Iluminación','FPR0000003'),('TPR0000015','Gasfitería','FPR0000003'),('TPR0000016','Baño','FPR0000004'),('TPR0000017','Cocina','FPR0000004'),('TPR0000018','Electrohogar','FPR0000004'),('TPR0000019','Calefacción','FPR0000005'),('TPR0000020','Ventilación','FPR0000005'),('TPR0000021','Muebles','FPR0000006'),('TPR0000022','Decoración','FPR0000006'),('TPR0000023','Menaje','FPR0000006'),('TPR0000024','Mundo Infantil','FPR0000006'),('TPR0000025','Mundo Bebé','FPR0000006'),('TPR0000026','Organizadores','FPR0000007'),('TPR0000027','Mudanza','FPR0000007'),('TPR0000028','Limpieza','FPR0000007'),('TPR0000029','Tecnología','FPR0000008'),('TPR0000030','Seguridad','FPR0000008'),('TPR0000031','Accesorios de Exterior para Autos','FPR0000009'),('TPR0000032','Accesorios de Interior para Autos','FPR0000009'),('TPR0000033','Aceites, Agua y Lubricantes para Autos','FPR0000009'),('TPR0000034','Amarres, Eslingas y Pulpos','FPR0000009'),('TPR0000035','Audio y Video para Autos','FPR0000009'),('TPR0000036','Batería para Autos y Accesorios','FPR0000009'),('TPR0000037','Herramientas y Equipos para Taller Mecánico','FPR0000009'),('TPR0000038','Terrazas','FPR0000010'),('TPR0000039','Jardín','FPR0000010'),('TPR0000040','Parrillas','FPR0000010'),('TPR0000041','Climatización Exterior','FPR0000010'),('TPR0000042','Iluminación Exterior','FPR0000010'),('TPR0000043','Camping y Deportes','FPR0000010'),('TPR0000044','Juegos y Recreación','FPR0000010'),('TPR0000045','Alimentos y Accesorios para Mascotas','FPR0000010'),('TPR0000046','Piscinas e Inflables','FPR0000010');
/*!40000 ALTER TABLE `tb_tipo_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_tipo_unidad`
--

DROP TABLE IF EXISTS `tb_tipo_unidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_tipo_unidad` (
  `cod_tip_unid` varchar(10) NOT NULL COMMENT 'Codigo de tipo de unidad.',
  `nom_tip_unid` varchar(80) NOT NULL COMMENT 'Nombre de tipo de unidad.',
  `pes_max_carg` decimal(12,2) NOT NULL COMMENT 'Peso maximo de carga en kilos.',
  `vol_max_carg` decimal(12,2) NOT NULL COMMENT 'Peso maximo de carga en metros cubicos.',
  PRIMARY KEY (`cod_tip_unid`),
  UNIQUE KEY `nom_tip_unid_UNIQUE` (`nom_tip_unid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del tipo de unidad.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_tipo_unidad`
--

LOCK TABLES `tb_tipo_unidad` WRITE;
/*!40000 ALTER TABLE `tb_tipo_unidad` DISABLE KEYS */;
INSERT INTO `tb_tipo_unidad` VALUES ('TUN0000001','Camioneta Luv',1000.00,5.00),('TUN0000002','Miniturbo',2000.00,12.00),('TUN0000003','Turbo',4500.00,18.00),('TUN0000004','Sencillo',8000.00,32.00);
/*!40000 ALTER TABLE `tb_tipo_unidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_unidad`
--

DROP TABLE IF EXISTS `tb_unidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_unidad` (
  `num_plac_unid` varchar(10) NOT NULL COMMENT 'Numero de placa de la unidad.',
  `mod_unid` varchar(50) NOT NULL COMMENT 'Modelo de la unidad.',
  `marc_unid` varchar(50) NOT NULL COMMENT 'Marca de la unidad.',
  `num_soat_unid` varchar(15) NOT NULL COMMENT 'Numero SOAT de la unidad.',
  `flag_activ_unid` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Flag de activacion de unidad.',
  `cod_tip_unid` varchar(10) NOT NULL COMMENT 'Codigo de tipo de unidad.',
  `cod_prv` varchar(10) NOT NULL COMMENT 'Codigo de proveedor.',
  PRIMARY KEY (`num_plac_unid`),
  KEY `fk_unid_prv_idx` (`cod_prv`),
  KEY `fk_unid_tip_unid_idx` (`cod_tip_unid`),
  CONSTRAINT `fk_unid_prv` FOREIGN KEY (`cod_prv`) REFERENCES `tb_proveedor` (`cod_prv`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_unid_tip_unid` FOREIGN KEY (`cod_tip_unid`) REFERENCES `tb_tipo_unidad` (`cod_tip_unid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la unidad.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_unidad`
--

LOCK TABLES `tb_unidad` WRITE;
/*!40000 ALTER TABLE `tb_unidad` DISABLE KEYS */;
INSERT INTO `tb_unidad` VALUES ('A3N-877','Axor 1933 S 36','Mercedes','02-21589920-4',1,'TUN0000001','PRV0000002'),('A3W-886','Ford Cargo 920','Ford','05-22443311-4',1,'TUN0000004','PRV0000001'),('A4S-923','Volkswagen 15270 Q','Volkswagen','04-76121122-6',1,'TUN0000003','PRV0000001'),('A5F-746','Volvo VM20','Volvo','13-72335591-3',1,'TUN0000001','PRV0000001'),('A7V-510','Scania G 420','Scania','01-01563361-8',1,'TUN0000004','PRV0000002'),('EFH-147','Volkswagen 13170 E','Volkswagen','09-02205309-2',1,'TUN0000004','PRV0000002'),('RIH-166','Volvo VM17','Volvo','05-31221477-9',1,'TUN0000004','PRV0000002'),('W1X-547','Ford Cargo 916','Ford','03-71234499-9',1,'TUN0000004','PRV0000002');
/*!40000 ALTER TABLE `tb_unidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_unidad_chofer`
--

DROP TABLE IF EXISTS `tb_unidad_chofer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_unidad_chofer` (
  `cod_unid_chof` varchar(10) NOT NULL,
  `cod_bod` varchar(10) NOT NULL COMMENT 'Codigo de bodega.',
  `num_placa_unid` varchar(10) NOT NULL COMMENT 'Numero de placa de la unidad.',
  `num_brev_chof` varchar(10) NOT NULL COMMENT 'Numero de brevete del chofer.',
  `fec_asig_unid_chof` datetime NOT NULL COMMENT 'Fecha de asignacion de unidad con chofer en formato dd/mm/yyyy hh24:mi:ss.',
  PRIMARY KEY (`cod_unid_chof`),
  KEY `fk_unid_chof_unid_idx` (`num_placa_unid`),
  KEY `fk_unid_chof_chof_idx` (`num_brev_chof`),
  KEY `fk_unid_chof_bod_idx` (`cod_bod`),
  CONSTRAINT `fk_unid_chof_bod` FOREIGN KEY (`cod_bod`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_unid_chof_chof` FOREIGN KEY (`num_brev_chof`) REFERENCES `tb_chofer` (`num_brev_chof`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_unid_chof_unid` FOREIGN KEY (`num_placa_unid`) REFERENCES `tb_unidad` (`num_plac_unid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de asignacion de unidad co';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_unidad_chofer`
--

LOCK TABLES `tb_unidad_chofer` WRITE;
/*!40000 ALTER TABLE `tb_unidad_chofer` DISABLE KEYS */;
INSERT INTO `tb_unidad_chofer` VALUES ('UCH0000001','BOD0000001','A3N-877','Q30221825','2018-06-01 10:20:30'),('UCH0000002','BOD0000001','A7V-510','Q40723053','2018-06-01 10:20:30'),('UCH0000003','BOD0000001','EFH-147','Q55121522','2018-06-01 10:20:30'),('UCH0000004','BOD0000001','RIH-166','Q71436309','2018-06-01 10:20:30'),('UCH0000005','BOD0000001','W1X-547','Q99221165','2018-06-01 10:20:30'),('UCH0000006','BOD0000001','A3W-886','Q22390922','2018-06-01 10:20:30'),('UCH0000007','BOD0000001','A4S-923','Q33401077','2018-06-01 10:20:30'),('UCH0000008','NOD0000002','A5F-746','Q76281109','2018-06-01 10:20:30');
/*!40000 ALTER TABLE `tb_unidad_chofer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_ventana_horaria`
--

DROP TABLE IF EXISTS `tb_ventana_horaria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_ventana_horaria` (
  `cod_vent_hor` varchar(10) NOT NULL COMMENT 'Codigo de ventana horaria.',
  `hor_ini_vent_hor` varchar(5) NOT NULL COMMENT 'Hora inicio de ventana horaria en formato hh24:mi.',
  `hor_fin_vent_hor` varchar(5) NOT NULL COMMENT 'Hora fin de ventana horaria en formato hh24:mi.',
  `tip_vent_hor` varchar(4) NOT NULL COMMENT 'Tipo de ventana horaria. (LOC: Local, PROV: Provinicial).',
  `flag_activ_vent_hor` tinyint(4) NOT NULL COMMENT 'Flag de activacion de ventana horaria.',
  PRIMARY KEY (`cod_vent_hor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena informacion de la ventana horaria.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_ventana_horaria`
--

LOCK TABLES `tb_ventana_horaria` WRITE;
/*!40000 ALTER TABLE `tb_ventana_horaria` DISABLE KEYS */;
INSERT INTO `tb_ventana_horaria` VALUES ('VHL0000001','08:00','12:00','LOC',1),('VHL0000002','13:00','17:00','LOC',1),('VHL0000003','17:00','21:00','LOC',1);
/*!40000 ALTER TABLE `tb_ventana_horaria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_zona`
--

DROP TABLE IF EXISTS `tb_zona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_zona` (
  `cod_zon` varchar(10) NOT NULL COMMENT 'Codigo de zona.',
  `nom_zon` varchar(80) NOT NULL COMMENT 'Nombre de zona.',
  PRIMARY KEY (`cod_zon`),
  UNIQUE KEY `nom_zon_cob_UNIQUE` (`nom_zon`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de las zonas.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_zona`
--

LOCK TABLES `tb_zona` WRITE;
/*!40000 ALTER TABLE `tb_zona` DISABLE KEYS */;
INSERT INTO `tb_zona` VALUES ('ZON0000006','Callao'),('ZON0000003','Lima Centro'),('ZON0000002','Lima Este'),('ZON0000004','Lima Moderna'),('ZON0000001','Lima Norte'),('ZON0000005','Lima Sur');
/*!40000 ALTER TABLE `tb_zona` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'bd_gesateped'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_eliminar_rutas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_eliminar_rutas`(
	pi_fecha_despacho DATE
)
BEGIN
	drop table  if exists rutas_ids;
	create table rutas_ids
	select cod_hoj_rut from tb_hoja_ruta where fec_desp_hoj_rut = pi_fecha_despacho;
    
    delete from tb_detalle_hoja_ruta where cod_hoj_rut in (select * from rutas_ids);
    
    delete from tb_hoja_ruta where cod_hoj_rut in (select * from rutas_ids);
    
	drop table rutas_ids;
    commit;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_bodegas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_bodegas`()
BEGIN
  SELECT bo.cod_bod,
		 bo.nom_bod
  FROM bd_gesateped.tb_bodega bo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_desp_ped_bod` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_desp_ped_bod`(
	IN pi_cod_bod VARCHAR(10),
	OUT po_msg_cod INT,
	OUT po_msg_desc VARCHAR(50))
proc_label:BEGIN
  DECLARE v_tot_ped INT;
  DECLARE v_num_dec INT DEFAULT 4;

  SET po_msg_cod := 0;
  SET po_msg_desc := 'Proceso satisfactorio';

  SELECT COUNT(dhr.cod_ped)
  INTO v_tot_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE();
  
  IF v_tot_ped = 0 THEN
    SET po_msg_cod := -1;
    SET po_msg_desc := 'No hay pedidos asignados a la hoja de ruta';
    LEAVE proc_label;
  END IF;

  SELECT 'Pendientes' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND ((ped.fec_desp_ped = CURDATE() AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL) OR
         (ped.fec_repro_ped = CURDATE() AND ped.fec_canc_ped IS NULL) OR
         (ped.fec_canc_ped IS NOT NULL AND ped.fec_devo_ped = CURDATE() AND ped.cod_tiend_devo IS NULL))
  UNION
  SELECT 'Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND dhr.fec_pact_desp IS NOT NULL
  UNION
  SELECT 'No Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND dhr.fec_no_cump_desp IS NOT NULL
  UNION
  SELECT 'Reprogramados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND ped.fec_repro_ped > CURDATE()
  UNION
  SELECT 'Cancelados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND DATE(ped.fec_canc_ped) = CURDATE();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_desp_ped_unid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_desp_ped_unid`(
  IN pi_cod_hoj_rut VARCHAR(10),
  OUT po_msg_cod INT,
  OUT po_msg_desc VARCHAR(50))
proc_label:BEGIN
  DECLARE v_tot_ped INT;
  DECLARE v_num_dec INT DEFAULT 4;

  SET po_msg_cod := 0;
  SET po_msg_desc := 'Proceso satisfactorio';

  SELECT COUNT(dhr.cod_ped)
  INTO v_tot_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut;
  
  IF v_tot_ped = 0 THEN
    SET po_msg_cod := -1;
    SET po_msg_desc := 'No hay pedidos asignados a la hoja de ruta';
    LEAVE proc_label;
  END IF;

  SELECT 'Pendientes' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND ((ped.fec_desp_ped = CURDATE() AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL) OR
         (ped.fec_repro_ped = CURDATE() AND ped.fec_canc_ped IS NULL) OR
         (ped.fec_canc_ped IS NOT NULL AND ped.fec_devo_ped = CURDATE() AND ped.cod_tiend_devo IS NULL))
  UNION
  SELECT 'Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_pact_desp IS NOT NULL
  UNION
  SELECT 'No Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_no_cump_desp IS NOT NULL
  UNION
  SELECT 'Reprogramados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND ped.fec_repro_ped > CURDATE()
  UNION
  SELECT 'Cancelados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND DATE(ped.fec_canc_ped) = CURDATE();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_desp_ped_unid_detail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_desp_ped_unid_detail`(
  IN pi_cod_hoj_rut VARCHAR(10),
  IN pi_est_ped VARCHAR(4))
BEGIN
  IF pi_est_ped = 'PEND' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.nom_tiend,
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (dhr.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NULL
      AND dhr.fec_no_cump_desp IS NULL
      AND ((ped.fec_desp_ped = CURDATE() AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL) OR
           (ped.fec_repro_ped = CURDATE() AND ped.fec_canc_ped IS NULL) OR
           (ped.fec_canc_ped IS NOT NULL AND ped.fec_devo_ped = CURDATE() AND ped.cod_tiend_devo IS NULL))
	ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'ATEN' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.nom_tiend,
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (dhr.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NOT NULL
    ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'NATE' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
		   tie.nom_tiend,           
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (dhr.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_no_cump_desp IS NOT NULL
    ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'REPR' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.nom_tiend,           
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND ped.fec_repro_ped > CURDATE();

  ELSEIF pi_est_ped = 'CANC' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.nom_tiend,           
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND DATE(ped.fec_canc_ped) = CURDATE();
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_unidades` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_unidades`(IN pi_cod_bod VARCHAR(10))
BEGIN
  SELECT hr.cod_hoj_rut,
         un.num_plac_unid,
		 ch.nom_chof,
         ch.ape_chof,
         ch.telf_chof,
         (SELECT COUNT(dhr.cod_ped)
	      FROM bd_gesateped.tb_detalle_hoja_ruta dhr
          INNER JOIN bd_gesateped.tb_pedido ped
            ON (dhr.cod_ped = ped.cod_ped)
		  WHERE dhr.cod_hoj_rut = hr.cod_hoj_rut
            AND dhr.fec_pact_desp IS NOT NULL) AS tot_ped_aten_unid,
		 (SELECT COUNT(dhr.cod_ped)
          FROM bd_gesateped.tb_detalle_hoja_ruta dhr
          WHERE dhr.cod_hoj_rut = hr.cod_hoj_rut) AS tot_ped_unid
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_unidad_chofer uc
    ON (hr.cod_unid_chof = uc.cod_unid_chof)
  INNER JOIN bd_gesateped.tb_unidad un
	ON (uc.num_placa_unid = un.num_plac_unid)
  INNER JOIN bd_gesateped.tb_chofer ch
    ON (uc.num_brev_chof = ch.num_brev_chof)
  WHERE hr.cod_bod = pi_cod_bod
    AND un.flag_activ_unid = 1
    AND ch.flag_activ_chof = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_bodega` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_bodega`(
	IN _codigo_bodega VARCHAR(10)
)
BEGIN
	select 
		bodega.cod_bod,
        bodega.nom_bod,
        bodega.dir_bod,
        distrito.cod_dist,
        distrito.nom_dist
        
	from tb_bodega bodega
    inner join tb_distrito distrito on bodega.cod_dist = distrito.cod_dist
    where bodega.cod_bod = _codigo_bodega;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_detalle_ruta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_detalle_ruta`(
	IN _cod_hoj_rut varchar(10)
)
BEGIN
	select pedido.cod_ped,
	pedido.cod_tiend_desp,
    pedido.fec_ret_tiend,
    detalle.ord_desp_ped,
    detalle.cod_hoj_rut,
    concat(pedido.dir_desp_ped," ",distrito.nom_dist) as domicilio,
    cliente.cod_cli,
	cliente.nom_cli, 
    cliente.ape_cli,
    cliente.dir_cli,
    distritoCliente.nom_dist as dist_cli,
    tiendaDespacho.cod_tiend as tiendaDespachoCod,
    tiendaDespacho.nom_tiend as tiendaDespachoNom,
    tiendaDespacho.dir_tiend as tiendaDespachoDir,
    distritoTiendaDespacho.nom_dist as tiendaDespachoDistNom,
 
	tiendaDevolucion.cod_tiend as tiendaDevolucionCod,
    tiendaDevolucion.nom_tiend as tiendaDevolucionNom,
    tiendaDevolucion.dir_tiend as tiendaDevolucionDir,
    distritoTiendaDevolucion.nom_dist as tiendaDevolucionDistNom,
 
    
    ventana.hor_ini_vent_hor,
    ventana.hor_fin_vent_hor
	from tb_detalle_hoja_ruta detalle 
	inner join tb_pedido pedido on pedido.cod_ped = detalle.cod_ped and detalle.cod_hoj_rut = _cod_hoj_rut
	left join tb_cliente cliente on pedido.cod_cli = cliente.cod_cli
	left join tb_distrito distritoCliente on cliente.cod_dist = distritoCliente.cod_dist
    inner join tb_ventana_horaria ventana on ventana.cod_vent_hor = detalle.cod_vent_hor
    left join tb_tienda tiendaDespacho on tiendaDespacho.cod_tiend = pedido.cod_tiend_desp
    left join tb_distrito distritoTiendaDespacho on distritoTiendaDespacho.cod_dist = tiendaDespacho.cod_dist
    left join tb_tienda tiendaDevolucion on tiendaDevolucion.cod_tiend = pedido.cod_tiend_devo
    left join tb_distrito distritoTiendaDevolucion on distritoTiendaDevolucion.cod_dist = tiendaDevolucion.cod_dist
    inner join tb_distrito distrito on distrito.cod_dist = pedido.cod_dist_desp_ped
    inner join tb_provincia provincia on provincia.cod_prov = distrito.cod_prov
    order by detalle.ord_desp_ped asc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_parametros` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_parametros`()
BEGIN
	select 
		cod_param,
		nom_param,
        desc_param,
        val_param
    from tb_parametro;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_pedidos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_pedidos`(
	_fecha_despacho DATE
)
BEGIN	 
    select ped.cod_ped,
		ped.cod_cli,
		ped.cod_tiend_desp,
		ped.cod_tiend_devo,
		ped.fec_ret_tiend,
        ped.fec_desp_ped,
        ped.fec_repro_ped,
        ped.fec_canc_ped,
        ped.fec_devo_ped,
        
        concat(ped.dir_desp_ped," ",distrito.nom_dist) as domicilio,
        
		det.cod_bod,
		det.cant_prod,
		pro.cod_prod,
		pro.vol_prod,
		pro.pes_prod, 
		tieDespacho.dir_tiend as tieDespacho,
        tieDespacho.nom_dist as tieDespachoDist,
        tieDevol.dir_tiend as tieDevol,
        tieDevol.nom_dist as tieDevolDist,
        ped.cod_cli as cliente,
        cliente.nom_cli as clienteNombres,
        cliente.ape_cli as clienteApellidos,
        cliente.dir_cli as clienteDireccion,
        cliente.nom_dist as clienteDireccionDist
	from tb_pedido ped
	left join (
		select cod_tiend,nom_tiend,dir_tiend,dist.cod_dist,dist.nom_dist 
        from tb_tienda 
        inner join tb_distrito dist on dist.cod_dist = tb_tienda.cod_dist) 
		as tieDespacho on tieDespacho.cod_tiend=ped.cod_tiend_desp
	left join (
		select cod_tiend,nom_tiend,dir_tiend,dist.cod_dist,dist.nom_dist 
        from tb_tienda 
        inner join tb_distrito dist on dist.cod_dist = tb_tienda.cod_dist) 
        as tieDevol on tieDevol.cod_tiend=ped.cod_tiend_devo
	left join (
		select cli.cod_cli,cli.nom_cli,cli.ape_cli,cli.num_dni_cli,cli.telf_cli,cli.dir_cli,dist.cod_dist,dist.nom_dist 
        from tb_cliente cli 
        inner join tb_distrito dist on dist.cod_dist = cli.cod_dist  ) 
        as cliente on cliente.cod_cli = ped.cod_cli
	inner join tb_detalle_pedido det on det.cod_ped = ped.cod_ped 
    inner join tb_producto pro on pro.cod_prod = det.cod_prod 
    inner join tb_distrito distrito on ped.cod_dist_desp_ped = distrito.cod_dist
    inner join tb_provincia provincia on provincia.cod_prov = distrito.cod_prov
    where 
		(ped.fec_desp_ped = _fecha_despacho AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL)
		OR (ped.fec_repro_ped = _fecha_despacho AND ped.fec_canc_ped IS NULL)
		OR (ped.fec_repro_ped IS NULL AND ped.fec_devo_ped = _fecha_despacho AND ped.cod_tiend_devo IS NULL)
    order by ped.cod_ped;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_rutas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_rutas`(
	_fecha_despacho DATE
)
BEGIN
	select hoj_rut.cod_hoj_rut,
    hoj_rut.fec_desp_hoj_rut,
    hoj_rut.fec_gen_hoj_rut,
    bodega.cod_bod,
    bodega.nom_bod,
	chofer.nom_chof,
    chofer.ape_chof,
    chofer.num_brev_chof,
    unidad.num_plac_unid,
    unidad.num_soat_unid,
    tipo_unidad.pes_max_carg,
    tipo_unidad.vol_max_carg
    
	from tb_hoja_ruta hoj_rut 
	inner join tb_unidad_chofer unid_chof on unid_chof.cod_unid_chof = hoj_rut.cod_unid_chof
	inner join tb_unidad unidad on unidad.num_plac_unid = unid_chof.num_placa_unid
	inner join tb_chofer chofer on chofer.num_brev_chof = unid_chof.num_brev_chof
	inner join tb_tipo_unidad tipo_unidad on tipo_unidad.cod_tip_unid = unidad.cod_tip_unid
    inner join tb_bodega bodega on hoj_rut.cod_bod = bodega.cod_bod
    
    where hoj_rut.fec_desp_hoj_rut = _fecha_despacho;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_unidades` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_unidades`()
BEGIN
	select *
	from tb_unidad_chofer unidad_chofer
	inner join (
			select num_placa_unid, MAX(fec_asig_unid_chof) as lastcreated
			from tb_unidad_chofer
			group by num_placa_unid
		) maxc 
		on maxc.num_placa_unid = unidad_chofer.num_placa_unid
		and maxc.lastcreated = unidad_chofer.fec_asig_unid_chof
	inner join tb_unidad unidad on unidad_chofer.num_placa_unid = unidad.num_plac_unid
	inner join tb_tipo_unidad tipo on unidad.cod_tip_unid = tipo.cod_tip_unid
	inner join tb_chofer chofer on unidad_chofer.num_brev_chof = chofer.num_brev_chof;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_unidades_bodega` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_unidades_bodega`(
	IN pi_cod_bod VARCHAR(10)
)
BEGIN
	select 
		unidad.num_plac_unid as placa_unidad,
        unidad.num_soat_unid as soat_unidad,
        chofer.num_brev_chof as brevete_chofer,
        CONCAT(chofer.nom_chof," ",chofer.ape_chof) as nombre_chofer,
        tipo.pes_max_carg as peso_maximo_carga,
        tipo.vol_max_carg as volumen_maximo_carga,
        unidad_chofer.cod_unid_chof as codigo_unidad_chofer
    
    from tb_unidad_chofer unidad_chofer
    inner join tb_unidad unidad on unidad_chofer.num_placa_unid = unidad.num_plac_unid
    inner join tb_tipo_unidad tipo on tipo.cod_tip_unid = unidad.cod_tip_unid
    inner join tb_chofer chofer on unidad_chofer.num_brev_chof = chofer.num_brev_chof
    where unidad_chofer.cod_bod = pi_cod_bod
    order by peso_maximo_carga DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_ventanas_horarias` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_ventanas_horarias`()
BEGIN
	select cod_vent_hor,
		hor_ini_vent_hor,
        hor_fin_vent_hor,
        tip_vent_hor
	from tb_ventana_horaria
    where flag_activ_vent_hor = 1
    order by cod_vent_hor asc;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_fin_actividad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_fin_actividad`(
	IN _NUM_ACTIV INT(11),
    IN _ERR_TEC_ACTIV VARCHAR(250),
    IN _EST_ACTIV VARCHAR(7)
)
BEGIN

	UPDATE tb_actividad 
    SET
		fec_fin_ejec_activ = NOW(),
        err_tec_activ = _ERR_TEC_ACTIV,
        est_activ = _EST_ACTIV
	WHERE
		num_activ = _NUM_ACTIV;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_fin_proceso` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_fin_proceso`(
	IN _NUM_PROC INT(11),
    IN _EST_PROC VARCHAR(7)
)
BEGIN
	UPDATE tb_proceso 
    SET 
		fec_fin_ejec_proc = NOW(),
        est_proc = _EST_PROC
	WHERE
		num_proc = _NUM_PROC
	;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_hoja_ruta` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_hoja_ruta`(
	IN _fec_desp_hoj_rut date,
    IN _cod_unid_chof varchar(10),
    IN _cod_bod varchar(10),
    OUT GENERATED_HR_KEY VARCHAR(10)
)
BEGIN
	DECLARE cantidad INT;
	select count(cod_hoj_rut)+1 from tb_hoja_ruta into cantidad;
   
    
    
    SET GENERATED_HR_KEY = CONCAT("HRU",LPAD(cantidad, 7, '0'));
	INSERT INTO tb_hoja_ruta (
		cod_hoj_rut,
		fec_gen_hoj_rut,
		fec_desp_hoj_rut,
		cod_bod,
		cod_unid_chof,
		cod_cuad
    )
    VALUES (
		GENERATED_HR_KEY,
        NOW(),
        _fec_desp_hoj_rut,
        _cod_bod,
        _cod_unid_chof,
        null
    );
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_inicio_actividad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_inicio_actividad`(
	IN _num_proc INT(11),
    IN _nom_activ VARCHAR(100),
    OUT GENERATED_NUM_ACTIV INT(11)
)
BEGIN
	DECLARE cantidad INT(11);
	select count(num_activ)+1 from tb_actividad into cantidad;
    
    SET GENERATED_NUM_ACTIV = cantidad;
    
	INSERT INTO tb_actividad (num_proc,num_activ,nom_activ,fec_ini_ejec_activ)
    VALUES (_num_proc,GENERATED_NUM_ACTIV,_nom_activ,NOW())
    ;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_inicio_proceso` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_inicio_proceso`(
	IN _nom_proc varchar(20),
    OUT GENERATED_NUM_PROC INT(11)
)
BEGIN
	DECLARE cantidad INT(11);
	select count(num_proc)+1 from tb_proceso into cantidad;
	
    SET GENERATED_NUM_PROC = cantidad;
    
	INSERT INTO tb_proceso (num_proc,nom_proc,fec_ini_ejec_proc)
    VALUES (GENERATED_NUM_PROC,_nom_proc,NOW());
	
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-08-05 13:29:12
