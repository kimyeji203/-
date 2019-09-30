<%@page import="java.sql.*"%> <%-- JDBC API 임포트 작업 --%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="css/map_page.css">
<link href="https://fonts.googleapis.com/css?family=Do+Hyeon" rel="stylesheet">
<title>test_Map_page</title>

<script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyDS22jeGpgL9QK1EScPlZfAxI0ulY-y-Ic" ></script>

</head>
 
<%
    String driverName="com.mysql.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/test";
    String id = "root";
    String pwd ="6789";
   
    Connection conn=null; //DB 접속 클래스
    Statement stmt =null; //접속 후 질의문 실행 클래스
    ResultSet rs = null; //질의문 샐행 결과 값 클래스
    
    String[][] array ;
    try{
        //[1] JDBC 드라이버 로드
        Class.forName(driverName); 
        //out.println("mysql jdbc Driver registered!!");
        
        //[2]데이타베이스 연결 
        conn = DriverManager.getConnection(url,id,pwd);
        
      	//[3]table불러오기
      	String sql = "select * from main;";
        stmt = conn.createStatement(); //DB레코드 한줄 생성
        rs = stmt.executeQuery(sql);

        
        String Nsql = "select count(*) from main;";
        stmt = conn.createStatement();
        ResultSet srs = stmt.executeQuery(Nsql);
        srs.next();

        
        array = new String[srs.getInt(1)][7];
        
        int idx = 0;
        while(rs.next()){
        	
        	array[idx][0] = rs.getString(2); //이름
        	array[idx][1] = rs.getString(7); //위도
        	array[idx][2] = rs.getString(8); //경도
        	array[idx][3] = rs.getString(3); //type
        	array[idx][4] = rs.getString(4); //시대
        	array[idx][5] = rs.getString(5); //나라
        	array[idx][6] = rs.getString(1);//idx
			
        	idx ++;
        }
    }catch(Exception e){
        out.println("Arise the Error!<br>");
        out.println(e.toString());
        return;
    }finally{
        //[Final]데이타베이스 연결 해제
        conn.close();

    }
%>


<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">

$(document).ready(function(){
	$("#bottom").load("public_bottom.jsp");
	$('#top').load("user_top.jsp");
	
	<%
		String userwant = request.getParameter("userwant");
		out.println("$('#"+userwant+"').show();");
	%>

});

$(function(){
	$('.select').change(function(){
		if(this.value != 'total'){
			initialize('null','null',this.value);
		}else{
			initialize('null','null','null');
		}
		
	});
});


