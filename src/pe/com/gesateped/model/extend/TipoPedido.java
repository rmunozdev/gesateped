package pe.com.gesateped.model.extend;

public enum TipoPedido {

	REPOSICION_TIENDA,
	SERVICIO_A_CLIENTE,
	RECOJO_EN_TIENDA,
	DEVOLUCION_A_TIENDA;
	
	
	@Override
	  public String toString() {
	    switch(this) {
	      case REPOSICION_TIENDA: return "Reposición a tienda";
	      case SERVICIO_A_CLIENTE: return "Servicio al cliente";
	      case RECOJO_EN_TIENDA: return "Recojo en tienda";
	      case DEVOLUCION_A_TIENDA: return "Devolución";
	      default: throw new IllegalArgumentException();
	    }
	  }
}
