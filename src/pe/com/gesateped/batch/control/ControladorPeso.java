package pe.com.gesateped.batch.control;

import java.util.List;

import pe.com.gesateped.batch.algorithm.Controlador;
import pe.com.gesateped.model.extend.PedidoNormalizado;

public class ControladorPeso implements Controlador {

	private double tolerancia = 1;//0 no tolerance, 1 full
	private double limite;
	
	@Override
	public boolean verificar(List<PedidoNormalizado> pedidos) {
		double peso = 0;
		for (PedidoNormalizado pedido : pedidos) {
			peso += pedido.getPeso();
			if(peso > limite) {
				return false;
			}
		}
		
		return peso > limite*(1-tolerancia);
	}

	public double getTolerancia() {
		return tolerancia;
	}

	public void setTolerancia(double tolerancia) {
		this.tolerancia = tolerancia;
	}

	public double getLimite() {
		return limite;
	}

	public void setLimite(double limite) {
		this.limite = limite;
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
