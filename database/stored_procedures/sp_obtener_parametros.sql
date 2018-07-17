-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_parametros`()
BEGIN
	select 
		cod_param,
		nom_param,
        desc_param,
        val_param
    from tb_parametro;
END