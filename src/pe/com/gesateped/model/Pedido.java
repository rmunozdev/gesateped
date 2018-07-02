package pe.com.gesateped.model;

import java.util.Date;

public class Pedido {
	
	private String codigo;
	private String codigoCliente;
	private String codigoTiendaDespacho;
	private int numeroReserva;
	private int numeroVerificacion;
	private Date fechaSolicitud;
	private Date fechaDespacho;
	private Date fechaReprogramacion;
	private Date fechaCancelacion;
	private Date fechaDevolucion;
	private String codigoTiendaDevolucion;
	private String codigoMotivoDevolucion;
	private String codigoPickeador;
	
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getCodigoCliente() {
		return codigoCliente;
	}
	public void setCodigoCliente(String codigoCliente) {
		this.codigoCliente = codigoCliente;
	}
	public String getCodigoTiendaDespacho() {
		return codigoTiendaDespacho;
	}
	public void setCodigoTiendaDespacho(String codigoTiendaDespacho) {
		this.codigoTiendaDespacho = codigoTiendaDespacho;
	}
	public int getNumeroReserva() {
		return numeroReserva;
	}
	public void setNumeroReserva(int numeroReserva) {
		this.numeroReserva = numeroReserva;
	}
	public int getNumeroVerificacion() {
		return numeroVerificacion;
	}
	public void setNumeroVerificacion(int numeroVerificacion) {
		this.numeroVerificacion = numeroVerificacion;
	}
	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}
	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}
	public Date getFechaDespacho() {
		return fechaDespacho;
	}
	public void setFechaDespacho(Date fechaDespacho) {
		this.fechaDespacho = fechaDespacho;
	}
	public Date getFechaReprogramacion() {
		return fechaReprogramacion;
	}
	public void setFechaReprogramacion(Date fechaReprogramacion) {
		this.fechaReprogramacion = fechaReprogramacion;
	}
	public Date getFechaCancelacion() {
		return fechaCancelacion;
	}
	public void setFechaCancelacion(Date fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}
	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}
	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
	}
	public String getCodigoTiendaDevolucion() {
		return codigoTiendaDevolucion;
	}
	public void setCodigoTiendaDevolucion(String codigoTiendaDevolucion) {
		this.codigoTiendaDevolucion = codigoTiendaDevolucion;
	}
	public String getCodigoMotivoDevolucion() {
		return codigoMotivoDevolucion;
	}
	public void setCodigoMotivoDevolucion(String codigoMotivoDevolucion) {
		this.codigoMotivoDevolucion = codigoMotivoDevolucion;
	}
	public String getCodigoPickeador() {
		return codigoPickeador;
	}
	public void setCodigoPickeador(String codigoPickeador) {
		this.codigoPickeador = codigoPickeador;
	}
	
	

}
