package pe.com.gesateped.carga.model;

import java.util.Date;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Proveedor;

public class Abastecimiento {

	private Item item;
	private Proveedor proveedor;
	private Bodega bodega;
	private Date fecha;
	private Integer cantidad;
	
	public Item getItem() {
		return item;
	}
	public void setItem(Item item) {
		this.item = item;
	}
	public Proveedor getProveedor() {
		return proveedor;
	}
	public void setProveedor(Proveedor proveedor) {
		this.proveedor = proveedor;
	}
	public Bodega getBodega() {
		return bodega;
	}
	public void setBodega(Bodega bodega) {
		this.bodega = bodega;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public Integer getCantidad() {
		return cantidad;
	}
	public void setCantidad(Integer cantidad) {
		this.cantidad = cantidad;
	}
}
