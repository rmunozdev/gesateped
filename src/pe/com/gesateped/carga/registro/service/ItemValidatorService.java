package pe.com.gesateped.carga.registro.service;

import pe.com.gesateped.carga.model.Item;
import pe.com.gesateped.carga.registro.validation.ItemValidationError;

public interface ItemValidatorService {

	public ItemValidationError validar(Item item);
	
}
