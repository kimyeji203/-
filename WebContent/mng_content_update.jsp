<%@page import="java.sql.*"%>
<%@page import="java.sql.PreparedStatement" %>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<% 
	request.setCharacterEncoding("utf-8");

	Integer idx = Integer.parseInt(request.getParameter("idx"));	
	String up_imgsrc = request.getParameter("up_imgsrc");
	String up_type = request.getParameter("up_type");
	String up_filed = request.getParameter("up_filed");
	String up_generation = request.getParameter("up_generation");
	String up_place = request.getParameter("up_place");
	String up_definition = request.getParameter("up_definition");
	String up_keyword = request.getParameter("up_keyword");
	String up_explain = request.getParameter("up_explain");
	String up_detail = request.getParameter("up_detail");
	
	String driverName="com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf-8";
	String id = "root";
	String pwd ="6789";
	
	Connection conn=null; //DB 접속 클래스
	PreparedStatement pstmt =null; //접속 후 질의문 실행 클래스

	String sql = "update main set ";
	sql += "imgurl=?, op_type=?, field=?, generation=?, place=?, definition=?, keyword=? ";
	sql += "where idx=?;";
	//ResultSet rs = null; //질의문 샐행 결과 값 클래스
	
	PreparedStatement pstmt2 = null;
	String sql2 = "update main set ";
	sql2 += "keysummary=?, detail=? where idx=?;";
	
	try{
	    //[1] JDBC 드라이버 로드
	    Class.forName(driverName); 
	    //[2]데이타베이스 연결 
	    conn = DriverManager.getConnection(url,id,pwd);
	  	//[3]table불러오기
	  	pstmt = conn.prepareStatement(sql);
	  	
	  	pstmt.setString(1,up_imgsrc);
	  	pstmt.setString(2,up_type);
	  	pstmt.setString(3,up_filed);
	  	pstmt.setString(4,up_generation);
	  	pstmt.setString(5,up_place);
	  	pstmt.setString(6,up_definition);
	  	pstmt.setString(7,up_keyword);
	  	pstmt.setInt(8,idx);
	  	
	  	
	  	pstmt.executeUpdate();
	}catch(Exception e){
	    out.println("Arise the Error!<br>");
	    out.println(e.toString());
	    return;
	}finally{
		//[Final]데이타베이스 연결 해제
		pstmt.close();
		conn.close();
	}
	
	
	try{
		//[1] JDBC 드라이버 로드
	    Class.forName(driverName); 
	    //[2]데이타베이스 연결 
	    conn = DriverManager.getConnection(url,id,pwd);
	  	//[3]table불러오기
	  	
	  	pstmt2 = conn.prepareStatement(sql2);
	  	pstmt2.setString(1,up_explain);
	  	pstmt2.setString(2,up_detail);
	  	pstmt2.setInt(3,idx);
	  	
	  	pstmt2.executeUpdate();
	  	
	}catch(Exception e){
		 out.println("Arise the Error!<br>");
		 out.println(e.toString());
		 return;
	}finally{
		pstmt2.close();
		conn.close();
	}
	  	
%>
<html>
<head><title></title></head>
	<script>
		alert("정보가 업데이트 되었습니다.");
		location.href="detail_page.jsp?idx="+<%= idx%>;
	</script>
<body></body>
</html>