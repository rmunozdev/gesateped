package pe.com.gesateped.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import pe.com.gesateped.batch.HojaRutaBatch;

@SessionAttributes({ "location"})
@Controller
@RequestMapping("/starter")
public class HomeController {

	private final static Logger logger = Logger.getLogger(HomeController.class);

	@Autowired
	private HojaRutaBatch hojaRutaBatch;

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView inicio() {
		logger.info("inicio() success");
		return new ModelAndView("starter");
	}

	@RequestMapping("/construir")
	@ResponseBody
	public List<String> construirHojaRutas(HttpSession session) {
		try {
			this.hojaRutaBatch.generarHojaRuta();
			List<String> bodegas = this.hojaRutaBatch.generarReporte();
			return bodegas;
		} catch (Exception exception) {
			logger.error("No se pudo generar hoja de ruta", exception);
		}
		return Collections.emptyList();
	}
	
	@RequestMapping("/descargar")
	public void descargarReporte(String nombreBodega, HttpServletResponse response, HttpSession session) {
		logger.info("Buscando reporte para bodega: " + nombreBodega);
		try {
			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "attachment; filename=HojaRutas.pdf");
			this.hojaRutaBatch.imprimirReporte(response.getOutputStream(), nombreBodega);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
