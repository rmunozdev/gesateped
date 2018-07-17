-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

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
END