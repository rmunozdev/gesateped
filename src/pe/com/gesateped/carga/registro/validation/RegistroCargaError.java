package pe.com.gesateped.carga.registro.validation;

import pe.com.gesateped.carga.model.Carga;
import pe.com.gesateped.carga.model.Item;

public class RegistroCargaError {

	private RegistroCargaErrorCode codigo;
	private Carga carga;
	private Item item;
	private Integer linea;
	private String campo;
	private boolean reposicion;
	
	public String getCampo() {
		return campo;
	}
	public void setCampo(String campo) {
		this.campo = campo;
	}
	public RegistroCargaErrorCode getCodigo() {
		return codigo;
	}
	public void setCodigo(RegistroCargaErrorCode codigo) {
		this.codigo = codigo;
	}
	public Integer getLinea() {
		return linea;
	}
	public void setLinea(Integer linea) {
		this.linea = linea;
	}
	public Item getItem() {
		return item;
	}
	public void setItem(Item item) {
		this.item = item;
	}
	public Carga getCarga() {
		return carga;
	}
	public void setCarga(Carga carga) {
		this.carga = carga;
	}
	public boolean isReposicion() {
		return reposicion;
	}
	public void setReposicion(boolean reposicion) {
		this.reposicion = reposicion;
	}
	
}
