package pe.com.gesateped.controller;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

import pe.com.gesateped.businesslogic.MonitoreoBL;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Unidad;

@SessionAttributes({ "bodega" })
@Controller
@RequestMapping("/monitoreo")
public class MonitoreoController {

	private final static Logger logger = Logger.getLogger(AdminController.class);
	
	@Autowired
	private MonitoreoBL monitoreoBL;
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView iniciar(ModelMap modelMap) {
		modelMap.put("bodegas", this.monitoreoBL.getBodegas());
		
		Bodega bodega = new Bodega();
		bodega.setCodigo("x");
		modelMap.addAttribute("bodega", bodega);
		return new ModelAndView("monitoreo");
	}
	
	@RequestMapping(path="verUnidades",method = RequestMethod.POST)
	@ResponseBody
	public List<Unidad> verUnidades(Bodega bodega) {
		logger.info("bodega: " + bodega.getCodigo());
		return this.monitoreoBL.getUnidades(bodega);
	}
	
	
	
}
