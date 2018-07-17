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
	
	
END