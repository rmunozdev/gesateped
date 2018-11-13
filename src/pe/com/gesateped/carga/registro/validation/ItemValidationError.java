package pe.com.gesateped.carga.registro.validation;

public class ItemValidationError {

	private RegistroCargaErrorCode codigo;
	private String campo;
	
	public RegistroCargaErrorCode getCodigo() {
		return codigo;
	}
	public void setCodigo(RegistroCargaErrorCode codigo) {
		this.codigo = codigo;
	}
	public String getCampo() {
		return campo;
	}
	public void setCampo(String campo) {
		this.campo = campo;
	}
	
}
