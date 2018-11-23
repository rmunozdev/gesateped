package pe.com.gesateped.notificacion.abastecimiento.service.impl;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.dao.MonitoreoDao;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.notificacion.abastecimiento.dao.NotificableDao;
import pe.com.gesateped.notificacion.abastecimiento.email.service.NotificableEmailService;
import pe.com.gesateped.notificacion.abastecimiento.model.Notificable;
import pe.com.gesateped.notificacion.abastecimiento.service.NotificableService;

@Service("NotificableServiceBatch")
public class NotificableServiceImpl implements NotificableService {

	private final static Logger logger = Logger.getLogger(NotificableServiceImpl.class);
	
	@Autowired
	private NotificableDao notificableDao;
	
	@Autowired
	private MonitoreoDao monitoreoDao;
	
	@Autowired
	private NotificableEmailService emailService;
	
	@Override
	public void procesarNotificables() {
		for(Bodega bodega: this.monitoreoDao.getBodegas()) {
			List<Notificable> notificables = notificableDao.obtenerNotificables(bodega.getCodigo());
			logger.info("Total original: " + notificables.size());
			//filtrar notificables
			notificables.removeIf(NotificableServiceImpl::cumpleCondicion);
			logger.info("Aprobados: " + notificables.size());
			
			if(notificables.isEmpty()) {
				logger.info("No hay notificables para bodega: " + bodega.getNombre());
			} else {
				
				for(Notificable notificable : notificables) {
					this.completarDatos(notificable);
					notificable.getKardex().setBodega(bodega);
				}
				
				this.emailService.enviar(notificables, bodega);
				for(Notificable notificable : notificables) {
					logger.info("Iniciando proceso de registro");
					//Solo se registra lo que se envio por primera vez
					if(!notificable.isAlerta()) {
						logger.info("Enviando registro a DAO");
						try {
							notificableDao.registrar(notificable);
							
						} catch(Exception exception) {
							logger.error("Error al registrar notificable.",exception);
						}
					} else {
						logger.info("No se puede registrar por ser alerta");
					}
				}
			}
			logger.info("Fin de proceso");
		}
	}
	
	public static boolean cumpleCondicion(Notificable notificable) {
		
		if(notificable.getKardex().getNotificacionAbastecimiento() != null) {
			Date maximoAbastecimiento = notificable.getKardex().getMaximoAbastecimiento();
			Date fechaLimite = new Date();
			if(maximoAbastecimiento.after(fechaLimite)) {
				return true;
			}
			
		} else {
			//La fecha de abastecimiento debe ser calculada
			Calendar nuevaFecha = Calendar.getInstance();
			//Cantidad de días configurable en parámetros
			nuevaFecha.add(Calendar.DATE, 7);
			notificable.getKardex().setMaximoAbastecimiento(nuevaFecha.getTime());
		}
		
		return false;
	}

	public void completarDatos(Notificable notificable) {
		if(notificable.getKardex().getNotificacionAbastecimiento() != null) {
			Date maximoAbastecimiento = notificable.getKardex().getMaximoAbastecimiento();
			ZoneId.systemDefault();
			LocalDate hasta = maximoAbastecimiento.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
			long dias = ChronoUnit.DAYS.between(hasta, LocalDate.now());
			
			if(dias > 1) {
				notificable.setEstado("Sin abastecer hace " + dias + " días");
			} else {
				notificable.setEstado("Sin abastecer hace 1 día");
			}
			notificable.setAlerta(true);
		} else {
			//La fecha de abastecimiento debe ser calculada
			Calendar nuevaFecha = Calendar.getInstance();
			//Cantidad de días configurable en parámetros
			nuevaFecha.add(Calendar.DATE, 7);
			notificable.getKardex().setMaximoAbastecimiento(nuevaFecha.getTime());
			notificable.getKardex().setNotificacionAbastecimiento(new Date());
			notificable.setEstado("Pendiente de abastecer.");
			notificable.setAlerta(false);
		}
	}
	
}
