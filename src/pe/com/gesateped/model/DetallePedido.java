package pe.com.gesateped.model;

public class DetallePedido {

	private String codigo;
	private String codigoProducto;
	private int cantidadProducto;
	private int cantidadProductoDefectuoso;
	private String observacionProductoDefectuoso;
	private int cantidadProductoNoUbicado;
	private String codigoBodega;
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getCodigoProducto() {
		return codigoProducto;
	}
	public void setCodigoProducto(String codigoProducto) {
		this.codigoProducto = codigoProducto;
	}
	public int getCantidadProducto() {
		return cantidadProducto;
	}
	public void setCantidadProducto(int cantidadProducto) {
		this.cantidadProducto = cantidadProducto;
	}
	public int getCantidadProductoDefectuoso() {
		return cantidadProductoDefectuoso;
	}
	public void setCantidadProductoDefectuoso(int cantidadProductoDefectuoso) {
		this.cantidadProductoDefectuoso = cantidadProductoDefectuoso;
	}
	public String getObservacionProductoDefectuoso() {
		return observacionProductoDefectuoso;
	}
	public void setObservacionProductoDefectuoso(String observacionProductoDefectuoso) {
		this.observacionProductoDefectuoso = observacionProductoDefectuoso;
	}
	public int getCantidadProductoNoUbicado() {
		return cantidadProductoNoUbicado;
	}
	public void setCantidadProductoNoUbicado(int cantidadProductoNoUbicado) {
		this.cantidadProductoNoUbicado = cantidadProductoNoUbicado;
	}
	public String getCodigoBodega() {
		return codigoBodega;
	}
	public void setCodigoBodega(String codigoBodega) {
		this.codigoBodega = codigoBodega;
	}
	
	
	
}
