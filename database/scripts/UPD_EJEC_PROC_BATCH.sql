UPDATE bd_gesateped.tb_parametro par
SET par.val_param = '20:53'
WHERE par.cod_param = 1;

COMMIT;

SELECT par.*
FROM bd_gesateped.tb_parametro par
WHERE par.cod_param = 1;