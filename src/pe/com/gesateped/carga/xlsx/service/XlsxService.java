package pe.com.gesateped.carga.xlsx.service;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import pe.com.gesateped.carga.model.ResumenCarga;

public interface XlsxService {
	
	public void imprimirErroresDeCarga(OutputStream output,InputStream logo,ResumenCarga resumen) throws IOException;
	
}
