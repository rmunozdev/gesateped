DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_listar_proveedores`()
BEGIN
	select 
		cod_prv,
        raz_soc_prv,
        num_ruc_prv,
        telf_prv,
        email_prv,
        tip_prv 
    from tb_proveedor
    where tip_prv = 'MERC'
    order by raz_soc_prv
    ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_listar_solo_bodegas`()
BEGIN
	select 
		cod_bod, 
        nom_bod, 
        tip_bod, 
        dir_bod, 
        email_bod,
        cod_dist 
    from tb_bodega 
    where tip_bod = 'BOD'
    order by nom_bod;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_listar_solo_nodos`()
BEGIN
	select 
		cod_bod, 
        nom_bod, 
        tip_bod, 
        dir_bod, 
        email_bod,
        cod_dist 
    from tb_bodega 
    where tip_bod = 'NOD'
    order by nom_bod;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_obtener_productos`(
	IN codigo_producto VARCHAR(15)
)
BEGIN
	select 
		cod_prod, 
        nom_prod, 
        marc_prod, 
        prec_unit_prod, 
        vol_prod, 
        pes_prod, 
        cod_tip_prod 
    from tb_producto
    where cod_prod = codigo_producto
    ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_registrar_abastecimiento`(
	pi_codigo_producto VARCHAR(15),
    pi_nombre_producto VARCHAR(150),
    
    pi_codigo_bodega VARCHAR(10),
    pi_cantidad INT(11),
    
    pi_fecha_abastecimiento DATE,
    pi_codigo_proveedor VARCHAR(10),
    
    OUT po_msg_cod INT,
	OUT po_msg_desc VARCHAR(200)
)
proc_label:BEGIN

	DECLARE v_existe_kardex boolean;
    
    DECLARE exit handler for 1062
	BEGIN
    ROLLBACK;
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -2;
	SET po_msg_desc :=  'Llave duplicada';
    
	END;
    
    DECLARE exit handler for sqlexception
	BEGIN
    ROLLBACK;
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -1;
	SET po_msg_desc :=  CONCAT(RETURNED_SQLSTATE,' ', MESSAGE_TEXT);
	END;
    
    
    START TRANSACTION;
    -- KARDEX
    select true into v_existe_kardex 
    from tb_kardex 
    where cod_bod = pi_codigo_bodega and cod_prod = pi_codigo_producto;
    
    if v_existe_kardex 
    then 
		update tb_kardex set 
        stk_act = stk_act + pi_cantidad,
        fec_act_reg = now(),
        fec_notif_abast = null,
        fec_max_abast = null
        where cod_bod = pi_codigo_bodega and cod_prod = pi_codigo_producto;
    else 
		-- Se lanza error
		SET po_msg_cod := -3;
		SET po_msg_desc := 'No existe registro kardex para producto';
		LEAVE proc_label;
    end if;
    
    -- ABASTECIMIENTO
    insert into tb_abastecimiento (fec_abast, cod_prv, cod_bod, cod_prod,cant_prod,fec_reg)
    values (pi_fecha_abastecimiento,pi_codigo_proveedor,pi_codigo_bodega,pi_codigo_producto,pi_cantidad, now());
    

	-- PRODUCTO
    update tb_producto 
    set nom_prod = pi_nombre_producto 
    where cod_prod = pi_codigo_producto;
    
	COMMIT;
        
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_registrar_reposicion`(
	pi_codigo_producto VARCHAR(15),
    pi_nombre_producto VARCHAR(150),
    
    pi_codigo_nodo VARCHAR(10),
    pi_cantidad INT(11),
    
    pi_fecha_reposicion DATE,
    pi_codigo_bodega VARCHAR(10),
    
    OUT po_msg_cod INT,
	OUT po_msg_desc VARCHAR(200)
)
proc_label:BEGIN

	DECLARE v_existe_kardex boolean;
    DECLARE v_stock_restante INT default null;
    
    DECLARE exit handler for 1062
	BEGIN
    ROLLBACK;
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -2;
	SET po_msg_desc :=  'Llave duplicada';
    
	END;
    
    DECLARE exit handler for sqlexception
	BEGIN
    ROLLBACK;
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -1;
	SET po_msg_desc :=  CONCAT(RETURNED_SQLSTATE,' ', MESSAGE_TEXT);
	END;
    
    
    START TRANSACTION;
    -- KARDEX (se espera que exista)
    select true into v_existe_kardex 
    from tb_kardex 
    where cod_bod = pi_codigo_nodo and cod_prod = pi_codigo_producto;
    
    select stk_act - pi_cantidad into v_stock_restante
    from tb_kardex
    where cod_bod = pi_codigo_bodega and cod_prod = pi_codigo_producto
    ;
    
    if v_stock_restante >= 0 
    then
		-- update se reduce en bodega
        update tb_kardex set 
        stk_act = stk_act - pi_cantidad,
        fec_act_reg = now()
        where cod_bod = pi_codigo_bodega and cod_prod = pi_codigo_producto;
	elseif v_stock_restante is not null
    then
		-- Se lanza error
		SET po_msg_cod := -4;
		SET po_msg_desc := 'Stock insuficiente para operacion';
        ROLLBACK;
		LEAVE proc_label;
	else
		-- Se lanza error
		SET po_msg_cod := -5;
		SET po_msg_desc := 'No existe registro kardex para producto en bodega';
        ROLLBACK;
		LEAVE proc_label;
    end if;
    
    if v_existe_kardex 
    then 
		update tb_kardex set 
        stk_act = stk_act + pi_cantidad,
        fec_act_reg = now(),
        fec_notif_abast = null,
        fec_max_abast = null
        where cod_bod = pi_codigo_nodo and cod_prod = pi_codigo_producto;
        
    else 
		-- Se lanza error
		SET po_msg_cod := -3;
		SET po_msg_desc := 'No existe registro kardex para producto';
        ROLLBACK;
		LEAVE proc_label;
    end if;
    
    -- registro de reposicion
    insert into tb_reposicion (fec_repo, cod_bod, cod_nod, cod_prod,cant_prod,fec_reg)
    values (pi_fecha_reposicion,pi_codigo_bodega,pi_codigo_nodo,pi_codigo_producto,pi_cantidad,now());
    

	-- PRODUCTO
    update tb_producto 
    set nom_prod = pi_nombre_producto 
    where cod_prod = pi_codigo_producto;
    
    COMMIT;
        
