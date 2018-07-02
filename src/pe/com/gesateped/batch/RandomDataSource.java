package pe.com.gesateped.batch;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.UnidadNormalizada;

public class RandomDataSource implements MyDataSource {

	private int pedidosNumber;
	private int bodegasNumber = 2;
	private int zonasNumber = 2;
	private int pesoLimiteKg = 1000;
	private int volumenLimiteCm3 = 1000;
	private int demoraMaximaMin = 120;
	
	private int unidadesNumber = 5;
	
	
	
	public RandomDataSource(int pedidosNumber) {
		this.pedidosNumber = pedidosNumber;
	}

	@Override
	public List<PedidoNormalizado> getPedidos() {
		List<PedidoNormalizado> pedidos = new ArrayList<>();
		
		ThreadLocalRandom random = ThreadLocalRandom.current();
		
		for (int i = 0; i < pedidosNumber; i++) {
			PedidoNormalizado pedido = new PedidoNormalizado();
			pedido.setCodigoPedido("P_"+(i+1));
			pedido.setCodigoBodega(String.valueOf(random.nextInt(bodegasNumber)+1));
			pedido.setCodigoZonaCobertura(String.valueOf(random.nextInt(zonasNumber)+1));
			pedido.setDomicilio("D_"+(i+1));
			pedido.setPeso(random.nextInt(pesoLimiteKg) + 1);
			pedido.setVolumen(random.nextInt(volumenLimiteCm3) +1);
			pedido.setDemora(random.nextInt(demoraMaximaMin));
			pedidos.add(pedido);
		}
		return pedidos;
	}

	public List<UnidadNormalizada> getUnidades() {
		List<UnidadNormalizada> unidades = new ArrayList<>();
		ThreadLocalRandom random = ThreadLocalRandom.current();
		
		for (int i = 0; i < unidadesNumber; i++) {
			UnidadNormalizada unidad = new UnidadNormalizada();
			unidad.setNumeroPlaca("U"+(i+1));
			unidad.setVolumenCargaMaxima(random.nextInt(volumenLimiteCm3)+200);
			unidad.setPesoCargaMaxima(random.nextInt(pesoLimiteKg)+200);
			unidades.add(unidad);
		}
		return unidades;
	}
}
