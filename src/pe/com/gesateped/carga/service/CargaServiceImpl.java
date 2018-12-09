package pe.com.gesateped.carga.service;

import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.carga.csv.exception.CSVException;
import pe.com.gesateped.carga.csv.model.ResumenProcesoCSV;
import pe.com.gesateped.carga.csv.service.CsvService;
import pe.com.gesateped.carga.csv.validation.CsvValidationError;
import pe.com.gesateped.carga.dao.BodegaDAO;
import pe.com.gesateped.carga.dao.ProveedorDAO;
import pe.com.gesateped.carga.model.Carga;
import pe.com.gesateped.carga.model.ErrorCarga;
import pe.com.gesateped.carga.model.Item;
import pe.com.gesateped.carga.model.ResumenCarga;
import pe.com.gesateped.carga.registro.service.RegistroCargaService;
import pe.com.gesateped.carga.registro.validation.RegistroCargaError;
import pe.com.gesateped.dao.PedidoDao;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Proveedor;

@Service
public class CargaServiceImpl implements CargaService {

	private final static Logger logger = Logger.getLogger(CargaServiceImpl.class);
	
	@Autowired
	private CsvService csvService;
	
	@Autowired
	private RegistroCargaService registroCargaService;
	
	@Autowired
	private BodegaDAO bodegaDAO;
	
	@Autowired
	private ProveedorDAO proveedorDAO;
	
	@Autowired
	private PedidoDao pedidoDAO;
	
	@Override
	public ResumenCarga procesar(Carga carga) {
		ResumenCarga resumen = new ResumenCarga();
		if(!this.verificarFecha(carga.getFecha())) {
			resumen.setValidacionFecha("Campo obligatorio (formato dd/mm/yyyy)");
		}
		
		if(!this.verificarBodega(carga.getBodega())) {
			resumen.setValidacionBodega("Campo obligatorio");
		}
		
		if("reposicion".equals(carga.getTipo()) && !this.verificarNodo(carga.getNodo())) {
			resumen.setValidacionNodo("Campo obligatorioo");
		}
		
		if("compra".equals(carga.getTipo()) && !this.verificarProveedor(carga.getProveedor())) {
			resumen.setValidacionProveedor("Campo obligatorio");
		}
		
		
		if(!csvService.isValidExtension(carga.getFile().getOriginalFilename())) {
			resumen.setCodigoRespuesta(-1);
			resumen.setMensajeResumen("Extension de archivo no valida");
			resumen.setArchivoCsvOk(false);
			return resumen;
		} else {
			resumen.setArchivoCsvOk(true);
		}
		
		try {
			ResumenProcesoCSV resumenProcesoCSV = this.csvService.getItems(new InputStreamReader(carga.getFile().getInputStream()));
			List<Item> items = resumenProcesoCSV.getItems();
			logger.info("Total csvException errors: " + resumenProcesoCSV.getErrores().size());
			for(CsvValidationError validationError : resumenProcesoCSV.getErrores()) {
				resumen.addAllErrors(Arrays.asList(ErrorCarga.fromCsvValidationError(validationError)));
			}
			//Zona de exito, se dan registros satisfactorios
			//Se completa contenido (para mensajes de validacion)
			if(carga.getBodega() != null && carga.getBodega().getCodigo() !=null) {
				Bodega bodega = this.pedidoDAO.obtenerBodega(carga.getBodega().getCodigo());
				carga.getBodega().setNombre(bodega.getNombre());
			}
			
			if(carga.getNodo() != null && carga.getNodo().getCodigo() !=null) {
				Bodega nodo = this.pedidoDAO.obtenerBodega(carga.getNodo().getCodigo());
				carga.getNodo().setNombre(nodo.getNombre());
			}
			
			
			List<RegistroCargaError> erroresRegistro = this.iniciarRegistro(carga,items);
			
			int omitidos = 0;
			for(RegistroCargaError errorRegistro: erroresRegistro) {
				//Se agrega como error solo si no son omitidos
				ErrorCarga error = ErrorCarga.fromRegistroCargaError(errorRegistro);
				if(error.getCodigo()!=16) {
					resumen.addError(error);
				} else {
					omitidos++;
				}
			}
			
			//Ordenamiento
			List<ErrorCarga> errores = resumen.getErrores();
			errores.sort((errorA, errorB) -> {
				return errorA.getRegistro().compareTo(errorB.getRegistro());
			});
			
			resumen.setTotal(items.size() + resumenProcesoCSV.getErrores().size());
			resumen.setCargados(items.size() - erroresRegistro.size());
			resumen.setOmitidos(omitidos);
			
		} catch(CSVException csvException) {
			//Falla predecible (no se imprime stack)
			logger.error("Error al leer archivo csv", csvException);
		} catch(IOException ioException) {
			logger.error("Error al leer archivo", ioException);
		} 
		
		return resumen;
	}

	
	private List<RegistroCargaError> iniciarRegistro(Carga carga, List<Item> items) {
		//Etapa 2 Registro de elementos
		if(!"0".equals(carga.getProveedor().getCodigo())) {
			return this.registroCargaService.registrarAbastecimiento(carga,items);
		} 
		return this.registroCargaService.registrarReposicion(carga,items);
	}
	
	@Override
	public List<Proveedor> listarProveedores() {
		return this.proveedorDAO.listarProveedores();
	}


	@Override
	public List<Bodega> listarSoloBodegas() {
		return this.bodegaDAO.listarSoloBodegas();
	}


	@Override
	public List<Bodega> listarSoloNodos() {
		return this.bodegaDAO.listarSoloNodos();
	}
	
	private boolean verificarProveedor(Proveedor proveedor) {
		return proveedor != null && 
				proveedor.getCodigo() != null && 
				!proveedor.getCodigo().isEmpty() && 
				!"0".equals(proveedor.getCodigo());
	}
	
	private boolean verificarBodega(Bodega bodega) {
		return bodega != null && 
				bodega.getCodigo() != null && 
				!bodega.getCodigo().isEmpty()&& 
				!"0".equals(bodega.getCodigo());
	}
	
	private boolean verificarNodo(Bodega nodo) {
		return nodo != null && 
				nodo.getCodigo() != null && 
				!nodo.getCodigo().isEmpty()&& 
				!"0".equals(nodo.getCodigo());
	}
	
	private boolean verificarFecha(Date fecha) {
		if(fecha == null) {
			return false;
		}
		return true;
	}
	
}
