DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_bodegas`()
BEGIN
  SELECT bo.cod_bod,
		 bo.nom_bod
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
    AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
    AND ped.fec_canc_ped IS NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE())
  UNION
  SELECT 'Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND dhr.fec_pact_desp IS NOT NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
    AND ped.fec_canc_ped IS NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE())
  UNION
  SELECT 'No Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_hoja_ruta hr
  INNER JOIN bd_gesateped.tb_detalle_hoja_ruta dhr
    ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE hr.cod_bod = pi_cod_bod
    AND hr.fec_desp_hoj_rut = CURDATE()
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NOT NULL
    AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
    AND ped.fec_canc_ped IS NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE())
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
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND ped.fec_repro_ped > CURDATE()
    AND ped.fec_canc_ped IS NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped > CURDATE())
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
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
    AND ped.fec_canc_ped IS NOT NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped > CURDATE());
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
    AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
    AND ped.fec_canc_ped IS NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE())
  UNION
  SELECT 'Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_pact_desp IS NOT NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
    AND ped.fec_canc_ped IS NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE())
  UNION
  SELECT 'No Atendidos' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NOT NULL
    AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
    AND ped.fec_canc_ped IS NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE())
  UNION
  SELECT 'Reprogramados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND ped.fec_repro_ped > CURDATE()
    AND ped.fec_canc_ped IS NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped > CURDATE())
  UNION
  SELECT 'Cancelados' AS est_ped,
         ROUND(COUNT(dhr.cod_ped) / v_tot_ped, v_num_dec) AS porc_est_ped
  FROM bd_gesateped.tb_detalle_hoja_ruta dhr
  INNER JOIN bd_gesateped.tb_pedido ped
    ON (dhr.cod_ped = ped.cod_ped)
  WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
    AND dhr.fec_pact_desp IS NULL
    AND dhr.fec_no_cump_desp IS NULL
    AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
    AND ped.fec_canc_ped IS NOT NULL
    AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped > CURDATE());
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_desp_ped_unid_detail`(
  IN pi_cod_hoj_rut VARCHAR(10),
  IN pi_est_ped VARCHAR(4))
