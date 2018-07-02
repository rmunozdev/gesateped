package pe.com.gesateped.model;

import java.util.Date;

public class Cuadrilla {

	private String codigo;
	private String nombre;
	private Date fechaIniAsign;
	private Date fechaFinAsign;
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public Date getFechaIniAsign() {
		return fechaIniAsign;
	}
	public void setFechaIniAsign(Date fechaIniAsign) {
		this.fechaIniAsign = fechaIniAsign;
	}
	public Date getFechaFinAsign() {
		return fechaFinAsign;
	}
	public void setFechaFinAsign(Date fechaFinAsign) {
		this.fechaFinAsign = fechaFinAsign;
	}
	
	
	
}
