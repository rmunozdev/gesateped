package pe.com.gesateped.dao;

import pe.com.gesateped.model.Actividad;

public interface AuditoriaDao {

	public int registrarInicioProceso(String nombreProceso);
	public void registrarFinProceso(int numeroProceso, boolean isSuccess);
	public Actividad registrarInicioActividad(Actividad actividad);
	public void registrarFinActividad(Actividad actividad);
	
}
