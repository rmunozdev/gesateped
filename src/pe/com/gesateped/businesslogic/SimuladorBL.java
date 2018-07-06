package pe.com.gesateped.businesslogic;

import java.util.List;

import pe.com.gesateped.model.PuntoPartida;

public interface SimuladorBL {

	public List<PuntoPartida> getPartidas(String codigoHojaRuta);
}
