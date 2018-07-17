-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_bodegas`()
BEGIN
  SELECT bo.cod_bod,
		 bo.nom_bod
  FROM bd_gesateped.tb_bodega bo;
END