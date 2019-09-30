<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@ page import="java.sql.*" %>
<%@page import="javax.mail.Session"%> <!-- 메일 처리 환경을 설정, 메일처리를 위한 객체 생성 -->
<%@page import="java.util.Properties"%><!-- 메일처리 환경 설정시 필요한 값을 객체로설정 -->
<%@page import="javax.mail.Message"%> <!-- 메일의 메시지 생성 -->
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Address"%> <!-- 송/수신 주소를 다루는 클래스 -->
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.Authenticator"%> <!-- 네트웍 또는 서버에 연결시 사용자 ID/PW확인 클래스 -->
<%@page import="kr.pe.hoyanet.mail.SMTPAuthenticatior"%> <!-- Authenticator클래스를 상속받음. -->
<%@page import="javax.mail.Transport"%> <!-- 메일 전송 -->
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>     

<%
	request.setCharacterEncoding("utf-8");

	Integer num = Integer.parseInt(request.getParameter("num"));
	String name = request.getParameter("name");
	String email_to = request.getParameter("email_to");
	String opini = request.getParameter("opini");
	
	Properties p = new Properties(); //메일처리 환경을 객체로 생성
	
	// SMTP 메일 정보를 담음
	p.put("mail.smtp.host","smtp.naver.com");
	p.put("mail.smtp.port", "587");
	p.put("mail.smtp.starttls.enable", "true"); //전송계층 보안
	p.put("mail.smtp.auth", "true"); //스팸 방지. 사용자 id와 pw인증.
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");

	try{
		Authenticator auth = new SMTPAuthenticatior(); //SMTP서버 인증 후 생성
		Session ses = Session.getInstance(p,auth); //구조화 된 mail객체 생성.
		
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses); //메일의 내용을 담을 객체 생성
		
		msg.setSubject("한국뽀입니다.");
		
		StringBuffer buffer = new StringBuffer(); //문자열 처리 버퍼
		buffer.append("**********************************<br><br>");
		buffer.append("[ 항  목 ]");
		buffer.append("<br>"+name + "<br><br>");
		buffer.append("[ 의 견  내 용  ]<br>");
		buffer.append(opini + "<br><br>**********************************<br><br><br>");
		buffer.append("안녕하세요. 한국뽀입니다.<br>보내주신 소중한 의견이 접수되었습니다.<br>");
		buffer.append("검토 및 반영 후 더 나은 정보로 찾아뵙겠습니다.<br> 감사합니다.");
		
		Address fromAddr = new InternetAddress("kimyeji203@naver.com"); //보내는 사람 이메일 설정
		msg.setFrom(fromAddr);
		
		Address toAddr = new InternetAddress(email_to); //받는 사람 이메일 설정
		msg.addRecipient(Message.RecipientType.TO,toAddr);
		
		msg.setContent(buffer.toString(),"text/html;charset=utf-8"); //메일 내용작성
		Transport.send(msg);
		
	}catch(Exception e){
		e.printStackTrace();
		return;
	}
	
	//
	//
	//
	//
	// --------------------- DB의 data 확인완료로 수정-----------------------------
	//
	//
	//
	//
	
	String driverName="com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/test";
	String id = "root";
	String pwd ="6789";
	
	Connection conn=null; //DB 접속 클래스
	PreparedStatement pstmt =null; //접속 후 질의문 실행 클래스
	ResultSet rs = null;
	
	String sql = "update opinion set ch=? where num=?";
	//ResultSet rs = null; //질의문 샐행 결과 값 클래스
	
	try{
	    //[1] JDBC 드라이버 로드
	    Class.forName(driverName); 
	    //[2]데이타베이스 연결 
	    conn = DriverManager.getConnection(url,id,pwd);
	  	//[3]table불러오기
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
alert("메일 발송 완료.");
location.href="mng_opini.jsp?num="+<%= num%>;
</script>