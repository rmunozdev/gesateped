package pe.com.gesateped.businesslogic;

public interface AuditoriaBL {
	
	public int registrarInicioProceso(String nombreProceso);
	public void registrarFinProceso(int numeroProceso, boolean isSuccess);
	public int registrarInicioActividad(int numeroProceso, String nombreActividad);
	public void registrarFinActividad(int numeroActividad);
	public void registrarFinActividad(int numeroActividad, String descripcionError);
}
