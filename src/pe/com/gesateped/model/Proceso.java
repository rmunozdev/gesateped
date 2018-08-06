package pe.com.gesateped.model;

import java.util.Date;

public class Proceso {

	private Integer numero;
	private String nombre;
	private Date inicioEjecucion;
	private Date finEjecucion;
	private String estado;
	
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
	
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
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
}
