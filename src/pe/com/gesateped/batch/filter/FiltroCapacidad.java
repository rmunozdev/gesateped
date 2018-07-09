package pe.com.gesateped.batch.filter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.UnidadNormalizada;

public class FiltroCapacidad implements Filtro {

	private List<UnidadNormalizada> unidades;

	public FiltroCapacidad(List<UnidadNormalizada> unidades) {
		this.unidades = new ArrayList<>(unidades);
	}

	@Override
	public List<PedidoNormalizado> filtrar(List<PedidoNormalizado> origen) {
		List<PedidoNormalizado> filtrados = new ArrayList<>();
		for (PedidoNormalizado pedido : origen) {
			for (UnidadNormalizada unidad : unidades) {
				if(unidad.getPeso()>pedido.getPeso() 
						&& unidad.getVolumen()>pedido.getVolumen()) {
					filtrados.add(pedido);
					break;
				}
			}
		}
		this.logReporte(origen, filtrados);
		return filtrados;
	}
	
	private void logReporte(List<PedidoNormalizado>origen, List<PedidoNormalizado>filtrados) {
		List<PedidoNormalizado> descartados = new ArrayList<>();
		for (PedidoNormalizado pedido : origen) {
			if(!filtrados.contains(pedido)) {
				System.out.println("Descartado pedido: " + pedido.getCodigoPedido() + " Peso: " + pedido.getPeso() + " Volumen: " + pedido.getVolumen());
				descartados.add(pedido);
			}
		}
		
		System.out.println("Reporte Filtro Capacidad");
		System.out.println("************************");
		System.out.println("Recibidos: " + origen.size());
		System.out.println("Descartados: " + descartados.size());
		System.out.println("Filtrados: " + filtrados.size());
		System.out.println("");
	}

	@Override
	public Map<String, List<PedidoNormalizado>> separar(List<PedidoNormalizado> origen) {
		return null;
	}
	
	
}
