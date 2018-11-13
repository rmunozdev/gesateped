package pe.com.gesateped.carga.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.carga.model.Abastecimiento;
import pe.com.gesateped.carga.model.Item;
import pe.com.gesateped.carga.model.Reposicion;
import pe.com.gesateped.carga.registro.validation.RegistroCargaError;
import pe.com.gesateped.carga.registro.validation.RegistroCargaErrorCode;

@Repository
public class CargaDAOImpl implements CargaDAO {

	@Autowired
	private SqlSession gesatepedSession;
	
	@Override
	public RegistroCargaError registrarAbastecimiento(Abastecimiento abastecimiento) {
		Map<String,Object> params = new HashMap<>();
		params.put("abastecimiento", abastecimiento);
		params.put("codigoRespuesta", null);
		params.put("mensajeRespuesta", null);
		this.gesatepedSession.insert("Carga.registrarAbastecimiento",params);
		return procesarResponse(params.get("codigoRespuesta"),abastecimiento.getItem(), false);
	}

	@Override
	public RegistroCargaError registrarReposicion(Reposicion reposicion) {
		Map<String,Object> params = new HashMap<>();
		params.put("reposicion", reposicion);
		params.put("codigoRespuesta", null);
		params.put("mensajeRespuesta", null);
		this.gesatepedSession.insert("Carga.registrarReposicion",params);
		
		return procesarResponse(params.get("codigoRespuesta"),reposicion.getItem(), true);
	}
	
	private RegistroCargaError procesarResponse(Object codigo, Item item, boolean esReposicion) {
		RegistroCargaError error = null;
		if(codigo != null) {
			error = new RegistroCargaError();
			error.setItem(item);
			error.setReposicion(esReposicion);
			switch(Integer.parseInt(codigo.toString())) {
			case -2:
				error.setCodigo(RegistroCargaErrorCode.BD_YA_SE_REGISTRO);
				break;
			case -3:
				error.setCodigo(RegistroCargaErrorCode.BD_NO_SE_ENCUENTRA_EN_KARDEX);
				break;
			default:
				error.setCodigo(RegistroCargaErrorCode.BASE_DE_DATOS);
			}
		}
		return error;
	}

}