END$$
DELIMITER ;

DELIMITER $$
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
    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_bodegas`()
BEGIN
  SELECT bo.cod_bod,
		 bo.nom_bod,
         bo.email_bod
  FROM bd_gesateped.tb_bodega bo;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_desp_ped_bod`(
	IN pi_cod_bod VARCHAR(10),
	OUT po_msg_cod INT,
	OUT po_msg_desc VARCHAR(50))
proc_label:BEGIN
  DECLARE v_tot_ped INT;
  DECLARE v_num_dec INT DEFAULT 4;

  SET po_msg_cod := 0;
  SET po_msg_desc := 'Proceso satisfactorio';

  SELECT COUNT(dhr.cod_ped)
  INTO v_tot_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE();
  
  IF v_tot_ped = 0 THEN
    SET po_msg_cod := -1;
    SET po_msg_desc := 'No hay pedidos asignados a la hoja de ruta';
    LEAVE proc_label;
  END IF;

  SELECT 'Pendientes' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND ((ped.fec_desp_ped = CURDATE() AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL) OR
         (ped.fec_repro_ped = CURDATE() AND ped.fec_canc_ped IS NULL) OR
         (ped.fec_canc_ped IS NOT NULL AND ped.fec_devo_ped = CURDATE() AND ped.cod_tiend_devo IS NULL))
  UNION
  SELECT 'Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND dhr.fec_pact_desp IS NOT NULL
  UNION
  SELECT 'No Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND dhr.fec_no_cump_desp IS NOT NULL
  UNION
  SELECT 'Reprogramados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND ped.fec_repro_ped > CURDATE()
  UNION
  SELECT 'Cancelados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND DATE(ped.fec_canc_ped) = CURDATE();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_desp_ped_unid`(
  IN pi_cod_hoj_rut VARCHAR(10),
  OUT po_msg_cod INT,
  OUT po_msg_desc VARCHAR(50))
