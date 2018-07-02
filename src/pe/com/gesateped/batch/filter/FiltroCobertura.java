package pe.com.gesateped.batch.filter;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import pe.com.gesateped.model.extend.PedidoNormalizado;

public class FiltroCobertura implements Filtro {

	private String cobertura;
	
	public FiltroCobertura(String cobertura) {
		this.cobertura = cobertura;
	}

	@Override
	public List<PedidoNormalizado> filtrar(List<PedidoNormalizado> origen) {
		List<PedidoNormalizado> filtrado = new ArrayList<>();
		for (PedidoNormalizado pedido : origen) {
			if(this.cobertura.equals(pedido.getCodigoZonaCobertura())) {
				filtrado.add(pedido);
			}
		}
		return filtrado;
	}

	@Override
	public Map<String, List<PedidoNormalizado>> separar(List<PedidoNormalizado> origen) {
		return null;
	}
}
