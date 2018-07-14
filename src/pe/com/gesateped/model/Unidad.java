package pe.com.gesateped.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_NULL)
public class Unidad {

	private String codigoHojaRuta;
	private String numeroPlaca;
	private String nombreChofer;
	private String apellidoChofer;
	private String telefonoChofer;
	private int totalPedidosAtendidos;
	private int totalPedidos;
	
	public String getCodigoHojaRuta() {
		return codigoHojaRuta;
	}
	public void setCodigoHojaRuta(String codigoHojaRuta) {
		this.codigoHojaRuta = codigoHojaRuta;
	}
	public String getNumeroPlaca() {
		return numeroPlaca;
	}
	public void setNumeroPlaca(String numeroPlaca) {
		this.numeroPlaca = numeroPlaca;
	}
	public String getNombreChofer() {
		return nombreChofer;
	}
	public void setNombreChofer(String nombreChofer) {
		this.nombreChofer = nombreChofer;
	}
	public String getApellidoChofer() {
		return apellidoChofer;
	}
	public void setApellidoChofer(String apellidoChofer) {
		this.apellidoChofer = apellidoChofer;
	}
	public String getTelefonoChofer() {
		return telefonoChofer;
	}
	public void setTelefonoChofer(String telefonoChofer) {
		this.telefonoChofer = telefonoChofer;
	}
	
	public int getTotalPedidos() {
		return totalPedidos;
	}
	public void setTotalPedidos(int totalPedidos) {
		this.totalPedidos = totalPedidos;
	}
	public int getTotalPedidosAtendidos() {
		return totalPedidosAtendidos;
	}
	public void setTotalPedidosAtendidos(int totalPedidosAtendidos) {
		this.totalPedidosAtendidos = totalPedidosAtendidos;
	}
	
	
	
	
}
