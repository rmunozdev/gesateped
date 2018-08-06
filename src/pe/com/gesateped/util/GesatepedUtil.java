package pe.com.gesateped.util;

import java.text.ParseException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;

public class GesatepedUtil {
	
	private static DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
	public static Date getDiaSiguiente() {
		Calendar instance = Calendar.getInstance();
		instance.add(Calendar.DATE, 1);
		return instance.getTime();
	}
	
	/**
	 * Obtiene el lapso de tiempo en segundos, entre una hora
	 * de inicio y una de fin.
	 * @param inicio
	 * @param fin
	 * @return
	 * @throws ParseException 
	 */
	public static long calcularLapsoTiempo(String inicio, String fin) {
		LocalTime ahora = LocalTime.parse(inicio, formatter);
		LocalTime luego = LocalTime.parse(fin, formatter);
		return luego.toSecondOfDay() - ahora.toSecondOfDay();
	}
}
