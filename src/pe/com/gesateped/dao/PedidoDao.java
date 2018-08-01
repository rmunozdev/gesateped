package pe.com.gesateped.dao;

import java.util.Date;
import java.util.List;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Parametro;
import pe.com.gesateped.model.Pedido;
import pe.com.gesateped.model.VentanaHoraria;
import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.model.extend.UnidadNormalizada;

public interface PedidoDao {

	List<Pedido> listar();
	List<PedidoNormalizado> obtenerPedidosNormalizados(Date fechaDespacho);
	List<UnidadNormalizada> obtenerUnidadesNormalizadas();
	List<UnidadNormalizada> obtenerUnidadesNormalizadas(String codigoBodega);
	void registrarHojaRuta(Ruta ruta);
	void eliminarRutas(Date fechaDespacho);
	List<Ruta> obtenerRutas(Date fechaDespacho);
	Bodega obtenerBodega(String codigoBodega);
	List<VentanaHoraria> obtenerVentanasHorarias();
	List<Parametro> listarParametros();
}