<!-- --------------------------- Google Map ------------------------------ -->
let Markers = Array();
let re_Markers;
function initialize(i_type,i_generation,i_contry){
	
	//------- html contain부분 소제목 -------------- //
	
	var strhtml = "<div id='contain_top'>Classification</div>";
	
	var contain = document.getElementById("contain");
	var contain_title = new Array();
	var idx = 0; //하단 상세 항목때 사용
	
	if('<%= userwant%>' == 'historic'){
		idx = 3;
		contain_title = ['유적지','비'];
	}else if('<%= userwant%>' == 'generation'){
		idx = 4;
		contain_title = ['구석기','신석기','청동기','삼국시대'];
	}else if('<%= userwant%>' == 'contry'){
		idx = 5;
		contain_title = ['구석기(전기)','구석기(중기)','구석기(후기)','신석기','중석기','청동기(전기)','청동기(무문토기시대)','고구려','신라'];
	}

	
	
	for(var a = 0 ; a < contain_title.length; a++){ // onclick = '$("#ct_0_in")'
		strhtml += "<div id='ct_"+a+"'></div>";
	}

	contain.innerHTML = strhtml;
	
	// ------- html contain부분 소베목_END----------- //

	
	var Y_point			= 39.040886;		// Y 좌표
	var X_point			= 126.880381;		// X 좌표
	var zoomLevel		= 6;				// 지도의 확대 레벨 : 숫자가 클수록 확대정도가 큼
	var markerMaxWidth	= 80;				// 마커를 클릭했을때 나타나는 말풍선의 최대 크기
	
	var centerLatlng = new google.maps.LatLng(Y_point, X_point);
	
	var mapOptions = {
						zoom: zoomLevel,
						center: centerLatlng,
						mapTypeId: google.maps.MapTypeId.SATELLITE
					}
	var map = new google.maps.Map(document.getElementById('map'), mapOptions); 

	

	var marker_array = Array();
	
	for(var i = 0; i < <%=array.length%>; i++){
	    marker_array[i] = Array();
	}

	<%for(int i=0;i<array.length;i++){
			if(array[i][0] == null) break;
			for(int j=0;j<array[i].length;j++){%>
				marker_array[<%=i%>][<%=j%>] = '<%= array[i][j]%>';
			<%}
	  }%>

	  
	re_Markers = setMarkers (map,marker_array,i_type,i_generation,i_contry)

	// ---------------- classification 항목 -------------- //
	//상단에 contain_title 배열에 항목이 담겨 있음
	var contain_cnt = new Array(contain_title.length);
	for(var i=0;i<contain_title.length;i++){ //$("+toggle_name+").slideToggle();
		var toggle_name = '"#ct_' + i + '_in"';
		contain_cnt[i] = "<div class='contain_title' onclick='slideToggle("+ toggle_name +", " + contain_title.length + ","+i+");'>"+ contain_title[i] + "</div>";
		contain_cnt[i] += "<div id='ct_"+i+"_in' class='ct_in' style='display:none'>";
	}
	for(var i=0 ; i < marker_array.length ; i++){
		
		for(var ct=0;ct<contain_title.length;ct++){
			if(marker_array[i][idx] == contain_title[ct]){
				var event = "'rightclick'";
				var test = re_Markers[i].title;
				
				let stringss = '<div class="contain_cnt" onclick="rc_marker(' + i + ');">'+marker_array[i][0]+'</div>';
				contain_cnt[ct] += stringss;
				break;
			}	
		}
	}

	for(var i=0;i<contain_title.length;i++){
		contain_cnt[i] +="</div>";
		document.getElementById("ct_"+i).innerHTML = contain_cnt[i];
	}
	
	// ---------------- classification 항목_END ----------- //
}

function slideToggle(toggle_name,cnt,me){
	for(var i = 0; i < cnt ; i++){
		if(i == me){continue;}
		$("#ct_"+ i +"_in").slideUp();
	}
	$(toggle_name).slideToggle();
}

function rc_marker(i){
	console.log("넘겨진 마커 : ");
	console.log(re_Markers[i]);
	google.maps.event.trigger(re_Markers[i],'rightclick');
}


<!-- initialize에서 호출 -->
function setMarkers(map,marker_array,i_type,i_generation,i_contry){
	var prev_infowindow = false;
	for(let i=0;i<marker_array.length;i++){

		if(i_type != 'null'){ //유적지.비일경우
			if(marker_array[i][3] != i_type) continue;
		}else if(i_generation != 'null'){ //시대일경우
			if(marker_array[i][4] != i_generation) continue;
		}else if(i_contry != 'null'){//나라일경우
			
			if(marker_array[i][5] != i_contry) continue;
		}
		
		
		/*if(isNaN(Number(marker_array[i][1])) || isNaN(Number(marker_array[i][2]))){
			break;
		}*/

		let loan = marker_array[i][0];
		let idx = marker_array[i][6];
		let lat = Number(marker_array[i][1]);
		let lng = Number(marker_array[i][2]);
		let content = marker_array[i][3];
		
		let markerSet = new google.maps.LatLng(lat,lng);
		
		var url = '';
		if('<%= userwant%>' == 'historic'){
			if(marker_array[i][3] != '유적지'){
				url = "image/icon비.png";
			}else{
				url = "image/icon유적지.png";
			}
		}else if('<%= userwant%>' == 'generation'){
			switch(marker_array[i][4]){
			case '구석기' :
				url = "image/icon구석기.png";
				break;
			case '신석기':
				url = "image/icon신석기.png";
				break;
			case '청동기':
				url = "image/icon청동기.png";
				break;
			case '삼국시대':
				url = "image/icon삼국시대.png";
				break;
			}
		}else if('<%= userwant%>' == 'contry'){
			switch(marker_array[i][5]){
			case '구석기' :
			case '구석기(전기)' :
			case '구석기(중기)' :
			case '구석기(후기)' :
				url = "image/icon구석기.png";
				break;
			case '신석기':
				url = "image/icon신석기.png";
				break;
			case '중석기':
				url = "image/icon중석기.png";
				break;
			case '청동기':
			case '청동기(전기)':
			case '청동기(무문토기시대)':
				url = "image/icon청동기.png";
				break;
			case '고구려':
				url = "image/icon고구려.png";
				break;
			case '신라':
				url = "image/icon신라.png";
				break;	
			}
		}
		
		
		
		var img = new google.maps.MarkerImage(url, null, null, null, new google.maps.Size(11,11));
		
		let infowindow = new google.maps.InfoWindow({
			content:loan + "<br>상세 정보를 보실려면 클릭하세요.",
			removable:true
		});
		
		
		let marker = new google.maps.Marker({
			position: markerSet,
			map,
			title: loan,
			icon: img
		});
				
		marker.addListener('click', () => {
			location.href="detail_page.jsp?idx="+ idx;	
		})
		
		marker.addListener('rightclick',()=>{
			console.log("rightclick 한 마커 : ");
			console.log(marker);
			
			if(prev_infowindow){
				prev_infowindow.close();
			}
			infowindow.open(map,marker);
			console.log(marker);
			prev_infowindow = infowindow;
		});

		Markers.push(marker);
	}
	return Markers;
	
}


