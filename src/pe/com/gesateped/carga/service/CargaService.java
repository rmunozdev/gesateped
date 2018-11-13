package pe.com.gesateped.carga.service;

import java.util.List;

import pe.com.gesateped.carga.model.Carga;
import pe.com.gesateped.carga.model.ResumenCarga;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Proveedor;

public interface CargaService {

	public ResumenCarga procesar(Carga carga);
	
	public List<Proveedor> listarProveedores();
	public List<Bodega> listarSoloBodegas();
	public List<Bodega> listarSoloNodos();
	
}
