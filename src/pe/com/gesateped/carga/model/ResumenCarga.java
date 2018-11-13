package pe.com.gesateped.carga.model;

import java.util.ArrayList;
import java.util.List;

public class ResumenCarga {

	private Integer codigoRespuesta;
	private Integer cargados;
	private Integer omitidos;
	private Integer total;
	private String mensajeResumen;
	private String validacionFecha;
	private String validacionProveedor;
	private String validacionBodega;
	private String validacionNodo;
	private String validacionLimiteCsv;
	private boolean archivoCsvOk;
	
	private List<ErrorCarga> errores;
	
	public ResumenCarga() {
		this.errores = new ArrayList<>();
	}
	
	public List<ErrorCarga> getErrores() {
		return errores;
	}
	
	public void addError(ErrorCarga errorCarga) {
		this.errores.add(errorCarga);
	}
	
	public void addAllErrors(List<ErrorCarga> errores) {
		this.errores.addAll(errores);
	}
	
	public Integer getTotal() {
		return total;
	}
	public void setTotal(Integer total) {
		this.total = total;
	}


	public Integer getCodigoRespuesta() {
		return codigoRespuesta;
	}


	public void setCodigoRespuesta(Integer codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}


	public String getMensajeResumen() {
		return mensajeResumen;
	}


	public void setMensajeResumen(String mensajeResumen) {
		this.mensajeResumen = mensajeResumen;
	}

	public String getValidacionProveedor() {
		return validacionProveedor;
	}


	public void setValidacionProveedor(String validacionProveedor) {
		this.validacionProveedor = validacionProveedor;
	}


	public String getValidacionBodega() {
		return validacionBodega;
	}


	public void setValidacionBodega(String validacionBodega) {
		this.validacionBodega = validacionBodega;
	}


	public String getValidacionNodo() {
		return validacionNodo;
	}


	public void setValidacionNodo(String validacionNodo) {
		this.validacionNodo = validacionNodo;
	}


	public void setErrores(List<ErrorCarga> errores) {
		this.errores = errores;
	}


	public boolean isArchivoCsvOk() {
		return archivoCsvOk;
	}


	public void setArchivoCsvOk(boolean archivoCsvOk) {
		this.archivoCsvOk = archivoCsvOk;
	}


	public String getValidacionFecha() {
		return validacionFecha;
	}


	public void setValidacionFecha(String validacionFecha) {
		this.validacionFecha = validacionFecha;
	}


	public String getValidacionLimiteCsv() {
		return validacionLimiteCsv;
	}


	public void setValidacionLimiteCsv(String validacionLimiteCsv) {
		this.validacionLimiteCsv = validacionLimiteCsv;
	}


	public Integer getOmitidos() {
		return omitidos;
	}


	public void setOmitidos(Integer omitidos) {
		this.omitidos = omitidos;
	}

	public Integer getCargados() {
		return cargados;
	}

	public void setCargados(Integer cargados) {
		this.cargados = cargados;
	}


	
	
}
