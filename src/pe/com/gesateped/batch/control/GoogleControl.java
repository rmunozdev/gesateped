package pe.com.gesateped.batch.control;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import com.google.maps.DirectionsApi;
import com.google.maps.GeoApiContext;
import com.google.maps.errors.ApiException;
import com.google.maps.model.DirectionsLeg;
import com.google.maps.model.DirectionsResult;

import pe.com.gesateped.batch.algorithm.Controlador;
import pe.com.gesateped.common.Parametros;
import pe.com.gesateped.model.extend.PedidoNormalizado;

public class GoogleControl implements Controlador {

	private static final String MAPS_API_KEY = "AIzaSyC5zx6JgWVPftfjOPJybTKhKUwhN5zVxJI";

	private static final int MAX_WAYPOINTS = 23;
	
	private String origen;
	private String destino;
	
	private int useCounter = 1;
	private static final int MAX_USES = 100;
	private long tiempoAcumuladoMaximo = 12 * 60 * 60;
	
	public GoogleControl(String origen, String destino) {
		this.origen = origen;
		this.destino = destino;
	}

	@Override
	public boolean verificar(List<PedidoNormalizado> pedidos) {
		boolean resultado = false;
		System.out.println("Usando control google: " + useCounter);
		if(pedidos.size()<MAX_WAYPOINTS && useCounter < MAX_USES) {
			resultado = completarData(pedidos);
			useCounter++;
		}
		System.out.println("GOOGLE CONTROL USES: " + useCounter);
		return resultado;
	}

	@Override
	public boolean incrementarTolerancia() {
		return false;
	}
	
	private boolean completarData(List<PedidoNormalizado> pedidos) {
		GeoApiContext context = new GeoApiContext.Builder().apiKey(MAPS_API_KEY).build();
		List<String> waypoints = new ArrayList<>();
		
		for(PedidoNormalizado pedido : pedidos) {
			waypoints.add(pedido.getDomicilio());
		}
		
		try {
			DirectionsResult directionsResult = DirectionsApi.newRequest(context)
					.origin(this.origen)
					.destination(this.destino)
					.waypoints(waypoints.toArray(new String[1]))
					.optimizeWaypoints(true).await();
			
			int[] waypointOrder = directionsResult.routes[0].waypointOrder;
			/*
			 * Cada leg es un punto de paso por pedido (ordenado), 
			 * exceptuando el ultimo por ser retorno
			 */
			DirectionsLeg[] legs = directionsResult.routes[0].legs;
			int index = 0;
			long tiempoCronometrico = 0;
			// Hora de partida según inicio de ventana horaria
			
			SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");
			Calendar tomorrow = Calendar.getInstance();
			tomorrow.add(Calendar.DAY_OF_MONTH, 1);
			Calendar fechaPartida = Calendar.getInstance();
			fechaPartida.setTime(timeFormatter.parse(Parametros.getInicioVentanaHoraria()));
			fechaPartida.set(tomorrow.get(Calendar.YEAR), tomorrow.get(Calendar.MONTH), tomorrow.get(Calendar.DAY_OF_MONTH));
			
			
			long previousLeg = 0;
			for(int orden : waypointOrder) {
				//Solo el primer pedido no considera tiempo de despacho
				tiempoCronometrico += (index==0)?0:(legs[index].duration.inSeconds + Long.valueOf(Parametros.getTiempoPromedioDespacho())*60);
				PedidoNormalizado pedidoActual = pedidos.get(waypointOrder[orden]);
				pedidoActual.setOrden(index + 1);
				pedidoActual.setTiempoCronometrico(tiempoCronometrico);
				pedidoActual.setTiempoEstimadoLlegada((int)legs[index].duration.inSeconds/60);
				
				if(index==0) {
					fechaPartida.add(Calendar.SECOND, ((int)legs[0].duration.inSeconds)*(-1));
				} else {
					fechaPartida.add(Calendar.SECOND, ((int)previousLeg + (Integer.valueOf(Parametros.getTiempoPromedioDespacho())*60)));
				}
				pedidoActual.setFechaEstimadaPartida(fechaPartida.getTime());
				previousLeg = legs[index].duration.inSeconds;
				index++;
			}
			if(tiempoCronometrico > tiempoAcumuladoMaximo) {
				//Exceso en conteo, rechazar!
				//TODO Se deberia hacer rollback de establecimientos?
				return false;
			} 
		} catch (ApiException | InterruptedException | IOException | ParseException e) {
			e.printStackTrace();
		}
		return true;
	}

}
