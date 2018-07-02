package pe.com.gesateped.batch.filter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import pe.com.gesateped.model.extend.PedidoNormalizado;

public class FiltroTipoPedido implements Filtro {

	@Override
	public List<PedidoNormalizado> filtrar(List<PedidoNormalizado> origen) {
		return null;
	}

	@Override
	public Map<String, List<PedidoNormalizado>> separar(List<PedidoNormalizado> origen) {
		Map<String,List<PedidoNormalizado>> pedidosPorTipo = new HashMap<>();
		
		Set<String> tipos = new HashSet<>();
		for(PedidoNormalizado pedido : origen) {
			tipos.add(pedido.getTipoPedido().toString());
		}
		
		for(String tipoPedido : tipos) {
			List<PedidoNormalizado> pedidos = new ArrayList<>();
			for(PedidoNormalizado pedido : origen) {
				if(tipoPedido.equals(pedido.getTipoPedido().toString())) {
					pedidos.add(pedido);
				}
			}
			pedidosPorTipo.put(tipoPedido, pedidos);
		}
		
		return pedidosPorTipo;
	}

}
