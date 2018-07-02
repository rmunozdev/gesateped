package pe.com.gesateped.model.extend;

public class UnidadNormalizada implements Medible {

	private String numeroPlaca;
	private String soat;
	private String nombreChofer;
	private String breveteChofer;
	private double pesoCargaMaxima;
	private double volumenCargaMaxima;
	private String codigoUnidadChofer;
	
	public String getNumeroPlaca() {
		return numeroPlaca;
	}
	public void setNumeroPlaca(String numeroPlaca) {
		this.numeroPlaca = numeroPlaca;
	}
	
	@Override
	public double getPeso() {
		return this.pesoCargaMaxima;
	}
	@Override
	public double getVolumen() {
		return this.volumenCargaMaxima;
	}
	
	public void setPesoCargaMaxima(double pesoCargaMaxima) {
		this.pesoCargaMaxima = pesoCargaMaxima;
	}
	
	public void setVolumenCargaMaxima(double volumenCargaMaxima) {
		this.volumenCargaMaxima = volumenCargaMaxima;
	}
	
	@Override
	public boolean equals(Object obj) {
		return this.numeroPlaca.equals(((UnidadNormalizada)obj).numeroPlaca);
	}
	public String getSoat() {
		return soat;
	}
	public void setSoat(String soat) {
		this.soat = soat;
	}
	public String getNombreChofer() {
		return nombreChofer;
	}
	public void setNombreChofer(String nombreChofer) {
		this.nombreChofer = nombreChofer;
	}
	public String getBreveteChofer() {
		return breveteChofer;
	}
	public void setBreveteChofer(String breveteChofer) {
		this.breveteChofer = breveteChofer;
	}
	public double getPesoCargaMaxima() {
		return pesoCargaMaxima;
	}
	public double getVolumenCargaMaxima() {
		return volumenCargaMaxima;
	}
	public String getCodigoUnidadChofer() {
		return codigoUnidadChofer;
	}
	public void setCodigoUnidadChofer(String codigoUnidadChofer) {
		this.codigoUnidadChofer = codigoUnidadChofer;
	}
}
