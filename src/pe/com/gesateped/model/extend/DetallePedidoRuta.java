package pe.com.gesateped.model.extend;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_NULL)
public class DetallePedidoRuta {

	private String codigoPedido;
	private String horaInicioVentana;
	private String horaFinVentana;
	private Date fechaPactadaDespacho;
	private Date fechaNoCumplimientoDespacho;
	private String descripcionMotivoPedido;
	private String direccionCliente;
	private String distritoCliente;
	private String direccionTienda;
	private String distritoTienda;
	private double latitudGpsDespacho;
	private double longitudGpsDespacho;
	
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
	public Date getFechaPactadaDespacho() {
		return fechaPactadaDespacho;
	}
	public void setFechaPactadaDespacho(Date fechaPactadaDespacho) {
		this.fechaPactadaDespacho = fechaPactadaDespacho;
	}
	public Date getFechaNoCumplimientoDespacho() {
		return fechaNoCumplimientoDespacho;
	}
	public void setFechaNoCumplimientoDespacho(Date fechaNoCumplimientoDespacho) {
		this.fechaNoCumplimientoDespacho = fechaNoCumplimientoDespacho;
	}
	public String getDescripcionMotivoPedido() {
		return descripcionMotivoPedido;
	}
	public void setDescripcionMotivoPedido(String descripcionMotivoPedido) {
		this.descripcionMotivoPedido = descripcionMotivoPedido;
	}
	public String getDireccionCliente() {
		return direccionCliente;
	}
	public void setDireccionCliente(String direccionCliente) {
		this.direccionCliente = direccionCliente;
	}
	public String getDistritoCliente() {
		return distritoCliente;
	}
	public void setDistritoCliente(String distritoCliente) {
		this.distritoCliente = distritoCliente;
	}
	public String getDireccionTienda() {
		return direccionTienda;
	}
	public void setDireccionTienda(String direccionTienda) {
		this.direccionTienda = direccionTienda;
	}
	public String getDistritoTienda() {
		return distritoTienda;
	}
	public void setDistritoTienda(String distritoTienda) {
		this.distritoTienda = distritoTienda;
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
	
}
