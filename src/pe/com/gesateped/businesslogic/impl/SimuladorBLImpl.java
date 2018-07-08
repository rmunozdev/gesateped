package pe.com.gesateped.businesslogic.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.businesslogic.AdminBL;
import pe.com.gesateped.businesslogic.SimuladorBL;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.PuntoPartida;
import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;

@Service
public class SimuladorBLImpl implements SimuladorBL {

	@Autowired
	private AdminBL adminBL;
	
	@Override
	public List<PuntoPartida> getPartidas(String codigoHojaRuta) {
		List<PuntoPartida> partidas = new ArrayList<>();
		Ruta ruta = this.obtenerRuta(codigoHojaRuta);
		
		//Punto base de partida direccion de bodega
		Bodega bodega = this.adminBL.obtenerBodega(ruta.getCodigoBodega());
		PuntoPartida inicio = new PuntoPartida();
		inicio.setCodigoPedido(ruta.getPedidos().get(0).getCodigoPedido());
		inicio.setDireccion(bodega.getDireccion());
		partidas.add(inicio);
		
		PedidoNormalizado pedidoPrevio = ruta.getPedidos().get(0);
		for (int i = 1; i < ruta.getPedidos().size(); i++) {
			PedidoNormalizado pedidoActual = ruta.getPedidos().get(i);
			PuntoPartida partida = new PuntoPartida();
			partida.setCodigoPedido(pedidoActual.getCodigoPedido());
			partida.setDireccion(pedidoPrevio.getDomicilio());
			partidas.add(partida);
			pedidoPrevio = ruta.getPedidos().get(i);
		}
		return partidas;
	}
	
	public Ruta obtenerRuta(String codigoHojaRuta) {
		//Simulacion>> Fecha despacho hoy
		List<Ruta> rutas = this.adminBL.obtenerRutas(new Date());
		
		//Filtrar pedidos por hoja de ruta
		for(Ruta ruta : rutas) {
			if(ruta.getCodigoRuta().equals(codigoHojaRuta)) {
				return ruta;
			}
		}
		
		throw new IllegalStateException(
				"No se encontro ruta con codigo: " 
						+ codigoHojaRuta);
	}
}
