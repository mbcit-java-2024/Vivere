<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 예약</title>
<style type="text/css">
	#pickSeat {
		width: 600px;
		justify-content: center;
		text-align: center;
	}
	.seat {
		margin: auto;
	}
	.divCard {
		border: 1px solid black;
		padding: 20px;
		display: flex;
	}
	.lineNum {
		color: gray;
		width: 15px;
		display: inline-block;
		text-align: center;
	}
	.selectSeat {
		width: 530px;
		height: 550px;
		justify-content: center;
		align-items: center;
	}
	.sideDetail {
		margin-left: 30px;
		width: 350px;
		padding: 20px;
	}
	.mgb {
		border: 1px solid black;
		height: 35%;
		margin-bottom: 20px;
	}
	.info {
		margin-top: 30px; 
		width: 952px; 
		display: inline-block;
	}
	.price {
		text-align: right;
		width: 250px;
		border-bottom: 1px solid black;
		font-weight: bold;
	}
	th {
		width: 100px;
		border-bottom: 1px solid black;
	}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

window.onload = () => {
	
	changeTime();
	
	seatPrice = {
		    VIP: parseInt(document.getElementById("seatPrice").getAttribute("data-vip")),
		    R: parseInt(document.getElementById("seatPrice").getAttribute("data-r")),
		    S: parseInt(document.getElementById("seatPrice").getAttribute("data-s")),
		    A: parseInt(document.getElementById("seatPrice").getAttribute("data-a")),
		    equal: parseInt(document.getElementById("seatPrice").getAttribute("data-equal"))
	};
	console.log(seatPrice);
	
};

function changeTime() {
	const selectedTimeId = document.getElementById("pickTime").value; // 선택된 공연 시간을 가져옴
    $.ajax({
    	url: "/getBookedSeats?conTimeId=" + selectedTimeId,  // 컨트롤러 요청 주소
      	method: "GET",
      	//data: {
    	//	conTimeId: selectedTimeId
		//},  // 선택된 공연 시간 전달
       	success: function(response) {
       		$(`input[class=seat]`).prop("checked", false);
       		$(`input[class=seat]`).prop("disabled", false);
       		// console.log(response);
        	response.bookedSeats.forEach(function(seat) {
        		// console.log(seat);
        		$(`input[name=` + seat + `]`).prop("disabled", true);
        	});
        	response.allSeats.forEach(function(seat) {
        		const lineNum = seat.lineNum;
        		const seatNum = String(seat.seatNum).padStart(2, '0');
        		const seatName = lineNum + seatNum;
        		// console.log(seatName);
        		$(`input[name=` + seatName + `]`).prop("value", seat.grade);
        		// console.log($(`input[name=` + seatName + `]`).val());
        	});
		},
    	error: function(xhr, status, error) {
    		console.error("AJAX 요청 실패:", status, error);
    	}
	});
}

function checkSeat() {
	let selectedSeats = [];
    $("input.seat:checked").each(function() {
        selectedSeats.push($(this).attr("name"));
    });
    let cnt = selectedSeats.length > 0 ? selectedSeats.length + "석" : "";
    $("#seatsCount").html(cnt);
    let seatText = selectedSeats.length > 0 ? selectedSeats.join(", ") : "좌석을 선택해 주세요";
    $("#pickedSeats").html(seatText);
    totalPrice();
}

function totalPrice() {
	let totalPrice = 0;
	// console.log(seatPrice);
	if (0 == seatPrice.equal) {
		$("input.seat:checked").each(function() {
			const seatGrade = $(this).val();
			if (seatGrade === 'VIP') {
				totalPrice += seatPrice.VIP;
			} else if (seatGrade === 'R') {
				totalPrice += seatPrice.R;
			} else if (seatGrade === 'S') {
				totalPrice += seatPrice.S;
			} else if (seatGrade === 'A') {
				totalPrice += seatPrice.A;
			}
		});
	} else {
		totalPrice = $("input.seat:checked").length * seatPrice.equal;
	}
	// console.log('totalPrice: ' + totalPrice + '원');
	$("#totalPrice").html(totalPrice + '원');
}
  
</script>

</head>
<body>

