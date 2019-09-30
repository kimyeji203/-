<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page import="java.sql.*" %>
<%@page import="javax.mail.Session"%> <!-- ���� ó�� ȯ���� ����, ����ó���� ���� ��ü ���� -->
<%@page import="java.util.Properties"%><!-- ����ó�� ȯ�� ������ �ʿ��� ���� ��ü�μ��� -->
<%@page import="javax.mail.Message"%> <!-- ������ �޽��� ���� -->
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Address"%> <!-- ��/���� �ּҸ� �ٷ�� Ŭ���� -->
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.Authenticator"%> <!-- ��Ʈ�� �Ǵ� ������ ����� ����� ID/PWȮ�� Ŭ���� -->
<%@page import="kr.pe.hoyanet.mail.SMTPAuthenticatior"%> <!-- AuthenticatorŬ������ ��ӹ���. -->
<%@page import="javax.mail.Transport"%> <!-- ���� ���� -->
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>     

<%
	request.setCharacterEncoding("utf-8");

	Integer num = Integer.parseInt(request.getParameter("num"));
	String name = request.getParameter("name");
	String email_to = request.getParameter("email_to");
	String opini = request.getParameter("opini");
	
	Properties p = new Properties(); //����ó�� ȯ���� ��ü�� ����
	
	// SMTP ���� ������ ����
	p.put("mail.smtp.host","smtp.naver.com");
	p.put("mail.smtp.port", "587");
	p.put("mail.smtp.starttls.enable", "true"); //���۰��� ����
	p.put("mail.smtp.auth", "true"); //���� ����. ����� id�� pw����.
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");

	try{
		Authenticator auth = new SMTPAuthenticatior(); //SMTP���� ���� �� ����
		Session ses = Session.getInstance(p,auth); //����ȭ �� mail��ü ����.
		
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses); //������ ������ ���� ��ü ����
		
		msg.setSubject("�ѱ����Դϴ�.");
		
		StringBuffer buffer = new StringBuffer(); //���ڿ� ó�� ����
		buffer.append("**********************************<br><br>");
		buffer.append("[ ��  �� ]");
		buffer.append("<br>"+name + "<br><br>");
		buffer.append("[ �� ��  �� ��  ]<br>");
		buffer.append(opini + "<br><br>**********************************<br><br><br>");
		buffer.append("�ȳ��ϼ���. �ѱ����Դϴ�.<br>�����ֽ� ������ �ǰ��� �����Ǿ����ϴ�.<br>");
		buffer.append("���� �� �ݿ� �� �� ���� ������ ã�ƺ˰ڽ��ϴ�.<br> �����մϴ�.");
		
		Address fromAddr = new InternetAddress("kimyeji203@naver.com"); //������ ��� �̸��� ����
		msg.setFrom(fromAddr);
		
		Address toAddr = new InternetAddress(email_to); //�޴� ��� �̸��� ����
		msg.addRecipient(Message.RecipientType.TO,toAddr);
		
		msg.setContent(buffer.toString(),"text/html;charset=utf-8"); //���� �����ۼ�
		Transport.send(msg);
		
	}catch(Exception e){
		e.printStackTrace();
		return;
	}
	
	//
	//
	//
	//
	// --------------------- DB�� data Ȯ�οϷ�� ����-----------------------------
	//
	//
	//
	//
	
	String driverName="com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/test";
	String id = "root";
	String pwd ="6789";
	
	Connection conn=null; //DB ���� Ŭ����
	PreparedStatement pstmt =null; //���� �� ���ǹ� ���� Ŭ����
	ResultSet rs = null;
	
	String sql = "update opinion set ch=? where num=?";
	//ResultSet rs = null; //���ǹ� ���� ��� �� Ŭ����
	
	try{
	    //[1] JDBC ����̹� �ε�
	    Class.forName(driverName); 
	    //[2]����Ÿ���̽� ���� 
	    conn = DriverManager.getConnection(url,id,pwd);
	  	//[3]table�ҷ�����
	  	pstmt = conn.prepareStatement(sql);	
	  	pstmt.setString(1,"True");
	  	pstmt.setInt(2,num);
	  	pstmt.executeUpdate();
	}catch(Exception e){
		e.printStackTrace();
		return;
	}finally{
		conn.close();
		pstmt.close();
	}
	
%>
<script>
alert("���� �߼� �Ϸ�.");
location.href="mng_opini.jsp?num="+<%= num%>;
</script>