<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<link rel="stylesheet" type="text/css" href="css/opinion.css">
<link href="https://fonts.googleapis.com/css?family=Do+Hyeon" rel="stylesheet">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>opinion_page</title>
<style>
@media screen and (max-width:1024px){
	#total_wrapper{width:800px;}
}
@media screen and (max-width:800px){
	body{font-size:13px;letter-spacing:4px;}
	#total_wrapper{
		width:600px;
	}
}
@media screen and (max-width:600px){
	body{font-size:10px;letter-spacing:3px;}
	#total_wrapper{width:400px;}
	#content_box{margin-top:40px;width:450px;}
	#content_table{width:400px;}
}
@media screen and (max-width:400px){
	body{font-size:9px; letter-spacing:2px;}
	#total_wrapper{width:300px;}
	#content_box{margin-top:40px;width:430px;}
	#content_table{width:380px;}
}

</style>

</head>

<%
	Integer idx = Integer.parseInt(request.getParameter("idx"));
	String name = null;	

	String driverName="com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/test";
	String id = "root";
	String pwd ="6789";
	
	Connection conn=null; //DB 접속 클래스
	PreparedStatement pstmt =null; //접속 후 질의문 실행 클래스
	ResultSet rs = null;
	
	String sql = "select * from main where idx = ?";
	//ResultSet rs = null; //질의문 샐행 결과 값 클래스
	
	try{
	    //[1] JDBC 드라이버 로드
	    Class.forName(driverName); 
	    //out.println("mysql jdbc Driver registered!!<br>");
	    
	    //[2]데이타베이스 연결 
	    conn = DriverManager.getConnection(url,id,pwd);
	    //out.println("DB연결성공!!<br>");
	    
	  	//[3]table불러오기
	  	pstmt = conn.prepareStatement(sql);	  	
	  	pstmt.setInt(1 , idx);
	  	//out.println("<br>"+pstmt.toString()+"<br>");
	  	
	  	rs = pstmt.executeQuery();
	  	rs.next();
		//out.println(rs.getString(11));
	
		name = rs.getString(2);
		
		conn.close();
	}catch(Exception e){
	    out.println("Arise the Error!<br>");
	    out.println(e.toString());
	    return;
	}
%>


<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">

function write_check(){
	var form = document.writeform;
	if( !form.email.value){
		alert("이메일을 적어주세요");
		form.email.focus();
		return;
	}
	if( !form.opini.value){
		alert("의견을 작성해 주세요");
		form.opini.focus();
		return;
	}
	
	if(confirm("의견을 제출 하시겠습니까?") == false){
		return;
	}else{
		form.submit();
	}
}
</script>

<body>	
	<div id="content_box">
		<h3>의견제시</h3>
		<form name="writeform" method=post action="send_opini.jsp?idx=<%= idx%>">
			<table id="content_table">
				<tr>
					<td>항목명</td>
					<td><%= name %></td>
				</tr>
				<tr>
					<td>이메일</td>
					<td><input type="text" class="text" name="email"></td>
				</tr>
				<tr>
					<td colspan="2"><hr>의   견</td>
				</tr>
				<tr>
					<td colspan="2">
						<textarea cols="55" rows="10" name="opini"></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2" id="button_td">
						<input type="button" class="button" id="offer" value="제시" onclick="write_check();">
						<input type="button" class="button" id="cancel" value="취소" onclick="$('#popup, #mask').hide(); $('html').css('overflow','scroll');"><!-- onclick="go_back();"> --> 
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>