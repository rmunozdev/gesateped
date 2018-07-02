package pe.com.gesateped.model;

public class Producto {

	private String codigo;
	private String nombre;
	private double precioUnitario;
	private double volumen;
	private double peso;
	private String codigoTipoProducto;
	private String codigoFamiliaProducto;
	
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
	public double getPrecioUnitario() {
		return precioUnitario;
	}
	public void setPrecioUnitario(double precioUnitario) {
		this.precioUnitario = precioUnitario;
	}
	public double getVolumen() {
		return volumen;
	}
	public void setVolumen(double volumen) {
		this.volumen = volumen;
	}
	public double getPeso() {
		return peso;
	}
	public void setPeso(double peso) {
		this.peso = peso;
	}
	public String getCodigoTipoProducto() {
		return codigoTipoProducto;
	}
	public void setCodigoTipoProducto(String codigoTipoProducto) {
		this.codigoTipoProducto = codigoTipoProducto;
	}
	public String getCodigoFamiliaProducto() {
		return codigoFamiliaProducto;
	}
	public void setCodigoFamiliaProducto(String codigoFamiliaProducto) {
		this.codigoFamiliaProducto = codigoFamiliaProducto;
	}
	
	
}
