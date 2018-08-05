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
    
END