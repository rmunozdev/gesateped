package pe.com.gesateped.batch;

import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.Collections;
import java.util.List;

import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.model.extend.UnidadNormalizada;


public class TesterUtil {
	
	public static void main(String[] args) {
		testBusquedaSimple();
	}
	
	public void test() {
		testBusquedaSimple();
	}
	
	public static void testBusquedaSimple() {
		DataGenerator generator = new DataGenerator(50);
		Despachador despachador = new Despachador(generator.generarPedidosNormalizado(),generator.generarUnidadesNormalizadas());
		despachador.despachar(null);
		System.out.println("\nResultado final: ");
		System.out.println("******************");
		if(despachador.getRutas().isEmpty()) {
			System.out.println("No se encontraron rutas");
		} else {
			DecimalFormat df = new DecimalFormat("#.##");
			df.setRoundingMode(RoundingMode.CEILING);
			for(Ruta ruta : despachador.getRutas()) {
				System.out.print("Placa: "+ruta.getUnidad().getNumeroPlaca());
				System.out.print("(");
				
				System.out.print("v%:" + df.format(ruta.calcularEfectividadVolumen()));
				System.out.print("  p%:" + df.format(ruta.calcularEfectividadPeso()));
				System.out.println(")");
				System.out.println("\tCodigo\tPeso\tVolumen\tTiempo");
				for(PedidoNormalizado pedido : ruta.getPedidos()) {
					System.out.println("\t"+pedido.getCodigoPedido() + "\t" + pedido.getPeso() + "\t" + pedido.getVolumen() + "\t" + pedido.getDemora());
				}
				System.out.println("");
			}
		}
		
	}
	
	public static void testOrdenamiento() {
		DataGenerator generator = new DataGenerator(30);
		List<UnidadNormalizada> unidades = generator.generarUnidadesNormalizadas();
		for (UnidadNormalizada unidadNormalizada : unidades) {
			System.out.print(unidadNormalizada.getPeso() + " ");
		}
		
		System.out.println("");
		Collections.sort(unidades, new ComparadorPeso(false));
		for (UnidadNormalizada unidadNormalizada : unidades) {
			System.out.print(unidadNormalizada.getPeso() + " ");
		}
		
	}

}
