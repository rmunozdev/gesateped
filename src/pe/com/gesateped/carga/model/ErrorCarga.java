package pe.com.gesateped.carga.model;

import pe.com.gesateped.carga.csv.validation.CsvValidationError;
import pe.com.gesateped.carga.registro.validation.RegistroCargaError;

public class ErrorCarga {
	
	/**
	 * Codigo de identificación único.
	 */
	private Integer codigo;
	
	/**
	 * Número de línea dentro del archivo csv.
	 */
	private Integer registro;
	
	/**
	 * Mensaje que ayuda determinar causa de problema.
	 */
	private String mensaje;
	
	public ErrorCarga() {
		
	}
	
	public static ErrorCarga fromCsvValidationError(CsvValidationError error) {
		ErrorCarga errorCarga = new ErrorCarga();
		
		errorCarga.setRegistro(error.getLinea());
		String mensaje = null;
		switch(error.getCodigo()) {
		case EMPTY:
			errorCarga.setCodigo(0);
			mensaje = String.format("Campo %s no debe ser vacío.", error.getCampo());
			break;
		case GENERAL:
			errorCarga.setCodigo(1);
			mensaje = String.format("Error general al procesar campo %s.", error.getCampo());
			break;
		case FORMAT:
			errorCarga.setCodigo(2);
			mensaje = String.format("Se espera una cantidad numérica exacta para el campo %s.", error.getCampo());
			break;
		case MISSING_VALUE:
			errorCarga.setCodigo(3);
			mensaje = "Registro incompleto, por favor ingrese todos los campos.";
			break;
		default:
			errorCarga.setCodigo(-1);
			mensaje = "Error de validación no identificado.";
			break;
		}
		errorCarga.setMensaje(mensaje);
		return errorCarga;
	}
	
	public static ErrorCarga fromRegistroCargaError(RegistroCargaError error) {
		ErrorCarga errorCarga = new ErrorCarga();
		errorCarga.setRegistro(error.getLinea());
		
		switch(error.getCodigo()) {
		case BASE_DE_DATOS:
			errorCarga.setCodigo(10);
			errorCarga.setMensaje("Error al grabar en base de datos.");
			break;
		case ERROR_GENERAL:
			errorCarga.setCodigo(11);
			errorCarga.setMensaje("Error general.");
			break;
		case ERROR_VALIDACION_ITEM_INCOMPLETO:
			errorCarga.setCodigo(12);
			errorCarga.setMensaje("El registro incompleto (Debe tener 3 columnas).");
			break;
		case ERROR_VALIDACION_PRODUCTO_NOMBRE_NO_VALIDO:
			errorCarga.setCodigo(13);
			errorCarga.setMensaje("Nombre de producto inadecuado.");
			break;
		case ERROR_VALIDACION_PRODUCTO_NO_EXISTE:
			errorCarga.setCodigo(14);
			errorCarga.setMensaje("El código de producto " + error.getItem().getProducto().getCodigo() + " no se encuentra registrado en el sistema.");
			break;
		case BD_NO_SE_ENCUENTRA_EN_KARDEX:
			errorCarga.setCodigo(15);
			String codigoBodegaKardex = error.isReposicion()?error.getCarga().getNodo().getCodigo():error.getCarga().getBodega().getCodigo();
			String nodoOBodega = error.isReposicion()?" para nodo ":" para bodega ";
			
			errorCarga.setMensaje("No se encuentra kardex para el producto " + error.getItem().getProducto().getCodigo() + nodoOBodega + codigoBodegaKardex + ".");
			break;
		case BD_YA_SE_REGISTRO:
			errorCarga.setCodigo(16);
			errorCarga.setMensaje("El producto ya fue registrado.");
			break;
		case VALIDACION_CANTIDAD_INADECUADA:
			errorCarga.setCodigo(18);
			errorCarga.setMensaje("La cantidad de producto debe ser mayor a cero.");
			break;
		case VALIDACION_CANTIDAD_OBLIGATORIA:
			errorCarga.setCodigo(19);
			errorCarga.setMensaje("Debe ingresar la cantidad de producto.");
			break;
		case VALIDACION_PRODUCTO_CODIGO_VACIO:
			errorCarga.setCodigo(20);
			errorCarga.setMensaje("El codigo del producto debe contener por lo menos un caracter alfanumérico.");
			break;
		case VALIDACION_PRODUCTO_NOMBRE_VACIO:
			errorCarga.setCodigo(21);
			errorCarga.setMensaje("El nombre del producto debe contener por lo menos un caracter alfanumérico.");
			break;
		case BD_STOCK_EN_BODEGA_INSUFICIENTE:
			errorCarga.setCodigo(22);
			errorCarga.setMensaje("La " + error.getCarga().getBodega().getNombre() +  " no cuenta con stock suficiente para reponer el producto " 
					+ error.getItem().getProducto().getCodigo() +" al "+ error.getCarga().getNodo().getNombre() + ".");
			break;
		case BD_NO_SE_ENCUENTRA_EN_KARDEX_PARA_BODEGA:
			errorCarga.setCodigo(23);
			errorCarga.setMensaje("No se encuentra kardex para el producto " + 
			error.getItem().getProducto().getCodigo() + " para bodega " + 
					error.getCarga().getBodega().getCodigo() + ".");
			break;
		default:
			errorCarga.setCodigo(17);
			errorCarga.setMensaje("Error no identificado.");
			break;
		}
		
		return errorCarga;
	}

	public Integer getRegistro() {
		return registro;
	}

	public void setRegistro(Integer registro) {
		this.registro = registro;
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}

	public Integer getCodigo() {
		return codigo;
	}

	public void setCodigo(Integer codigo) {
		this.codigo = codigo;
	}
	
	
}
