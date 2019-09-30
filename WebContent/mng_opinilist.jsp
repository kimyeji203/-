<%@page import="java.sql.*"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.sql.PreparedStatement" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>manage_page</title>
<link rel="stylesheet" type="text/css" href="css/mng_opinilist.css">
<link href="https://fonts.googleapis.com/css?family=Do+Hyeon" rel="stylesheet">
</head>

<% 

	String driverName="com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/test";
	String id = "root";
	String pwd ="6789";
	
	Connection conn=null; //DB 접속 클래스
	PreparedStatement pstmt =null; //접속 후 질의문 실행 클래스
	ResultSet rs = null;
	
	String sql = "select * from opinion;";
	//ResultSet rs = null; //질의문 샐행 결과 값 클래스
	
	try{
	    //[1] JDBC 드라이버 로드
	    Class.forName(driverName); 
	    //[2]데이타베이스 연결 
	    conn = DriverManager.getConnection(url,id,pwd);
	  	//[3]table불러오기
	  	pstmt = conn.prepareStatement(sql);	  	
	  	rs = pstmt.executeQuery();
	  	
%>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#bottom").load("public_bottom.jsp");
	$("#top").load("mng_top.jsp");
	
});

function goto_mng_opini(num){
	location.href="mng_opini.jsp?num="+num;
}
</script>

<body>
<div id="top"></div>
<div id="total_wrapper">
	<div id="content_update_box"><h3>업데이트 할 정보를 선택하지 않았습니다.</h3></div>
	
	<h3>의견 제시 항목</h3>
	<table>
		<tr style="background-color:gray; color:white; height:30px;">
			<td width="50px;">번 호</td>
			<td width="140px;">항 목</td>
			<td width="250px;">내 용</td>
			<td width="180px;">이 메 일</td>
			<td width="70px;">접 수</td>
		</tr>
<% 
	while(rs.next()){
		out.println("<tr onclick='goto_mng_opini("+rs.getInt(1)+")'><td>"+rs.getInt(1)+"</td>");
		out.println("<td style='text-align:left;'>"+rs.getString(3)+"</td>");
		
		String opini = rs.getString(5);
		if(opini.length() > 15){
			opini = rs.getString(5).substring(0, 15) + "...";
		}
		
		String email = rs.getString(4);
		if(email.length() > 15){
			email = rs.getString(4).substring(0,12)+ "...";
		}
		
		String check = rs.getString(6);
		String c_style="style='color:black;'";
		if(check.equals("True") || check.equals("true")){
			check = "확인완료";
		}else{
			check = "확인 전";
			c_style = "style='color:#9972bc;'";
		}
		
		out.println("<td style='text-align:left;'>"+opini+"</td>");
		out.println("<td style='text-align:left;'>"+email+"</td>");
		out.println("<td "+c_style+">"+check+"</td></tr>");
		out.println("<tr style='height:1px; background-color:gray;'><td colspan='5'></td></tr>");
	}
	
%>
	</table>
<%  	
		//out.println(rs.getString(11));
	}catch(Exception e){
	    out.println("Arise the Error!<br>");
	    out.println(e.toString());
	    return;
	}finally{
		//[Final]데이타베이스 연결 해제
		conn.close();
	}
    
	


%>

</div><!-- total_wrap -->
	<div id="bottom">
	</div>
</body>
</html>

