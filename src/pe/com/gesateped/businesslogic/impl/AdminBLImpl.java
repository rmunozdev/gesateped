package pe.com.gesateped.businesslogic.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pe.com.gesateped.businesslogic.AdminBL;
import pe.com.gesateped.dao.PedidoDao;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.model.Parametro;
import pe.com.gesateped.model.Pedido;
import pe.com.gesateped.model.VentanaHoraria;
import pe.com.gesateped.model.extend.PedidoNormalizado;
import pe.com.gesateped.model.extend.Ruta;
import pe.com.gesateped.model.extend.UnidadNormalizada;

@Service
public class AdminBLImpl implements AdminBL {

	@Autowired
	private PedidoDao pedidoDao;
	
	@Override
	public List<Pedido> listarPedidos() {
		return pedidoDao.listar();
	}

	@Override
	public List<PedidoNormalizado> obtenerPedidosNormalizados() {
		Calendar tomarrow = Calendar.getInstance();
		tomarrow.add(Calendar.DATE, 1);
		System.out.println("Buscando pedidos a despachar el: " + tomarrow.getTime());
		return pedidoDao.obtenerPedidosNormalizados(tomarrow.getTime());
	}

	@Override
	public List<UnidadNormalizada> obtenerUnidadesNormalizadas() {
		return pedidoDao.obtenerUnidadesNormalizadas();
	}

	@Override
	public void registrarHojaRuta(Ruta ruta) {
		pedidoDao.registrarHojaRuta(ruta);
	}

	@Override
	public List<Ruta> obtenerRutas(Date fechaDespacho) {
		return pedidoDao.obtenerRutas(fechaDespacho);
	}

	@Override
	public Bodega obtenerBodega(String codigoBodega) {
		return pedidoDao.obtenerBodega(codigoBodega);
	}

	@Override
	public List<VentanaHoraria> obtenerVentanas() {
		return pedidoDao.obtenerVentanasHorarias();
	}

	@Override
	public List<Parametro> listarParametros() {
		return pedidoDao.listarParametros();
	}
	
}
