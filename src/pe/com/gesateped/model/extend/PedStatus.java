package pe.com.gesateped.model.extend;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_NULL)
public class PedStatus {

	private String codigoHojaRuta;
	private int atendidos;
	private int noAtendidos;
	private int pendientes;
	private int reprogramados;
	private int cancelados;
	
	public int getAtendidos() {
		return atendidos;
	}
	public void setAtendidos(int atendidos) {
		this.atendidos = atendidos;
	}
	public int getNoAtendidos() {
		return noAtendidos;
	}
	public void setNoAtendidos(int noAtendidos) {
		this.noAtendidos = noAtendidos;
	}
	public int getPendientes() {
		return pendientes;
	}
	public void setPendientes(int pendientes) {
		this.pendientes = pendientes;
	}
	public int getReprogramados() {
		return reprogramados;
	}
	public void setReprogramados(int reprogramados) {
		this.reprogramados = reprogramados;
	}
	public int getCancelados() {
		return cancelados;
	}
	public void setCancelados(int cancelados) {
		this.cancelados = cancelados;
	}
	public String getCodigoHojaRuta() {
		return codigoHojaRuta;
	}
	public void setCodigoHojaRuta(String codigoHojaRuta) {
		this.codigoHojaRuta = codigoHojaRuta;
	}
	
	
}
