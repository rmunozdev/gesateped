package pe.com.gesateped.model;

import java.util.Date;

public class Actividad {

	private Proceso proceso;
	private Integer numero;
	private String nombre;
	private Date inicioEjecucion;
	private Date finEjecucion;
	private String mensaje;
	private String error;
	private String estado;
	
	public Proceso getProceso() {
		return proceso;
	}
	public void setProceso(Proceso proceso) {
		this.proceso = proceso;
	}
	public Integer getNumero() {
		return numero;
	}
	public void setNumero(Integer numero) {
		this.numero = numero;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public Date getInicioEjecucion() {
		return inicioEjecucion;
	}
	public void setInicioEjecucion(Date inicioEjecucion) {
		this.inicioEjecucion = inicioEjecucion;
	}
	public Date getFinEjecucion() {
		return finEjecucion;
	}
	public void setFinEjecucion(Date finEjecucion) {
		this.finEjecucion = finEjecucion;
	}
	public String getMensaje() {
		return mensaje;
	}
	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	
	
}
