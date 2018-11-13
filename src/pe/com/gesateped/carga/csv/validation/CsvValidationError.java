package pe.com.gesateped.carga.csv.validation;

public class CsvValidationError {

	private CsvValidationErrorCode codigo;
	private String campo;
	private int linea;
	private int columna;
	
	public static class Builder {
		
		private CsvValidationErrorCode codigo;
		private int columna;
		private int linea;
		private String campo;
		
		public Builder forPosition(int linea, int columna) {
			this.linea = linea;
			this.columna = columna;
			return this;
		}
		
		public Builder withCodigo(CsvValidationErrorCode codigo) {
			this.codigo = codigo;
			return this;
		}
		
		public Builder withCampo(String campo) {
			this.campo = campo;
			return this;
		}
		
		public CsvValidationError build() {
			return new CsvValidationError(this);
		}
	}
	
	private CsvValidationError(Builder builder) {
		this.codigo = builder.codigo;
		this.linea = builder.linea;
		this.columna = builder.columna;
		this.campo = builder.campo;
	}
	
	
	public CsvValidationErrorCode getCodigo() {
		return codigo;
	}
	public String getCampo() {
		return campo;
	}
	public int getLinea() {
		return linea;
	}
	public int getColumna() {
		return columna;
	}
	
	@Override
	public String toString() {
		return String.format("%s %s [%s, %s]", codigo,campo,linea,columna);
	}
}
