-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

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
END