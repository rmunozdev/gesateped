package pe.com.gesateped.businesslogic;

import java.util.List;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Unidad;

public interface MonitoreoBL {

	public List<Bodega> getBodegas();
	public List<Unidad> getUnidades(Bodega bodega);
	
}
