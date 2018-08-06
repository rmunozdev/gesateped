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
import com.google.maps.model.TravelMode;

import pe.com.gesateped.batch.algorithm.Controlador;
import pe.com.gesateped.common.Parametros;
import pe.com.gesateped.model.extend.PedidoNormalizado;

public class GoogleControl implements Controlador {

	private static final String MAPS_API_KEY = "AIzaSyC5zx6JgWVPftfjOPJybTKhKUwhN5zVxJI";

	private static final String LOG_PATTERN_USOS = "GOOGLE: Query número %s para origen %s";
	private static final String LOG_PATTERN_SUCCESS = "GOOGLE: Query exitoso para %s pedidos, con demora total: %s \n\tDetalle: %s";
	private static final String LOG_PATTERN_FAIL = "GOOGLE: Query fallo para %s pedidos, con demora total: %s \\n\\tDetalle: %s";
	
	private static final int MAX_WAYPOINTS = 23;
	private static final int MAX_USES = 100;
	
	private String origen;
	private String destino;
	
	private int useCounter = 1;
	
	
	public GoogleControl(String origen, String destino) {
		System.out.println("Lapso Laborable: " + Parametros.getLapsoLaborable());
		this.origen = origen;
		this.destino = destino;
	}

	@Override
	public boolean verificar(List<PedidoNormalizado> pedidos) {
		boolean resultado = false;
		System.out.println(String.format(LOG_PATTERN_USOS, useCounter,this.origen));
		if(pedidos.size()<MAX_WAYPOINTS && useCounter < MAX_USES) {
			resultado = queryGoogleDirections(pedidos);
			useCounter++;
		}
		return resultado;
	}

	@Override
	public boolean incrementarTolerancia() {
		return false;
	}
	
	private boolean queryGoogleDirections(List<PedidoNormalizado> pedidos) {
		GeoApiContext context = new GeoApiContext.Builder().apiKey(MAPS_API_KEY).build();
		List<String> waypoints = new ArrayList<>();
		
		for(PedidoNormalizado pedido : pedidos) {
			waypoints.add(pedido.getDomicilio() + " Peru");
		}
		try {
			DirectionsResult directionsResult = DirectionsApi.newRequest(context)
					.origin(this.origen + " Peru")
					.destination(this.destino + " Peru")
					.waypoints(waypoints.toArray(new String[waypoints.size()]))
					.mode(TravelMode.DRIVING)
					.optimizeWaypoints(true).await();
			if(directionsResult.routes.length == 0) {
				return false;
			}
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
			
			List<String> direccionesOrdenadas = new ArrayList<>();
			for(int orden : waypointOrder) {
				//Solo el primer pedido no considera tiempo de despacho
				tiempoCronometrico += (index==0)?0:(legs[index].duration.inSeconds + Long.valueOf(Parametros.getTiempoPromedioDespacho())*60);
				PedidoNormalizado pedidoActual = pedidos.get(orden);
				pedidoActual.setOrden(index + 1);
				pedidoActual.setTiempoCronometrico(tiempoCronometrico);
				pedidoActual.setTiempoEstimadoLlegada((int)legs[index].duration.inSeconds/60);
				
				//Distancia aprox
				pedidoActual.setDistanciaMetros(legs[index].distance.inMeters);
				
				
				if(index==0) {
					fechaPartida.add(Calendar.SECOND, ((int)legs[0].duration.inSeconds)*(-1));
				} else {
					fechaPartida.add(Calendar.SECOND, ((int)previousLeg + (Integer.valueOf(Parametros.getTiempoPromedioDespacho())*60)));
				}
				pedidoActual.setFechaEstimadaPartida(fechaPartida.getTime());
				previousLeg = legs[index].duration.inSeconds;
				index++;
				direccionesOrdenadas.add(pedidoActual.getDomicilio());
			}
			if(tiempoCronometrico > Parametros.getLapsoLaborable()) {
				//TODO Se deberia hacer rollback de establecimientos?
				System.out.println(String.format(LOG_PATTERN_FAIL, pedidos.size(),tiempoCronometrico ,pedidos));
				return false;
			} else {
				System.out.println(String.format(LOG_PATTERN_SUCCESS, pedidos.size(),tiempoCronometrico ,pedidos));
			}
		} catch (ApiException | InterruptedException | IOException | ParseException e) {
			e.printStackTrace();
		}
		return true;
	}

}
