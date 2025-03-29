<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 결제</title>
</head>
<body>

<h1>payment.jsp</h1>

${concertVO}
<br/>
id: ${concertVO.id}<br/>
title: ${concertVO.title}<br/>
hallType: ${concertVO.hallType}<br/>
posterUrl: ${concertVO.posterUrl}<br/>
priceVIP: ${concertVO.priceVIP}<br/>
priceR: ${concertVO.priceR}<br/>
priceS" value="${concertVO.priceS}"/><br/>
priceA: ${concertVO.priceA}<br/>
equalPrice: ${concertVO.equalPrice}<br/>

결제금액: ${totalPrice}<br/>

</body>
</html>