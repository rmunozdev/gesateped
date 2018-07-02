package pe.com.gesateped.batch.algorithm;

import java.util.List;

import pe.com.gesateped.model.extend.PedidoNormalizado;

public class Resultado {

	private List<PedidoNormalizado> pedidos;
	private long counter;
	
	
	public Resultado(List<PedidoNormalizado> pedidos, long counter) {
		this.pedidos = pedidos;
		this.counter = counter;
	}

	public List<PedidoNormalizado> getPedidos() {
		return pedidos;
	}

	public long getCounter() {
		return counter;
	}
	
	public boolean isReady() {
		return !pedidos.isEmpty();
	}
	
	
}
