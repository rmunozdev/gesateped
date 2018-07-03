package pe.com.gesateped.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.dao.MonitoreoDao;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Unidad;

@Repository
public class MonitoreoDaoImpl implements MonitoreoDao {

	@Autowired
    protected SqlSession gesatepedSession;
	
	@Override
	public List<Bodega> getBodegas() {
		return gesatepedSession.selectList("monitoreoDao.getBodegas");
	}

	@Override
	public List<Unidad> getUnidades(String codigoBodega) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("pi_cod_bod", codigoBodega);
		return gesatepedSession.selectList("monitoreoDao.getUnidades",parameters);
	}

}
