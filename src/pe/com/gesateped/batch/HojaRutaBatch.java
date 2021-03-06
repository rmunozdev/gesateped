package pe.com.gesateped.batch;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;
import net.sf.jasperreports.engine.util.JRLoader;
import pe.com.gesateped.batch.filter.FiltroBodega;
import pe.com.gesateped.batch.filter.FiltroCapacidad;
import pe.com.gesateped.batch.filter.FiltroTipoPedido;
import pe.com.gesateped.businesslogic.AdminBL;
import pe.com.gesateped.businesslogic.AuditoriaBL;
import pe.com.gesateped.common.Parametros;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.VentanaHoraria;
import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.model.extend.UnidadNormalizada;
import pe.com.gesateped.notificacion.service.NotificacionService;
import pe.com.gesateped.reports.PedidoReport;
import pe.com.gesateped.util.GesatepedUtil;

/**
 * Clase para ejecuci�n de proceso generador de hoja de rutas.
 * @author rmunozdev
 */
@Service("hojaRutaBach")
public class HojaRutaBatch {
	
	public static final String PROCESO_HOJA_RUTA = "GEN_HOJ_RUT"; 
	private static final String ACTIVIDAD_SELECCION = "Selecci�n de pedidos a procesar"; 
	private static final String ACTIVIDAD_AGRUPACION = "Agrupaci�n de pedidos por bodega"; 
	private static final String ACTIVIDAD_DISTRIBUCION = "Distribuci�n de pedidos a unidades"; 
	private static final String ACTIVIDAD_REGISTRO = "Registro de rutas en base datos"; 
	private static final String ACTIVIDAD_REPORTE = "Generaci�n de reporte hoja de ruta"; 

	@Autowired
	private AdminBL adminBL;
	
	@Autowired
	private PedidoReport pedidoReport;
	
	@Autowired
	private AuditoriaBL auditoriaBL;
	
	@Autowired
	private NotificacionService notificacionService;
	
	@Autowired
	public Parametros parametros;
	
	private ServletContext context;
	
	@Autowired
	public HojaRutaBatch(ServletContext context) {
		this.context = context;
	}
	
	/**
	 * Se ejecuta desde batch (Limpia despacho equivalentes previos)
	 */
	public void ejecutar() {
		this.auditoriaBL.iniciarProceso(PROCESO_HOJA_RUTA);
		this.eliminarRutas();
		this.generarHojaRuta();
		this.generarReporte(GesatepedUtil.getDiaSiguiente());
		this.auditoriaBL.finalizarProceso(true);
	}
	
	public void eliminarRutas() {
		this.adminBL.eliminarRutas();
	}

