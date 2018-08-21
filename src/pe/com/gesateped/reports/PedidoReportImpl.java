package pe.com.gesateped.reports;

import java.util.ArrayList;
import java.util.Date;
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
	
	
	public Map<String,List<Map<String,?>>> getGruposPorBodega(Date fechaDespacho) {
		Map<String,List<Map<String, ?>>> grupos = new HashMap<>();
		List<Map<String,?>> grupo;
		for (Ruta ruta : pedidoDao.obtenerRutas(fechaDespacho)) {
			if(grupos.containsKey(ruta.getNombreBodega())) {
				grupo = grupos.get(ruta.getNombreBodega());
			} else {
				grupo = new ArrayList<>();
				grupos.put(ruta.getNombreBodega(), grupo);
			}
			for (PedidoNormalizado pedido : ruta.getPedidos()) {
				Map<String,Object> map = new HashMap<>();
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
				
				//Campos por pedido (fila)
				map.put("orden", pedido.getOrden());
				map.put("nombre_apellido", pedido.getCliente());
				map.put("direccion", pedido.getDomicilio());
				map.put("pedido", pedido.getCodigoPedido());
				map.put("modalidad",getModalidad(pedido));
				map.put("ventana", pedido.getVentana());
				grupo.add(map);
			}
		}
		return grupos;
	}
	
	private String getModalidad(PedidoNormalizado pedido) {
		if(pedido.getFechaDevolucion() != null) {
			return "Recojo";
		}
		return "Entrega";
	}
}
