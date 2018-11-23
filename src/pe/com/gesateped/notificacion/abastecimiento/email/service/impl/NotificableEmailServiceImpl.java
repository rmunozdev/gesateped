package pe.com.gesateped.notificacion.abastecimiento.email.service.impl;

import java.io.StringWriter;
import java.util.List;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.tools.generic.DateTool;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import pe.com.gesateped.common.Parametros;
import pe.com.gesateped.model.Bodega;
import pe.com.gesateped.notificacion.abastecimiento.email.model.MailResponseCodes;
import pe.com.gesateped.notificacion.abastecimiento.email.service.NotificableEmailService;
import pe.com.gesateped.notificacion.abastecimiento.model.Notificable;
import pe.com.gesateped.notificacion.abastecimiento.model.NotificableWrapper;

@Service
public class NotificableEmailServiceImpl implements NotificableEmailService {

	private final static Logger logger = Logger.getLogger(NotificableEmailServiceImpl.class);
	
	@Override
	public void enviar(List<Notificable> notificables, Bodega bodega) {
		Assert.notEmpty(notificables);
		
		logger.info("Se inicia envío de notificacion.");
		
		for (Notificable notificable : notificables) {
			logger.info(notificable.getKardex().getProducto().getNombre());
		}
		
		logger.info("***");
		String mensaje = this.construirMensaje(notificables);
		System.out.println(mensaje);
		
		this.sendEmail("Notificación de Abastecimiento de Productos " + bodega.getNombre(), mensaje, bodega.getEmailBodega());
		
		logger.info("***");
		
		logger.info("Notificacion enviada.");
		
	}
	
	public String construirMensaje(List<Notificable> notificables) {
		VelocityContext context = new VelocityContext();
		context.put("data", new NotificableWrapper(notificables));
		/*
		 * Formato usando DateTool
		 * https://stackoverflow.com/questions/15092372/how-to-select-the-format-of-date-in-vm-file
		 */
		context.put("date", new DateTool());
		
		Properties properties = new Properties();
		properties.setProperty("resource.loader", "class");
		properties.setProperty("class.resource.loader.class", 
				"org.apache.velocity.runtime.resource.loader.ClasspathResourceLoader");
		
		
		Velocity.init(properties);
		String result = null;
		Template template = Velocity.getTemplate("templates/email_html.vm");
		StringWriter writer = new StringWriter();
		template.merge(context, writer);
		result = writer.toString();
		return result;
	}
	
	public Integer sendEmail(String asunto, String mensaje, String destinatario) {
		
		Properties properties = new Properties();
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.smtp.starttls.enable", "true");
		properties.put("mail.smtp.EnableSSL.enable", "true");
		properties.put("mail.smtp.host", Parametros.getSmtpServer());
		
		properties.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");   
		properties.setProperty("mail.smtp.socketFactory.fallback", "false");   
		properties.setProperty("mail.smtp.port", Parametros.getSmtpPort());   
		properties.setProperty("mail.smtp.socketFactory.port", Parametros.getSmtpPort());
		
		
		final String username = Parametros.getFromEmail();
		final String password = Parametros.getPasswordEmail();
		
		Session session = Session.getInstance(properties, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(username, password);
			}
		});
		
		try {
			MimeMessage mimeMessage = new MimeMessage(session);
			mimeMessage.setFrom(new InternetAddress(Parametros.getFromEmail()));
			mimeMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
			mimeMessage.setSubject(asunto);
			mimeMessage.setContent(mensaje, "text/html; charset=utf-8");
			
			Transport.send(mimeMessage);
			System.out.println("done");
		} catch(MessagingException exception) {
			exception.printStackTrace();
			return MailResponseCodes.FAIL;
		}
		return MailResponseCodes.SUCESS;
	}

}
