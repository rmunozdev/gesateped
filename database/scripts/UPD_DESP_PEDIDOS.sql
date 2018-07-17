-- Pedido atendido
UPDATE bd_gesateped.tb_detalle_hoja_ruta dhr
SET dhr.fec_pact_desp = dhr.fec_estim_lleg,
    dhr.lat_gps_desp_ped = -12.1122134,
    dhr.long_gps_desp_ped = -77.031828
WHERE dhr.cod_hoj_rut = 'HRU0000002'
  AND dhr.cod_ped = 'PED0000022';

-- Pedido no atendido
UPDATE bd_gesateped.tb_detalle_hoja_ruta dhr
SET dhr.fec_no_cump_desp = dhr.fec_estim_lleg,
    dhr.lat_gps_desp_ped = -12.0721231,
    dhr.long_gps_desp_ped = -77.0802653,
    dhr.cod_mot_ped = 'MPE0000007'
WHERE dhr.cod_hoj_rut = 'HRU0000002'
  AND dhr.cod_ped = 'PED0000006';

-- Pedido reprogramado
UPDATE bd_gesateped.tb_pedido ped
SET ped.fec_repro_ped = DATE_ADD(CURDATE(), INTERVAL 2 DAY),
    ped.cod_mot_ped = 'MPE0000001'
WHERE ped.cod_ped = 'PED0000009';

-- Pedido cancelado
UPDATE bd_gesateped.tb_pedido ped
SET ped.fec_canc_ped = NOW(),
    ped.cod_mot_ped = 'MPE0000004'
WHERE ped.cod_ped = 'PED0000003';

COMMIT;