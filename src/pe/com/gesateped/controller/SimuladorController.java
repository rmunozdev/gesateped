package pe.com.gesateped.controller;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import pe.com.gesateped.businesslogic.SimuladorBL;
import pe.com.gesateped.model.PuntoPartida;


@Controller
@RequestMapping("/sim")
public class SimuladorController {

	private final static Logger logger = Logger.getLogger(SimuladorController.class);
	
	@Autowired
	private SimuladorBL simuladorBL;
	
	@RequestMapping("/partidas")
	@ResponseBody
	public List<PuntoPartida> getPartidas(String codigoRuta) {
		logger.info("Buscando partidas para ruta: " + codigoRuta);
		return this.simuladorBL.getPartidas(codigoRuta);
	}
}
