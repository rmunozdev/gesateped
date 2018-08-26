package pe.com.gesateped.businesslogic.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.businesslogic.MonitoreoBL;
import pe.com.gesateped.common.Parametros;
import pe.com.gesateped.dao.MonitoreoDao;
import pe.com.gesateped.dao.PedidoDao;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.EstadoPedido;
import pe.com.gesateped.model.Unidad;
import pe.com.gesateped.model.VentanaHoraria;
import pe.com.gesateped.model.extend.DetallePedidoRuta;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.util.GesatepedUtil;

@Service
public class MonitoreoBLImpl  implements MonitoreoBL {

	@Autowired
	private MonitoreoDao monitoreoDao;
	
	@Autowired
	private PedidoDao pedidoDao;
	
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
	public boolean detectarCambios(List<EstadoPedido> estadoTotal, String codigoBodega) {
		List<EstadoPedido> estadoTotalActual = this.monitoreoDao.getEstadoPorBodega(codigoBodega);
		boolean atendidosOk = (estadoTotalActual.get(0).getPorcentaje() == estadoTotal.get(0).getPorcentaje());
		boolean noAtendidosOk = (estadoTotalActual.get(1).getPorcentaje() == estadoTotal.get(1).getPorcentaje());
		boolean pendientesOk = (estadoTotalActual.get(2).getPorcentaje() == estadoTotal.get(2).getPorcentaje());
		boolean reprogramadosOk = (estadoTotalActual.get(3).getPorcentaje() == estadoTotal.get(3).getPorcentaje());
		boolean canceladosOk = (estadoTotalActual.get(4).getPorcentaje() == estadoTotal.get(4).getPorcentaje());
		
		return !atendidosOk || !noAtendidosOk || !pendientesOk || !reprogramadosOk || !canceladosOk ;
	}

	@Override
	public List<String> getInfoParaAlerta() {
		//Obtencion de unidades a partir de rutas
		List<Ruta> rutas = this.pedidoDao.obtenerRutas(new Date());

		Map<String,List<String>> map = new HashMap<>();
		for (Ruta ruta : rutas) {
			String bodega = ruta.getNombreBodega();
			String unidad = ruta.getUnidad().getNumeroPlaca();
			List<DetallePedidoRuta> detallePedidoRuta = this.monitoreoDao.getDetallePedidoRuta(ruta.getCodigoRuta(), "PEND");
			
			if(!detallePedidoRuta.isEmpty()) {
				map.putIfAbsent(bodega, new ArrayList<>());
				map.get(bodega).add(unidad);
			}
		}
		
		List<String> result = new ArrayList<>();
		
		for(String bodega : map.keySet()) {
			StringBuilder builder = new StringBuilder();
			builder.append("En " + bodega + ", ");
			List<String> unidades = map.get(bodega);
			builder.append((unidades.size()==1)?"la unidad ":"las unidades ");
			int counter = unidades.size();
			for (String unidad : unidades) {
				builder.append(unidad);
				if(counter > 2) {
					builder.append(", ");
				} else if(counter == 2) {
					builder.append(" y ");
				}
				counter--;
			}
			builder.append((unidades.size()==1)?" tiene ":" tienen ");
			builder.append("pedidos a puntos de sobrepasar la ventana horaria");
			result.add(builder.toString());
		}
		return result;
	}

	@Override
	public List<Date> getAlertTimes() {
		List<VentanaHoraria> ventanasHorarias = this.pedidoDao.obtenerVentanasHorarias();
		int lapsoCritico = Integer.parseInt(Parametros.getLapsoCritico());
		
		List<Date> alarmas = new ArrayList<>();
		for (VentanaHoraria ventanaHoraria : ventanasHorarias) {
			Date fechaFin = GesatepedUtil.obtenerFechaDia(ventanaHoraria.getHoraFin());
			Date fechaAlarma = new Date(fechaFin.getTime() - (lapsoCritico*60*1000));
			alarmas.add(fechaAlarma);
		}
		
		return alarmas;
	}

}
