CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_obtener_ventanas_horarias`()
BEGIN
	select cod_vent_hor,
		hor_ini_vent_hor,
        hor_fin_vent_hor,
        tip_vent_hor
	from tb_ventana_horaria
    where flag_activ_vent_hor = 1
    order by cod_vent_hor asc;
END