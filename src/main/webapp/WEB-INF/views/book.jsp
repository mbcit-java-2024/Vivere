<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 예약</title>
</head>
<body>

<h2>book.jsp</h2>
concertVO: ${concertVO}<br/>
conTimes: ${conTimes}<br/>
selectedTime: ${selectedTime}<br/><br/><br/>

<fmt:formatDate value="${selectedTime}" pattern="yyyy-MM-dd HH:mm" var="fmtSelTime" />

<div>
	<select>
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
</div>

</body>
</html>