package pe.com.gesateped.reports;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.dao.PedidoDao;
import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;

@Service
public class PedidoReportImpl implements PedidoReport {
	
	@Autowired
	private PedidoDao pedidoDao;

	@Override
	public List<Map<String, ?>> prepareData() {
		List<Map<String,?>> maps = new ArrayList<>();
		for (Ruta ruta : pedidoDao.obtenerRutas()) {
			for (PedidoNormalizado pedido : ruta.getPedidos()) {
				Map<String,Object> map = new HashMap<>();
				System.out.println("Orden pedido:" + pedido.getOrden());
				map.put("orden", pedido.getOrden());
				map.put("nombre_apellido", pedido.getCliente());
				map.put("direccion", pedido.getDomicilio());
				map.put("pedido", pedido.getCodigoPedido());
				map.put("ventana", pedido.getVentana());
				
				//campos agrupados
				map.put("cod_hoj_rut", ruta.getCodigoRuta());
				map.put("chofer", ruta.getUnidad().getNombreChofer());
				map.put("brevete", ruta.getUnidad().getBreveteChofer());
				map.put("placa", ruta.getUnidad().getNumeroPlaca());
				map.put("soat", ruta.getUnidad().getSoat());
				map.put("peso", String.valueOf(ruta.getUnidad().getPesoCargaMaxima()));
				map.put("volumen", String.valueOf(ruta.getUnidad().getVolumenCargaMaxima()));
				map.put("fec_generacion", ruta.getFechaGeneracion());
				map.put("fec_desp", ruta.getFechaDespacho());
				map.put("bodega", ruta.getNombreBodega());
				maps.add(map);
			}
		}
		return maps;
	}
	
	
	
}
