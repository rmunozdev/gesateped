package pe.com.gesateped.carga.model;

import java.util.Date;

import pe.com.gesateped.model.Bodega;

public class Reposicion {

	private Item item;
	private Bodega bodega;
	private Bodega nodo;
	private Date fecha;
	private Integer cantidad;
	
	public Item getItem() {
		return item;
	}
	public void setItem(Item item) {
		this.item = item;
	}
	public Bodega getBodega() {
		return bodega;
	}
	public void setBodega(Bodega bodega) {
		this.bodega = bodega;
	}
	public Bodega getNodo() {
		return nodo;
	}
	public void setNodo(Bodega nodo) {
		this.nodo = nodo;
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