proc_label:BEGIN
  DECLARE v_tot_ped INT;
  DECLARE v_num_dec INT DEFAULT 4;

  SET po_msg_cod := 0;
  SET po_msg_desc := 'Proceso satisfactorio';

  SELECT COUNT(dhr.cod_ped)
  INTO v_tot_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut;
  
  IF v_tot_ped = 0 THEN
    SET po_msg_cod := -1;
    SET po_msg_desc := 'No hay pedidos asignados a la hoja de ruta';
    LEAVE proc_label;
  END IF;

  SELECT 'Pendientes' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND ((ped.fec_desp_ped = CURDATE() AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL) OR
         (ped.fec_repro_ped = CURDATE() AND ped.fec_canc_ped IS NULL) OR
         (ped.fec_canc_ped IS NOT NULL AND ped.fec_devo_ped = CURDATE() AND ped.cod_tiend_devo IS NULL))
  UNION
  SELECT 'Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_pact_desp IS NOT NULL
  UNION
  SELECT 'No Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_no_cump_desp IS NOT NULL
  UNION
  SELECT 'Reprogramados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND ped.fec_repro_ped > CURDATE()
  UNION
  SELECT 'Cancelados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND DATE(ped.fec_canc_ped) = CURDATE();
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_desp_ped_unid_detail`(
  IN pi_cod_hoj_rut VARCHAR(10),
  IN pi_est_ped VARCHAR(4))
BEGIN
  IF pi_est_ped = 'PEND' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           ped.dir_desp_ped,
           dist.nom_dist AS nom_dist_desp_ped,
           cli.nom_cli,
           cli.ape_cli,
           tie.nom_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	INNER JOIN bd_gesateped.tb_distrito dist
      ON (ped.cod_dist_desp_ped = dist.cod_dist)
	INNER JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NULL
      AND dhr.fec_no_cump_desp IS NULL
      AND ((ped.fec_desp_ped = CURDATE() AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL) OR
           (ped.fec_repro_ped = CURDATE() AND ped.fec_canc_ped IS NULL) OR
           (ped.fec_canc_ped IS NOT NULL AND ped.fec_devo_ped = CURDATE() AND ped.cod_tiend_devo IS NULL))
	ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'ATEN' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           ped.dir_desp_ped,
           dist.nom_dist AS nom_dist_desp_ped,
           cli.nom_cli,
           cli.ape_cli,
           tie.nom_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	INNER JOIN bd_gesateped.tb_distrito dist
      ON (ped.cod_dist_desp_ped = dist.cod_dist)
	INNER JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NOT NULL
    ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'NATE' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           ped.dir_desp_ped,
           dist.nom_dist AS nom_dist_desp_ped,
           cli.nom_cli,
           cli.ape_cli,
           tie.nom_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	INNER JOIN bd_gesateped.tb_distrito dist
      ON (ped.cod_dist_desp_ped = dist.cod_dist)
	INNER JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_no_cump_desp IS NOT NULL
    ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'REPR' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           ped.dir_desp_ped,
           dist.nom_dist AS nom_dist_desp_ped,
           cli.nom_cli,
           cli.ape_cli,
           tie.nom_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	INNER JOIN bd_gesateped.tb_distrito dist
      ON (ped.cod_dist_desp_ped = dist.cod_dist)
	INNER JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND ped.fec_repro_ped > CURDATE();

  ELSEIF pi_est_ped = 'CANC' THEN 
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           ped.dir_desp_ped,
           dist.nom_dist AS nom_dist_desp_ped,
           cli.nom_cli,
           cli.ape_cli,
           tie.nom_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	INNER JOIN bd_gesateped.tb_distrito dist
      ON (ped.cod_dist_desp_ped = dist.cod_dist)
	INNER JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND DATE(ped.fec_canc_ped) = CURDATE();
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_unidades`(IN pi_cod_bod VARCHAR(10))
BEGIN
  SELECT hr.cod_hoj_rut,
         un.num_plac_unid,
		 ch.nom_chof,
         ch.ape_chof,
         ch.telf_chof,
         (SELECT COUNT(dhr.cod_ped)
	      FROM bd_gesateped.tb_detalle_hoja_ruta dhr
          INNER JOIN bd_gesateped.tb_pedido ped
            ON (dhr.cod_ped = ped.cod_ped)
		  WHERE dhr.cod_hoj_rut = hr.cod_hoj_rut
            AND dhr.fec_pact_desp IS NOT NULL) AS tot_ped_aten_unid,
		 (SELECT COUNT(dhr.cod_ped)
          FROM bd_gesateped.tb_detalle_hoja_ruta dhr
          WHERE dhr.cod_hoj_rut = hr.cod_hoj_rut) AS tot_ped_unid
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_unidad_chofer uc
    ON (hr.cod_unid_chof = uc.cod_unid_chof)
  INNER JOIN bd_gesateped.tb_unidad un
	ON (uc.num_placa_unid = un.num_plac_unid)
  INNER JOIN bd_gesateped.tb_chofer ch
    ON (uc.num_brev_chof = ch.num_brev_chof)
  WHERE hr.cod_bod = pi_cod_bod
    AND un.flag_activ_unid = 1
    AND ch.flag_activ_chof = 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_n_obtener_notificables_abastecimiento`(
	pi_codigo_bodega VARCHAR(10)
)
BEGIN
	select 
		producto.cod_prod,
		producto.nom_prod,
		producto.marc_prod,
		kardex.stk_min,
		kardex.stk_act,
		kardex.fec_max_abast,
		kardex.fec_notif_abast
	from tb_kardex kardex inner join tb_producto producto 
	on producto.cod_prod = kardex.cod_prod
	where kardex.cod_bod = pi_codigo_bodega
	and kardex.stk_act < kardex.stk_min;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_n_registrar_notificacion`(
	pi_codigo_producto VARCHAR(15),
    pi_codigo_bodega VARCHAR(10),
    pi_notificacion DATE,
    pi_maxima_abastecimiento DATE
    
)
BEGIN
	update tb_kardex
    set 
		fec_notif_abast = pi_notificacion,
        fec_max_abast = pi_maxima_abastecimiento
	where
		cod_bod = pi_codigo_bodega and
        cod_prod = pi_codigo_producto
	;
