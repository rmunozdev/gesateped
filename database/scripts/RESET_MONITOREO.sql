UPDATE bd_gesateped.tb_hoja_ruta hr
SET hr.fec_desp_hoj_rut = CURDATE()
WHERE hr.cod_hoj_rut LIKE 'HRU%';

UPDATE bd_gesateped.tb_detalle_hoja_ruta dhr
SET dhr.fec_estim_part = CONCAT(CURDATE(), ' ', TIME(dhr.fec_estim_part)),
    dhr.fec_estim_lleg = CONCAT(CURDATE(), ' ', TIME(dhr.fec_estim_lleg))
WHERE dhr.cod_hoj_rut LIKE 'HRU%';

UPDATE bd_gesateped.tb_pedido p
SET p.fec_sol_ped = DATE_ADD(NOW(), INTERVAL -5 DAY),
    p.fec_vent_ped = DATE_ADD(NOW(), INTERVAL -5 DAY)
WHERE p.cod_ped LIKE 'PED%';

UPDATE bd_gesateped.tb_pedido p
SET p.fec_desp_ped = CURDATE()
WHERE p.cod_ped IN (
  'PED0000001',
  'PED0000002',
  'PED0000003',
  'PED0000004',
  'PED0000005',
  'PED0000006',
  'PED0000007',
  'PED0000008',
  'PED0000009',
  'PED0000010',
  'PED0000011',
  'PED0000012',
  'PED0000013',
  'PED0000014',
  'PED0000015',
  'PED0000016',
  'PED0000017',
  'PED0000018',
  'PED0000019',
  'PED0000020',
  'PED0000025',
  'PED0000026',
  'PED0000027',
  'PED0000028',
  'PED0000035',
  'PED0000036',
  'PED0000037',
  'PED0000038',
  'PED0000039');

UPDATE bd_gesateped.tb_pedido p
SET p.fec_desp_ped = DATE_ADD(CURDATE(), INTERVAL -4 DAY)
WHERE p.cod_ped IN (
  'PED0000021',
  'PED0000022',
  'PED0000023',
  'PED0000024',
  'PED0000029',
  'PED0000030',
  'PED0000031',
  'PED0000032',
  'PED0000033',
  'PED0000034');

UPDATE bd_gesateped.tb_pedido p
SET p.fec_ret_tiend = DATE_ADD(CURDATE(), INTERVAL 1 DAY)
WHERE p.cod_ped IN (
  'PED0000016',
  'PED0000017');

UPDATE bd_gesateped.tb_pedido p
SET p.fec_repro_ped = CURDATE()
WHERE p.cod_ped IN (
  'PED0000021',
  'PED0000022',
  'PED0000023',
  'PED0000024');

UPDATE bd_gesateped.tb_pedido p
SET p.fec_repro_ped = DATE_ADD(CURDATE(), INTERVAL 3 DAY)
WHERE p.cod_ped IN (
  'PED0000025',
  'PED0000026');

UPDATE bd_gesateped.tb_pedido p
SET p.fec_canc_ped = DATE_ADD(NOW(), INTERVAL -3 DAY)
WHERE p.cod_ped IN (
  'PED0000027',
  'PED0000028',
  'PED0000029',
  'PED0000030',
  'PED0000031',
  'PED0000032',
  'PED0000033',
  'PED0000034');

UPDATE bd_gesateped.tb_pedido p
SET p.fec_devo_ped = CURDATE()
WHERE p.cod_ped IN (
  'PED0000023',
  'PED0000024',
  'PED0000029',
  'PED0000030',
  'PED0000031',
  'PED0000032',
  'PED0000033',
  'PED0000034');

COMMIT;