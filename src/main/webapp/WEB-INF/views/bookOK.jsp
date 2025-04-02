<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 결제완료</title>
</head>
<body>

<h2>bookOK.jsp</h2>

<c:forEach items="${books}" var="book">
	<div style="flex">
		<div style="border: 1px solid black; width:500px; margin:10px; padding:10px;">
			id: ${book.id}<br/>
			consumerId: ${book.consumerId}<br/>
			concertId: ${book.concertId}<br/>
			cardId: ${book.cardId}<br/>
			bookNum: ${book.bookNum}<br/>
			seatNum: ${book.seatNum}<br/>
			price: ${book.price}<br/>
			grade: ${book.grade}<br/>
			orderDate: ${book.orderDate}<br/>
			concertTime: ${book.concertTime}<br/>
			payType: ${book.payType}<br/>
		</div>
	</div>
</c:forEach>

</body>
</html>