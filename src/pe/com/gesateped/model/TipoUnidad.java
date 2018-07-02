package pe.com.gesateped.model;

public class TipoUnidad {

	private String codigo;
	private String nombreTipoUnidad;
	private double pesoMaximoCarga;
	private double volumenMaximoCarga;
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getNombreTipoUnidad() {
		return nombreTipoUnidad;
	}
	public void setNombreTipoUnidad(String nombreTipoUnidad) {
		this.nombreTipoUnidad = nombreTipoUnidad;
	}
	public double getPesoMaximoCarga() {
		return pesoMaximoCarga;
	}
	public void setPesoMaximoCarga(double pesoMaximoCarga) {
		this.pesoMaximoCarga = pesoMaximoCarga;
	}
	public double getVolumenMaximoCarga() {
		return volumenMaximoCarga;
	}
	public void setVolumenMaximoCarga(double volumenMaximoCarga) {
		this.volumenMaximoCarga = volumenMaximoCarga;
	}
	
	
	
	
}
