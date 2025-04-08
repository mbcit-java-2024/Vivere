<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 오시는길</title>
<style type="text/css">
.contents {
	margin: 50px 0px 50px;
	display: flex;
	justify-content: center;
	align-items: center;
}
.map {
	display: flex;
	justify-content: flex;
	width: 1000px;
}
.text {
	margin-left: 50px;
	align-items: flex-start;
}
.imgbox {
	background-color: #78171C;
	border-radius: 5px;
	width: 620px;
	height: 420px;
}
img {
	width: 600px;
	border-radius: 5px;
	margin: 10px;
}
</style>
</head>
<body>

<div class="wrapper">
	<jsp:include page="./include/header.jsp"/>
	<div class="body-main contents">
		<div class="map">
			<div class="imgbox">
				<img src="/map/map.png">
			</div>
			<div class="text">
				<h1>오시는 길</h1><br/>
				<h3>버스</h3>
				<ul>
					<li>150, 160, 270, 272, 601 (시내)</li>
					<li>1101, 1102, 1170 (광역)</li>
				</ul>
				<h3>지하철</h3>
				<ul>
					<li>종각역 (1호선)</li>
					<li>종로3가역 (1, 3, 5호선)</li>
				</ul>
			</div>
		</div>
		
	</div>
	<jsp:include page="./include/footer.jsp"/>
</div>

</body>
</html>