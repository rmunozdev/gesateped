SELECT p.*
FROM tb_pedido p
WHERE (p.fec_desp_ped = DATE_ADD(CURDATE(), INTERVAL 1 DAY) AND p.fec_repro_ped IS NULL AND p.fec_canc_ped IS NULL)
  OR (p.fec_repro_ped = DATE_ADD(CURDATE(), INTERVAL 1 DAY) AND p.fec_canc_ped IS NULL)
  OR (p.fec_canc_ped IS NOT NULL AND p.fec_devo_ped = DATE_ADD(CURDATE(), INTERVAL 1 DAY) AND p.cod_tiend_devo IS NULL);

SELECT COUNT(p.cod_ped) AS cant_ped_proc
FROM tb_pedido p
WHERE (p.fec_desp_ped = DATE_ADD(CURDATE(), INTERVAL 1 DAY) AND p.fec_repro_ped IS NULL AND p.fec_canc_ped IS NULL)
  OR (p.fec_repro_ped = DATE_ADD(CURDATE(), INTERVAL 1 DAY) AND p.fec_canc_ped IS NULL)
  OR (p.fec_canc_ped IS NOT NULL AND p.fec_devo_ped = DATE_ADD(CURDATE(), INTERVAL 1 DAY) AND p.cod_tiend_devo IS NULL);