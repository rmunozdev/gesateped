package pe.com.gesateped.model;

import java.util.Date;

public class DisponibilidadUnidad {

	private String codigo;
	private String numeroPlacaUnidad;
	private String numeroLicenciaChofer;
	private Date fechaDisponible;
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNumeroPlacaUnidad() {
		return numeroPlacaUnidad;
	}
	public void setNumeroPlacaUnidad(String numeroPlacaUnidad) {
		this.numeroPlacaUnidad = numeroPlacaUnidad;
	}
	public String getNumeroLicenciaChofer() {
		return numeroLicenciaChofer;
	}
	public void setNumeroLicenciaChofer(String numeroLicenciaChofer) {
		this.numeroLicenciaChofer = numeroLicenciaChofer;
	}
	public Date getFechaDisponible() {
		return fechaDisponible;
	}
	public void setFechaDisponible(Date fechaDisponible) {
		this.fechaDisponible = fechaDisponible;
	}
	
	
}
