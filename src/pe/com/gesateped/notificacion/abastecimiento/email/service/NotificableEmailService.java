package pe.com.gesateped.notificacion.abastecimiento.email.service;

import java.util.List;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.notificacion.abastecimiento.model.Notificable;

public interface NotificableEmailService {

	/**
	 * Envia por email la lista de notificables de abastecimiento.
	 * Este servicio no debe utilizarse si la lista está vacía.
	 * @param bodega
	 */
	public void enviar(List<Notificable> notificables, Bodega bodega);
	
}
