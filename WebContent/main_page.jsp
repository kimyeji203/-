<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Main_Page</title>
<link rel="stylesheet" type="text/css" href="css/main.css">
<link rel="stylesheet" type="text/css" href="letterfx-master/jquery-letterfx.css">
<link href="https://fonts.googleapis.com/css?family=Do+Hyeon" rel="stylesheet">
</head>

<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="letterfx-master/tuxsudo.min.js"></script>
<script src="letterfx-master/jquery-letterfx.js"></script>
<script type="text/javascript">


function goto_show(){
	location.href="show_page.jsp";
}

$(document).ready(function(){
	$("#bottom").load("public_bottom.jsp");
	$("#title").letterfx({"fx":"wave","letter_end":"rewind","fx_duration":"300ms"});
});




</script>

<body>
<div id="total_wrapper">
	<h1 id="title">History _ Perfect Conquest</h1>
	<form name="menu_form" action="map_page.jsp"  method="get" accept-charset="utf-8">
		<input type="submit" class="menu_btn" name="userwant" value="historic">
		<input type="submit" class="menu_btn" name="userwant" value="contry">
		<input type="submit" class="menu_btn" name="userwant" value="generation">
	</form>
</div><!-- total_wrapper -->
	<div id="bottom">
		<!-- public_bottom.jsp -->>
	</div>

</body>
</html>