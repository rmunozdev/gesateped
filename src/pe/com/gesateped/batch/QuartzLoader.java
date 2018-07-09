package pe.com.gesateped.batch;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.CronTriggerFactoryBean;
import org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

import pe.com.gesateped.common.Parametros;

@Configuration
@ComponentScan("pe.com.gesateped.batch")
public class QuartzLoader {
	
	
	@Bean
	public MethodInvokingJobDetailFactoryBean methodInvokingJobDetailFactoryBean() {
		MethodInvokingJobDetailFactoryBean obj = new MethodInvokingJobDetailFactoryBean();
		obj.setTargetBeanName("hojaRutaBach");
		obj.setTargetMethod("ejecutar");
		return obj;
	}
	
	@Bean
	public CronTriggerFactoryBean cronTriggerFactoryBean(){
		CronTriggerFactoryBean stFactory = new CronTriggerFactoryBean();
		stFactory.setJobDetail(methodInvokingJobDetailFactoryBean().getObject());
		stFactory.setStartDelay(3000);
		stFactory.setName("mytrigger");
		stFactory.setGroup("mygroup");
		
		String horaEjecucion = Parametros.getHoraEjecucion();
		SimpleDateFormat format = new SimpleDateFormat("HH:mm");
		try {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(format.parse(horaEjecucion));
			int hour = calendar.get(Calendar.HOUR_OF_DAY);
			int minutes = calendar.get(Calendar.MINUTE);
			stFactory.setCronExpression("0 "+minutes + " " + hour + " 1/1 * ? *");
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return stFactory;
	}
	
	@Bean
	public SchedulerFactoryBean schedulerFactoryBean() {
		SchedulerFactoryBean scheduler = new SchedulerFactoryBean();
		scheduler.setTriggers(cronTriggerFactoryBean().getObject());
		return scheduler;
	}
	
}
