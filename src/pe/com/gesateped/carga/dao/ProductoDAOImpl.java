package pe.com.gesateped.carga.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.carga.model.Producto;

@Repository
public class ProductoDAOImpl implements ProductoDAO {

	@Autowired
	private SqlSession gesatepedSession;
	
	@Override
	public boolean existeProducto(String codigoProducto) {
		List<Producto> productos = this.gesatepedSession.selectList("Producto.buscar",codigoProducto);
		return !productos.isEmpty();
	}

}
