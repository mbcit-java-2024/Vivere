<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 예약</title>

<link rel="stylesheet" type="text/css" href="/resources/css/book.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="/resources/js/book.js" defer></script>

</head>
<body>

<fmt:formatDate value="${selectedTime}" pattern="yyyy년 MM월 dd일 HH시 mm분" var="fmtSelTime"/>

<div id="seatPrice" 
     data-vip="${concertVO.priceVIP}" 
     data-r="${concertVO.priceR}" 
     data-s="${concertVO.priceS}" 
     data-a="${concertVO.priceA}"
     data-equal="${concertVO.equalPrice}">
</div>

<div style="display: flex; flex-direction: column; align-items: center;">
	<!-- 예약할 공연 날짜, 시간(회차) 선택 -->
	<div class="divCard info" style="text-align: left;">
		<h2>${concertVO.title}</h2>
		<select id="pickTime" onchange="changeTime()">
			<c:forEach var="time" items="${conTimes}" varStatus="i">
				<fmt:formatDate value="${time.concertTime}" pattern="yyyy년 MM월 dd일 HH시 mm분" var="fmtTime"/>
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
		<div class="divCard selectSeat" style="padding-top: 0;">
			<div id="pickSeat">
				<div class="stage">
					stage
				</div><br/>
				<c:if test="${concertVO.hallType == 0}">
					<c:forEach var="lineNum" items="${gHall}" varStatus="i">
						<span class="lineNum">${lineNum}</span>
						<c:forEach var="j" begin="1" step="1" end="24">
							<fmt:formatNumber var="fmtSeatNum" value="${j}" type="number" minIntegerDigits="2"/>
							<c:set value="${lineNum}${fmtSeatNum}" var="seatName"/>
							<label class="seat">
								<input class="checkbox" type="checkbox" name="${seatName}" onchange="checkSeat()"/>
								<span></span>
							</label>
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
							<label class="seat">
								<input class="checkbox" type="checkbox" name="${seatName}" onchange="checkSeat()"/>
								<span></span>
							</label>
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
							<th>VIP</th>
							<th><div class="gradeExample" style="background-color: #78171C; border-color: black"></div></th>
							<td class="price">${concertVO.priceVIP}원</td>
						</tr>
						<tr>
							<th>R</th>
							<th><div class="gradeExample" style="background-color: #B63330; border-color: #9B2F2A"></div></th>
							<td class="price">${concertVO.priceR}원</td>
						</tr>
						<tr>
							<th>S</th>
							<th><div class="gradeExample" style="background-color: #CDAA39; border-color: #4C6A91"></div></th>
							<td class="price">${concertVO.priceS}원</td>
						</tr>
						<tr>
							<th>A</th>
							<th><div class="gradeExample" style="background-color: #E5CD94; border-color: #5E8B32"></div></th>
							<td class="price">${concertVO.priceA}원</td>
						</tr>
						<tr>
							<th>-</th>
							<th><div class="gradeExample" style="background-color: lightgray; border-color: lightgray;"></div></th>
							<td class="price">예매불가</td>
						</tr>
					</table>
				</c:if>
				<c:if test="${concertVO.equalPrice > 0}">
					<table>
						<tr>
							<th>전 좌석</th>
							<th><div class="gradeExample" style="background-color: #BDC3C7; border-color: CDAA39"></div></th>
							<td class="price">${concertVO.equalPrice}원</td>
						</tr>
						<tr>
							<th>-</th>
							<th><div class="gradeExample" style="background-color: lightgray; border-color: lightgray;"></div></th>
							<td class="price">예매불가</td>
						</tr>
					</table>
				</c:if>
			</div>
			<form action="/payment" method="POST" onsubmit="return doubleCheck()">
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
				
				<input type="hidden" name="id" value="${concertVO.id}"/>
				<input type="hidden" name="title" value="${concertVO.title}"/>
				<input type="hidden" name="hallType" value="${concertVO.hallType}"/>
				<input type="hidden" name="posterUrl" value="${concertVO.posterUrl}"/>
				<input type="hidden" name="priceVIP" value="${concertVO.priceVIP}"/>
				<input type="hidden" name="priceR" value="${concertVO.priceR}"/>
				<input type="hidden" name="priceS" value="${concertVO.priceS}"/>
				<input type="hidden" name="priceA" value="${concertVO.priceA}"/>
				<input type="hidden" name="equalPrice" value="${concertVO.equalPrice}"/>
				
				<input type="hidden" name="totalPrice"/>
				<input type="hidden" name="selectedSeats"/>
				<input type="hidden" name="selectedTime"/>
				<input type="hidden" name="conTimeId"/>
				
				<div class="sideDetail">
					<input id="goToPay" class="sideDetail" type="submit" value="예매하기" disabled="disabled"/>
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