package pe.com.gesateped.carga.dao;

import java.util.List;

import pe.com.gesateped.model.Bodega;

public interface BodegaDAO {

	/**
	 * Obtiene exclusivamente bodegas que no funcionan como nodos.
	 * @return
	 */
	public List<Bodega> listarSoloBodegas();
	
	
	/**
	 * Obtiene exclusivamente nodos, los que funcionan como
	 * almacenes pequeños.
	 * @return
	 */
	public List<Bodega> listarSoloNodos();
	
}
