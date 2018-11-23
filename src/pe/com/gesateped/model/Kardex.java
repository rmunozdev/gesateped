package pe.com.gesateped.model;

import java.util.Date;

public class Kardex {

	private Bodega bodega;
	private Producto producto;
	private Integer stockMinimo;
	private Integer stockActual;
	private Date actualRegistro;
	private Date notificacionAbastecimiento;
	private Date maximoAbastecimiento;
	
	public Bodega getBodega() {
		return bodega;
	}
	public void setBodega(Bodega bodega) {
		this.bodega = bodega;
	}
	public Producto getProducto() {
		return producto;
	}
	public void setProducto(Producto producto) {
		this.producto = producto;
	}
	public Integer getStockMinimo() {
		return stockMinimo;
	}
	public void setStockMinimo(Integer stockMinimo) {
		this.stockMinimo = stockMinimo;
	}
	public Integer getStockActual() {
		return stockActual;
	}
	public void setStockActual(Integer stockActual) {
		this.stockActual = stockActual;
	}
	public Date getActualRegistro() {
		return actualRegistro;
	}
	public void setActualRegistro(Date actualRegistro) {
		this.actualRegistro = actualRegistro;
	}
	public Date getNotificacionAbastecimiento() {
		return notificacionAbastecimiento;
	}
	public void setNotificacionAbastecimiento(Date notificacionAbastecimiento) {
		this.notificacionAbastecimiento = notificacionAbastecimiento;
	}
	public Date getMaximoAbastecimiento() {
		return maximoAbastecimiento;
	}
	public void setMaximoAbastecimiento(Date maximoAbastecimiento) {
		this.maximoAbastecimiento = maximoAbastecimiento;
	}
	
}
