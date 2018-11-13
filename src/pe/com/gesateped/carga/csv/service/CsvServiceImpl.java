package pe.com.gesateped.carga.csv.service;

import java.io.Reader;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.jsefa.DeserializationException;
import org.jsefa.common.converter.ConversionException;
import org.jsefa.common.validator.ValidationErrorCodes;
import org.jsefa.common.validator.ValidationException;
import org.jsefa.csv.CsvDeserializer;
import org.jsefa.csv.CsvIOFactory;
import org.jsefa.csv.config.CsvConfiguration;
import org.springframework.stereotype.Service;

import pe.com.gesateped.carga.csv.exception.CSVException;
import pe.com.gesateped.carga.csv.model.ResumenProcesoCSV;
import pe.com.gesateped.carga.csv.validation.CsvValidationError;
import pe.com.gesateped.carga.csv.validation.CsvValidationError.Builder;
import pe.com.gesateped.carga.csv.validation.CsvValidationErrorCode;
import pe.com.gesateped.carga.model.Item;

@Service
public class CsvServiceImpl implements CsvService {
	
	private final static Logger logger = Logger.getLogger(CsvService.class);

	@Override
	public ResumenProcesoCSV getItems(Reader reader) throws CSVException {
		ResumenProcesoCSV resumen = new ResumenProcesoCSV();
		
		CsvConfiguration config = new CsvConfiguration();
        config.setFieldDelimiter(';');
		CsvDeserializer deserializer = CsvIOFactory.createFactory(config,Item.class).createDeserializer();
		
		List<Item> items = new ArrayList<>();
		List<CsvValidationError> errores = new ArrayList<>();
		
		deserializer.open(reader);
		//Control de cabecera
		if(deserializer.hasNext()) {
			try {
				deserializer.next();
			} catch(DeserializationException deserializationException) {
				logger.error("Falla en line de cabecera es ignorada");
			}finally {
				logger.info("Resultado de procesamiento de cabecera omitido");
			}
		}
		
		int linea = deserializer.getInputPosition().getLineNumber();
		while(deserializer.hasNext()) {
			try {
				linea = deserializer.getInputPosition().getLineNumber();
				Item item = deserializer.next();
				item.setLinea(linea);
				items.add(item);
			} catch (DeserializationException deserializationException) {
				errores.addAll(parseErrors(deserializationException));
				logger.error("Error al deserializar");
			}
		}
		
		
		
		resumen.setItems(items);
		resumen.setErrores(errores);
		return resumen;
	}
	
	private List<CsvValidationError> parseErrors(DeserializationException exception) {
		List<CsvValidationError> errores = new ArrayList<>();
		logger.info("Exception line number:" + exception.getInputPosition().getLineNumber());
		Builder builder = new CsvValidationError.Builder()
				.forPosition(exception.getInputPosition().getLineNumber(),
						exception.getInputPosition().getColumnNumber());
		
		if(exception.getCause() != null && 
				exception.getCause() instanceof ValidationException) {
			ValidationException cause = (ValidationException) exception.getCause();
			logger.info("Cause fails: "+ cause.getValidationResult().getErrors().size());
			cause.getValidationResult().getErrors().forEach(error -> {
				error.getRelativeObjectPath().forEach(path -> {
					builder.withCampo(path.getFieldName());
				});
				switch(error.getErrorCode()) {
				case ValidationErrorCodes.MISSING_VALUE:
					builder.withCodigo(CsvValidationErrorCode.MISSING_VALUE);
					break;
				default:
					builder.withCodigo(CsvValidationErrorCode.GENERAL);
				}
				errores.add(builder.build());
			});
			
		} else if(exception.getCause() != null && 
				exception.getCause() instanceof ConversionException) {
			ConversionException cause = (ConversionException) exception.getCause();
			System.out.println(">>Conversion cause: " + cause.getCause());
			System.out.println(">>Conversion suppressed: " + cause.getSuppressed());
			if(cause.getSuppressed()!= null) {
				for(Throwable error : cause.getSuppressed()) {
					System.out.println(">>error >>" + error);
				}
			}
			exception.getObjectPath().forEach(path -> {
				builder.withCampo(path.getFieldName());
				builder.withCodigo(CsvValidationErrorCode.FORMAT);
				errores.add(builder.build());
			});
			
		} else {
			builder.withCampo("-- NO FIELD --");
			builder.withCodigo(CsvValidationErrorCode.GENERAL);
			errores.add(builder.build());
		}
		
		return errores;
	}

	@Override
	public boolean isValidExtension(String filename) {
		return filename.matches(".*?\\.csv");
	}

}
