package pe.com.gesateped.carga.controller;

import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.ModelAndView;

import pe.com.gesateped.carga.model.Carga;
import pe.com.gesateped.carga.model.ResumenCarga;
import pe.com.gesateped.carga.service.CargaService;
import pe.com.gesateped.carga.xlsx.service.XlsxService;
import pe.com.gesateped.common.Parametros;

@SessionAttributes({ "carga"})
@Controller
@RequestMapping("/carga")
public class CargaController {

	private final static Logger logger = Logger.getLogger(CargaController.class);
	
	@Autowired
	private CargaService cargaService;
	
	@Autowired
	private XlsxService xlsxService;
	
	@Autowired
	public Parametros parametros;
	
	@RequestMapping(method=RequestMethod.GET)
	public ModelAndView inicio(ModelMap model) {
		logger.info("inicio Success");
		model.addAttribute("menu", "carga");
		model.addAttribute("carga",new Carga());
		model.put("proveedores", this.cargaService.listarProveedores());
		model.put("bodegas", this.cargaService.listarSoloBodegas());
		model.put("nodos", this.cargaService.listarSoloNodos());
		model.put("maxFileSize", Parametros.getMaxUploadFileMBSize());
		return new ModelAndView("carga");
	}
	
	@RequestMapping(path="procesar",method=RequestMethod.POST)
	@ResponseBody
	public ResumenCarga procesar(Carga carga, HttpSession session) {
		ResumenCarga resumen;
		logger.info("Bodega: " + carga.getBodega().getCodigo());
		logger.info("Proveedor: " + carga.getProveedor().getCodigo());
		logger.info("Nodo: " + carga.getNodo().getCodigo());
		logger.info("Fecha: " + carga.getFecha());
		logger.info("Archivo: " + carga.getFile().getName());
		logger.info("Archivo nombre original: " + carga.getFile().getOriginalFilename());
		resumen = this.cargaService.procesar(carga);
		session.setAttribute("resumen", resumen);
		return resumen;
	}
	
	@Bean(name = "multipartResolver")
	public CommonsMultipartResolver multipartResolver() {
	    CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
	    multipartResolver.setMaxUploadSize(Parametros.getMaxUploadFileMBSize());
	    return multipartResolver;
	}
	
	
	@RequestMapping("/exportar-excel")
	public void exportarExcel(HttpServletResponse response, HttpSession session) throws IOException {
		ResumenCarga resumen = (ResumenCarga) session.getAttribute("resumen");
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment; filename=ErroresCarga.xlsx");
		InputStream logo = session.getServletContext().getResourceAsStream("/images/sodimaclogo.png");
		this.xlsxService.imprimirErroresDeCarga(response.getOutputStream(),logo, resumen);
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
	
	@RequestMapping("/ver-plantilla")
	public void verPlantilla(HttpServletRequest request, HttpServletResponse response) throws IOException {
		InputStream resourceStream = request.getServletContext().getResourceAsStream("/files/PlantillaCargaProductos.csv");
		response.setContentType("text/csv");
		response.setHeader("Content-Disposition", "attachment; filename=plantilla.csv");
		ServletOutputStream outputStream = response.getOutputStream();
		
		byte[] buffer = new byte[1024];
		while(resourceStream.read(buffer) != -1) {
			outputStream.write(buffer);
		}
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
	
}
