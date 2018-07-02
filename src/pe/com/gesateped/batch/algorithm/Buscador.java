package pe.com.gesateped.batch.algorithm;

import java.util.List;

import pe.com.gesateped.model.extend.PedidoNormalizado;

/**
 * Provee operaciones para busqueda desde una lista de pedidos, utilizando
 * controladores especificos.
 * 
 * @author rmunozdev
 *
 */
public interface Buscador {

	/**
	 * Busqueda por defecto, termina cuando ha encontrado un resultado que cumple
	 * las condiciones dadas por los controladores.
	 */
	public Resultado buscar(List<PedidoNormalizado> pedidos);

	/**
	 * Agrega un controlador, considerar orden.
	 */
	public void addControlador(Controlador controlador);

	/**
	 * Habilita el buscador para volver a usarlo (Con los mismo controles)
	 */
	public void reset();

	/**
	 * Recupera los controladores usados actualmente por este buscador.
	 * 
	 * @return
	 */
	public List<Controlador> getControladores();
}
