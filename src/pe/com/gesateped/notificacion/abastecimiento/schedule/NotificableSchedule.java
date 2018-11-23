package pe.com.gesateped.notificacion.abastecimiento.schedule;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.CronTriggerFactoryBean;
import org.springframework.scheduling.quartz.MethodInvokingJobDetailFactoryBean;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

@Configuration
@ComponentScan("pe.com.gesateped.notificacion.abastecimiento")
public class NotificableSchedule {

	@Bean
	public MethodInvokingJobDetailFactoryBean methodInvokingJobDetailFactoryBean() {
		MethodInvokingJobDetailFactoryBean obj = new MethodInvokingJobDetailFactoryBean();
		obj.setTargetBeanName("NotificableServiceBatch");
		obj.setTargetMethod("procesarNotificables");
		return obj;
	}
	
	@Bean
	public CronTriggerFactoryBean cronTriggerFactoryBean() {
		CronTriggerFactoryBean factoryBean = new CronTriggerFactoryBean();
		factoryBean.setJobDetail(methodInvokingJobDetailFactoryBean().getObject());
		factoryBean.setStartDelay(3000);
		factoryBean.setName("NotificacionAbastecimientoTrigger");
		factoryBean.setGroup("NotificacionAbastecimientoGroup");
		
		factoryBean.setCronExpression("0 0 0 1/1 * ? *");
		
		return factoryBean;
	}
	
	@Bean
	public SchedulerFactoryBean schedulerFactoryBean() {
		SchedulerFactoryBean scheduler = new SchedulerFactoryBean();
		scheduler.setTriggers(cronTriggerFactoryBean().getObject());
		return scheduler;
	}
	
}
