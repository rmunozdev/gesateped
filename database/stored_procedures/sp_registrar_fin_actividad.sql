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

END