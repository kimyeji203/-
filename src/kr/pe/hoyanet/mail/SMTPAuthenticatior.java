package kr.pe.hoyanet.mail;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class SMTPAuthenticatior  extends Authenticator{ 
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("kimyeji203@naver.com","kyj1208203");
	}
}
