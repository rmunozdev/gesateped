package pe.com.gesateped.batch.control;

import java.util.List;

import pe.com.gesateped.batch.algorithm.Controlador;
import pe.com.gesateped.model.extend.PedidoNormalizado;

public class ControladorTiempo implements Controlador {

	private double tolerancia = 0.5;//0 no tolerance, 1 full
	private int limite = 120;
	
	@Override
	public boolean verificar(List<PedidoNormalizado> pedidos) {
		int tiempo = 0;
		for (PedidoNormalizado pedido : pedidos) {
			if(pedido.getDomicilio()==null) {
				tiempo += pedido.getDemora();
				if(tiempo > limite) {
					return false;
				}
			}
			
		}
		return tiempo > limite*(1-tolerancia);
	}
	
	@Override
	public boolean incrementarTolerancia() {
		if(tolerancia >= 1) {
			return false;
		} else {
			tolerancia += 0.1;
			return true;
		}
	}
}
