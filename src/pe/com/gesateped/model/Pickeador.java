package pe.com.gesateped.model;

import java.util.Date;

public class Pickeador {

	public String codigo;
	public String nombres;
	public String apellidos;
	public Date fechaNacimiento;
	public Date fechaIngreso;
	public String codigoCuadrilla;
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombres() {
		return nombres;
	}
	public void setNombres(String nombres) {
		this.nombres = nombres;
	}
	public String getApellidos() {
		return apellidos;
	}
	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}
	public Date getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(Date fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public Date getFechaIngreso() {
		return fechaIngreso;
	}
	public void setFechaIngreso(Date fechaIngreso) {
		this.fechaIngreso = fechaIngreso;
	}
	public String getCodigoCuadrilla() {
		return codigoCuadrilla;
	}
	public void setCodigoCuadrilla(String codigoCuadrilla) {
		this.codigoCuadrilla = codigoCuadrilla;
	}
	
	
	
}
