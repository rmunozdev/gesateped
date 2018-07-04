package pe.com.gesateped.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.dao.MonitoreoDao;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.EstadoPedido;
import pe.com.gesateped.model.Unidad;
import pe.com.gesateped.model.extend.DetallePedidoRuta;

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

	@Override
	public List<EstadoPedido> getEstadoPedidos(String codigoHojaRuta) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("pi_cod_hoj_rut", codigoHojaRuta);
		parameters.put("po_msg_cod", "");
		parameters.put("po_msg_desc", "");
		return gesatepedSession.selectList("monitoreoDao.getEstadoPedidos",parameters);
	}

	@Override
	public List<DetallePedidoRuta> getDetallePedidoRuta(String codigoHojaRuta, String estadoPedido) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("pi_cod_hoj_rut", codigoHojaRuta);
		parameters.put("pi_est_ped", estadoPedido);
		return gesatepedSession.selectList("monitoreoDao.getDetallePedidoRuta",parameters);
	}

	@Override
	public List<EstadoPedido> getEstadoPorBodega(String codigoBodega) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("pi_cod_bod", codigoBodega);
		parameters.put("po_msg_cod", "");
		parameters.put("po_msg_desc", "");
		return gesatepedSession.selectList("monitoreoDao.getEstadoPedidosPorBodega",parameters);
	}

}
