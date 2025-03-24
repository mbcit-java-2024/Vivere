<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 예약</title>
<style type="text/css">
	.seat {
		margin: 0px;
	}
	.divCard {
		border: 1px solid black;
		padding: 20px;
		width: 500px;
		height: 500px;
	}
</style>

<script>



</script>

</head>
<body>

<h2>book.jsp</h2>
<!--
concertVO: ${concertVO}<br/>
conTimes: ${conTimes}<br/>
selectedTime: ${selectedTime}<br/><br/><br/>
-->


<fmt:formatDate value="${selectedTime}" pattern="yyyy-MM-dd HH:mm" var="fmtSelTime" />

<!-- 예약할 공연 날짜, 시간(회차) 선택 -->
<div>
	<select id="pickTime" onchange="alert(this.value)">
		<c:forEach var="time" items="${conTimes}">
			<fmt:formatDate value="${time.concertTime}" pattern="yyyy-MM-dd HH:mm" var="fmtTime"/>
			
			<c:if test="${fmtTime.equals(fmtSelTime)}">
				<option selected="selected">${fmtTime}</option>
			</c:if>
			<c:if test="${!fmtTime.equals(fmtSelTime)}">
				<option>${fmtTime}</option>
			</c:if>
		</c:forEach>
	</select>
</div><br/>

<!-- 좌석 선택 -->
<div class="divCard">
	<div id="pickSeat">
		<c:if test="${concertVO.hallType == 0}">
			<c:forEach var="lineNum" items="${gHall}" varStatus="i">
				<c:forEach var="j" begin="1" step="1" end="24">
					<fmt:formatNumber var="fmtSeatNum" value="${j}" type="number" minIntegerDigits="2"/>
					<input class="seat" type="checkbox" name="${lineNum}${fmtSeatNum}" onchange="alert(this.name)"/>
					<c:if test="${j == 6 or j == 18}">&nbsp;&nbsp;&nbsp;</c:if>
				</c:forEach><br/>
				<c:if test="${'J' eq lineNum.toString()}"><br/><br/></c:if>
			</c:forEach>
		</c:if>
	</div>
</div>

</body>
</html>