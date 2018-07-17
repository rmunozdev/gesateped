/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_inicio_proceso` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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
	
	
END ;;
DELIMITER ;