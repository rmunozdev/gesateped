package pe.com.gesateped.batch;

import java.util.ArrayList;
import java.util.List;

import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.model.extend.UnidadNormalizada;

/**
 * Provee alternativas en base a un resultado
 * de despacho.
 * @author rmunozdev
 *
 */
public class Asesor {
	
	private Despachador despachador;
	
	public Asesor(Despachador despachador) {
		this.despachador = despachador;
	}

	/*
	 * Prioridades
	 * 	> Que no sobren pedidos
	 *  > 
	 */
	public void evaluar(List<PedidoNormalizado> pedidosHuerfanos) {
		List<Ruta> rutas = this.despachador.getRutas();
		List<UnidadNormalizada> unidades = this.despachador.getUnidades();
		
		List<UnidadNormalizada> unidadesUsadas = new ArrayList<>();
		List<UnidadNormalizada> unidadesVacias = new ArrayList<>();
		
		for (Ruta ruta : rutas) {
			unidadesUsadas.add(ruta.getUnidad());
		}
		
		//Se buscan unidades vacias
		for (UnidadNormalizada unidad : unidades) {
			if(!unidadesUsadas.contains(unidad)) {
				unidadesVacias.add(unidad);
			}
		}
		
		//Para cada unidad vacia se intenta adaptar pedido
		for (UnidadNormalizada unidadVacia : unidadesVacias) {
			for (PedidoNormalizado pedido : pedidosHuerfanos) {
				if(pedido.getVolumen()<unidadVacia.getVolumen() 
						&& pedido.getPeso() < unidadVacia.getPeso()) {
					//Se puede asignar pedido a unidad (Al hacerlo su capacidad se reduce)
					
				}
			}
		}
		
		
	}
	
	private void llenarUnidadesVacias() {
		//Buscar unidades vacias y ponerle pedido
	}
	
	private void adicionarRutaAUnidad() {
		//En caso alguna unidad tenga tiempo suficiente
	}
	
	private void resolverPedidosHuerfanos() {
		//En nuevo viaje
		
		
	}
}
