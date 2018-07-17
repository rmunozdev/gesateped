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

END