</script>

<!-- $('selector').trigger('선택할 이벤트'); -->

<body onload="initialize('null','null','null')">
<div id="top">
		<!-- public_top.jsp -->
	</div>

<div id="total_wrapper">
	
	<form id="select_menu" name="select_menu" >
		<div id="historic">
			<input class="option" type="radio" name="r_historic" value="total" onclick="initialize('null','null','null');"> &nbsp;전체	
			<input class="option" type="radio" name="r_historic" value="sites" onclick="initialize('유적지','null','null'); $('#ct_0_in').slideToggle();"> <img src="image/icon유적지.png" width="13" height="13">&nbsp;유적지	
			<input class="option" type="radio" name="r_historic" value="rain" onclick="initialize('비','null','null'); $('#ct_1_in').slideToggle();"> <img src="image/icon비.png" width="13" height="13">&nbsp;비			 
		</div>
		
		<div id="contry">
			<select class="select" name="contry">
				<option value="" selected = selected>상세시기 및 나라 선택</option>
			    <option value="total">전체</option>
			    <option value="구석기(전기)">구석기(전기)</option>
			    <option value="구석기(중기)">구석기(중기)</option>
			    <option value="구석기(후기)">구석기(후기)</option>
			    <option value="신석기">신석기</option>
			    <option value="중석기">중석기</option>
			    <option value="청동기(전기)">청동기(전기)</option>
			    <option value="청동기(무문토기시대)">청동기(무문토기시대)</option>
			    <option value="고구려">고구려</option>
			    <option value="신라">신라</option>
			</select>
		</div>
		
		<div id="generation">
		<!-- 
			<a class="option">시대</a><input class="option" type="text" class="searchtext" name="times">
			<input class="option_btn" type="submit" name="searchbtn" value="검색">
			 -->
			<input class="option" type="radio" name="r_generation" value="t" onclick="initialize('null','null','null')">&nbsp;전체
			<input class="option" type="radio" name="r_generation" value="a" onclick="initialize('null','구석기','null'); $('#ct_0_in').slideToggle();"> <img src="image/icon구석기.png" width="13" height="13">&nbsp;구석기	
			<input class="option" type="radio" name="r_generation" value="b" onclick="initialize('null','신석기','null'); $('#ct_1_in').slideToggle();"> <img src="image/icon신석기.png" width="13" height="13">&nbsp;신석기
			<input class="option" type="radio" name="r_generation" value="c" onclick="initialize('null','청동기','null'); $('#ct_2_in').slideToggle();"> <img src="image/icon청동기.png" width="13" height="13">&nbsp;청동기
			<input class="option" type="radio" name="r_generation" value="d" onclick="initialize('null','삼국시대','null'); $('#ct_3_in').slideToggle();"> <img src="image/icon삼국시대.png" width="13" height="13">&nbsp;삼국시대
		</div>		
	</form>
	
	
	<div id="contain">
		
	</div>
	<div id="map"></div>
	
	
</div><!-- total_wrapper -->
<div id="bottom">
	<!-- public_bottom.jsp -->
</div>
</body>
</html>