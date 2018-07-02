package pe.com.gesateped.batch.filter;

import java.util.List;
import java.util.Map;

import pe.com.gesateped.model.extend.PedidoNormalizado;

public interface Filtro {
	
	public List<PedidoNormalizado> filtrar(List<PedidoNormalizado> origen);
	public Map<String,List<PedidoNormalizado>> separar(List<PedidoNormalizado> origen);
	
}
