package pe.com.gesateped.carga.model;

import org.jsefa.csv.annotation.CsvDataType;
import org.jsefa.csv.annotation.CsvField;

@CsvDataType
public class Item {

	@CsvField(pos=0)
	private Producto producto;
	
	@CsvField(pos=2,required=true)
	private Integer cantidad;
	
	/**
	 * Linea que corresponde al origen de este item,
	 * obtenido a partir de la fuente (ejem. CSV)
	 * 
	 */
	private Integer linea;


	public Integer getCantidad() {
		return cantidad;
	}

	public void setCantidad(Integer cantidad) {
		this.cantidad = cantidad;
	}
	
	@Override
	public String toString() {
		return String.format("<Item: [%s] [%s]>", producto, cantidad);
	}

	public Producto getProducto() {
		return producto;
	}

	public void setProducto(Producto producto) {
		this.producto = producto;
	}

	public Integer getLinea() {
		return linea;
	}

	public void setLinea(Integer linea) {
		this.linea = linea;
	}
	
}
