package pe.com.gesateped.model.extend;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import pe.com.gesateped.util.JsonDateSerializer;

@JsonInclude(Include.NON_NULL)
public class DetallePedidoRuta {

	private String codigoPedido;
	private String horaInicioVentana;
	private String horaFinVentana;
	
	private Date fechaPactadaDespacho;
	private Date fechaNoCumplimientoDespacho;
	private String descripcionMotivoPedidoHR;
	private String descripcionMotivoPedidoPE;
	private String nombresCliente;
	private String apellidosCliente;
	private String nombreTienda;
	private double latitudGpsDespacho;
	private double longitudGpsDespacho;
	private String direccionDespacho;
	private String distritoDespacho;
	
	public String getCodigoPedido() {
		return codigoPedido;
	}
	public void setCodigoPedido(String codigoPedido) {
		this.codigoPedido = codigoPedido;
	}
	public String getHoraInicioVentana() {
		return horaInicioVentana;
	}
	public void setHoraInicioVentana(String horaInicioVentana) {
		this.horaInicioVentana = horaInicioVentana;
	}
	public String getHoraFinVentana() {
		return horaFinVentana;
	}
	public void setHoraFinVentana(String horaFinVentana) {
		this.horaFinVentana = horaFinVentana;
	}
	
	@JsonSerialize(using=JsonDateSerializer.class)
	public Date getFechaPactadaDespacho() {
		return fechaPactadaDespacho;
	}
	public void setFechaPactadaDespacho(Date fechaPactadaDespacho) {
		this.fechaPactadaDespacho = fechaPactadaDespacho;
	}
	
	@JsonSerialize(using=JsonDateSerializer.class)
	public Date getFechaNoCumplimientoDespacho() {
		return fechaNoCumplimientoDespacho;
	}
	public void setFechaNoCumplimientoDespacho(Date fechaNoCumplimientoDespacho) {
		this.fechaNoCumplimientoDespacho = fechaNoCumplimientoDespacho;
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
	public String getNombresCliente() {
		return nombresCliente;
	}
	public void setNombresCliente(String nombresCliente) {
		this.nombresCliente = nombresCliente;
	}
	public String getApellidosCliente() {
		return apellidosCliente;
	}
	public void setApellidosCliente(String apellidosCliente) {
		this.apellidosCliente = apellidosCliente;
	}
	public String getNombreTienda() {
		return nombreTienda;
	}
	public void setNombreTienda(String nombreTienda) {
		this.nombreTienda = nombreTienda;
	}
	public String getDescripcionMotivoPedidoHR() {
		return descripcionMotivoPedidoHR;
	}
	public void setDescripcionMotivoPedidoHR(String descripcionMotivoPedidoHR) {
		this.descripcionMotivoPedidoHR = descripcionMotivoPedidoHR;
	}
	public String getDescripcionMotivoPedidoPE() {
		return descripcionMotivoPedidoPE;
	}
	public void setDescripcionMotivoPedidoPE(String descripcionMotivoPedidoPE) {
		this.descripcionMotivoPedidoPE = descripcionMotivoPedidoPE;
	}
	public String getDireccionDespacho() {
		return direccionDespacho;
	}
	public void setDireccionDespacho(String direccionDespacho) {
		this.direccionDespacho = direccionDespacho;
	}
	public String getDistritoDespacho() {
		return distritoDespacho;
	}
	public void setDistritoDespacho(String distritoDespacho) {
		this.distritoDespacho = distritoDespacho;
	}
	
}
