package pe.com.gesateped.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import pe.com.gesateped.dao.PedidoDao;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Parametro;
import pe.com.gesateped.model.Pedido;
import pe.com.gesateped.model.VentanaHoraria;
import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.model.extend.TipoPedido;
import pe.com.gesateped.model.extend.UnidadNormalizada;

@Repository
public class PedidoDaoImpl implements PedidoDao {

	@Autowired
    protected SqlSession gesatepedSession;
	
	@Override
	public List<Pedido> listar() {
		return gesatepedSession.selectList("pedidoDao.listar");
	}

	@Override
	public List<PedidoNormalizado> obtenerPedidosNormalizados(Date fechaDespacho) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("_fecha_despacho", fechaDespacho);
		List<Map<Object,Object>> resultados = gesatepedSession.selectList("pedidoDao.obtenerPedidos",parameters);
		
		Map<String,PedidoNormalizado> pedidosMap = new HashMap<>();
		for (Map<Object, Object> resultado : resultados) {
			PedidoNormalizado pedido = null;
			if(pedidosMap.containsKey(String.valueOf(resultado.get("cod_ped"))+ String.valueOf(resultado.get("cod_bod")))) {
				pedido = pedidosMap.get(String.valueOf(resultado.get("cod_ped"))+ String.valueOf(resultado.get("cod_bod")));
			} else {
				pedido = new PedidoNormalizado();
				pedidosMap.put(String.valueOf(resultado.get("cod_ped"))+ String.valueOf(resultado.get("cod_bod")), pedido);
				pedido.setCodigoPedido(String.valueOf(resultado.get("cod_ped")));
				pedido.setCodigoBodega(String.valueOf(resultado.get("cod_bod")));
				pedido.setFechaDespacho((Date)resultado.get("fec_desp_ped"));
				
				String codigoCliente = String.valueOf(resultado.get("cod_cli"));
				String codigoTiendaDesp = String.valueOf(resultado.get("cod_tiend_desp"));
				String codigoTiendaDevo = String.valueOf(resultado.get("cod_tiend_devo"));
				String fechaRetiroTiend = String.valueOf(resultado.get("fec_ret_tiend"));
				pedido.setTipoPedido(identificarTipoPedido(codigoCliente, codigoTiendaDesp, codigoTiendaDevo, fechaRetiroTiend));
				
				String cliente = String.valueOf(resultado.get("clienteNombres")) + " " + String.valueOf(resultado.get("clienteApellidos"));
				pedido.setCliente(cliente);
				
				//Se adaptan direcciones a lo requerido por apis externas (google)
				String domicilioCliente = String.valueOf(resultado.get("clienteDireccion")) + " " + String.valueOf(resultado.get("clienteDireccionDist")) + " Peru";
				String domicilioTiendaDesp = String.valueOf(resultado.get("tieDespacho")) + " " + String.valueOf(resultado.get("tieDespachoDist")) + " Peru";
				String domicilioTiendaDevol = String.valueOf(resultado.get("tieDevol"))+ " " + String.valueOf(resultado.get("tieDevolDist")) + " Peru";
				
				setDomicilioObjetivo(pedido, domicilioCliente, domicilioTiendaDesp, domicilioTiendaDevol);
			}
			double peso = pedido.getPeso()+Double.valueOf(String.valueOf(resultado.get("pes_prod")));
			double volumen = pedido.getVolumen()+Double.valueOf(String.valueOf(resultado.get("vol_prod")));
			int cantidadProductos = Integer.valueOf(String.valueOf(resultado.get("cant_prod")));
			
			pedido.setPeso(peso*cantidadProductos);
			pedido.setVolumen(volumen*cantidadProductos);
			
		}
		return new ArrayList<>(pedidosMap.values());
	}
	
	private TipoPedido identificarTipoPedido(String codigoCliente,String codigoTiendaDesp,String codigoTiendaDevo,String fechaRetiroTiend) {
		if("null".equals(codigoCliente)) {
			return TipoPedido.REPOSICION_TIENDA;
		} else if("null".equals(codigoTiendaDesp)) {
			return TipoPedido.SERVICIO_A_CLIENTE;
		} else if(!"null".equals(fechaRetiroTiend)){
			return TipoPedido.RECOJO_EN_TIENDA;
		} 
		
		return TipoPedido.DEVOLUCION_A_TIENDA;
	}
	
	private void setDomicilioObjetivo(PedidoNormalizado pedido, String domicilioCliente, String domicilioTiendaDesp, String domicilioTiendaDevol) {
		switch(pedido.getTipoPedido()) {
		case DEVOLUCION_A_TIENDA:
			break;
		case RECOJO_EN_TIENDA:
			pedido.setDomicilio(domicilioTiendaDesp);
			break;
		case REPOSICION_TIENDA:
			pedido.setDomicilio(domicilioTiendaDesp);
			break;
		case SERVICIO_A_CLIENTE:
			pedido.setDomicilio(domicilioCliente);
			break;
		default:
			break;
		
		}
	}

	@Override
	public List<UnidadNormalizada> obtenerUnidadesNormalizadas() {
		List<Map<Object,Object>> resultados = gesatepedSession.selectList("pedidoDao.obtenerUnidades");
		
		List<UnidadNormalizada> unidades = new ArrayList<>();
		for (Map<Object, Object> resultadoMap : resultados) {
			UnidadNormalizada unidad = new UnidadNormalizada();
			unidad.setNumeroPlaca(String.valueOf(resultadoMap.get("num_plac_unid")));
			unidad.setCodigoUnidadChofer(String.valueOf(resultadoMap.get("cod_unid_chof")));
			unidad.setNombreChofer(String.valueOf(resultadoMap.get("nom_chof")) + " " + String.valueOf(resultadoMap.get("ape_chof")) );
			unidad.setBreveteChofer(String.valueOf(resultadoMap.get("num_brev_chof")));
			unidad.setSoat(String.valueOf(resultadoMap.get("num_soat_unid")));
			unidad.setPesoCargaMaxima(Double.valueOf(String.valueOf(resultadoMap.get("pes_max_carg"))));
			unidad.setVolumenCargaMaxima(Double.valueOf(String.valueOf(resultadoMap.get("vol_max_carg"))));
			unidades.add(unidad);
		}
		return unidades;
	}

	@Override
	public void registrarHojaRuta(Ruta ruta) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("_fec_desp_hoj_rut", ruta.getFechaDespacho());
		parameters.put("_cod_bod", ruta.getCodigoBodega());
		parameters.put("_cod_unid_chof", ruta.getUnidad().getCodigoUnidadChofer());
		parameters.put("RANDOM_KEY", null);
		gesatepedSession.insert("pedidoDao.registrarHojaRuta", parameters );
		Object insertedKey = parameters.get("RANDOM_KEY");
		System.out.println("Inserted a retrieved id: " + insertedKey);
		//Estableciendo codigo hoja de ruta creado
		for(PedidoNormalizado pedido : ruta.getPedidos()) {
			String codigoHojaRuta = String.valueOf(insertedKey);
			pedido.setCodigoHojaRuta(codigoHojaRuta);
		}
		
		//Registrando detalles
		int response = gesatepedSession.insert("pedidoDao.registrarDetallePedidoList",ruta.getPedidos());
		System.out.println("Response: " + response);
		
	}

	@Override
	public List<Ruta> obtenerRutas() {
		List<Ruta> rutas = new ArrayList<>();
		List<Map<Object,Object>> resultados = gesatepedSession.selectList("pedidoDao.obtenerRutas");
		
		for (Map<Object, Object> resultadoMap : resultados) {
			Ruta ruta = new Ruta();
			ruta.setCodigoRuta(String.valueOf(resultadoMap.get("cod_hoj_rut")));
			ruta.setFechaDespacho((Date)resultadoMap.get("fec_desp_hoj_rut"));
			ruta.setFechaGeneracion((Date)resultadoMap.get("fec_gen_hoj_rut"));
			ruta.setCodigoBodega(String.valueOf(resultadoMap.get("cod_bod")));
			ruta.setNombreBodega(String.valueOf(resultadoMap.get("nom_bod")));
			UnidadNormalizada unidad = new UnidadNormalizada();
			
			unidad.setNumeroPlaca(String.valueOf(resultadoMap.get("num_plac_unid")));
			unidad.setNombreChofer(String.valueOf(resultadoMap.get("nom_chof")) + " " + String.valueOf(resultadoMap.get("ape_chof")) );
			unidad.setBreveteChofer(String.valueOf(resultadoMap.get("num_brev_chof")));
			unidad.setSoat(String.valueOf(resultadoMap.get("num_soat_unid")));
			unidad.setPesoCargaMaxima(Double.valueOf(String.valueOf(resultadoMap.get("pes_max_carg"))));
			unidad.setVolumenCargaMaxima(Double.valueOf(String.valueOf(resultadoMap.get("vol_max_carg"))));
			ruta.setUnidad(unidad);
			Map<String,Object> parameters = new HashMap<>();
			parameters.put("_cod_hoj_rut", ruta.getCodigoRuta());
			List<Map<Object,Object>> detalles = gesatepedSession.selectList("pedidoDao.obtenerDetalleRutaCliente",parameters);
			System.out.println("detalles de ruta para hoja ruta " + ruta.getCodigoRuta() + " : " + detalles.size());
			
			List<PedidoNormalizado> pedidos = new ArrayList<>();
			for (Map<Object, Object> detalleMap : detalles) {
				PedidoNormalizado pedido = new PedidoNormalizado();
				pedido.setCodigoPedido(String.valueOf(detalleMap.get("cod_ped")));
				pedido.setOrden((Integer)detalleMap.get("ord_desp_ped"));
				
				if(detalleMap.get("nom_cli") == null || detalleMap.get("fec_ret_tiend") != null) {
					pedido.setCliente(String.valueOf(detalleMap.get("nom_tiend")));
					pedido.setDomicilio(String.valueOf(detalleMap.get("dir_tiend")) + " " + String.valueOf(detalleMap.get("dist_tiend")));
				} else {
					pedido.setCliente(String.valueOf(detalleMap.get("nom_cli")) + " " + String.valueOf(detalleMap.get("ape_cli")));
					pedido.setDomicilio(String.valueOf(detalleMap.get("dir_cli")) + " " + String.valueOf(detalleMap.get("dist_cli")));
				}
				pedido.setVentana("De " + String.valueOf(detalleMap.get("hor_ini_vent_hor")) + " a " + String.valueOf(detalleMap.get("hor_fin_vent_hor")));
				pedidos.add(pedido);
			}
			ruta.setPedidos(pedidos);
			rutas.add(ruta);
		}
		
		return rutas;
	}

	@Override
	public Bodega obtenerBodega(String codigoBodega) {
		Map<String,Object> parameters = new HashMap<>();
		parameters.put("_codigo_bodega", codigoBodega);
		List<Map<Object,Object>> resultados = gesatepedSession.selectList("pedidoDao.obtenerBodegaCliente", parameters);
		
		if(resultados.isEmpty() || resultados.size()>1) {
			throw new IllegalStateException("Resultados de bodegas inesperados");
		}
		
		Map<Object, Object> resultMap = resultados.get(0);
		
		Bodega bodega = new Bodega();
		bodega.setCodigo(codigoBodega);
		bodega.setCodigoDistrito(String.valueOf(resultMap.get("cod_dist")));
		bodega.setDireccion(String.valueOf(resultMap.get("dir_bod")) + " " + String.valueOf(resultMap.get("nom_dist") + " Peru"));
		return bodega;
	}

	@Override
	public List<VentanaHoraria> obtenerVentanasHorarias() {
		List<VentanaHoraria> ventanas = new ArrayList<>();
		List<Map<Object,Object>> resultados = gesatepedSession.selectList("pedidoDao.obtenerVentanasHorarias");
		
		for (Map<Object, Object> resultado : resultados) {
			VentanaHoraria ventana = new VentanaHoraria();
			ventana.setCodigo(String.valueOf(resultado.get("cod_vent_hor")));
			ventana.setHoraInicio(String.valueOf(resultado.get("hor_ini_vent_hor")));
			ventana.setHoraFin(String.valueOf(resultado.get("hor_fin_vent_hor")));
			ventana.setTipo(String.valueOf(resultado.get("tip_vent_hor")));
			ventanas.add(ventana);
		}
		
		return ventanas;
	}

	@Override
	public List<Parametro> listarParametros() {
		List<Parametro> parametros = new ArrayList<>();
		List<Map<Object,Object>> resultados = gesatepedSession.selectList("pedidoDao.listarParametros");
		
		for (Map<Object, Object> resultado : resultados) {
			Parametro parametro = new Parametro();
			parametro.setNombre(String.valueOf(resultado.get("nom_param")));
			parametro.setDescripcion(String.valueOf(resultado.get("desc_param")));
			parametro.setValor(String.valueOf(resultado.get("val_param")));
			parametros.add(parametro);
		}
		
		return parametros;
	}
	
	

}