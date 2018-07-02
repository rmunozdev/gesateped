package pe.com.gesateped.model;

public class Kardex {

	public String codigoBodega;
	public String codigoProducto;
	public int stockMinimo;
	public int stockActual;
	public int cantidadAbast;
	
	public String getCodigoBodega() {
		return codigoBodega;
	}
	public void setCodigoBodega(String codigoBodega) {
		this.codigoBodega = codigoBodega;
	}
	public String getCodigoProducto() {
		return codigoProducto;
	}
	public void setCodigoProducto(String codigoProducto) {
		this.codigoProducto = codigoProducto;
	}
	public int getStockMinimo() {
		return stockMinimo;
	}
	public void setStockMinimo(int stockMinimo) {
		this.stockMinimo = stockMinimo;
	}
	public int getStockActual() {
		return stockActual;
	}
	public void setStockActual(int stockActual) {
		this.stockActual = stockActual;
	}
	public int getCantidadAbast() {
		return cantidadAbast;
	}
	public void setCantidadAbast(int cantidadAbast) {
		this.cantidadAbast = cantidadAbast;
	}
	
	
}
