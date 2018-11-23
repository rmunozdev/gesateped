package pe.com.gesateped.notificacion.abastecimiento.email.model;

public class MailResponseCodes {

	private MailResponseCodes() {
	}
	
	public static final Integer SUCESS = 1;
	public static final Integer SUCESS_AFTER_FIRST_ATTEMPT = 2;
	public static final Integer FAIL = -1;
	
}