END$$
DELIMITER ;

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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_controller_tienda`(
	pi_cod_tiend VARCHAR(10)
)
BEGIN
	DECLARE pi_cod_contr_tiend VARCHAR(10);
    
    SELECT 	cod_contr_tienda INTO pi_cod_contr_tiend
    FROM tb_tienda WHERE cod_tiend = pi_cod_tiend;
    
    SELECT 
		controller.cod_contr_tiend,
		controller.nom_contr_tiend,
		controller.ape_contr_tiend,
		controller.telf_contr_tiend,
		controller.email_contr_tiend
	FROM tb_controller_tienda controller
    WHERE controller.cod_contr_tiend = pi_cod_contr_tiend;
    
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_parametros`()
BEGIN
	select 
		cod_param,
		nom_param,
        desc_param,
        val_param
    from tb_parametro;
END$$
DELIMITER ;

DELIMITER $$
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
        
        concat(ped.dir_desp_ped," ",distrito.nom_dist) as domicilio,
        
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
    inner join tb_distrito distrito on ped.cod_dist_desp_ped = distrito.cod_dist
    inner join tb_provincia provincia on provincia.cod_prov = distrito.cod_prov
    where 
		(ped.fec_desp_ped = _fecha_despacho AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL)
		OR (ped.fec_repro_ped = _fecha_despacho AND ped.fec_canc_ped IS NULL)
		OR (ped.fec_canc_ped IS NOT NULL AND ped.fec_devo_ped = _fecha_despacho AND ped.cod_tiend_devo IS NULL)
    order by ped.cod_ped;
END$$
DELIMITER ;

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
END$$
DELIMITER ;

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
END$$
DELIMITER ;

DELIMITER $$
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
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_ventanas_horarias`()
BEGIN
	select cod_vent_hor,
		hor_ini_vent_hor,
        hor_fin_vent_hor,
        tip_vent_hor
	from tb_ventana_horaria
    where flag_activ_vent_hor = 1
    order by cod_vent_hor asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_fin_actividad`(
	IN _NUM_ACTIV INT(11),
    IN _MSG_INF_ACTIV VARCHAR(300),
    IN _ERR_TEC_ACTIV VARCHAR(250),
    IN _EST_ACTIV VARCHAR(7)
)
BEGIN

	UPDATE tb_actividad 
    SET
		fec_fin_ejec_activ = NOW(),
        msg_inf_activ = _MSG_INF_ACTIV,
        err_tec_activ = _ERR_TEC_ACTIV,
        est_activ = _EST_ACTIV
	WHERE
		num_activ = _NUM_ACTIV;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_fin_proceso`(
	IN _NUM_PROC INT(11),
    IN _EST_PROC VARCHAR(7)
)
BEGIN
	UPDATE tb_proceso 
    SET 
		fec_fin_ejec_proc = NOW(),
        est_proc = _EST_PROC
	WHERE
		num_proc = _NUM_PROC
	;
END$$
DELIMITER ;

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
	
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_inicio_actividad`(
	IN _num_proc INT(11),
    IN _nom_activ VARCHAR(100),
    OUT GENERATED_NUM_ACTIV INT(11)
)
BEGIN
	DECLARE cantidad INT(11);
	select count(num_activ)+1 from tb_actividad into cantidad;
    
    SET GENERATED_NUM_ACTIV = cantidad;
    
	INSERT INTO tb_actividad (num_proc,num_activ,nom_activ,fec_ini_ejec_activ)
    VALUES (_num_proc,GENERATED_NUM_ACTIV,_nom_activ,NOW())
    ;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_inicio_proceso`(
	IN _nom_proc varchar(20),
    OUT GENERATED_NUM_PROC INT(11)
)
BEGIN
	DECLARE cantidad INT(11);
	select count(num_proc)+1 from tb_proceso into cantidad;
	
    SET GENERATED_NUM_PROC = cantidad;
    
	INSERT INTO tb_proceso (num_proc,nom_proc,fec_ini_ejec_proc)
    VALUES (GENERATED_NUM_PROC,_nom_proc,NOW());
	
	
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_describir_pedido`(
	pi_codigo_pedido VARCHAR(10),
    pi_codigo_bodega VARCHAR(10)
    )