	public void generarHojaRuta() {
		List<Ruta> rutasGeneradas = new ArrayList<>();
		this.auditoriaBL.iniciarActividad(ACTIVIDAD_SELECCION);
		
		List<PedidoNormalizado> pedidosNormalizado = adminBL.obtenerPedidosNormalizados();
		
		//Se mantiene la adquisici�n total para descartar pedidos imposibles
		List<UnidadNormalizada> unidadesNormalizadas = adminBL.obtenerUnidadesNormalizadas();
		this.auditoriaBL.finalizarActividad(ACTIVIDAD_SELECCION, true, "Total pedidos originales: " + pedidosNormalizado.size());
		
		// Filtros
		List<PedidoNormalizado> pedidosValidos = new FiltroCapacidad(unidadesNormalizadas).filtrar(pedidosNormalizado);

		// Se separan los pedidosValidos agrupandolos por bodegas
		this.auditoriaBL.iniciarActividad(ACTIVIDAD_AGRUPACION);
		FiltroBodega filtroBodega = new FiltroBodega();
		Map<String, List<PedidoNormalizado>> pedidosPorBodega = filtroBodega.separar(pedidosValidos);
		this.auditoriaBL.finalizarActividad(ACTIVIDAD_AGRUPACION,true,"Grupos por bodega: " + pedidosPorBodega.size());
		
		// Cada grupo por bodega es separado por tipo de pedido
		FiltroTipoPedido filtroTipoPedido = new FiltroTipoPedido();
		
		this.auditoriaBL.iniciarActividad(ACTIVIDAD_DISTRIBUCION);
		for (String codigoBodega : pedidosPorBodega.keySet()) {
			Map<String, List<PedidoNormalizado>> pedidosPorTipo = filtroTipoPedido
					.separar(pedidosPorBodega.get(codigoBodega));
			// Cada subgrupo de pedidoPorTipo debe procesarse
			List<UnidadNormalizada> unidadesBodega = this.adminBL.obtenerUnidadesNormalizadas(codigoBodega);
			for (String tipoPedido : pedidosPorTipo.keySet()) {
				Bodega bodega = adminBL.obtenerBodega(codigoBodega);
				//Update: Las unidades se eligen por bodega
				
				Despachador despachador = new Despachador(pedidosPorTipo.get(tipoPedido), unidadesBodega);
				System.out.println(String.format("Despacho para bodega %s, tipoPedido %s y numero pedidos: %s",
						codigoBodega, tipoPedido, pedidosPorTipo.get(tipoPedido).size()));
				despachador.despachar(bodega);
				rutasGeneradas.addAll(despachador.getRutas());
				unidadesBodega = filtrarUnidades(unidadesBodega, despachador.getRutas());
			}
		}
		
		
		System.out.println("\nResultado final: ");
		System.out.println("******************");
		if (rutasGeneradas.isEmpty()) {
			this.auditoriaBL.finalizarActividad(ACTIVIDAD_DISTRIBUCION,false,"No se gener� ninguna ruta");
		} else {
			this.auditoriaBL.finalizarActividad(ACTIVIDAD_DISTRIBUCION,true,"Rutas generadas " + rutasGeneradas.size());
			this.auditoriaBL.iniciarActividad(ACTIVIDAD_REGISTRO);
			asignarHorarios(rutasGeneradas);
			DecimalFormat df = new DecimalFormat("#.##");
			df.setRoundingMode(RoundingMode.CEILING);
			for (Ruta ruta : rutasGeneradas) {
				System.out.print("Placa: " + ruta.getUnidad().getNumeroPlaca());
				System.out.print("(");

				System.out.print("v%:" + df.format(ruta.calcularEfectividadVolumen()));
				System.out.print("  p%:" + df.format(ruta.calcularEfectividadPeso()));
				System.out.println(")");
				System.out.println("\tCodigo\t\tPeso\tVolumen\tTiempo\tVentana\tTiempo");
				for (PedidoNormalizado pedido : ruta.getPedidos()) {
					System.out.println("\t" + pedido.getCodigoPedido() + "\t" + pedido.getPeso() + "\t"
							+ pedido.getVolumen() + "\t" + pedido.getDemora() + "\t" + pedido.getCodigoVentanaHoraria()
							+ "\t" + pedido.getTiempoCronometrico());
				}
				System.out.println("");
				adminBL.registrarHojaRuta(ruta);
			}
			this.auditoriaBL.finalizarActividad(ACTIVIDAD_REGISTRO,true,"Reporte finalizado");
			if(Parametros.flagNotificacionActivada()) {
				this.notificacionService.notificarVentanasHorarias();
			} else {
				System.out.println("La notificaci�n de ventana horaria se encuentra desactivada");
			}
		}
		
	}

