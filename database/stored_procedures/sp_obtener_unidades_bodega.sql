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
END