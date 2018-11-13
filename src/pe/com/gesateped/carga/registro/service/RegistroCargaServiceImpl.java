package pe.com.gesateped.carga.registro.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.carga.dao.CargaDAO;
import pe.com.gesateped.carga.model.Abastecimiento;
import pe.com.gesateped.carga.model.Carga;
import pe.com.gesateped.carga.model.Item;
import pe.com.gesateped.carga.model.Reposicion;
import pe.com.gesateped.carga.registro.validation.ItemValidationError;
import pe.com.gesateped.carga.registro.validation.RegistroCargaError;

@Service
public class RegistroCargaServiceImpl implements RegistroCargaService {

	private final static Logger logger = Logger.getLogger(RegistroCargaServiceImpl.class);
	
	@Autowired
	private ItemValidatorService itemValidatorService;
	
	@Autowired
	private CargaDAO cargaDao;
	
	@Override
	public List<RegistroCargaError> registrarAbastecimiento(Carga carga, List<Item> items) {
		logger.info("Iniciando registro de abastecimiento");
		List<RegistroCargaError> errores = new ArrayList<>();
		
		for(Item item: items) {
			RegistroCargaError errorDeValidacion = this.validarItem(item);
			
			if(errorDeValidacion == null) {
				Abastecimiento abastecimiento = new Abastecimiento();
				abastecimiento.setBodega(carga.getBodega());
				abastecimiento.setCantidad(item.getCantidad());
				abastecimiento.setItem(item);
				abastecimiento.setFecha(carga.getFecha());
				abastecimiento.setProveedor(carga.getProveedor());
				RegistroCargaError cargaError = this.cargaDao.registrarAbastecimiento(abastecimiento);
				
				if(cargaError != null) {
					logger.info("Ocurrio error al registrar el abastecimiento del item:" + item.getProducto().getCodigo());
					cargaError.setLinea(item.getLinea());
					cargaError.setCarga(carga);
					errores.add(cargaError);
					
				} else {
					logger.info("Se completo el registro de abastecimiento en la base de datos.");
				}
			} else {
				errores.add(errorDeValidacion);
			}
		}
		
		logger.info("Registro de abastecimiento completado");
		return errores;
	}

	@Override
	public List<RegistroCargaError> registrarReposicion(Carga carga, List<Item> items) {
		logger.info("Iniciando registro de reposicion");
		List<RegistroCargaError> errores = new ArrayList<>();
		for(Item item: items) {
			RegistroCargaError errorDeValidacion = this.validarItem(item);
			
			
			if(errorDeValidacion == null) {
				Reposicion reposicion = new Reposicion();
				reposicion.setBodega(carga.getBodega());
				reposicion.setCantidad(item.getCantidad());
				reposicion.setItem(item);
				reposicion.setFecha(carga.getFecha());
				reposicion.setNodo(carga.getNodo());
				RegistroCargaError cargaError = this.cargaDao.registrarReposicion(reposicion);
				if(cargaError != null) {
					logger.info("Ocurrio error al registrar la reposición del item:" + item.getProducto().getCodigo());
					cargaError.setLinea(item.getLinea());
					cargaError.setCarga(carga);
					errores.add(cargaError);
				} else {
					logger.info("Se completo el registro de reposición en la base de datos.");
				}
			} else {
				errores.add(errorDeValidacion);
			}
		}
		logger.info("Registro de reposición completado");
		return errores;
	}
	
	private RegistroCargaError validarItem(Item item) {
		ItemValidationError itemValidationError = itemValidatorService.validar(item);
		if (itemValidationError != null) {
			RegistroCargaError cargaError = new RegistroCargaError();
			cargaError.setCodigo(itemValidationError.getCodigo());
			cargaError.setCampo(itemValidationError.getCampo());
			cargaError.setItem(item);
			cargaError.setLinea(item.getLinea());
			return cargaError;
		}
		return null;
	}

}
