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
END