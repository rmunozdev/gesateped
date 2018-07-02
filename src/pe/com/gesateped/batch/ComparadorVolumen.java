package pe.com.gesateped.batch;

import java.util.Comparator;

import pe.com.gesateped.model.extend.Medible;

public class ComparadorVolumen implements Comparator<Medible> {

private int direccionOrdenamiento;
	
	public ComparadorVolumen(boolean isAscendente) {
		this.direccionOrdenamiento = (isAscendente)?1:-1;
	}

	@Override
	public int compare(Medible o1, Medible o2) {
		return this.direccionOrdenamiento*((int)(o1.getVolumen() - o2.getVolumen()));
	}
}