	private void asignarHorarios(List<Ruta> rutas) {
		try {
			List<VentanaHoraria> ventanas = this.adminBL.obtenerVentanas();

			// Fecha de inicio
			SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");
			Calendar tomorrow = Calendar.getInstance();
			tomorrow.add(Calendar.DAY_OF_MONTH, 1);
			
			List<Calendar> inicios = new ArrayList<>();
			List<Calendar> finales = new ArrayList<>();
			//Almacena tiempo muerto acumulado
			List<Long> saltos = new ArrayList<>();
			saltos.add(0L); //Primer espacio se considera vacio
			
			long[] rangos = new long[ventanas.size()];
			long finPrevio = 0;
			int index = 0;
			// Se asume que las ventanas estan ordenadas en forma ascendente
			for (VentanaHoraria ventana : ventanas) {
				if (index != 0) {
					rangos[index] = rangos[index - 1]
							+ getSecondsBetween(ventana.getHoraInicio(), ventana.getHoraFin());
				} else {
					rangos[index] = getSecondsBetween(ventana.getHoraInicio(), ventana.getHoraFin());
				}
				index++;
				
				Calendar inicio = Calendar.getInstance();
				inicio.setTime(timeFormatter.parse(ventana.getHoraInicio()));
				inicio.set(tomorrow.get(Calendar.YEAR), tomorrow.get(Calendar.MONTH), tomorrow.get(Calendar.DAY_OF_MONTH));
				inicios.add(inicio);
				
				Calendar fin = Calendar.getInstance();
				fin.setTime(timeFormatter.parse(ventana.getHoraFin()));
				fin.set(tomorrow.get(Calendar.YEAR), tomorrow.get(Calendar.MONTH), tomorrow.get(Calendar.DAY_OF_MONTH));
				finales.add(fin);
				
				if(finPrevio != 0) {
					saltos.add(saltos.get(saltos.size()-1) + inicio.getTimeInMillis() - finPrevio);
				}
				finPrevio = fin.getTimeInMillis();
				
			}
			
			 

			System.out.println("Rangos: " + Arrays.toString(rangos));
			for (Ruta ruta : rutas) {
				// Pedidos dentro de ruta (inicio de horario)
				//TODO La fecha de partida cambiara de acuerdo a la salida de la unidad.
				for (PedidoNormalizado pedido : ruta.getPedidos()) {
					long tiempoMuerto = 0;
					long tiempo = pedido.getTiempoCronometrico();
					if (tiempo < rangos[0]) {
						pedido.setCodigoVentanaHoraria(ventanas.get(0).getCodigo());
					} else {
						for (int i = 1; i < rangos.length; i++) {
							if (rangos[i - 1] <= tiempo && tiempo < rangos[i]) {
								// Pertenece a i
								pedido.setCodigoVentanaHoraria(ventanas.get(i).getCodigo());
								tiempoMuerto = saltos.get(i);
							}
						}
					}

					// Establecer fecha pactada de despacho
					Date fechaEstimadaLlegada = new Date(inicios.get(0).getTimeInMillis() + tiempo*1000 + tiempoMuerto);
					pedido.setFechaEstimadaLlegada(fechaEstimadaLlegada);
					pedido.setTiempoPromedioDespacho(Integer.parseInt(Parametros.getTiempoPromedioDespacho()));
					
				}
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}

	}

	private long getSecondsBetween(String horaInicio, String horaFin) throws ParseException {
		SimpleDateFormat timeFormatter = new SimpleDateFormat("HH:mm");
		return (timeFormatter.parse(horaFin).getTime() - timeFormatter.parse(horaInicio).getTime()) / 1000;
	}
	
	private List<UnidadNormalizada> filtrarUnidades(List<UnidadNormalizada> fuente, List<Ruta> referencias) {
		List<UnidadNormalizada> filtrado = new ArrayList<>(fuente);
		for(Ruta referencia: referencias) {
			filtrado.remove(referencia.getUnidad());
		}
		return filtrado;
	}
	
	public List<String> generarReporte(Date fechaDespacho) {
		Map<String, Object> parameters = new HashMap<String, Object>();
		try {
			//Se filtra data por cada bodega
			Map<String, List<Map<String, ?>>> grupos = pedidoReport.getGruposPorBodega(fechaDespacho);
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
			String marcadorFecha = simpleDateFormat.format(new Date());
			for(String nombreBodega : grupos.keySet()) {
				this.auditoriaBL.iniciarActividad(ACTIVIDAD_REPORTE);
				List<Map<String, ?>> grupo = grupos.get(nombreBodega);
				JRDataSource jrDataSource = new JRBeanCollectionDataSource(grupo);
				//20180702_HojaRuta_nombrebodega.pdf
				String pathDestination = Parametros.getDirectorioDestinoHojaRuta() + "/"+marcadorFecha+"_HojaRuta_"
						+ nombreBodega
						+ ".pdf";
				String source = this.context.getRealPath("/report/HojaRuta.jasper");
				File destino = new File(pathDestination);
				FileOutputStream fileOutputStream = new FileOutputStream(destino);
				
				JasperReport jasperReport = (JasperReport) JRLoader.loadObjectFromFile(source);
				JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, jrDataSource);
				JasperExportManager.exportReportToPdfStream(jasperPrint, fileOutputStream);
				fileOutputStream.close();
				this.auditoriaBL.finalizarActividad(ACTIVIDAD_REPORTE, true, "Reporte para bodega " + nombreBodega + " construido en: " + pathDestination);
			}
			return new ArrayList<>(grupos.keySet());
		} catch (JRException | IOException e) {
			this.auditoriaBL.finalizarActividad(ACTIVIDAD_REPORTE, false, "No se pudo grabar reporte");
			e.printStackTrace();
		}
		return Collections.emptyList();
	}
	
	public List<String> getBodegasAsignadas(Date fechaDespacho) {
		Map<String, List<Map<String, ?>>> grupos = pedidoReport.getGruposPorBodega(fechaDespacho);
		return new ArrayList<>(grupos.keySet());
	}
	
	public void imprimirReporte(OutputStream output, String nombreBodega,Date fechaDespacho) {
		try {
			//Se filtra data por cada bodega
			Map<String, List<Map<String, ?>>> grupos = pedidoReport.getGruposPorBodega(fechaDespacho);
			for(String nombreBodegaActual : grupos.keySet()) {
				if(nombreBodegaActual.equals(nombreBodega)) {
					List<Map<String, ?>> grupo = grupos.get(nombreBodegaActual);
					JRDataSource jrDataSource = new JRBeanCollectionDataSource(grupo);
					String source = this.context.getRealPath("/report/HojaRuta.jasper");
					JasperReport jasperReport = (JasperReport) JRLoader.loadObjectFromFile(source);
					Map<String, Object> parameters = new HashMap<String, Object>();
					JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, jrDataSource);
					JasperExportManager.exportReportToPdfStream(jasperPrint, output);
					return;
				}
			}
		} catch (JRException e) {
			e.printStackTrace();
		}
	}
}
