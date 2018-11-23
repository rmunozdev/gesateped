package pe.com.gesateped.notificacion.abastecimiento.model;

import pe.com.gesateped.model.Kardex;

public class Notificable {

	private Kardex kardex;
	private String estado;
	private boolean alerta = false;
	
	public Kardex getKardex() {
		return kardex;
	}
	public void setKardex(Kardex kardex) {
		this.kardex = kardex;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public boolean isAlerta() {
		return alerta;
	}
	public void setAlerta(boolean alerta) {
		this.alerta = alerta;
	}
	
}
