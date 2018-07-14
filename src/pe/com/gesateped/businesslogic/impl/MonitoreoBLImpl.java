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
import pe.com.gesateped.model.extend.PedStatus;

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

	@Override
	public List<EstadoPedido> getEstadoPedidosPorBodega(String codigoBodega) {
		return monitoreoDao.getEstadoPorBodega(codigoBodega);
	}

	@Override
	public boolean detectarCambios(PedStatus pedStatus) {
		int atendidos = this.monitoreoDao.getDetallePedidoRuta(pedStatus.getCodigoHojaRuta(), "ATEN").size();
		int noAtendidos = this.monitoreoDao.getDetallePedidoRuta(pedStatus.getCodigoHojaRuta(), "NATE").size();
		int pendientes = this.monitoreoDao.getDetallePedidoRuta(pedStatus.getCodigoHojaRuta(), "PEND").size();
		int reprogramados = this.monitoreoDao.getDetallePedidoRuta(pedStatus.getCodigoHojaRuta(), "REPR").size();
		int cancelados = this.monitoreoDao.getDetallePedidoRuta(pedStatus.getCodigoHojaRuta(), "CANC").size();
		
		return (pedStatus.getAtendidos() != atendidos) ||
				(pedStatus.getNoAtendidos() != noAtendidos) || 
				(pedStatus.getPendientes() != pendientes) || 
				(pedStatus.getReprogramados() != reprogramados) || 
				(pedStatus.getCancelados() != cancelados);
	}

}
