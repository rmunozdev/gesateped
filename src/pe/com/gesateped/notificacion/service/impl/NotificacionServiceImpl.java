package pe.com.gesateped.notificacion.service.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.UnknownHostException;

import org.springframework.stereotype.Service;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import pe.com.gesateped.common.Parametros;
import pe.com.gesateped.notificacion.service.NotificacionService;

@Service
public class NotificacionServiceImpl  implements NotificacionService{
	
	public static final int RESPONSE_CODIGO_EXITO = 1;
	public static final int RESPONSE_CODIGO_FALLA = -1;

	@Override
	public int notificarVentanasHorarias() {
		String ws_url = Parametros.getNotificacionWSURL();
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
			JsonElement jsonElement = new JsonParser().parse(stringBuffer.toString());
			
			JsonArray jsonArray = jsonElement.getAsJsonArray();
			for(int i = 0; i<jsonArray.size(); i++) {
				JsonElement element = jsonArray.get(i);
				JsonObject jsonObject = element.getAsJsonObject();
				System.out.println("Mensaje " + (i+1) + ":");
				System.out.println("codigo: " + jsonObject.get("codigo").getAsString());
				JsonArray mensajes = jsonObject.getAsJsonArray("mensajes");
				if(mensajes.size()>0) {
					System.out.println("mensajes: " + mensajes.getAsString());
				} else {
					System.out.println("mensajes: []");
				}
			}
			
			System.out.println(stringBuffer.toString());
			return RESPONSE_CODIGO_EXITO;
		} catch(UnknownHostException exception) {
			throw new IllegalStateException("No se pudo establecer comunicacion", exception);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return RESPONSE_CODIGO_FALLA;
	}

	
}
