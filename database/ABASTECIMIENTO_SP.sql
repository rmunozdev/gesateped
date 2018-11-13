DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_listar_proveedores`()
BEGIN
	select 
		cod_prv,
        raz_soc_prv,
        num_ruc_prv,
        telf_prv,
        email_prv,
        tip_prv 
    from tb_proveedor
    order by raz_soc_prv
    ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_listar_solo_bodegas`()
BEGIN
	select 
		cod_bod, 
        nom_bod, 
        tip_bod, 
        dir_bod, 
        email_bod,
        cod_dist 
    from tb_bodega 
    where tip_bod = 'BOD'
    order by nom_bod;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_listar_solo_nodos`()
BEGIN
	select 
		cod_bod, 
        nom_bod, 
        tip_bod, 
        dir_bod, 
        email_bod,
        cod_dist 
    from tb_bodega 
    where tip_bod = 'NOD'
    order by nom_bod;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_obtener_productos`(
	IN codigo_producto VARCHAR(15)
)
BEGIN
	select 
		cod_prod, 
        nom_prod, 
        marc_prod, 
        prec_unit_prod, 
        vol_prod, 
        pes_prod, 
        cod_tip_prod 
    from tb_producto
    where cod_prod = codigo_producto
    ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_registrar_abastecimiento`(
	pi_codigo_producto VARCHAR(15),
    pi_nombre_producto VARCHAR(150),
    
    pi_codigo_bodega VARCHAR(10),
    pi_cantidad INT(11),
    
    pi_fecha_abastecimiento DATE,
    pi_codigo_proveedor VARCHAR(10),
    
    OUT po_msg_cod INT,
	OUT po_msg_desc VARCHAR(200)
)
proc_label:BEGIN

	DECLARE v_existe_kardex boolean;
    
    DECLARE exit handler for 1062
	BEGIN
    ROLLBACK;
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -2;
	SET po_msg_desc :=  'Llave duplicada';
    
	END;
    
    DECLARE exit handler for sqlexception
	BEGIN
    ROLLBACK;
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -1;
	SET po_msg_desc :=  CONCAT(RETURNED_SQLSTATE,' ', MESSAGE_TEXT);
	END;
    
    -- KARDEX
    select true into v_existe_kardex 
    from tb_kardex 
    where cod_bod = pi_codigo_bodega and cod_prod = pi_codigo_producto;
    
    if v_existe_kardex 
    then 
		update tb_kardex set 
        stk_act = stk_act + pi_cantidad,
        fec_act_reg = now(),
        fec_notif_abast = null,
        fec_max_abast = null
        where cod_bod = pi_codigo_bodega and cod_prod = pi_codigo_producto;
    else 
		-- Se lanza error
		SET po_msg_cod := -3;
		SET po_msg_desc := 'No existe registro kardex para producto';
		LEAVE proc_label;
    end if;
    
    -- ABASTECIMIENTO
    insert into tb_abastecimiento (fec_abast, cod_prv, cod_bod, cod_prod,cant_prod,fec_reg)
    values (pi_fecha_abastecimiento,pi_codigo_proveedor,pi_codigo_bodega,pi_codigo_producto,pi_cantidad, now());
    

	-- PRODUCTO
    update tb_producto 
    set nom_prod = pi_nombre_producto 
    where cod_prod = pi_codigo_producto;

        
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_c_registrar_reposicion`(
	pi_codigo_producto VARCHAR(15),
    pi_nombre_producto VARCHAR(150),
    
    pi_codigo_nodo VARCHAR(10),
    pi_cantidad INT(11),
    
    pi_fecha_reposicion DATE,
    pi_codigo_bodega VARCHAR(10),
    
    OUT po_msg_cod INT,
	OUT po_msg_desc VARCHAR(200)
)
proc_label:BEGIN

	DECLARE v_existe_kardex boolean;
    
    DECLARE exit handler for 1062
	BEGIN
    ROLLBACK;
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -2;
	SET po_msg_desc :=  'Llave duplicada';
    
	END;
    
    DECLARE exit handler for sqlexception
	BEGIN
    ROLLBACK;
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
    SET po_msg_cod := -1;
	SET po_msg_desc :=  CONCAT(RETURNED_SQLSTATE,' ', MESSAGE_TEXT);
	END;
    
    -- KARDEX (se espera que exista)
    select true into v_existe_kardex 
    from tb_kardex 
    where cod_bod = pi_codigo_nodo and cod_prod = pi_codigo_producto;
    
    if v_existe_kardex 
    then 
		update tb_kardex set 
        stk_act = stk_act + pi_cantidad,
        fec_act_reg = now(),
        fec_notif_abast = null,
        fec_max_abast = null
        where cod_bod = pi_codigo_nodo and cod_prod = pi_codigo_producto;
    else 
		-- Se lanza error
		SET po_msg_cod := -3;
		SET po_msg_desc := 'No existe registro kardex para producto';
		LEAVE proc_label;
    end if;
    
    -- registro de reposicion
    insert into tb_reposicion (fec_repo, cod_bod, cod_nod, cod_prod,cant_prod,fec_reg)
    values (pi_fecha_reposicion,pi_codigo_bodega,pi_codigo_nodo,pi_codigo_producto,pi_cantidad,now());
    

	-- PRODUCTO
    update tb_producto 
    set nom_prod = pi_nombre_producto 
    where cod_prod = pi_codigo_producto;
    
    
        
END$$
DELIMITER ;
