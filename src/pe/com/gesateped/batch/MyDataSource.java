package pe.com.gesateped.batch;

import java.util.List;

import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.UnidadNormalizada;

public interface MyDataSource {

	public List<PedidoNormalizado> getPedidos();
	public List<UnidadNormalizada> getUnidades();
}
