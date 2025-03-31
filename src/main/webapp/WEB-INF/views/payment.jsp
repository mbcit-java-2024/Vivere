<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 결제</title>

<style type="text/css">
	.main {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
	}
	.box {
		border: 1px solid black;
		width: 900px;
		font-weight: bold;
		padding: 10px;
		margin: 10px;
		border-radius: 10px;
		background-color: #FCFCFC;
	}
	.subTitle {
		width: 900px;
		margin-bottom: 10px;
		display: flex;
		justify-content: center;
		align-items: center;
		border-radius: 5px;
		background-color: #78171C;
		color: white;
		height: 30px;
	}
	.mg-left {
		margin-left: 10px;
	}
	.text-gray {
		font-weight: normal;
		color: gray;
		font-size: 14px;
	}
	#discount {
		width: 300px;
		height: 25px;
		text-align: center;
	}
</style>

<script type="text/javascript">
	
	function discount() {
		
	}
	
</script>

</head>
<body>

<fmt:formatDate value="${selTime}" pattern="yyyy년 MM월 dd일" var="selectDate"/>
<fmt:formatDate value="${selTime}" pattern="HH시mm분" var="selectTime"/>

<div class="main">
	<!-- 공연 및 예매정보 표시 -->
	<div class="box">
		<div class="subTitle">
			예매 정보
		</div>
		<div class="mg-left" style="display: flex">
			<div>
				<img src="${concertVO.posterUrl}" height="200" style="margin-right: 30px;"/>
			</div>
			<div>
				<h2>${concertVO.title}</h2>
				${selectDate}<br/><br/>
				${selectTime}<br/><br/>
				${selectedSeats}<br/>
			</div>
		</div>
	</div>
	
	<!-- 할인 선택 -->
	<div class="box">
		<div class="subTitle">
			할인 선택
		</div>
		<div class="mg-left">
			<div class="text-gray">
				할인 유형은 중복 선택이 불가능합니다
			</div><br/>
			<div>
				<select id="discount" onchange="discount()">
					<option value="0" selected="selected">해당 없음</option>
					<option value="60">국가 유공자 할인 60%</option>
					<option value="60">장애인 할인 60%</option>
					<option value="40">청소년 할인 40%</option>
				</select>
			</div>
		</div>
	</div>
	
	<!-- 결제 수단 -->
	<div class="box">
		<div class="subTitle">
			결제 수단
		</div>
		<div class="">
		
		</div>
	</div>
	
</div>

</body>
</html>