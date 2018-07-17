/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_obtener_pedidos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_pedidos`(
	_fecha_despacho DATE
)
BEGIN	 
    select ped.cod_ped,
		ped.cod_cli,
		ped.cod_tiend_desp,
		ped.cod_tiend_devo,
		ped.fec_ret_tiend,
        ped.fec_desp_ped,
        ped.fec_repro_ped,
        ped.fec_canc_ped,
        ped.fec_devo_ped,
		det.cod_bod,
		det.cant_prod,
		pro.cod_prod,
		pro.vol_prod,
		pro.pes_prod, 
		tieDespacho.dir_tiend as tieDespacho,
        tieDespacho.nom_dist as tieDespachoDist,
        tieDevol.dir_tiend as tieDevol,
        tieDevol.nom_dist as tieDevolDist,
        ped.cod_cli as cliente,
        cliente.nom_cli as clienteNombres,
        cliente.ape_cli as clienteApellidos,
        cliente.dir_cli as clienteDireccion,
        cliente.nom_dist as clienteDireccionDist
	from tb_pedido ped
	left join (
		select cod_tiend,nom_tiend,dir_tiend,dist.cod_dist,dist.nom_dist 
        from tb_tienda 
        inner join tb_distrito dist on dist.cod_dist = tb_tienda.cod_dist) 
		as tieDespacho on tieDespacho.cod_tiend=ped.cod_tiend_desp
	left join (
		select cod_tiend,nom_tiend,dir_tiend,dist.cod_dist,dist.nom_dist 
        from tb_tienda 
        inner join tb_distrito dist on dist.cod_dist = tb_tienda.cod_dist) 
        as tieDevol on tieDevol.cod_tiend=ped.cod_tiend_devo
	left join (
		select cli.cod_cli,cli.nom_cli,cli.ape_cli,cli.num_dni_cli,cli.telf_cli,cli.dir_cli,dist.cod_dist,dist.nom_dist 
        from tb_cliente cli 
        inner join tb_distrito dist on dist.cod_dist = cli.cod_dist  ) 
        as cliente on cliente.cod_cli = ped.cod_cli
	inner join tb_detalle_pedido det on det.cod_ped = ped.cod_ped 
    inner join tb_producto pro on pro.cod_prod = det.cod_prod 
    where 
		(ped.fec_desp_ped = _fecha_despacho AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL)
		OR (ped.fec_repro_ped = _fecha_despacho AND ped.fec_canc_ped IS NULL)
		OR (ped.fec_repro_ped IS NULL AND ped.fec_devo_ped = _fecha_despacho AND ped.cod_tiend_devo IS NULL)
    order by ped.cod_ped;
END ;;
DELIMITER ;