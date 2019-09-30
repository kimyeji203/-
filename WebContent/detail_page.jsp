<%@page import="java.sql.*"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.sql.PreparedStatement" %>
<%@ page language="java" contentType="text/html; charset=euc-kr"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>detail_page</title>
<link rel="stylesheet" type="text/css" href="css/detail_page.css">
<link href="https://fonts.googleapis.com/css?family=Do+Hyeon" rel="stylesheet">
<style>
@media screen and (max-width:1024px){
	#total_wrapper{width:800px;}
	img{width:230px;height:230px;border-radius:115px;}
}
@media screen and (max-width:900px){
	#total_wrapper{width:750px;}
	img{width:200px;height:200px;border-radius:100px;}
}
@media screen and (max-width:800px){
	body{font-size:13px;letter-spacing:4px;}
	#total_wrapper{width:600px;}
	img{width:180px;height:180px;border-radius:60px;}
	#imgtd{width:150px;}
}
@media screen and (max-width:650px){
	body{font-size:10px;letter-spacing:3px;}
	#total_wrapper{width:500px;}
	img{width:160px;height:160px;border-radius:80px;}
}
@media screen and (max-width:530px){
	body{font-size:9px; letter-spacing:2px;}
	#total_wrapper{width:400px;}
	img{width:120px;height:120px;border-radius:60px;}
	#imgtd{width:120px;padding-right:20px;}
}
@media screen and (max-width:400px){
	body{font-size:9px; letter-spacin}
	#total_wrapper{width:300px;}
	img{width:100px;height:100px;border-radius:50px;}
	#imgtd{width:80px;padding-right:8px;}
}
#popup{
	display:none;
	position:absolute;
	left:30%;
	z-index:10000;
}
#mask{
	position:absolute;
	z-index:9000;
	background:rgba(0,0,0,0.5);
	display:none;
	left:0;
	top:0;
	width:100%;
	height:100%;
}
</style>


</head>

<% 
	request.setCharacterEncoding("utf-8");
	Integer idx = Integer.parseInt(request.getParameter("idx"));
	//Integer idx = 3;
	
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
	    
	  	//[3]table불러오기
	  	pstmt = conn.prepareStatement(sql);	  	
	  	pstmt.setInt(1 , idx);
	  	rs = pstmt.executeQuery();
	  	rs.next();

	}catch(Exception e){
	    out.println("Arise the Error!<br>");
	    out.println(e.toString());
	    return;
	}

%>


<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#bottom").load("public_bottom.jsp");
	$("#top").load("user_top.jsp");
	$("#popup").load("opinion.jsp?idx="+<%= idx%>);
	
	$("#popup, #mask").hide();
	
	$("#openPopup").click(function(){
		$("#popup, #mask").show();
		$("html").css("overflow","hidden");
	});
	/*$("#cancel").click(function(){
		$("#popup, #mask").hide();
		$("html").css("overflow","scroll");
	});*/
	
	$('#definition').click(function(){
		$(".definition").slideToggle();
		
		var img = $("#defini_img").attr("src");
		if(img == "image/select_down.png"){
			$("#defini_img").attr("src", "image/select_up.png");
		}else{
			$("#defini_img").attr("src", "image/select_down.png");
		}
		
	});
	
	$('#explain').click(function(){
		$(".explain").slideToggle();

		var img = $("#ex_img").attr("src");
		if(img == "image/select_down.png"){
			$("#ex_img").attr("src", "image/select_up.png");
		}else{
			$("#ex_img").attr("src", "image/select_down.png");
		}
	});
	
	$('#detail').click(function(){
		$(".detail").slideToggle();
		
		var img = $("#de_img").attr("src");
		if(img == "image/select_down.png"){
			$("#de_img").attr("src", "image/select_up.png");
		}else{
			$("#de_img").attr("src", "image/select_down.png");
		}
	});
	
	$('#references').click(function(){
		$(".references").slideToggle();
		
		var img = $("#refer_img").attr("src");
		if(img == "image/select_down.png"){
			$("#refer_img").attr("src", "image/select_up.png");
		}else{
			$("#refer_img").attr("src", "image/select_down.png");
		}
	});
});


/*function goto_opinion(idx){
	location.href="opinion.jsp?idx="+idx;
}*/


var initBody;
function print_view(){
	window.onbeforeprint = beforePrint;
	window.onafterprint = afterPrint;
	window.print();
}
function afterPrint(){
	decument.body.innerHTML = initBody;
}
function beforePrint(){
	initBody = document.body.innerHTML;
	document.body.innerHTML = print_page.innerHTML;
}

</script>


<body>
<div id="top">
	</div>
<div id="total_wrapper">
	<div id="mask"></div>
	<div id="popup"></div>
	
	<div id="community_box">
		<input class="button" type="button" onclick="print_view();" value="인쇄">
		<input class="button" type="button" id="openPopup" value="의견 제시">
	</div>
	
	<div id="print_view">
	<div id="title_content">
		<h2><%= rs.getString(2)%></h2>
		<table>
			<tr>
				<td rowspan="6" id="imgtd" style="padding-right:40px;"><img id="title_img" src="<%= rs.getString(18)%>" width="260px" height="260px"></td>
				<td> ▷ 유    형</td>
				<td><%= rs.getString(3)%></td>
			</tr>
			<tr>
				<td> ▷ 분    야</td>
				<td><%= rs.getString(9)%></td>
			</tr>
			<tr>
				<td> ▷ 시    대</td>
				<td><%= rs.getString(10)%></td>
			</tr>
			<tr>
				<td> ▷ 소재지</td>
				<td><%= rs.getString(11)%></td>
			</tr>
			
			<%
				if(rs.getInt(12) == 1){
					out.println("<tr><td> ▷ 문화재 : </td><td>"+ rs.getString(13) +"</td></tr>");
				}
			%>
		
		</table>
	</div>
	
	<div id="definition"><h3>정의<img id="defini_img" class="drop_img" src="image/select_up.png"></h3><hr></div>
	<div class="definition"><%= rs.getString(14)%><h6>[핵심 단어] <%= rs.getString(15)%></h6></div>
	
	<div id="explain"><h3>핵심 요약<img id="ex_img" class="drop_img" src="image/select_up.png"></h3><hr></div>
	<div class="explain"><%= rs.getString(16)%></div>
	
	<div id="detail"><h3>상세 내용<img id="de_img" class="drop_img" src="image/select_up.png"></h3><hr></div>
	<div class="detail"><%= rs.getString(17)%></div>
	
	<div id="references"><h3>참고 문헌<img id="refer_img" class="drop_img" src="image/select_up.png"></h3><hr></div>
	<div class="references">「한국민족문화대백과사전」 - https://encykorea.aks.ac.kr<br>「위키백과」- https://wikipedia.org<br>「나무위키」- https://namu.wiki<br>「해커스 공무원 한국사」- gosi.Hackers.com</div>


	</div><!-- print_view_end -->
</div><!-- total_wrap -->
	<div id="bottom">
		<!-- public_bottom.jsp -->
	</div>
</body>
</html>

<%
    //[Final]데이타베이스 연결 해제
	conn.close();


%>