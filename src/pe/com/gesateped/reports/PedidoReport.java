package pe.com.gesateped.reports;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface PedidoReport {

	public List<Map<String,?>> prepareData(Date fechaDespacho);
	public Map<String,List<Map<String,?>>> getGruposPorBodega(Date fechaDespacho);
	
}