BEGIN
	select 
	detalle.cod_prod,
    producto.nom_prod,
    detalle.cant_prod
    -- TODO Tipo de producto (DESPACHO - RETIRO)
	from tb_detalle_pedido detalle 
	inner join tb_producto producto
    on producto.cod_prod = detalle.cod_prod
	where detalle.cod_ped = pi_codigo_pedido 
    and detalle.cod_bod = pi_codigo_bodega
    order by producto.cod_prod asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_listar_motivos`(
	pi_categoria VARCHAR(4)
    )
BEGIN
	select 
		cod_mot_ped as codigo,
        desc_mot_ped as descripcion,
        cat_mot_ped as categoria
    from tb_motivo_pedido
    where cat_mot_ped = pi_categoria
    ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_choferes`()
BEGIN
	select 
		num_brev_chof, 
        nom_chof, 
        ape_chof,
        telf_chof,
        email_chof
        
	from tb_chofer 
    where flag_activ_chof = 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_cliente_por_email`(
	pi_cod_cli VARCHAR(10),
    pi_email VARCHAR(50)
)
BEGIN

	SELECT 
		cod_cli,
        nom_cli,
		ape_cli,
		num_dni_cli,
		telf_cli,
		email_cli, 
		dir_cli,
		cod_dist
	FROM tb_cliente
    WHERE email_cli = pi_email
    AND cod_cli <> pi_cod_cli;
    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_cliente_por_telefono`(
	pi_cod_cli VARCHAR(10),
    pi_telefono VARCHAR(9)
)
BEGIN

	SELECT 
		cod_cli,
        nom_cli,
		ape_cli,
		num_dni_cli,
		telf_cli,
		email_cli, 
		dir_cli,
		cod_dist
	FROM tb_cliente
    WHERE telf_cli = pi_telefono
    AND cod_cli <> pi_cod_cli;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_detalle_ruta`(
	pi_codigo_ruta VARCHAR(10)
)
BEGIN
    select 
		detalle.ord_desp_ped as orden,
		detalle.cod_ped as _pedido,
		fn_obtener_nombre_destinatario(detalle.cod_ped) as destinatario,
		CONCAT(pedido.dir_desp_ped,' ',distrito.nom_dist) as domicilio,
		CONCAT('De ' , ventana.hor_ini_vent_hor,' a ',ventana.hor_fin_vent_hor) as horario,
        ventana.hor_ini_vent_hor,
        ventana.hor_fin_vent_hor,
        fn_obtener_estado(detalle.cod_ped,detalle.cod_hoj_rut) as estado
    from tb_detalle_hoja_ruta detalle
    inner join tb_ventana_horaria ventana on ventana.cod_vent_hor = detalle.cod_vent_hor
    inner join tb_pedido pedido on pedido.cod_ped = detalle.cod_ped
    inner join tb_distrito distrito on distrito.cod_dist = pedido.cod_dist_desp_ped
    WHERE detalle.cod_hoj_rut = pi_codigo_ruta
    order by detalle.ord_desp_ped asc;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_estado_ruta`(
	pi_codigo_hoja_ruta VARCHAR(10),
    OUT po_pendientes INTEGER,
    OUT po_atendidos INTEGER,
    OUT po_no_atendidos INTEGER,
    OUT po_reprogramados INTEGER,
    OUT po_cancelados INTEGER
)
BEGIN
	DECLARE pendientes INTEGER DEFAULT 0;
    DECLARE atendidos INTEGER DEFAULT 0;
    DECLARE no_atendidos INTEGER DEFAULT 0;
    DECLARE reprogramados INTEGER DEFAULT 0;
    DECLARE cancelados INTEGER DEFAULT 0;
    DECLARE estado VARCHAR(50) DEFAULT "";
    
    DEClARE c_estado CURSOR FOR 
	select fn_obtener_estado(cod_ped,cod_hoj_rut)
    from tb_detalle_hoja_ruta 
    where cod_hoj_rut = pi_codigo_hoja_ruta;
    
    OPEN c_estado;
    
    count_estados: LOOP
    FETCH c_estado INTO estado;
    
    IF (estado = 'PENDIENTE') THEN 
		SET pendientes = pendientes + 1;
	ELSEIF (estado = 'ATENDIDO') THEN 
		SET atendidos = atendidos + 1;
	ELSEIF (estado = 'NO ATENDIDO') THEN 
		SET no_atendidos = no_atendidos + 1;
	ELSEIF (estado = 'REPROGRAMADO') THEN 
		SET reprogramados = reprogramados + 1;
	ELSEIF (estado = 'CANCELADO') THEN 
		SET cancelados = cancelados + 1;
    END IF;    
	END LOOP count_estados;
    CLOSE c_estado;
    
    
    SET po_pendientes = pendientes;
    SET po_atendidos = atendidos;
    SET po_no_atendidos = no_atendidos;
    SET po_reprogramados = reprogramados;
    SET po_cancelados = cancelados;
    
    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_kardex`(
	pi_cod_ped VARCHAR(10)
)
BEGIN
	SELECT 
		kardex.cod_bod,
        kardex.cod_prod,
		kardex.stk_act,
		kardex.stk_min,
        kardex.fec_act_reg,
        producto.nom_prod,
        producto.marc_prod,
        producto.prec_unit_prod
    FROM tb_detalle_pedido detalle
    inner join tb_producto producto 
		on producto.cod_prod = detalle.cod_prod
    inner join tb_kardex kardex 
		on kardex.cod_prod = detalle.cod_prod 
        and kardex.cod_bod = detalle.cod_bod
    WHERE detalle.cod_ped = pi_cod_ped;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_mensaje_data`(
	pi_codigo_hoja_ruta VARCHAR(10),
    pi_codigo_pedido VARCHAR(10)
)
BEGIN
	select
		detalle.cod_hoj_rut as codigoHojaRuta,
		detalle.cod_ped as codigoPedido,
		fn_obtener_nombre_destinatario(detalle.cod_ped) as destinatario,
		CONCAT(pedido.dir_desp_ped,' ',distrito.nom_dist) as domicilio,
        pedido.num_reserv_ped as numeroReserva,
        num_verif_ped as numeroVerificacion, 
        fec_desp_ped as fechaDespacho,
		CONCAT('de ',ventana.hor_ini_vent_hor,' a ',ventana.hor_fin_vent_hor) as rangoHorario,
        fn_obtener_numero_destinatario(detalle.cod_ped) as numero
        
    from tb_detalle_hoja_ruta detalle
    inner join tb_ventana_horaria ventana on ventana.cod_vent_hor = detalle.cod_vent_hor
    inner join tb_pedido pedido on pedido.cod_ped = detalle.cod_ped
    inner join tb_distrito distrito on distrito.cod_dist = pedido.cod_dist_desp_ped
    WHERE detalle.cod_hoj_rut = pi_codigo_hoja_ruta
    and detalle.cod_ped = pi_codigo_pedido;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_mensajes_data`(
	pi_fecha_despacho DATE
)
BEGIN
	select 
    detalle.cod_hoj_rut as codigoHojaRuta,
	detalle.cod_ped as codigoPedido,
	fn_obtener_nombre_destinatario(detalle.cod_ped) as destinatario,
	CONCAT(pedido.dir_desp_ped,' ',distrito.nom_dist) as domicilio,
    pedido.num_reserv_ped as numeroReserva,
    
    num_verif_ped as numeroVerificacion, 
    ruta.fec_desp_hoj_rut as fechaDespacho,
	CONCAT('de ',TIME_FORMAT(ventana.hor_ini_vent_hor,"%l:%i %p"),' a ',TIME_FORMAT(ventana.hor_fin_vent_hor,"%l:%i %p")) as rangoHorario,
    fn_obtener_numero_destinatario(detalle.cod_ped) as numero,
    
    -- NUEVO REQUERIMIENTO
    pedido.cod_tiend_desp as codigoTiendaDespacho,
    tienda.nom_tiend as nombreTiendaDespacho,
    unidad.num_plac_unid as unidad,
    cliente.nom_cli as clienteNombres,
    cliente.ape_cli as clienteApellidos
    
    from tb_detalle_hoja_ruta detalle
    inner join tb_hoja_ruta ruta on ruta.cod_hoj_rut = detalle.cod_hoj_rut
    inner join tb_ventana_horaria ventana on ventana.cod_vent_hor = detalle.cod_vent_hor
    inner join tb_pedido pedido on pedido.cod_ped = detalle.cod_ped
    inner join tb_distrito distrito on distrito.cod_dist = pedido.cod_dist_desp_ped
    
    -- NUEVO REQUERIMIENTO
    left join tb_tienda tienda on tienda.cod_tiend = pedido.cod_tiend_desp
    left join tb_cliente cliente on cliente.cod_cli = pedido.cod_cli
    inner join tb_unidad_chofer uc on uc.cod_unid_chof = ruta.cod_unid_chof
    inner join tb_unidad unidad on unidad.num_plac_unid = uc.num_placa_unid
    
    where ruta.fec_desp_hoj_rut = pi_fecha_despacho;
    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_obtener_ruta`(
	pi_brevete_chofer VARCHAR(10),
    pi_fecha_despacho DATE
)
BEGIN
	select 
		ruta.cod_hoj_rut,
        ruta.cod_bod,
        bodega.nom_bod,
        bodega.dir_bod,
        distrito.nom_dist,
		unidad.num_plac_unid,
		unidad.num_soat_unid,
		chofer.nom_chof,
        chofer.ape_chof,
		ruta.fec_desp_hoj_rut
    
	from tb_hoja_ruta ruta
    inner join tb_unidad_chofer uc on uc.cod_unid_chof = ruta.cod_unid_chof
    inner join tb_unidad unidad on unidad.num_plac_unid = uc.num_placa_unid
    inner join tb_chofer chofer on chofer.num_brev_chof = uc.num_brev_chof
    inner join tb_bodega bodega on bodega.cod_bod = ruta.cod_bod
    inner join tb_distrito distrito on distrito.cod_dist = bodega.cod_dist
    where ruta.fec_desp_hoj_rut = pi_fecha_despacho
    and chofer.num_brev_chof = pi_brevete_chofer;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_registrar_atencion`(
	pi_codigo_hoja_ruta VARCHAR(10),
    pi_codigo_pedido VARCHAR(10),
    pi_numero_verificacion INT,
    pi_fecha_pactada_despacho DATETIME,
    pi_latitud DECIMAL(10,7),
    pi_longitud DECIMAL(10,7),
    pi_foto MEDIUMBLOB,
    OUT po_msg_cod INT,
	OUT po_msg_desc VARCHAR(50)
)
proc_label:BEGIN
	
    
	DECLARE v_verificacion INT;
    
    DECLARE exit handler for sqlexception
	BEGIN
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -1;
	SET po_msg_desc :=  CONCAT(RETURNED_SQLSTATE,' ', MESSAGE_TEXT);
    
	END;
        
    select num_verif_ped INTO v_verificacion
    from tb_pedido
    where cod_ped = pi_codigo_pedido;
    
    IF pi_numero_verificacion IS NULL OR v_verificacion <> pi_numero_verificacion THEN
    SET po_msg_cod := -1;
    SET po_msg_desc := 'Numero de verificación no válido';
    LEAVE proc_label;
	END IF;

	update tb_detalle_hoja_ruta set
	fec_pact_desp = pi_fecha_pactada_despacho,
    lat_gps_desp_ped = pi_latitud,
    long_gps_desp_ped = pi_longitud,
    fot_desp_ped = pi_foto
    
	where 
    tb_detalle_hoja_ruta.cod_hoj_rut = pi_codigo_hoja_ruta
    and tb_detalle_hoja_ruta.cod_ped = pi_codigo_pedido;
    
    SET po_msg_cod := 1;
    SET po_msg_desc := 'Numero de verificación válido';
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_registrar_detalle_pedido`(
	pi_cod_ped VARCHAR(10),
    pi_cod_prod VARCHAR(15),
    pi_cant_prod INT(11),
    pi_cod_bod VARCHAR(10)
)
BEGIN
	-- Kardex Update
    UPDATE tb_kardex SET 
		stk_act = (stk_act - pi_cant_prod),
        fec_act_reg = NOW()
	WHERE
		cod_bod = pi_cod_bod
        AND cod_prod = pi_cod_prod;

	-- Detalle Pedido Insert
	INSERT INTO tb_detalle_pedido (
			cod_ped,
			cod_prod,
			cant_prod,
			cod_bod
		) VALUES (
			pi_cod_ped,
            pi_cod_prod,
            pi_cant_prod,
            pi_cod_bod
        );
		
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_registrar_incumplimiento`(
	pi_codigo_hoja_ruta VARCHAR(10),
    pi_codigo_pedido VARCHAR(10),
    pi_codigo_motivo VARCHAR(10),
    pi_fecha_incumplimiento DATETIME,
    pi_latitud DECIMAL(10,7),
    pi_longitud DECIMAL(10,7),
    pi_foto MEDIUMBLOB
)
BEGIN
	update tb_detalle_hoja_ruta set
		fec_no_cump_desp = pi_fecha_incumplimiento,
		lat_gps_desp_ped = pi_latitud,
		long_gps_desp_ped = pi_longitud,
        cod_mot_ped = pi_codigo_motivo,
        fot_desp_ped = pi_foto
    
	where 
    tb_detalle_hoja_ruta.cod_hoj_rut = pi_codigo_hoja_ruta
    and tb_detalle_hoja_ruta.cod_ped = pi_codigo_pedido;
    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_registrar_notificacion`(
	pi_codigo_hoja_ruta VARCHAR(10),
	pi_cod_ped VARCHAR(10)
)
BEGIN
	update tb_detalle_hoja_ruta 
    set flag_env_vent_hor = 1
    where cod_hoj_rut = pi_codigo_hoja_ruta
    and cod_ped = pi_cod_ped;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ws_reservar_pedido`(
	pi_cod_ped VARCHAR(10),

	pi_fec_sol_ped datetime,
	pi_num_reserv_ped int(11),
	pi_fec_vent_ped datetime,
	pi_fec_desp_ped date,
    
	 -- DATOS DE DESTINO
	pi_dir_desp_ped VARCHAR(100),
	pi_cod_dist_desp_ped VARCHAR(10),
    
	 -- CAMPOS PARA CLIENTE (ACTUALIZAN)
	pi_cod_cli VARCHAR(10),
	pi_nom_cli VARCHAR(50),
	pi_ape_cli VARCHAR(50),
	pi_num_dni_cli VARCHAR(8),
	pi_telf_cli VARCHAR(9),
	pi_email_cli VARCHAR(50),
	pi_dir_cli VARCHAR(100),
	pi_cod_dist VARCHAR(10),
    
	 -- CAMPOS PARA TIENDA (RETIRO O REPOSICION)
	pi_cod_tiend_desp VARCHAR(10),
	pi_fec_ret_tiend DATE

)
BEGIN
	DECLARE cliente_count INT default 0;
    DECLARE p_num_verif_ped INT(11) default null;
    
    
	
    -- CASO RETIRO EN TIENDA (REUSO DE NUMERO DE VERIFICACION)
    select num_verif_ped into p_num_verif_ped 
		from tb_pedido 
        where fec_desp_ped = pi_fec_desp_ped
        and fec_ret_tiend is not null
        and cod_tiend_desp = pi_cod_tiend_desp
        order by num_verif_ped DESC LIMIT 1;
        
	-- SI NO REUSA, SE CREA
	IF(p_num_verif_ped IS NULL) THEN
		select num_verif_ped into p_num_verif_ped from tb_pedido order by num_verif_ped DESC LIMIT 1;
    END IF;
    
    
    IF(p_num_verif_ped IS NULL) THEN 
		SET p_num_verif_ped = 1000;
    ELSE
		SET p_num_verif_ped = p_num_verif_ped + 1;
    END IF;

     -- Se inserta cliente solo si no existe
    
    SELECT COUNT(cod_cli) into cliente_count from tb_cliente where cod_cli = pi_cod_cli;
    
    IF (cliente_count > 0) THEN
    
    UPDATE tb_cliente SET 
        telf_cli = IFNULL(pi_telf_cli,telf_cli),
        email_cli = IFNULL(pi_email_cli,email_cli),
        dir_cli = IFNULL(pi_dir_cli,dir_cli),
        cod_dist = IFNULL(pi_cod_dist,cod_dist)
	WHERE cod_cli = pi_cod_cli;
    
    ELSE 
    
     INSERT INTO tb_cliente (
		cod_cli,
        nom_cli,
        ape_cli,
        num_dni_cli,
        telf_cli,
        email_cli,
        dir_cli,
        cod_dist
    ) VALUES (
		pi_cod_cli,
        pi_nom_cli,
        pi_ape_cli,
        pi_num_dni_cli,
        pi_telf_cli,
        pi_email_cli,
        pi_dir_cli,
        pi_cod_dist
    );
    
    END IF;
    
    -- Se resuelve direccion de despacho  
    IF pi_cod_tiend_desp IS NOT NULL THEN
		SELECT  
			dir_tiend,cod_dist INTO pi_dir_desp_ped,pi_cod_dist_desp_ped
		FROM tb_tienda 
		where cod_tiend = pi_cod_tiend_desp;
		

	ELSEIF pi_dir_desp_ped IS NULL THEN
		SELECT 
			dir_cli,cod_dist INTO pi_dir_desp_ped,pi_cod_dist_desp_ped
        FROM tb_cliente
		WHERE cod_cli = pi_cod_cli;
		
	END IF;

    -- Se construye pedido para cliente
	INSERT INTO tb_pedido (
		cod_ped,
        cod_cli,
        fec_sol_ped,
        num_reserv_ped,
        num_verif_ped,
        fec_vent_ped,
        fec_desp_ped,
        dir_desp_ped,
        cod_dist_desp_ped,
        cod_tiend_desp,
        fec_ret_tiend
    ) VALUES (
		pi_cod_ped,
        pi_cod_cli,
        pi_fec_sol_ped,
        pi_num_reserv_ped,
        p_num_verif_ped,
        pi_fec_vent_ped,
        pi_fec_desp_ped,
        
        pi_dir_desp_ped,
        pi_cod_dist_desp_ped,
        pi_cod_tiend_desp,
        pi_fec_ret_tiend
    );

END$$
DELIMITER ;
