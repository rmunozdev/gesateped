CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_detalle_ruta`(
	IN _cod_hoj_rut varchar(10)
)
BEGIN
	select pedido.cod_ped,
	pedido.cod_tiend_desp,
    pedido.fec_ret_tiend,
    pedido.fec_devo_ped,
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
END