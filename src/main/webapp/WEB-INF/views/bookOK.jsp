<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 결제완료</title>
<link rel="stylesheet" type="text/css" href="/resources/css/payment.css">
<script type="text/javascript">
window.onload = () => {
	alert('예약이 완료되었습니다.')
}
</script>
</head>
<body style="background-color: #EEEEEE">

	<fmt:formatDate value="${books[0].concertTime}" pattern="yyyy년 MM월 dd일" var="conDate"/>
	<fmt:formatDate value="${books[0].concertTime}" pattern="HH시 mm분" var="conTime"/>

<%-- 
	<h2>bookOK.jsp</h2>
		<div style="flex">
			<div style="border: 1px solid black; width:500px; margin:10px; padding:10px;">
			</div>
		</div>
--%>

<div class="main">
	<div class="bookInfo-title">
		예매완료
	</div>
	<div>
		
	</div>
	<table class="box" style="border: none;">
		<tr>
			<td class="infoTitle">공연정보</td>
			<td class="infoContent">
				<div style="font-size: 22px;">
					${conVO.title}
				</div>
				<div style="color: #555555; font-weight: normal; margin-bottom: 5px; font-size: 14px;">
					${conVO.description}
				</div>
				${conDate}<br/>
				${conTime}<br/>
				<c:forEach items="${books}" var="book" varStatus="i">
					${book.seatNum}(${book.grade}석)
				</c:forEach>
			</td>
			<td><img src="${conVO.posterUrl}" style="height: 140px;" align="right"></td>
		</tr>
		<tr><td colspan="3"><hr/></td></tr>
		<tr>
			<td class="infoTitle">예매번호</td>
			<td class="infoContent">${books[0].bookNum}</td>
		</tr>
		<tr><td colspan="3"><hr/></td></tr>
		<tr>
			<td class="infoTitle">결제상태</td>
			<td class="infoContent">
				<c:if test="${books[0].payType == 0}">결제완료</c:if>
				<c:if test="${books[0].payType == 1}">입금대기 (무통장입금)</c:if>
			</td>
		</tr>
		<tr><td colspan="3"><hr/></td></tr>
		<tr>
			<td class="infoTitle">결제금액</td>
			<td class="infoContent">
				<fmt:formatNumber value="${books[0].price}" type="number" pattern="#,##0"/>원
			</td>
		</tr>
	</table>
	<input class="bt900" type="button" value="홈으로" onclick="location.href='/'"/>
</div>

</body>
</html>