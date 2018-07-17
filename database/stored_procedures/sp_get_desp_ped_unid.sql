-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
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
END