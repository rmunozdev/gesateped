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
  `err_tec_activ` varchar(250) DEFAULT NULL COMMENT 'Error tecnico de actividad.',
  `est_activ` varchar(7) DEFAULT NULL COMMENT 'Estado de actividad (SUCCESS: Satisfactorio, ERROR: Error).',
  PRIMARY KEY (`num_proc`,`num_activ`),
  CONSTRAINT `fk_proc_act` FOREIGN KEY (`num_proc`) REFERENCES `tb_proceso` (`num_proc`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de la actividad del proceso batch.';
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `cod_dist` varchar(10) NOT NULL COMMENT 'Codigo de distrito.',
  PRIMARY KEY (`cod_bod`),
  UNIQUE KEY `nom_bod_UNIQUE` (`nom_bod`),
  KEY `fk_bod_dist_idx` (`cod_dist`),
  CONSTRAINT `fk_bod_dist` FOREIGN KEY (`cod_dist`) REFERENCES `tb_distrito` (`cod_dist`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena informacion de la bodega.';
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `fec_pact_desp` datetime DEFAULT NULL COMMENT 'Fecha pactada de despacho en formato dd/mm/yyyy hh24:mi:ss.',
  `fec_no_cump_desp` datetime DEFAULT NULL COMMENT 'Fecha de no cumplimiento de despacho en formato dd/mm/yyyy hh24:mi:ss.',
  `lat_gps_desp_ped` decimal(10,6) DEFAULT NULL COMMENT 'Latitud GPS de despacho de pedido.',
  `long_gps_desp_ped` decimal(10,6) DEFAULT NULL COMMENT 'Longitud GPS de despacho de pedido.',
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
  `cant_abast` int(11) NOT NULL COMMENT 'Cantidad de abastecimiento de producto.',
  PRIMARY KEY (`cod_bod`,`cod_prod`),
  KEY `fk_kard_prod_idx` (`cod_prod`),
  CONSTRAINT `fk_kard_bod` FOREIGN KEY (`cod_bod`) REFERENCES `tb_bodega` (`cod_bod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_kard_prod` FOREIGN KEY (`cod_prod`) REFERENCES `tb_producto` (`cod_prod`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del kardex (existencia de los productos en bodega).';
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `fk_ped_cli` FOREIGN KEY (`cod_cli`) REFERENCES `tb_cliente` (`cod_cli`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_mot_ped` FOREIGN KEY (`cod_mot_ped`) REFERENCES `tb_motivo_pedido` (`cod_mot_ped`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_pick` FOREIGN KEY (`cod_pick`) REFERENCES `tb_pickeador` (`cod_pick`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_tiend_desp` FOREIGN KEY (`cod_tiend_desp`) REFERENCES `tb_tienda` (`cod_tiend`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ped_tiend_devo` FOREIGN KEY (`cod_tiend_devo`) REFERENCES `tb_tienda` (`cod_tiend`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del pedido.';
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`cod_prv`),
  UNIQUE KEY `num_ruc_UNIQUE` (`num_ruc_prv`),
  UNIQUE KEY `raz_soc_prv_UNIQUE` (`raz_soc_prv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion del proveedor.';
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `tb_unidad_chofer`
--

DROP TABLE IF EXISTS `tb_unidad_chofer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tb_unidad_chofer` (
  `cod_unid_chof` varchar(10) NOT NULL,
  `num_placa_unid` varchar(10) NOT NULL COMMENT 'Numero de placa de la unidad.',
  `num_brev_chof` varchar(10) NOT NULL COMMENT 'Numero de brevete del chofer.',
  `fec_asig_unid_chof` datetime NOT NULL COMMENT 'Fecha de asignacion de unidad con chofer en formato dd/mm/yyyy hh24:mi:ss.',
  PRIMARY KEY (`cod_unid_chof`),
  KEY `fk_unid_chof_unid_idx` (`num_placa_unid`),
  KEY `fk_unid_chof_chof_idx` (`num_brev_chof`),
  CONSTRAINT `fk_unid_chof_chof` FOREIGN KEY (`num_brev_chof`) REFERENCES `tb_chofer` (`num_brev_chof`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_unid_chof_unid` FOREIGN KEY (`num_placa_unid`) REFERENCES `tb_unidad` (`num_plac_unid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena la informacion de asignacion de unidad co';
/*!40101 SET character_set_client = @saved_cs_client */;

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
  PRIMARY KEY (`cod_vent_hor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Tabla que almacena informacion de la ventana horaria.';
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-07-15 23:45:12