<fmt:formatDate value="${selectedTime}" pattern="yyyy-MM-dd HH:mm" var="fmtSelTime" />

<div id="seatPrice" 
     data-vip="${concertVO.priceVIP}" 
     data-r="${concertVO.priceR}" 
     data-s="${concertVO.priceS}" 
     data-a="${concertVO.priceA}"
     data-equal="${concertVO.equalPrice}">
</div>

<div style="display: flex; flex-direction: column; align-items: center;">
	<!-- 예약할 공연 날짜, 시간(회차) 선택 -->
	<div style="justify-content: left; align-items: left;">
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
	<div style="display: flex; justify-content: center;">
		<!-- 좌석 선택 -->
		<div class="divCard selectSeat">
			<div id="pickSeat">
				<c:if test="${concertVO.hallType == 0}">
					<c:forEach var="lineNum" items="${gHall}" varStatus="i">
						<span class="lineNum">${lineNum}</span>
						<c:forEach var="j" begin="1" step="1" end="24">
							<fmt:formatNumber var="fmtSeatNum" value="${j}" type="number" minIntegerDigits="2"/>
							<c:set value="${lineNum}${fmtSeatNum}" var="seatName"/>
							<input class="seat" type="checkbox" name="${seatName}" onchange="checkSeat()"/>
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
							<input class="seat" type="checkbox" name="${seatName}" onchange="checkSeat()"/>
							<c:if test="${j == 7}">&nbsp;&nbsp;&nbsp;</c:if>
						</c:forEach><span class="lineNum">${lineNum}</span><br/>
					</c:forEach>
				</c:if>
			</div>
		</div>
		<div style="display: inline-block;">
			<div class="sideDetail mgb">
				<h3 style="margin: 0px;">좌석 등급 및 가격 안내</h3><br/>
				<c:if test="${concertVO.equalPrice == 0}">
					<table>
						<tr>
							<th style="color: purple;">VIP</th>
							<td class="price" style="color: purple;">${concertVO.priceVIP}원</td>
						</tr>
						<tr>
							<th style="color: tomato;">R</th>
							<td class="price" style="color: tomato;">${concertVO.priceR}원</td>
						</tr>
						<tr>
							<th style="color: skyblue;">S</th>
							<td class="price" style="color: skyblue;">${concertVO.priceS}원</td>
						</tr>
						<tr>
							<th style="color: yellowgreen;">A</th>
							<td class="price" style="color: yellowgreen;">${concertVO.priceA}원</td>
						</tr>
					</table>
				</c:if>
				<c:if test="${concertVO.equalPrice > 0}">
					<table>
						<tr>
							<th>전 좌석</th>
							<td class="price">${concertVO.equalPrice}원</td>
						</tr>
					</table>
				</c:if>
			</div>
			<form action="/payment">
				<div class="sideDetail mgb">
					<div style="height: 187px;">
						<h3 style="margin: 0px;">선택 좌석</h3>
						<div id="seatsCount"></div>
						<div id="pickedSeats">좌석을 선택해 주세요</div>
					</div>
					<div style="display: flex; justify-content: space-between; font-size: 20px;">
						<div style="font-weight: bold; margin-top: auto;">결제 금액</div>
						<div id="totalPrice" style="font-weight: bold; margin-top: auto;"></div>
					</div>
				</div>
				<div class="sideDetail">
					<input type="button" value="결제하기"/>
				</div>
			</form>
		</div>
	</div>
	<div class="divCard info">
		<h4>취소 및 환불 규정</h4>
		<div>
        	<ul>
	            <li>공연 7일 전까지 취소 시 전액 환불</li>
	            <li>공연 3~6일 전 취소 시 결제 금액의 50% 환불</li>
	            <li>공연 1~2일 전 취소 시 결제 금액의 30% 환불</li>
	            <li>공연 당일 취소 및 노쇼(No-show) 시 환불 불가</li>
	            <li>취소 및 변경은 마이페이지 > 예약 내역에서 가능합니다.</li>
	            <li>천재지변, 주최 측 사정으로 인한 공연 취소 시 전액 환불</li>
	        </ul>
		</div>
	</div>
</div>

</body>
</html>