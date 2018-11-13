package pe.com.gesateped.carga.model;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Proveedor;

public class Carga {

	private String tipo;
	private Proveedor proveedor;
	private Bodega bodega;
	private Bodega nodo;
	
	@DateTimeFormat(pattern="dd/MM/yyyy")
	private Date fecha;
	private List<Item> items;
	
	private MultipartFile file;
	
	public Proveedor getProveedor() {
		return proveedor;
	}
	public void setProveedor(Proveedor proveedor) {
		this.proveedor = proveedor;
	}
	public List<Item> getItems() {
		return items;
	}
	public void setItems(List<Item> items) {
		this.items = items;
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
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	
	
	
}
