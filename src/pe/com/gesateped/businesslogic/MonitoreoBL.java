package pe.com.gesateped.businesslogic;

import java.util.List;

import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.EstadoPedido;
import pe.com.gesateped.model.Unidad;
import pe.com.gesateped.model.extend.DetallePedidoRuta;

public interface MonitoreoBL {

	public List<Bodega> getBodegas();
	public List<Unidad> getUnidades(Bodega bodega);
	public List<EstadoPedido> getEstadoPedidos(String codigoHojaRuta);
	public List<DetallePedidoRuta> getDetallePedidosRuta(String codigoHojaRuta,String estadoPedido);
	public List<EstadoPedido> getEstadoPedidosPorBodega(String codigoBodega);
	
}