BEGIN
  IF pi_est_ped = 'PEND' THEN -- Pedidos Pendientes
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (dhr.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NULL
      AND dhr.fec_no_cump_desp IS NULL
      AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
      AND ped.fec_canc_ped IS NULL
      AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE())
	ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'ATEN' THEN -- Pedidos Atendidos
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (dhr.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NOT NULL
      AND dhr.fec_no_cump_desp IS NULL
      AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
      AND ped.fec_canc_ped IS NULL
      AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE());

  ELSEIF pi_est_ped = 'NATE' THEN -- Pedidos No Atendidos
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (dhr.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NULL
      AND dhr.fec_no_cump_desp IS NOT NULL
      AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
      AND ped.fec_canc_ped IS NULL
      AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE());

  ELSEIF pi_est_ped = 'REPR' THEN -- Pedidos Reprogramados
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (dhr.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NULL
      AND dhr.fec_no_cump_desp IS NULL
      AND ped.fec_repro_ped > CURDATE()
      AND ped.fec_canc_ped IS NULL
      AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped > CURDATE());

  ELSEIF pi_est_ped = 'CANC' THEN -- Pedidos Cancelados
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.dir_tiend,
           dtie.nom_dist AS nom_dist_tiend,
		   dhr.lat_gps_desp_ped,
		   dhr.long_gps_desp_ped
	FROM bd_gesateped.tb_detalle_hoja_ruta dhr
	INNER JOIN bd_gesateped.tb_pedido ped
	  ON (dhr.cod_ped = ped.cod_ped)
	INNER JOIN bd_gesateped.tb_ventana_horaria vh
	  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
	LEFT JOIN bd_gesateped.tb_cliente cli
      ON (ped.cod_cli = cli.cod_cli)
	LEFT JOIN bd_gesateped.tb_distrito dcli
      ON (cli.cod_dist = dcli.cod_dist)
    LEFT JOIN bd_gesateped.tb_tienda tie
	  ON (ped.cod_tiend_desp = tie.cod_tiend)
	LEFT JOIN bd_gesateped.tb_distrito dtie
      ON (tie.cod_dist = dtie.cod_dist)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mph
	  ON (dhr.cod_mot_ped = mph.cod_mot_ped)
	LEFT JOIN bd_gesateped.tb_motivo_pedido mpp
	  ON (dhr.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND dhr.fec_pact_desp IS NULL
      AND dhr.fec_no_cump_desp IS NULL
      AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
      AND ped.fec_canc_ped IS NOT NULL
      AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped > CURDATE());
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
            AND dhr.fec_pact_desp IS NOT NULL
            AND dhr.fec_no_cump_desp IS NULL
            AND (ped.fec_repro_ped IS NULL OR ped.fec_repro_ped = CURDATE())
            AND ped.fec_canc_ped IS NULL
            AND (ped.fec_devo_ped IS NULL OR ped.fec_devo_ped = CURDATE())) AS tot_ped_pend_unid,
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_detalle_ruta`(
	IN _cod_hoj_rut varchar(10)
)
BEGIN
	select pedido.cod_ped,
	pedido.cod_tiend_desp,
    pedido.fec_ret_tiend,
    detalle.ord_desp_ped,
    detalle.cod_hoj_rut,
	cliente.nom_cli, 
    cliente.ape_cli,
    cliente.dir_cli,
    distrito.nom_dist as dist_cli,
    tienda.cod_tiend,
    tienda.nom_tiend,
    tienda.dir_tiend,
    distrito_tienda.nom_dist as dist_tiend,
    ventana.hor_ini_vent_hor,
    ventana.hor_fin_vent_hor
	from tb_detalle_hoja_ruta detalle 
	inner join tb_pedido pedido on pedido.cod_ped = detalle.cod_ped and detalle.cod_hoj_rut = _cod_hoj_rut
	left join tb_cliente cliente on pedido.cod_cli = cliente.cod_cli
	left join tb_distrito distrito on cliente.cod_dist = distrito.cod_dist
    inner join tb_ventana_horaria ventana on ventana.cod_vent_hor = detalle.cod_vent_hor
    left join tb_tienda tienda on tienda.cod_tiend = pedido.cod_tiend_desp
    left join tb_distrito distrito_tienda on distrito_tienda.cod_dist = tienda.cod_dist
    order by detalle.ord_desp_ped asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_detalles_ruta_cliente`(
	IN _cod_hoj_rut varchar(10)
)
BEGIN
	select pedido.cod_ped,
    detalle.ord_desp_ped,
	cliente.nom_cli, 
    cliente.ape_cli,
    cliente.dir_cli,
    distrito.nom_dist,
    ventana.hor_ini_vent_hor,
    ventana.hor_fin_vent_hor
	from tb_detalle_hoja_ruta detalle 
	inner join tb_pedido pedido on pedido.cod_ped = detalle.cod_ped and detalle.cod_hoj_rut = _cod_hoj_rut
	inner join tb_cliente cliente on pedido.cod_cli = cliente.cod_cli
	inner join tb_distrito distrito on cliente.cod_dist = distrito.cod_dist
    inner join tb_ventana_horaria ventana on ventana.cod_vent_hor = detalle.cod_vent_hor
    order by detalle.ord_desp_ped asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_detalles_ruta_tienda`(
	IN _cod_hoj_rut varchar(10)
)
BEGIN
	select pedido.cod_ped,
    detalle.ord_desp_ped,
	tienda.nom_tiend, 
    tienda.dir_tiend,
    distrito.nom_dist,
    ventana.hor_ini_vent_hor,
    ventana.hor_fin_vent_hor
	from tb_detalle_hoja_ruta detalle 
	inner join tb_pedido pedido on pedido.cod_ped = detalle.cod_ped and detalle.cod_hoj_rut = _cod_hoj_rut
	inner join tb_tienda tienda on pedido.cod_tiend_desp = tienda.cod_tiend
	inner join tb_distrito distrito on tienda.cod_dist = distrito.cod_dist
    inner join tb_ventana_horaria ventana on ventana.cod_vent_hor = detalle.cod_vent_hor
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
	left join (select cod_tiend,nom_tiend,dir_tiend,dist.cod_dist,dist.nom_dist from tb_tienda inner join tb_distrito dist on dist.cod_dist = tb_tienda.cod_dist) as tieDespacho on tieDespacho.cod_tiend=ped.cod_tiend_desp
	left join (select cod_tiend,nom_tiend,dir_tiend,dist.cod_dist,dist.nom_dist from tb_tienda inner join tb_distrito dist on dist.cod_dist = tb_tienda.cod_dist) as tieDevol on tieDevol.cod_tiend=ped.cod_tiend_devo
	left join (select cli.cod_cli,cli.nom_cli,cli.ape_cli,cli.num_dni_cli,cli.telf_cli,cli.dir_cli,dist.cod_dist,dist.nom_dist from tb_cliente cli inner join tb_distrito dist on dist.cod_dist = cli.cod_dist  ) as cliente on cliente.cod_cli = ped.cod_cli
	inner join tb_detalle_pedido det on det.cod_ped = ped.cod_ped 
    inner join tb_producto pro on pro.cod_prod = det.cod_prod 
    where 
		ped.fec_canc_ped is null
		and ped.fec_desp_ped = _fecha_despacho 
		or ped.fec_repro_ped = _fecha_despacho
        or ped.fec_devo_ped = _fecha_despacho
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_ventanas_horarias`()
BEGIN
	select cod_vent_hor,
		hor_ini_vent_hor,
        hor_fin_vent_hor,
        tip_vent_hor
	from tb_ventana_horaria
    order by cod_vent_hor asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_registrar_hoja_ruta`(
	IN _fec_desp_hoj_rut date,
    IN _cod_unid_chof varchar(10),
    IN _cod_bod varchar(10),
    OUT RANDOM_KEY VARCHAR(8)
)
BEGIN
	
    SET RANDOM_KEY = LEFT(UUID(), 8);
	INSERT INTO tb_hoja_ruta (
		cod_hoj_rut,
		fec_gen_hoj_rut,
		fec_desp_hoj_rut,
		cod_bod,
		cod_unid_chof,
		cod_cuad
    )
    VALUES (
		RANDOM_KEY,
        NOW(),
        _fec_desp_hoj_rut,
        _cod_bod,
        _cod_unid_chof,
        null
    );
	
END$$
DELIMITER ;
