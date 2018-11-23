package pe.com.gesateped.notificacion.abastecimiento.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.notificacion.abastecimiento.model.Notificable;

@Repository
public class NotificableDaoImpl implements NotificableDao {

	private final static Logger logger = Logger.getLogger(NotificableDaoImpl.class);
	
	@Autowired
	private SqlSession gesatepedSession;
	
	@Override
	public List<Notificable> obtenerNotificables(String codigoBodega) {
		logger.info("Obteniendo notificables.");
		return this.gesatepedSession.selectList("Notificable.obtenerNotificables", codigoBodega);
	}

	@Override
	public void registrar(Notificable notificable) {
		logger.info("Registrando notificable: " + 
				notificable.getKardex().getBodega().getCodigo() + 
				" - " + notificable.getKardex().getProducto().getCodigo());
		this.gesatepedSession.update("Notificable.registrar", notificable);
	}

}
