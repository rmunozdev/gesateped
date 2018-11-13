package pe.com.gesateped.carga.csv.model;

import java.util.List;

import pe.com.gesateped.carga.csv.validation.CsvValidationError;
import pe.com.gesateped.carga.model.Item;

public class ResumenProcesoCSV {

	private List<Item> items;
	private List<CsvValidationError> errores;
	
	public List<Item> getItems() {
		return items;
	}
	public void setItems(List<Item> items) {
		this.items = items;
	}
	public List<CsvValidationError> getErrores() {
		return errores;
	}
	public void setErrores(List<CsvValidationError> errores) {
		this.errores = errores;
	}
}
