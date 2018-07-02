package pe.com.gesateped.batch.algorithm;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import pe.com.gesateped.model.extend.PedidoNormalizado;

/**
 * Realiza busqueda basandose en seleccion de muestras acorde a las 
 * combinaciones generadas de un grupo de pedidos.
 * Puede establecerse la progresión de combinaciones en 
 * orden ascendente(default) o descendente.
 * @author rmunozdev
 *
 */
public class BuscadorCombinacional implements Buscador {

	private List<Controlador> controladores;
	private long counter;
	private Resultado resultado;
	
	public BuscadorCombinacional() {
		this.controladores = new ArrayList<>();
		this.counter = 0;
	}
	
	@Override
	public Resultado buscar(List<PedidoNormalizado> pedidos) {
		PedidoNormalizado[] origen = pedidos.toArray(new PedidoNormalizado[pedidos.size()]);
		for(int i=pedidos.size(); i>= 1;i--) {
			this.iniciar(origen, origen.length,i,0,new PedidoNormalizado[i],0);
		}
		return this.resultado;
	}
	
	/**
	 * @param origen
	 * @param inicio Indice inicial de evaluacion de origen
	 * @param fin Indice final de evaluacion de origen
	 * @param posicionEnData
	 * @param data Array temporal para almacenar combinacion actual
	 * @param i
	 */
	public void iniciar(PedidoNormalizado[] origen, int inicio, int fin, int posicionEnData, PedidoNormalizado[] data, int i) {
		if(this.resultado != null) {
			return;
		}
		this.counter++;
		
		if(fin == posicionEnData) {
			this.inspeccionarCombinado(fin,data);
			return;
		}
		
		if(i >= inicio) {
			return;
		}
		
		data[posicionEnData] = origen[i];
		
		//Recursividad bajo nuevas condiciones
		iniciar(origen,inicio,fin,posicionEnData+1,data,i+1);
		iniciar(origen,inicio,fin,posicionEnData,data,i+1);
	}
	
	public void inspeccionarCombinado(int fin, PedidoNormalizado[] data) {
		List<PedidoNormalizado> pedidos = Arrays.asList(data);
		for (Controlador controlador : controladores) {
			if(!controlador.verificar(pedidos)) {
				return;
			}
		}
		//TODO Solo se establece orden si no hay previo
		if(!pedidos.isEmpty() && pedidos.get(0).getOrden()==null) {
			int orden = 1;
			for(PedidoNormalizado pedido : pedidos) {
				pedido.setOrden(orden);
				orden++;
			}
		}
		resultado = new Resultado(pedidos, this.counter);
	}

	@Override
	public void addControlador(Controlador controlador) {
		this.controladores.add(controlador);
	}

	public void reset() {
		this.resultado = null;
	}

	public List<Controlador> getControladores() {
		return controladores;
	}
	
}
