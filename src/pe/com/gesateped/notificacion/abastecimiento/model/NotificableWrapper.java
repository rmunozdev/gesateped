package pe.com.gesateped.notificacion.abastecimiento.model;

import java.util.List;

public class NotificableWrapper {

	public List<Notificable> notificables;
	
	public NotificableWrapper(List<Notificable> notificables) {
		this.notificables = notificables;
	}

	public List<Notificable> getNotificables() {
		return notificables;
	}

	public void setNotificables(List<Notificable> notificables) {
		this.notificables = notificables;
	}
	
	
}
