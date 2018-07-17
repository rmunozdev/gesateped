-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

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
END