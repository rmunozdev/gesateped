package pe.com.gesateped.dao;

import java.util.List;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.EstadoPedido;
import pe.com.gesateped.model.Unidad;
import pe.com.gesateped.model.extend.DetallePedidoRuta;

public interface MonitoreoDao {

	public List<Bodega> getBodegas();
	public List<Unidad> getUnidades(String codigoBodega);
	public List<EstadoPedido> getEstadoPedidos (String codigoHojaRuta);
	public List<DetallePedidoRuta> getDetallePedidoRuta(String codigoHojaRuta, String estadoPedido);
	
}
