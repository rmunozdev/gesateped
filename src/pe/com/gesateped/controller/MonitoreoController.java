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
import pe.com.gesateped.model.EstadoPedido;
import pe.com.gesateped.model.Unidad;
import pe.com.gesateped.model.extend.DetallePedidoRuta;

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
	
	
	@RequestMapping(path="verEstadoPedidos",method = RequestMethod.POST)
	@ResponseBody
	public List<EstadoPedido> verEstadosPedidos(String codigoHojaRuta) {
		logger.info("codigoHojaRuta:" + codigoHojaRuta);
		return this.monitoreoBL.getEstadoPedidos(codigoHojaRuta);
	}
	
	@RequestMapping(path="verDetallePedidosAtendidos",method = RequestMethod.POST)
	@ResponseBody
	public List<DetallePedidoRuta> verDetallePedidosAtendidos(String codigoHojaRuta) {
		logger.info("codigoHojaRuta:" + codigoHojaRuta);
		return this.monitoreoBL.getDetallePedidosRuta(codigoHojaRuta, "ATEN");
	}
	
	@RequestMapping(path="verDetallePedidosNoAtendidos",method = RequestMethod.POST)
	@ResponseBody
	public List<DetallePedidoRuta> verDetallePedidosNoAtendidos(String codigoHojaRuta) {
		logger.info("codigoHojaRuta:" + codigoHojaRuta);
		return this.monitoreoBL.getDetallePedidosRuta(codigoHojaRuta, "NATE");
	}
	
	@RequestMapping(path="verDetallePedidosPendientes",method = RequestMethod.POST)
	@ResponseBody
	public List<DetallePedidoRuta> verDetallePedidosPendientes(String codigoHojaRuta) {
		logger.info("codigoHojaRuta:" + codigoHojaRuta);
		return this.monitoreoBL.getDetallePedidosRuta(codigoHojaRuta, "PEND");
	}
	
	@RequestMapping(path="verDetallePedidosReprogramados",method = RequestMethod.POST)
	@ResponseBody
	public List<DetallePedidoRuta> verDetallePedidosReprogramados(String codigoHojaRuta) {
		logger.info("codigoHojaRuta:" + codigoHojaRuta);
		return this.monitoreoBL.getDetallePedidosRuta(codigoHojaRuta, "REPR");
	}
	
	@RequestMapping(path="verDetallePedidosCancelados",method = RequestMethod.POST)
	@ResponseBody
	public List<DetallePedidoRuta> verDetallePedidosCancelados(String codigoHojaRuta) {
		logger.info("codigoHojaRuta:" + codigoHojaRuta);
		return this.monitoreoBL.getDetallePedidosRuta(codigoHojaRuta, "CANC");
	}
	
}
