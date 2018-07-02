package pe.com.gesateped.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.util.JRLoader;
import pe.com.gesateped.batch.HojaRutaBatch;
import pe.com.gesateped.businesslogic.AdminBL;
import pe.com.gesateped.common.Parametros;
import pe.com.gesateped.reports.PedidoReport;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	private final static Logger logger = Logger.getLogger(AdminController.class);
	
	@Autowired
	private AdminBL adminBL;
	
	@Autowired
	private Parametros parametros;
	
	@Autowired
	private PedidoReport pedidoReport;
	
	@Autowired
	private HojaRutaBatch hojaRutaBatch;
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView welcome() {
		logger.info("Admin controller acceded");
		return new ModelAndView("admin");
	}
	
	@RequestMapping("/runbatch")
	public void runbatch(HttpServletResponse response, HttpSession session)  throws IOException {
		hojaRutaBatch.generarHojaRuta(session.getServletContext().getRealPath("/report/HojaRuta.jasper"));
		
		response.setContentType("text/plain");
		response.getWriter().print("Batch executed");
	}
	
	
	@RequestMapping("/generarReporte")
	public void generarReporte(HttpServletResponse response, HttpSession session) throws IOException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		try {
			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "attachment; filename=HojaRutas.pdf");
			JRDataSource jrDataSource = new JRBeanCollectionDataSource(pedidoReport.prepareData());
			String path = session.getServletContext().getRealPath("/report/HojaRuta.jasper");
			JasperReport jasperReport = (JasperReport) JRLoader.loadObjectFromFile(path);
			JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, jrDataSource);
			JasperExportManager.exportReportToPdfStream(jasperPrint, response.getOutputStream());
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (JRException | IOException e) {
			e.printStackTrace();
		}
	}
	
}
