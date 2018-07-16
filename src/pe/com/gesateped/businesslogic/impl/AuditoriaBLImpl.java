package pe.com.gesateped.businesslogic.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.businesslogic.AuditoriaBL;
import pe.com.gesateped.dao.AuditoriaDao;

@Service
public class AuditoriaBLImpl implements AuditoriaBL {

	@Autowired
	private AuditoriaDao auditoriaDao;
	
	@Override
	public int registrarInicioProceso(String nombreProceso) {
		return this.auditoriaDao.registrarInicioProceso(nombreProceso);
	}

	@Override
	public void registrarFinProceso(int numeroProceso, boolean isSuccess) {
		this.auditoriaDao.registrarFinProceso(numeroProceso, isSuccess);
	}

	@Override
	public int registrarInicioActividad(int numeroProceso, String nombreActividad) {
		return this.auditoriaDao.registrarInicioActividad(numeroProceso, nombreActividad);
	}

	@Override
	public void registrarFinActividad(int numeroActividad, String descripcionError) {
		this.auditoriaDao.registrarFinActividad(numeroActividad, false, descripcionError);
	}

	@Override
	public void registrarFinActividad(int numeroActividad) {
		this.auditoriaDao.registrarFinActividad(numeroActividad, true, null);
	}

}
