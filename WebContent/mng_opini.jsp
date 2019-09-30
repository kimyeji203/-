<%@page import="java.sql.*"%>
<%@page import="java.sql.PreparedStatement" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/mng_opini.css">
<link href="https://fonts.googleapis.com/css?family=Do+Hyeon" rel="stylesheet">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>mng_opinion</title>
</head>

<% 
	Integer num = Integer.parseInt(request.getParameter("num"));	

	String driverName="com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/test";
	String id = "root";
	String pwd ="6789";
	
	Connection conn=null; //DB 접속 클래스
	
	//opinion table
	PreparedStatement pstmt =null; //접속 후 질의문 실행 클래스
	ResultSet rs = null;
	String sql = "select * from opinion where num = ?;";
	
	//main table
	PreparedStatement pstmt_update =null; //접속 후 질의문 실행 클래스
	ResultSet rs_update = null;
	String sql_update = "select * from main where idx = ?;";
	
	//ResultSet rs = null; //질의문 샐행 결과 값 클래스
	
	try{
	    //[1] JDBC 드라이버 로드
	    Class.forName(driverName); 
	    //[2]데이타베이스 연결 
	    conn = DriverManager.getConnection(url,id,pwd);
	  	//[3]table불러오기
	  	pstmt = conn.prepareStatement(sql);	 //opinion table
	  	pstmt.setInt(1,num);
	  	rs = pstmt.executeQuery();
	  	rs.next();
	  	
	  	pstmt_update = conn.prepareStatement(sql_update);	//main table
		pstmt_update.setInt(1,rs.getInt(2));
		rs_update = pstmt_update.executeQuery();
		rs_update.next();
%>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#bottom").load("public_bottom.jsp");
	$("#top").load("mng_top.jsp");
});
</script>

<body>
<div id="top"></div>
	<div id="total_wrapper">
		
		
		<div id="content">
			<h3><%= rs.getString(3)%> 의견접수</h3>
			<table>
				<tr style="text-align:right; font-size:10px;">
					<td colspan="2">
					<%
						String check = rs.getString(6);
						if(check.equals("True")){
							check = "확인완료";
						}else{
							check = "확인 전";
						}
						out.print(check);
					%>	
					</td>
				</tr>
				<tr><td colspan="2" class="td_line"></td></tr>
				
				<tr>
					<td class="title">항 목</td>
					<td><%= rs.getString(3)%></td>
				</tr>
				<tr><td colspan="2" class="td_line"></td></tr>
				<tr>
					<td class="title">이메일</td>
					<td><%= rs.getString(4)%></td>
				</tr>
				<tr><td colspan="2" class="td_line"></td></tr>
				
				<tr>
					<td class="title">의 견</td>
					<td id="td_opini"><%= (rs.getString(5)).replace("\r\n","<br>")%></td>
				</tr>
				<tr><td colspan="2" class="td_line"></td></tr>
				
			</table>
			
			<!-- ================sendMail=============== -->
			<form action="sendMail.jsp" name="sendMail_form">
				<input type="hidden" class="mail_op" name="num" value="<%= rs.getString(1)%>">
				<input type="hidden" class="mail_op" name="name" value="<%= rs.getString(3)%>">
				<input type="hidden" class="mail_op" name ="email_to" value="<%= rs.getString(4) %>">
				<input type="hidden" class="mail_op" name="opini" value="<%= rs.getString(5)%>">
				
				<input type="button" class="button" name="cancel" value="뒤로 가기" onclick="location.href='mng_opinilist.jsp';">
				<%
					if(rs.getString(6).equals("False") || rs.getString(6).equals("false")){
						out.println("<input type='submit' class='button' name='check_opini' value='의견 접수'>");
					}
				%>
			</form>
		</div> <!-- end_content -->

		<!-- ============== 정보 업데이트 클릭시 show ============== -->
		<div id="content_update_box">
			<h3>의견 반영 업데이트</h3>
			<form  method="post" name="content_update_form" action="mng_content_update.jsp?idx=<%= rs_update.getInt(1)%>">
				<table>
					<tr><td colspan="2" class="td_line"></td></tr>
					<tr>
						<td class="up_title" width="130" style="background-color:#ceb5d7;"> ▷ img경로</td>
						<td><textarea name="up_imgsrc" cols="95" rows="3"><%= rs_update.getString(18)%></textarea></td>
					</tr>
					
					<tr>
						<td class="up_title" style="background-color:#ceb5d7;"> ▷ 유    형</td>
						<td><input type="text" class="textbox" name="up_type" value="<%= rs_update.getString(3)%>"></td>
					</tr>
					
					<tr>
						<td class="up_title" style="background-color:#ceb5d7;"> ▷ 분    야</td>
						<td><input type="text" class="textbox" name="up_filed" value="<%= rs_update.getString(9)%>"></td>
					</tr>
					
					<tr>
						<td class="up_title" style="background-color:#ceb5d7;"> ▷ 시    대</td>
						<td><input type="text" class="textbox" name="up_generation" value="<%= rs_update.getString(10)%>"></td>
					</tr>
					
					<tr>
						<td class="up_title" style="background-color:#ceb5d7;"> ▷ 소재지</td>
						<td><input type="text" class="textbox" name="up_place" value="<%= rs_update.getString(11)%>"></td>
					</tr>
					<tr><td colspan="2" class="td_line"></td></tr>
					
					<%
						if(rs_update.getInt(12) == 1){
							out.println("<tr><td class='up_title' style='background-color:#ceb5d7;'> ▷ 문화재</td><td><input type='text' class='textbox' name='up_cultural' value='"+ rs_update.getString(13) +"'></td></tr><tr><td colspan='2' class='td_line'></td></tr>");
						}
					%>
					<tr>
						<td class="up_title"> ▷ 정    의</td>
						<td><textarea name="up_definition" cols="95" rows="3"><%= rs_update.getString(14)%></textarea></td>
					</tr>
					
					<tr>
						<td class="up_title"> ▷ 핵심단어</td>
						<td><input type="text" class="textbox" name="up_keyword" value="<%= rs_update.getString(15)%>"></td>
					</tr>
					<tr><td colspan="2" class="td_line"></td></tr>
					<tr>
						<td class="up_title" style="background-color:#8d8dc7"> ▷ 핵심요약</td>
						<td><textarea name="up_explain" cols="95" rows="1"><%= rs_update.getString(16)%></textarea></td>
						
					</tr>
					
					<tr>
						<td class="up_title" style="background-color:#8d8dc7"> ▷ 상세내용</td>
						<td><textarea name="up_detail" cols="95" rows="20"><%= rs_update.getString(17)%></textarea></td>
					</tr>
					<tr><td colspan="2" class="td_line"></td></tr>
				</table>
				<input type="submit" class="button" name="update" value="정보 수정">
			</form>
		</div><!-- content_update_box -->
	</div><!-- total_warpper -->
	<div id="bottom"></div>
</body>
</html>

<%
	}catch(Exception e){
	    out.println("Arise the Error!<br>");
	    out.println(e.toString());
	    return;
	}finally{
		//[Final]데이타베이스 연결 해제
		conn.close();
	}
	 
	
%>
