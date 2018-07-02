package pe.com.gesateped.model;

import java.util.Date;

public class HojaRuta {
	
	private String codigo;
	private Date fechaGeneracion;
	private Date fechaDespacho;
	private String codigoBodega;
	private String codigoDisponibilidadUnidad;
	private String codigoCuadrilla;
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public Date getFechaGeneracion() {
		return fechaGeneracion;
	}
	public void setFechaGeneracion(Date fechaGeneracion) {
		this.fechaGeneracion = fechaGeneracion;
	}
	public Date getFechaDespacho() {
		return fechaDespacho;
	}
	public void setFechaDespacho(Date fechaDespacho) {
		this.fechaDespacho = fechaDespacho;
	}
	public String getCodigoBodega() {
		return codigoBodega;
	}
	public void setCodigoBodega(String codigoBodega) {
		this.codigoBodega = codigoBodega;
	}
	public String getCodigoDisponibilidadUnidad() {
		return codigoDisponibilidadUnidad;
	}
	public void setCodigoDisponibilidadUnidad(String codigoDisponibilidadUnidad) {
		this.codigoDisponibilidadUnidad = codigoDisponibilidadUnidad;
	}
	public String getCodigoCuadrilla() {
		return codigoCuadrilla;
	}
	public void setCodigoCuadrilla(String codigoCuadrilla) {
		this.codigoCuadrilla = codigoCuadrilla;
	}

}
