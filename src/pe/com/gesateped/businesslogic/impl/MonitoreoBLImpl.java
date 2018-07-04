package pe.com.gesateped.businesslogic.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.businesslogic.MonitoreoBL;
import pe.com.gesateped.dao.MonitoreoDao;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.EstadoPedido;
import pe.com.gesateped.model.Unidad;
import pe.com.gesateped.model.extend.DetallePedidoRuta;

@Service
public class MonitoreoBLImpl  implements MonitoreoBL {

	@Autowired
	private MonitoreoDao monitoreoDao;
	
	@Override
	public List<Bodega> getBodegas() {
		return this.monitoreoDao.getBodegas();
	}

	@Override
	public List<Unidad> getUnidades(Bodega bodega) {
		return monitoreoDao.getUnidades(bodega.getCodigo());
	}

	@Override
	public List<EstadoPedido> getEstadoPedidos(String codigoHojaRuta) {
		return monitoreoDao.getEstadoPedidos(codigoHojaRuta);
	}

	@Override
	public List<DetallePedidoRuta> getDetallePedidosRuta(String codigoHojaRuta, String estadoPedido) {
		return monitoreoDao.getDetallePedidoRuta(codigoHojaRuta, estadoPedido);
	}

}
