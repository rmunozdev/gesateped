package pe.com.gesateped.businesslogic;

import java.util.Date;
import java.util.List;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Parametro;
import pe.com.gesateped.model.Pedido;
import pe.com.gesateped.model.VentanaHoraria;
import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.model.extend.UnidadNormalizada;

public interface AdminBL {

	List<Pedido> listarPedidos();
	List<PedidoNormalizado> obtenerPedidosNormalizados();
	List<UnidadNormalizada> obtenerUnidadesNormalizadas();
	void registrarHojaRuta(Ruta ruta);
	List<Ruta> obtenerRutas(Date fechaDespacho);
	Bodega obtenerBodega(String codigoBodega);
	List<VentanaHoraria> obtenerVentanas();
	List<Parametro> listarParametros();
	
}
