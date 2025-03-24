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
		width: 530px;
		height: 550px;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.lineNum {
		color: gray;
		width: 15px;
		display: inline-block;
		text-align: center;
	}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

function changeTime() {
	const selectedTimeId = document.getElementById("pickTime").value; // 선택된 공연 시간을 가져옴
    
    $.ajax({
    	url: "/getBookedSeats",  // 이 경로는 컨트롤러에서 처리할 URL 경로입니다.
      	method: "GET",
      	data: {
    		conTimeId: selectedTimeId 
		},  // 선택된 공연 시간을 전달
      	success: function(response) {
       		$(`input[class=seat]`).prop("checked", false);
       		$(`input[class=seat]`).prop("disabled", false);
        	// 서버에서 받은 예약된 좌석 데이터(response)를 처리하는 부분
        	response.forEach(function(seat) {
        		// console.log(seat);
        		$(`input[name=` + seat + `]`).prop("disabled", true); // 예약된 좌석을 disabled 처리
        	});
		},
    	error: function(xhr, status, error) {
    		console.error("AJAX 요청 실패:", status, error);
    	}
	});
}
  
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
	<select id="pickTime" onchange="changeTime()">
		<c:forEach var="time" items="${conTimes}" varStatus="i">
			<fmt:formatDate value="${time.concertTime}" pattern="yyyy-MM-dd HH:mm" var="fmtTime"/>
			
			<c:if test="${fmtTime.equals(fmtSelTime)}">
				<option value="${time.id}" selected="selected">${fmtTime}</option>
			</c:if>
			<c:if test="${!fmtTime.equals(fmtSelTime)}">
				<option value="${time.id}">${fmtTime}</option>
			</c:if>
		</c:forEach>
	</select>
</div><br/>

<!-- 좌석 선택 -->
<div class="divCard">
	<div id="pickSeat">
		<c:if test="${concertVO.hallType == 0}">
			<c:forEach var="lineNum" items="${gHall}" varStatus="i">
				<span class="lineNum">${lineNum}</span>
				<c:forEach var="j" begin="1" step="1" end="24">
					<fmt:formatNumber var="fmtSeatNum" value="${j}" type="number" minIntegerDigits="2"/>
					<c:set value="${lineNum}${fmtSeatNum}" var="seatName"/>
					<input class="seat" type="checkbox" name="${seatName}" onchange="alert(this.name)"/>
					<c:if test="${j == 6 or j == 18}">&nbsp;&nbsp;&nbsp;</c:if>
				</c:forEach><span class="lineNum">${lineNum}</span><br/>
				<c:if test="${'J' eq lineNum.toString()}"><br/><br/></c:if>
			</c:forEach>
		</c:if>
		<c:if test="${concertVO.hallType == 1}">
			<c:forEach var="lineNum" items="${fHall}" varStatus="i">
				<span class="lineNum">${lineNum}</span>
				<c:forEach var="j" begin="1" step="1" end="14">
					<fmt:formatNumber var="fmtSeatNum" value="${j}" type="number" minIntegerDigits="2"/>
					<c:set value="${lineNum}${fmtSeatNum}" var="seatName"/>
					<input class="seat" type="checkbox" name="${seatName}" onchange="alert(this.name)"/>
					<c:if test="${j == 7}">&nbsp;&nbsp;&nbsp;</c:if>
				</c:forEach><span class="lineNum">${lineNum}</span><br/>
				<%-- <c:if test="${'G' eq lineNum.toString()}"><br/><br/></c:if> --%>
			</c:forEach>
		</c:if>
	</div>
</div>

</body>
</html>