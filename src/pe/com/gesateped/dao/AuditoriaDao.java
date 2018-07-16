package pe.com.gesateped.dao;

public interface AuditoriaDao {

	public int registrarInicioProceso(String nombreProceso);
	public void registrarFinProceso(int numeroProceso, boolean isSuccess);
	public int registrarInicioActividad(int numeroProceso,String nombreActividad);
	public void registrarFinActividad(int numeroActividad, boolean isSuccess, String descripcionError);
	
}
