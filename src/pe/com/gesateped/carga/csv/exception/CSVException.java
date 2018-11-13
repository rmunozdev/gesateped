package pe.com.gesateped.carga.csv.exception;

import java.util.List;

import pe.com.gesateped.carga.csv.validation.CsvValidationError;

public class CSVException extends Throwable {

	private static final long serialVersionUID = 1L;
	
	private List<CsvValidationError> errors;

	public CSVException(List<CsvValidationError> errors) {
		this.errors = errors;
	}

	public List<CsvValidationError> getErrors() {
		return errors;
	}

	public void setErrors(List<CsvValidationError> errors) {
		this.errors = errors;
	}
	
	
}
