-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
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
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.nom_tiend,
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
      AND ((ped.fec_desp_ped = CURDATE() AND ped.fec_repro_ped IS NULL AND ped.fec_canc_ped IS NULL) OR
           (ped.fec_repro_ped = CURDATE() AND ped.fec_canc_ped IS NULL) OR
           (ped.fec_canc_ped IS NOT NULL AND ped.fec_devo_ped = CURDATE() AND ped.cod_tiend_devo IS NULL))
	ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'ATEN' THEN -- Pedidos Atendidos
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.nom_tiend,
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
    ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'NATE' THEN -- Pedidos No Atendidos
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
		   tie.nom_tiend,           
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
      AND dhr.fec_no_cump_desp IS NOT NULL
    ORDER BY dhr.ord_desp_ped ASC;

  ELSEIF pi_est_ped = 'REPR' THEN -- Pedidos Reprogramados
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.nom_tiend,           
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
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND ped.fec_repro_ped > CURDATE();

  ELSEIF pi_est_ped = 'CANC' THEN -- Pedidos Cancelados
    SELECT dhr.cod_ped,
		   vh.hor_ini_vent_hor,
		   vh.hor_fin_vent_hor,
		   dhr.fec_pact_desp,
		   dhr.fec_no_cump_desp,
		   mph.desc_mot_ped AS desc_mot_ped_hr,
		   mpp.desc_mot_ped AS desc_mot_ped_pe,
           cli.nom_cli,
           cli.ape_cli,
           cli.dir_cli,
           dcli.nom_dist AS nom_dist_cli,
           tie.nom_tiend,           
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
	  ON (ped.cod_mot_ped = mpp.cod_mot_ped)
	WHERE dhr.cod_hoj_rut = pi_cod_hoj_rut
      AND DATE(ped.fec_canc_ped) = CURDATE();
  END IF;
END