package pe.com.gesateped.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.businesslogic.AdminBL;
import pe.com.gesateped.model.Parametro;
import pe.com.gesateped.model.VentanaHoraria;
import pe.com.gesateped.util.GesatepedUtil;

@Service
public class Parametros {

	private static Map<String, String> parametrosMap;
	private static long lapsoLaborable;
	
	public Parametros(@Autowired AdminBL adminBL) {
		System.out.println("Parametros ready with: " + adminBL);
		List<Parametro> parametros = adminBL.listarParametros();
		parametrosMap = new HashMap<>();
		for (Parametro parametro : parametros) {
			parametrosMap.put(parametro.getNombre(), parametro.getValor());
		}
		List<VentanaHoraria> ventanas = adminBL.obtenerVentanas();
		if(!ventanas.isEmpty()) {
			parametrosMap.put("INICIO_VENTANA_HORARIA", ventanas.get(0).getHoraInicio());
		}
		
		//Generacion de tiempo total
		lapsoLaborable = 0;
		for (VentanaHoraria ventanaHoraria : ventanas) {
			lapsoLaborable += GesatepedUtil.calcularLapsoTiempo(ventanaHoraria.getHoraInicio(), ventanaHoraria.getHoraFin());
		}
	}


	public static String getHoraEjecucion() {
		return parametrosMap.get("HOR_EJEC_PROC");
	}


	public static String getHoraSalidaUnidades() {
		return parametrosMap.get("HOR_SAL_UNID_BOD");
	}


	public static String getTiempoPromedioDespacho() {
		return parametrosMap.get("TIEMP_PROM_DESP");
	}


	public static String getFactorPesoCarga() {
		return parametrosMap.get("FACT_PES_CARG");
	}


	public static String getFactorVolumenCarga() {
		return parametrosMap.get("FACT_VOL_CARG");
	}


	public static String getDirectorioDestinoHojaRuta() {
		return parametrosMap.get("RUT_GEN_HOJ_RUT");
	}
	
	public static String getInicioVentanaHoraria() {
		return parametrosMap.get("INICIO_VENTANA_HORARIA");
	}

	public static long getLapsoLaborable() {
		return lapsoLaborable;
	}
	
	/**
	 * Minutos antes de la finalización de una ventana horaria,
	 * para la ejecución de alertas.
	 * @return
	 */
	public static String getLapsoCritico() {
		return parametrosMap.get("MIN_ADVERT_VENT_HOR");
	}
	
	
	public static boolean flagNotificacionActivada() {
		return new Boolean(parametrosMap.get("FLAG_NOTIF_VENT_HOR"));
	}
	
	public static String getNotificacionWSURL() {
		return parametrosMap.get("URL_WS_NOTIF_VENT_HOR");
	}
	
	/****************** GOOGLE MAPS PARAMS ******************/
	public static String getDirectionsAPIKEY() {
		return parametrosMap.get("KEY_API_DIRECTIONS");
	}
	
	/****************** FIREBASE PARAMS ******************/
	public static String getFirebaseAPIKEY() {
		return parametrosMap.get("KEY_FIREBASE");
	}
	
	public static String getFirebaseAuthDomain() {
		return parametrosMap.get("AUTH_DOMAIN");
	}
	
	public static String getFirebaseDatabaseURL() {
		return parametrosMap.get("DATABASE_URL");
	}
	
	public static String getFirebaseProjectId() {
		return parametrosMap.get("PROJECT_ID");
	}
	
	public static String getFirebaseStorageBucket() {
		return parametrosMap.get("STORAGE_BUCKET");
	}
	
	public static String getFirebaseMessageSenderId() {
		return parametrosMap.get("MESSAGING_SENDER_ID");
	}
	
}
