package pe.com.gesateped.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_NULL)
public class Bodega {

	private String codigo;
	private String nombre;
	private String direccion;
	private String codigoDistrito;
	private String zonaCobertura;
	private String tipoBodega;
	private String emailBodega;
	
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
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getCodigoDistrito() {
		return codigoDistrito;
	}
	public void setCodigoDistrito(String codigoDistrito) {
		this.codigoDistrito = codigoDistrito;
	}
	public String getZonaCobertura() {
		return zonaCobertura;
	}
	public void setZonaCobertura(String zonaCobertura) {
		this.zonaCobertura = zonaCobertura;
	}
	
	@Override
	public boolean equals(Object obj) {
		return (this.getCodigo().equals(((Bodega)obj).codigo));
	}
	public String getTipoBodega() {
		return tipoBodega;
	}
	public void setTipoBodega(String tipoBodega) {
		this.tipoBodega = tipoBodega;
	}
	public String getEmailBodega() {
		return emailBodega;
	}
	public void setEmailBodega(String emailBodega) {
		this.emailBodega = emailBodega;
	}
}
