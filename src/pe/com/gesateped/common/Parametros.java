package pe.com.gesateped.common;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.businesslogic.AdminBL;
import pe.com.gesateped.model.Parametro;
import pe.com.gesateped.model.VentanaHoraria;

@Service
public class Parametros {

	private static Map<String, String> parametrosMap;
	
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
	
}
