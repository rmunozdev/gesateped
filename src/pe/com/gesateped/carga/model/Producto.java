package pe.com.gesateped.carga.model;

import org.jsefa.csv.annotation.CsvDataType;
import org.jsefa.csv.annotation.CsvField;


@CsvDataType
public class Producto {

	@CsvField(pos=0,required=true)
	private String codigo;
	
	@CsvField(pos=1,required=true)
	private String nombre;
	
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
	
	@Override
	public String toString() {
		return String.format("<Producto %s - %s>", codigo, nombre);
	}
}
