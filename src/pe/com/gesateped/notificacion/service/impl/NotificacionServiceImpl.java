package pe.com.gesateped.notificacion.service.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.UnknownHostException;

import org.springframework.stereotype.Service;

import pe.com.gesateped.notificacion.service.NotificacionService;

@Service
public class NotificacionServiceImpl  implements NotificacionService{

	@Override
	public int notificarVentanasHorarias() {
		String ws_url = "http://localhost:8080/GesatepedWS/notificacion/ejecutar";
		try {
			HttpURLConnection conn = (HttpURLConnection) new URL(ws_url).openConnection();
			
			System.out.println("Comunicando con " + ws_url);
			
			conn.setDoOutput(true);
			conn.setRequestMethod("GET");
			
			final BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			final StringBuffer stringBuffer = new StringBuffer();
			String line;
			while ((line = rd.readLine()) != null) {
				stringBuffer.append(line);
			}
			rd.close();
			System.out.println(stringBuffer.toString());
			return 1;
		} catch(UnknownHostException exception) {
			throw new IllegalStateException("No se pudo establecer comunicacion", exception);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return -1;
	}

	
}
