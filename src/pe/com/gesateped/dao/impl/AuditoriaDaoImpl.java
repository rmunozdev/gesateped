package pe.com.gesateped.dao.impl;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.dao.AuditoriaDao;

@Repository
public class AuditoriaDaoImpl implements AuditoriaDao {

	@Autowired
	protected SqlSession gesatepedSession;
	
	@Override
	public int registrarInicioProceso(String nombreProceso) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("_nom_proc", nombreProceso);
		parameters.put("GENERATED_NUM_PROC", null);
		gesatepedSession.insert("auditoriaDao.registrarInicioProceso", parameters);
		Integer insertedKey = (Integer)parameters.get("GENERATED_NUM_PROC");
		return insertedKey;
	}

	@Override
	public void registrarFinProceso(int numeroProceso, boolean isSuccess) {
		String estado = isSuccess?"SUCCESS":"ERROR";
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("_NUM_PROC", numeroProceso);
		parameters.put("_EST_PROC", estado);
		gesatepedSession.update("auditoriaDao.registrarFinProceso", parameters);
	}

	@Override
	public int registrarInicioActividad(int numeroProceso, String nombreActividad) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("_num_proc", numeroProceso);
		parameters.put("_nom_activ", nombreActividad);
		parameters.put("GENERATED_NUM_ACTIV", null);
		gesatepedSession.insert("auditoriaDao.registrarInicioActividad", parameters);
		Integer insertedKey = (Integer)parameters.get("GENERATED_NUM_ACTIV");
		return insertedKey;
	}

	@Override
	public void registrarFinActividad(int numeroActividad, boolean isSuccess, String descripcionError) {
		String estado = isSuccess?"SUCCESS":"ERROR";
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("_NUM_ACTIV", numeroActividad);
		parameters.put("_ERR_TEC_ACTIV", descripcionError);
		parameters.put("_EST_ACTIV", estado);
		gesatepedSession.update("auditoriaDao.registrarFinActividad", parameters);
	}

}
