package pe.com.gesateped.batch.algorithm;

import java.util.List;

import pe.com.gesateped.model.extend.PedidoNormalizado;

public interface Controlador {

	public boolean verificar(List<PedidoNormalizado> pedidos);
	public boolean incrementarTolerancia();
	
}
