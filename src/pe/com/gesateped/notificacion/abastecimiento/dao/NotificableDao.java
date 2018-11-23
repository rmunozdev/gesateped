package pe.com.gesateped.notificacion.abastecimiento.dao;

import java.util.List;

import pe.com.gesateped.notificacion.abastecimiento.model.Notificable;

public interface NotificableDao {

	public List<Notificable> obtenerNotificables(String codigoBodega);
	public void registrar(Notificable notificable);
	
}
