-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

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
	
END