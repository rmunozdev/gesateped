package pe.com.gesateped.model.extend;

import java.util.Date;
import java.util.List;

public class Ruta {
	
	private String codigoRuta;
	private Date fechaDespacho;
	private Date fechaGeneracion;
	private String nombreBodega;
	private String codigoBodega;
	
	private List<PedidoNormalizado> pedidos;
	private UnidadNormalizada unidad;
	
	public double calcularEfectividadPeso() {
		double cargaNeta = 0;
		for (PedidoNormalizado pedido : pedidos) {
			cargaNeta += pedido.getPeso();
		}
		return 100*cargaNeta/unidad.getPeso();
	}
	
	public double calcularEfectividadVolumen() {
		double volumenNeto = 0;
		for (PedidoNormalizado pedido : pedidos) {
			volumenNeto += pedido.getVolumen();
		}
		return 100*volumenNeto/unidad.getVolumen();
	}
	
	
	public List<PedidoNormalizado> getPedidos() {
		return pedidos;
	}
	public void setPedidos(List<PedidoNormalizado> pedidos) {
		this.pedidos = pedidos;
	}
	public UnidadNormalizada getUnidad() {
		return unidad;
	}
	public void setUnidad(UnidadNormalizada unidad) {
		this.unidad = unidad;
	}

	public String getCodigoRuta() {
		return codigoRuta;
	}

	public void setCodigoRuta(String codigoRuta) {
		this.codigoRuta = codigoRuta;
	}
	
	public Date getFechaDespacho() {
		return this.fechaDespacho;
	}
	
	public String getCodigoBodega() {
		if(this.codigoBodega == null) {
			if(this.pedidos.isEmpty()) {
				return null;
			}
			return this.pedidos.get(0).getCodigoBodega();
		}
		return this.codigoBodega;
	}

	public void setFechaDespacho(Date fechaDespacho) {
		this.fechaDespacho = fechaDespacho;
	}

	public Date getFechaGeneracion() {
		return fechaGeneracion;
	}

	public void setFechaGeneracion(Date fechaGeneracion) {
		this.fechaGeneracion = fechaGeneracion;
	}

	public String getNombreBodega() {
		return nombreBodega;
	}

	public void setNombreBodega(String nombreBodega) {
		this.nombreBodega = nombreBodega;
	}

	public void setCodigoBodega(String codigoBodega) {
		this.codigoBodega = codigoBodega;
	}
	
	
	
}
