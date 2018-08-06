package pe.com.gesateped.businesslogic.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import pe.com.gesateped.businesslogic.AuditoriaBL;
import pe.com.gesateped.dao.AuditoriaDao;
import pe.com.gesateped.model.Actividad;
import pe.com.gesateped.model.Proceso;

@Scope(value="singleton")
@Service
public class AuditoriaBLImpl implements AuditoriaBL {

	@Autowired
	private AuditoriaDao auditoriaDao;
	
	private Proceso procesoActual;
	private Map<String, Actividad> actividades;
	
	
	@Override
	public void iniciarProceso(String nombreProceso) {
		this.procesoActual = new Proceso();
		this.actividades = new HashMap<>();
		this.procesoActual.setNumero(this.auditoriaDao.registrarInicioProceso(nombreProceso));
	}

	@Override
	public void finalizarProceso(boolean isSuccess) {
		this.actividades.clear();
		this.auditoriaDao.registrarFinProceso(this.procesoActual.getNumero(), isSuccess);
	}

	@Override
	public void iniciarActividad(String nombre) {
		Actividad actividad = new Actividad();
		actividad.setNombre(nombre);
		actividad.setProceso(procesoActual);
		this.auditoriaDao.registrarInicioActividad(actividad);
		actividades.put(nombre, actividad);
	}

	@Override
	public void finalizarActividad(String nombre, boolean isSuccess, String mensaje) {
		System.out.println(mensaje);
		Actividad actividad = actividades.get(nombre);
		if(isSuccess) {
			actividad.setMensaje(mensaje);
			actividad.setEstado("SUCCESS");
		} else {
			actividad.setError(mensaje);
			actividad.setEstado("ERROR");
		}
		this.auditoriaDao.registrarFinActividad(actividad);
	}

	

}
