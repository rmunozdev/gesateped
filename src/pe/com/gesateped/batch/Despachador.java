package pe.com.gesateped.batch;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import pe.com.gesateped.batch.algorithm.Buscador;
import pe.com.gesateped.batch.algorithm.BuscadorCombinacional;
import pe.com.gesateped.batch.algorithm.Controlador;
import pe.com.gesateped.batch.algorithm.Resultado;
import pe.com.gesateped.batch.control.ControladorPeso;
import pe.com.gesateped.batch.control.ControladorVolumen;
import pe.com.gesateped.batch.control.GoogleControl;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.model.extend.UnidadNormalizada;
import pe.com.gesateped.util.GesatepedUtil;

/**
 * Construye hojas de rutas, siguiendo diversos mecanismos para alcanzar la
 * mejor solución.
 * 
 * @author rmunozdev
 *
 */
public class Despachador {

	private List<PedidoNormalizado> pedidos;
	private List<UnidadNormalizada> unidades;
	private List<Ruta> rutas;

	public Despachador(List<PedidoNormalizado> pedidos, List<UnidadNormalizada> unidades) {
		this.pedidos = pedidos;
		this.unidades = unidades;
		this.rutas = new ArrayList<>();
	}

	public void despachar(Bodega bodega) {
		List<PedidoNormalizado> pedidosAProcesar = new ArrayList<>(pedidos);
		
		ControladorVolumen ctrlVolumen = new ControladorVolumen();
		ControladorPeso ctrlPeso = new ControladorPeso();
		GoogleControl ctrlGoogle = new GoogleControl(bodega.getDireccion(), bodega.getDireccion());
		
		Buscador buscador = new BuscadorCombinacional();
		buscador.addControlador(ctrlVolumen);
		buscador.addControlador(ctrlPeso);
		buscador.addControlador(ctrlGoogle);

		// Las unidades deben ordenarse segun tipo de pedido
		Collections.sort(unidades, new ComparadorPeso(true));

		System.out.println("Unidades");
		System.out.println("Placa\tCarga\tVolumen");
		for (UnidadNormalizada unidad : unidades) {
			System.out.println(String.format("%s\t%s\t%s", unidad.getNumeroPlaca(), unidad.getPeso(),
					unidad.getVolumen()));
		}

		// Se busca un resultado por cada unidad
		boolean continuar = true;
		while (continuar) {
			List<UnidadNormalizada> unidadesVacias = new ArrayList<>();
			
			for (UnidadNormalizada unidad : unidades) {
				ctrlVolumen.setLimite(unidad.getVolumen());
				ctrlPeso.setLimite(unidad.getPeso());
				Resultado resultado = buscador.buscar(pedidosAProcesar);
				if (resultado != null) {
					buscador.reset();
					Ruta ruta = new Ruta();
					ruta.setPedidos(resultado.getPedidos());
					ruta.setUnidad(unidad);
					ruta.setFechaDespacho(GesatepedUtil.getDiaSiguiente());
					this.rutas.add(ruta);
					this.reducirPedidos(resultado.getPedidos(),pedidosAProcesar);
				} else {
					unidadesVacias.add(unidad);
				}
			}
			
			if (pedidosAProcesar.isEmpty() || unidadesVacias.isEmpty()) {
				System.out.println("\n[Stop cause: Is empty]\n");
				continuar = false;
			} else {
				// Se aumenta tolerancia para unidades restantes
				unidades = new ArrayList<>(unidadesVacias);
				int modificacionCounter = 0;
				for (Controlador controlador : buscador.getControladores()) {
					boolean result = controlador.incrementarTolerancia();
					if (!result) {
						modificacionCounter++;
					}
				}
				if (modificacionCounter == 3) {
					// Se alcanzo maximo de tolerancia
					System.out.println("\n[Stop cause: No more tolerance]\n");
					continuar = false;
				}
			}
		}
		
		

		System.out.println("Pedidos Huerfanos: " + pedidosAProcesar.size());
		System.out.println("*****************");
		if(!pedidosAProcesar.isEmpty()) {
			System.out.println("Codigo\tPeso\tVolumen\tDemora\tbodega");
			for (PedidoNormalizado pedido : pedidosAProcesar) {
				System.out.println(String.format("%s\t%s\t%s\t%s\t%s", pedido.getCodigoPedido(), pedido.getPeso(),
						pedido.getVolumen(), pedido.getDemora(), pedido.getCodigoBodega()));
			}
		}
	}

	private void reducirPedidos(List<PedidoNormalizado> sustraendos,List<PedidoNormalizado> pedidosAReducir) {
		for (PedidoNormalizado pedido : sustraendos) {
			pedidosAReducir.remove(pedido);
		}
	}

	public List<Ruta> getRutas() {
		return rutas;
	}

	public List<UnidadNormalizada> getUnidades() {
		return unidades;
	}
}
