package pe.com.gesateped.controller;

import java.util.Date;
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

import pe.com.gesateped.businesslogic.AdminBL;
import pe.com.gesateped.businesslogic.MonitoreoBL;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.EstadoPedido;
import pe.com.gesateped.model.Unidad;
import pe.com.gesateped.model.extend.DetallePedidoRuta;
import pe.com.gesateped.model.extend.Ruta;

@SessionAttributes({ "bodega"})
@Controller
@RequestMapping("/monitoreo")
public class MonitoreoController {

	private final static Logger logger = Logger.getLogger(MonitoreoController.class);
	
	@Autowired
	private MonitoreoBL monitoreoBL;
	
	@Autowired
	private AdminBL adminBL;
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView iniciar(ModelMap modelMap) {
		modelMap.put("bodegas", this.monitoreoBL.getBodegas());
		modelMap.addAttribute("bodega", new Bodega());
		modelMap.addAttribute("menu", "monitoreo");
		
		List<Ruta> rutas = this.adminBL.obtenerRutas(new Date());
		modelMap.addAttribute("rutas", rutas);
		
		return new ModelAndView("monitoreo");
	}
	
	@RequestMapping(path="verUnidades",method = RequestMethod.POST)
	@ResponseBody
	public List<Unidad> verUnidades(Bodega bodega) {
		logger.info("bodega: " + bodega.getCodigo());
		return this.monitoreoBL.getUnidades(bodega);
	}
	
	@RequestMapping(path="verEstadoPedidosPorBodega",method = RequestMethod.POST)
	@ResponseBody
	public List<EstadoPedido> verEstadosPedidosPorBodega(Bodega bodega) {
		logger.info("codigoBodega:" + bodega.getCodigo());
		return this.monitoreoBL.getEstadoPedidosPorBodega(bodega.getCodigo());
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
		List<DetallePedidoRuta> pedidosAtendidos = this.monitoreoBL.getDetallePedidosRuta(codigoHojaRuta, "ATEN");
		
		if(pedidosAtendidos.isEmpty()) {
			DetallePedidoRuta mock = new DetallePedidoRuta();
			mock.setCodigoPedido("PED0000024");
			mock.setHoraInicioVentana("8:00");
			mock.setHoraFinVentana("10:00");
			mock.setFechaPactadaDespacho(new Date());
			mock.setDireccionCliente("Calle Doña Ester 216");
			mock.setDistritoCliente("Surco");
			pedidosAtendidos.add(mock);
		}
		
		return pedidosAtendidos;
	}
	
	@RequestMapping(path="verDetallePedidosNoAtendidos",method = RequestMethod.POST)
	@ResponseBody
	public List<DetallePedidoRuta> verDetallePedidosNoAtendidos(String codigoHojaRuta) {
		logger.info("codigoHojaRuta:" + codigoHojaRuta);
		List<DetallePedidoRuta> pedidosNoAtendidos = this.monitoreoBL.getDetallePedidosRuta(codigoHojaRuta, "NATE");
		if(pedidosNoAtendidos.isEmpty()) {
			DetallePedidoRuta mock = new DetallePedidoRuta();
			mock.setCodigoPedido("PED0000024");
			mock.setHoraInicioVentana("8:00");
			mock.setHoraFinVentana("10:00");
			mock.setFechaPactadaDespacho(new Date());
			mock.setDireccionCliente("Calle Doña Ester 216");
			mock.setDistritoCliente("Surco");
			mock.setFechaNoCumplimientoDespacho(new Date());
			mock.setDescripcionMotivoPedido("Sin motivo");
			mock.setLatitudGpsDespacho(-12.136258);
			mock.setLongitudGpsDespacho(-76.996071);
			pedidosNoAtendidos.add(mock);
		}
		return pedidosNoAtendidos;
	}
	
	@RequestMapping(path="verDetallePedidosPendientes",method = RequestMethod.POST)
	@ResponseBody
	public List<DetallePedidoRuta> verDetallePedidosPendientes(String codigoHojaRuta) {
		logger.info("codigoHojaRuta:" + codigoHojaRuta);
		List<DetallePedidoRuta> detallePedidosPendientesRuta = this.monitoreoBL.getDetallePedidosRuta(codigoHojaRuta, "PEND");
		if(detallePedidosPendientesRuta.isEmpty()) {
			DetallePedidoRuta mockItem = new DetallePedidoRuta();
			/*
			 * codigo hoja ruta: 89be9b4f
			 * placa: A7V-510
			 */
			mockItem.setCodigoPedido("PED0000004");
			mockItem.setHoraInicioVentana("8:00");
			detallePedidosPendientesRuta.add(mockItem);
		}
		return detallePedidosPendientesRuta;
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
