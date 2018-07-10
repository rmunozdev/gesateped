package pe.com.gesateped.util;

import java.util.Calendar;
import java.util.Date;

public class GesatepedUtil {
	
	public static Date getDiaSiguiente() {
		Calendar instance = Calendar.getInstance();
		instance.add(Calendar.DATE, 1);
		return instance.getTime();
	}

}
