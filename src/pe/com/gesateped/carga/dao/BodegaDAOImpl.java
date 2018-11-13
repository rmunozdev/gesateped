package pe.com.gesateped.carga.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.model.Bodega;

@Repository
public class BodegaDAOImpl implements BodegaDAO {

	@Autowired
    protected SqlSession gesatepedSession;
	
	@Override
	public List<Bodega> listarSoloBodegas() {
		return this.gesatepedSession.selectList("Bodega.listarSoloBodegas");
	}

	@Override
	public List<Bodega> listarSoloNodos() {
		return this.gesatepedSession.selectList("Bodega.listarSoloNodos");
	}

}
