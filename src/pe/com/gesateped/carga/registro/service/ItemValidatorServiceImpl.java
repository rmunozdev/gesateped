package pe.com.gesateped.carga.registro.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.carga.dao.ProductoDAO;
import pe.com.gesateped.carga.model.Item;
import pe.com.gesateped.carga.registro.validation.ItemValidationError;
import pe.com.gesateped.carga.registro.validation.RegistroCargaErrorCode;

@Service
public class ItemValidatorServiceImpl implements ItemValidatorService {

	@Autowired
	private ProductoDAO productoDAO;
	
	@Override
	public ItemValidationError validar(Item item) {
		
		ItemValidationError tieneCodigoVacio = productoCodigoVacio(item);
		if(tieneCodigoVacio != null) {
			return tieneCodigoVacio;
		} 
		
		ItemValidationError tieneNombreVacio = productoNombreVacio(item);
		if(tieneNombreVacio != null) {
			return tieneNombreVacio;
		} 
		
		ItemValidationError noExisteProducto = existeProducto(item);
		if(noExisteProducto != null) {
			return noExisteProducto;
		} 
		
		ItemValidationError tieneCantidadAdecuada = cantidadAdecuada(item);
		if(tieneCantidadAdecuada != null) {
			return tieneCantidadAdecuada;
		}
		
		
		
		return null;
	}
	
	private ItemValidationError productoCodigoVacio(Item item) {
		if(item.getProducto().getCodigo() == null || item.getProducto().getCodigo().trim().isEmpty()) {
			ItemValidationError error = new ItemValidationError();
			error.setCodigo(RegistroCargaErrorCode.VALIDACION_PRODUCTO_CODIGO_VACIO);
			error.setCampo("Codigo");
			return error;
		}
		return null;
	}
	
	private ItemValidationError productoNombreVacio(Item item) {
		if(item.getProducto().getNombre() == null || item.getProducto().getNombre().trim().isEmpty()) {
			ItemValidationError error = new ItemValidationError();
			error.setCodigo(RegistroCargaErrorCode.VALIDACION_PRODUCTO_NOMBRE_VACIO);
			error.setCampo("Codigo");
			return error;
		}
		return null;
	}
	
	private ItemValidationError existeProducto(Item item) {
		
		boolean existeProducto = this.productoDAO.existeProducto(item.getProducto().getCodigo());
		
		if(!existeProducto) {
			ItemValidationError itemValidationError = new ItemValidationError();
			itemValidationError.setCodigo(RegistroCargaErrorCode.ERROR_VALIDACION_PRODUCTO_NO_EXISTE);
			itemValidationError.setCampo("Codigo");
			return itemValidationError;
		}
		
		return null;
	}

	private ItemValidationError cantidadAdecuada(Item item) {
		ItemValidationError itemValidationError = new ItemValidationError();
		itemValidationError.setCampo("Cantidad");
		if(item.getCantidad() == null) {
			itemValidationError.setCodigo(RegistroCargaErrorCode.VALIDACION_CANTIDAD_OBLIGATORIA);
		} else if(item.getCantidad() <= 0) {
			itemValidationError.setCodigo(RegistroCargaErrorCode.VALIDACION_CANTIDAD_INADECUADA);
		} else {
			return null;
		}
		return itemValidationError;
	}
	
}
