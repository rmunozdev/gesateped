package pe.com.gesateped.model;

import java.util.Date;

public class DetalleHojaRuta {

	private String codigoHojaRuta;
	private String codigoPedido;
	private int ordenDespacho;
	private int tiempoPromedio;
	private Date fechaEstimadaPartida;
	private int tiempoEstimadoLlegada;
	private Date fechaEstimadaLlegada;
	private Date fechaPactadaDespacho;
	private String codigoVentanaHoraria;
	
	public String getCodigoHojaRuta() {
		return codigoHojaRuta;
	}
	public void setCodigoHojaRuta(String codigoHojaRuta) {
		this.codigoHojaRuta = codigoHojaRuta;
	}
	public String getCodigoPedido() {
		return codigoPedido;
	}
	public void setCodigoPedido(String codigoPedido) {
		this.codigoPedido = codigoPedido;
	}
	public int getOrdenDespacho() {
		return ordenDespacho;
	}
	public void setOrdenDespacho(int ordenDespacho) {
		this.ordenDespacho = ordenDespacho;
	}
	public int getTiempoPromedio() {
		return tiempoPromedio;
	}
	public void setTiempoPromedio(int tiempoPromedio) {
		this.tiempoPromedio = tiempoPromedio;
	}
	public Date getFechaEstimadaPartida() {
		return fechaEstimadaPartida;
	}
	public void setFechaEstimadaPartida(Date fechaEstimadaPartida) {
		this.fechaEstimadaPartida = fechaEstimadaPartida;
	}
	public int getTiempoEstimadoLlegada() {
		return tiempoEstimadoLlegada;
	}
	public void setTiempoEstimadoLlegada(int tiempoEstimadoLlegada) {
		this.tiempoEstimadoLlegada = tiempoEstimadoLlegada;
	}
	public Date getFechaEstimadaLlegada() {
		return fechaEstimadaLlegada;
	}
	public void setFechaEstimadaLlegada(Date fechaEstimadaLlegada) {
		this.fechaEstimadaLlegada = fechaEstimadaLlegada;
	}
	public Date getFechaPactadaDespacho() {
		return fechaPactadaDespacho;
	}
	public void setFechaPactadaDespacho(Date fechaPactadaDespacho) {
		this.fechaPactadaDespacho = fechaPactadaDespacho;
	}
	public String getCodigoVentanaHoraria() {
		return codigoVentanaHoraria;
	}
	public void setCodigoVentanaHoraria(String codigoVentanaHoraria) {
		this.codigoVentanaHoraria = codigoVentanaHoraria;
	}
	
	
	
}
