package pe.com.gesateped.batch;

import java.util.List;

import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.UnidadNormalizada;

public class DataGenerator {
	
	private MyDataSource source;
	
	public DataGenerator(int numeroPedidos) {
		this.source  = new RandomDataSource(numeroPedidos);
	}

	public List<PedidoNormalizado> generarPedidosNormalizado() {
		return source.getPedidos();
	}
	
	public List<UnidadNormalizada> generarUnidadesNormalizadas() {
		return source.getUnidades();
	}

}
