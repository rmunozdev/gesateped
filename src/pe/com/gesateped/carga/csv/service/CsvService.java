package pe.com.gesateped.carga.csv.service;

import java.io.Reader;

import pe.com.gesateped.carga.csv.exception.CSVException;
import pe.com.gesateped.carga.csv.model.ResumenProcesoCSV;

public interface CsvService {
	
	/**
	 * Comprueba si el nombre de archivo csv posee una extensión válida.
	 * @param filename
	 * @return
	 */
	public boolean isValidExtension(String filename);
	
	
	/**
	 * Obtiene items a partir de un reader con formato
	 * de CSV.
	 * @param reader
	 * @return
	 * @throws CSVException Si ocurre alguna falla que impida que se 
	 * continue procesando el CSV.
	 */
	public ResumenProcesoCSV getItems(Reader reader) throws CSVException;
}
