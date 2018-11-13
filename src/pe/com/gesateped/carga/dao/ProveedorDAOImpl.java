package pe.com.gesateped.carga.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.model.Proveedor;

@Repository
public class ProveedorDAOImpl implements ProveedorDAO {

	@Autowired
	private SqlSession gesatepedSession;
	
	@Override
	public List<Proveedor> listarProveedores() {
		return this.gesatepedSession.selectList("Proveedor.listar");
	}

}
