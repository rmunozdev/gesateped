package pe.com.gesateped.carga.registro.service;

import java.util.List;

import pe.com.gesateped.carga.model.Carga;
import pe.com.gesateped.carga.model.Item;
import pe.com.gesateped.carga.registro.validation.RegistroCargaError;

public interface RegistroCargaService {

	public List<RegistroCargaError> registrarAbastecimiento(Carga carga, List<Item> items);
	public List<RegistroCargaError> registrarReposicion(Carga carga, List<Item> items);
	
}
