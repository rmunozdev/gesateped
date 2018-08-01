package pe.com.gesateped.model.extend;

import java.util.Calendar;
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
	private Date fechaReprogramacion;
	private Date fechaCancelamiento;
	private Date fechaDevolucion;
	
	//Requerido al usar google maps directions
	private long tiempoCronometrico; //Tiempo (segundos) transcurrido basado en el orden
	private long distanciaMetros;
	
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

	public Date getFechaReprogramacion() {
		return fechaReprogramacion;
	}

	public void setFechaReprogramacion(Date fechaReprogramacion) {
		this.fechaReprogramacion = fechaReprogramacion;
	}

	public Date getFechaCancelamiento() {
		return fechaCancelamiento;
	}

	public void setFechaCancelamiento(Date fechaCancelamiento) {
		this.fechaCancelamiento = fechaCancelamiento;
	}

	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}

	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
	}
	
	public String getClasificacionTipo() {
		return this.tipoPedido.toString();
	}
	
	public String getClasificacionFecha() {
		
		Calendar tomorrow = Calendar.getInstance();
		tomorrow.add(Calendar.DATE, 1);
		tomorrow.set(Calendar.HOUR_OF_DAY, 0);
		tomorrow.set(Calendar.MINUTE, 0);
		tomorrow.set(Calendar.SECOND, 0);
		tomorrow.set(Calendar.MILLISECOND, 0);
		
		Calendar thisDate = Calendar.getInstance();
		thisDate.setTime(this.fechaDespacho);
		thisDate.set(Calendar.HOUR_OF_DAY, 0);
		thisDate.set(Calendar.MINUTE, 0);
		thisDate.set(Calendar.SECOND, 0);
		thisDate.set(Calendar.MILLISECOND, 0);
		
		
		if(this.fechaCancelamiento!=null) {
			return "Cancelado";
		} else if(thisDate.getTime().compareTo(tomorrow.getTime())==0) {
			return "Despacho normal";
		} else if(this.fechaDevolucion != null 
				&& this.fechaReprogramacion == null) {
			return "Devolución";
		} else if(this.fechaReprogramacion != null) {
			return "Reprogramado";
		} else {
			System.out.println("Fecha despacho: " + this.fechaDespacho);
			System.out.println("Fecha mañana: " + tomorrow.getTime());
			System.out.println("Mañana segun fecha despacho: " + thisDate.getTime());
			System.out.println("Comparacion: " + (thisDate.getTime().compareTo(tomorrow.getTime())==0));
			throw new IllegalStateException("No se puede determinar clasificacion fecha para " + this.codigoPedido);
		}
	}
	
	@Override
	public boolean equals(Object obj) {
		PedidoNormalizado comparable = (PedidoNormalizado) obj;
		return this.codigoPedido.equals(comparable.getCodigoPedido());
	}

	public long getDistanciaMetros() {
		return distanciaMetros;
	}

	public void setDistanciaMetros(long distanciaMetros) {
		this.distanciaMetros = distanciaMetros;
	}
}
