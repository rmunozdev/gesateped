package pe.com.gesateped.reports;

import java.util.List;
import java.util.Map;

public interface PedidoReport {

	public List<Map<String,?>> prepareData();
	public Map<String,List<Map<String,?>>> getGruposPorBodega();
	
}
