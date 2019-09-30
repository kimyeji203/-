<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<%
	request.setCharacterEncoding("euc-kr");

	Integer num = null;
	Integer idx = Integer.parseInt(request.getParameter("idx"));
	//String name_sql = "";
	String email = request.getParameter("email");
	String opinion = request.getParameter("opini");
	
	
	String driverName="com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8"; //발표
	String id = "root";
	String pwd ="6789";
	
	Connection conn=null; //DB 접속 클래스
	PreparedStatement pstmt =null; //접속 후 질의문 실행 클래스
	
	//mysql은 자기 테이블의 데이터를 바로 사용 못함. 해결 방법 테이블 별칭 사용.
	String sql = "insert into opinion(num,idx,name,email,opinion,ch) values((select max(num)+1 from opinion a),?,(select name from main where idx = ?),?,?,'false')";
	
	try{
	    //[1] JDBC 드라이버 로드
	    Class.forName(driverName); 
	    //out.println("mysql jdbc Driver registered!!<br>");
	    
	    //[2]데이타베이스 연결 
	    conn = DriverManager.getConnection(url,id,pwd);
	    //out.println("DB연결성공!!<br>");
	    
	  	//[3]table불러오기
	  	pstmt = conn.prepareStatement(sql);	
	  	
	  	pstmt.setInt(1,idx);
	  	pstmt.setInt(2,idx);
	  	pstmt.setString(3,email);
	  	pstmt.setString(4,opinion);
	  	
	  	pstmt.execute(); //pstmt쿼리문 실행
	  	pstmt.close();
	
		//name = rs.getString(2);
		//out.println(idx+"<br>"+email+"<br>"+opinion);
		//out.println("<br>제출 성공");
		conn.close();
	}catch(Exception e){
	    out.println("Arise the Error!<br>");
	    out.println(e.toString());
	    return;
	}
%>

<script>
	alert("의견이 제출되었습니다. 감사합니다.");
	location.href="detail_page.jsp?idx=<%= idx%>";
</script>
<body>

</body>
</html>