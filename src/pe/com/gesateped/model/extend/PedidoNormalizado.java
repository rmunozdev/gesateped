package pe.com.gesateped.model.extend;

import java.util.Date;

/**
 * Representa una agregación de data relacionada a un pedido, para fines de
 * operacion dentro del algoritmos de filtrado, recorrido y control.
 * 
 * @author rmunozdev
 *
 */
public class PedidoNormalizado implements Medible {

	private String codigoPedido;

	// Campos para generacion de reporte
	private Integer orden;
	private String cliente;
	private String tienda;
	private String codigoHojaRuta;
	private String ventana;
	private Date fechaDespacho;
	
	//Requerido al usar google maps directions
	private long tiempoCronometrico; //Tiempo (segundos) transcurrido basado en el orden
	
	private Integer tiempoPromedioDespacho;
	private Date fechaEstimadaPartida;
	private Integer tiempoEstimadoLlegada;
	private Date fechaEstimadaLlegada;
	
	
	private Date fechaPactadaDespacho;
	private double latitudGpsDespacho;
	private double longitudGpsDespacho;
	private String codigoVentanaHoraria;

	/*
	 * Campos para filtrado, algunos pueden ya estar filtrados desde origen (Request
	 * BD, etc)
	 */
	private String codigoBodega;
	private TipoPedido tipoPedido;
	private String codigoZonaCobertura;

	// Campos para control (También pueden usarse para filtro previo)
	private String domicilio;
	private double peso;
	private double volumen;
	private int demora;

	public String getCodigoPedido() {
		return codigoPedido;
	}

	public void setCodigoPedido(String codigoPedido) {
		this.codigoPedido = codigoPedido;
	}

	public String getCodigoBodega() {
		return codigoBodega;
	}

	public void setCodigoBodega(String codigoBodega) {
		this.codigoBodega = codigoBodega;
	}

	public TipoPedido getTipoPedido() {
		return tipoPedido;
	}

	public void setTipoPedido(TipoPedido tipoPedido) {
		this.tipoPedido = tipoPedido;
	}

	public String getCodigoZonaCobertura() {
		return codigoZonaCobertura;
	}

	public void setCodigoZonaCobertura(String codigoZonaCobertura) {
		this.codigoZonaCobertura = codigoZonaCobertura;
	}

	public String getDomicilio() {
		return domicilio;
	}

	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}

	public double getPeso() {
		return peso;
	}

	public void setPeso(double peso) {
		this.peso = peso;
	}

	public double getVolumen() {
		return volumen;
	}

	public void setVolumen(double volumen) {
		this.volumen = volumen;
	}

	public int getDemora() {
		return demora;
	}

	public void setDemora(int demora) {
		this.demora = demora;
	}

	@Override
	public boolean equals(Object obj) {
		PedidoNormalizado comparable = (PedidoNormalizado) obj;
		return this.codigoPedido.equals(comparable.getCodigoPedido());
	}

	public String getCliente() {
		return cliente;
	}

	public void setCliente(String cliente) {
		this.cliente = cliente;
	}

	public String getCodigoHojaRuta() {
		return codigoHojaRuta;
	}

	public void setCodigoHojaRuta(String codigoHojaRuta) {
		this.codigoHojaRuta = codigoHojaRuta;
	}

	public Date getFechaDespacho() {
		return fechaDespacho;
	}

	public void setFechaDespacho(Date fechaDespacho) {
		this.fechaDespacho = fechaDespacho;
	}

	public Integer getOrden() {
		return orden;
	}

	public void setOrden(Integer orden) {
		this.orden = orden;
	}

	public Date getFechaPactadaDespacho() {
		return fechaPactadaDespacho;
	}

	public void setFechaPactadaDespacho(Date fechaPactadaDespacho) {
		this.fechaPactadaDespacho = fechaPactadaDespacho;
	}

	public double getLatitudGpsDespacho() {
		return latitudGpsDespacho;
	}

	public void setLatitudGpsDespacho(double latitudGpsDespacho) {
		this.latitudGpsDespacho = latitudGpsDespacho;
	}

	public double getLongitudGpsDespacho() {
		return longitudGpsDespacho;
	}

	public void setLongitudGpsDespacho(double longitudGpsDespacho) {
		this.longitudGpsDespacho = longitudGpsDespacho;
	}

	public String getCodigoVentanaHoraria() {
		return codigoVentanaHoraria;
	}

	public void setCodigoVentanaHoraria(String codigoVentanaHoraria) {
		this.codigoVentanaHoraria = codigoVentanaHoraria;
	}

	public long getTiempoCronometrico() {
		return tiempoCronometrico;
	}

	public void setTiempoCronometrico(long tiempoCronometrico) {
		this.tiempoCronometrico = tiempoCronometrico;
	}

	public String getVentana() {
		return ventana;
	}

	public void setVentana(String ventana) {
		this.ventana = ventana;
	}

	public String getTienda() {
		return tienda;
	}

	public void setTienda(String tienda) {
		this.tienda = tienda;
	}

	public Integer getTiempoPromedioDespacho() {
		return tiempoPromedioDespacho;
	}

	public void setTiempoPromedioDespacho(Integer tiempoPromedioDespacho) {
		this.tiempoPromedioDespacho = tiempoPromedioDespacho;
	}

	public Date getFechaEstimadaPartida() {
		return fechaEstimadaPartida;
	}

	public void setFechaEstimadaPartida(Date fechaEstimadaPartida) {
		this.fechaEstimadaPartida = fechaEstimadaPartida;
	}

	public Integer getTiempoEstimadoLlegada() {
		return tiempoEstimadoLlegada;
	}

	public void setTiempoEstimadoLlegada(Integer tiempoEstimadoLlegada) {
		this.tiempoEstimadoLlegada = tiempoEstimadoLlegada;
	}

	public Date getFechaEstimadaLlegada() {
		return fechaEstimadaLlegada;
	}

	public void setFechaEstimadaLlegada(Date fechaEstimadaLlegada) {
		this.fechaEstimadaLlegada = fechaEstimadaLlegada;
	}

	
}
