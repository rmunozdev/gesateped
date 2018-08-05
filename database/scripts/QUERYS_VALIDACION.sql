-- DETALLE DE HOJA DE RUTA
SELECT hr.fec_desp_hoj_rut,
	   bod.nom_bod,
       dhr.cod_hoj_rut,
	   dhr.cod_ped,
       dhr.ord_desp_ped,
       dhr.tiemp_prom_desp,       
       dhr.fec_estim_part,
       dhr.tiemp_estim_lleg,
       dhr.fec_estim_lleg,
       dhr.distancia_estim,
       vh.hor_ini_vent_hor,
       vh.hor_fin_vent_hor
FROM tb_hoja_ruta hr
INNER JOIN tb_detalle_hoja_ruta dhr
  ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
INNER JOIN tb_bodega bod
  ON (hr.cod_bod = bod.cod_bod)
INNER JOIN tb_ventana_horaria vh
  ON (dhr.cod_vent_hor = vh.cod_vent_hor)
ORDER BY fec_desp_hoj_rut,
         cod_hoj_rut,
         ord_desp_ped;

-- COMPARACION DE CAPACIDAD DE UNIDADES CON CAPACIDAD DE PEDIDOS
SELECT hr.cod_hoj_rut,
       bod.nom_bod,
       uc.num_placa_unid,
	   COUNT(DISTINCT dhr.cod_ped) AS cant_ped,
       tu.pes_max_carg,
	   SUM(dp.cant_prod * pro.pes_prod) AS tot_pes_ped,
	   tu.vol_max_carg,
       SUM(dp.cant_prod * pro.vol_prod) AS tot_vol_ped
FROM tb_hoja_ruta hr
INNER JOIN tb_detalle_hoja_ruta dhr
  ON (hr.cod_hoj_rut = dhr.cod_hoj_rut)
INNER JOIN tb_bodega bod
  ON (hr.cod_bod = bod.cod_bod)
INNER JOIN tb_unidad_chofer uc
  ON (hr.cod_unid_chof = uc.cod_unid_chof)
INNER JOIN tb_unidad u
  ON (uc.num_placa_unid = u.num_plac_unid)
INNER JOIN tb_tipo_unidad tu
  ON (u.cod_tip_unid = tu.cod_tip_unid)
INNER JOIN tb_pedido ped
  ON (dhr.cod_ped = ped.cod_ped)
INNER JOIN tb_detalle_pedido dp
  ON (ped.cod_ped = dp.cod_ped)
INNER JOIN tb_producto pro
  ON (dp.cod_prod = pro.cod_prod)
GROUP BY hr.cod_hoj_rut,
         bod.nom_bod,
         uc.num_placa_unid,
         tu.pes_max_carg,
         tu.vol_max_carg;