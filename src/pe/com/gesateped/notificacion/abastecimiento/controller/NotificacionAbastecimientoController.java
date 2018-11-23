package pe.com.gesateped.notificacion.abastecimiento.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import pe.com.gesateped.notificacion.abastecimiento.service.NotificableService;

@Controller
@RequestMapping("/notabast")
public class NotificacionAbastecimientoController {
	
	@Autowired
	private NotificableService service;
	
	@RequestMapping(method=RequestMethod.GET)
	public ModelAndView ejecutar() {
		service.procesarNotificables();
		return new ModelAndView("notabast");
	}
	
}
