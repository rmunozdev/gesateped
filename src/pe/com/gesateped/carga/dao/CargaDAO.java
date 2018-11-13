package pe.com.gesateped.carga.dao;

import pe.com.gesateped.carga.model.Abastecimiento;
import pe.com.gesateped.carga.model.Reposicion;
import pe.com.gesateped.carga.registro.validation.RegistroCargaError;

public interface CargaDAO {
	
	public RegistroCargaError registrarAbastecimiento(Abastecimiento abastecimiento);
	public RegistroCargaError registrarReposicion(Reposicion reposicion);

}
