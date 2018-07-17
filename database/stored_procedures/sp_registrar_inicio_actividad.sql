/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_registrar_inicio_actividad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
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

END ;;
DELIMITER ;