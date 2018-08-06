package pe.com.gesateped.businesslogic;

public interface AuditoriaBL {
	
	public void iniciarProceso(String nombreProceso);
	public void finalizarProceso(boolean isSuccess);
	public void iniciarActividad(String nombre);
	public void finalizarActividad(String nombre, boolean isSuccess, String mensaje);
}
