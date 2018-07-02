package pe.com.gesateped.batch.filter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import pe.com.gesateped.model.extend.PedidoNormalizado;

public class FiltroBodega implements Filtro {

	@Override
	public List<PedidoNormalizado> filtrar(List<PedidoNormalizado> origen) {
		return null;
	}

	private void logReporte(List<PedidoNormalizado>origen, List<PedidoNormalizado>filtrados,String codigoBodega) {
		List<PedidoNormalizado> descartados = new ArrayList<>();
		for (PedidoNormalizado pedido : origen) {
			if(!filtrados.contains(pedido)) {
				descartados.add(pedido);
			}
		}
		
		System.out.println("Reporte Filtro Bodega ("+codigoBodega+")");
		System.out.println("*******************************");
		System.out.println("Recibidos: " + origen.size());
		System.out.println("Descartados: " + descartados.size());
		System.out.println("Filtrados: " + filtrados.size());
		System.out.println("");
	}

	@Override
	public Map<String,List<PedidoNormalizado>> separar(List<PedidoNormalizado> origen) {
		Map<String,List<PedidoNormalizado>> pedidosPorBodega = new HashMap<>();
		
		//Colleccion sin repeticion (Captura de codigos de bodega)
		Set<String> bodegas = new HashSet<>();
		for (PedidoNormalizado pedido : origen) {
			bodegas.add(pedido.getCodigoBodega());
		}
		
		//Cada bodega => n pedidos
		for(String bodega : bodegas) {
			List<PedidoNormalizado> pedidos = new ArrayList<>();
			for(PedidoNormalizado pedido : origen) {
				if(bodega.equals(pedido.getCodigoBodega())) {
					pedidos.add(pedido);
				}
			}
			pedidosPorBodega.put(bodega,pedidos);
		}
		return pedidosPorBodega;
	}
	
}
