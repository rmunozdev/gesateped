-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
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
END