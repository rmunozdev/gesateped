package pe.com.gesateped.dao;

import java.util.List;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Unidad;

public interface MonitoreoDao {

	public List<Bodega> getBodegas();
	public List<Unidad> getUnidades(String codigoBodega);
	
}
