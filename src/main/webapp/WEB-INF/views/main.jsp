<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere Art Hall</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</head>
<body>
<div class="wrapper">
	<jsp:include page="./include/header.jsp"/>
	<div class="body-main mgb-50">
		<c:if test="${sessionScope.loginUser.grade eq 'ADMIN'}">
			<div style="display:flex; justify-content: right">
				<a style="text-decoration: none; color: gray;" href="/carouselList">메인표지 등록/수정</a>
			</div>
		</c:if>
		<!-- Carousel -->
		<div id="demo" class="carousel slide" data-bs-ride="carousel">
		
		  <!-- Indicators/dots -->
		  <div class="carousel-indicators">
		  	<c:forEach varStatus="i" items="${carouselList }">
		  		<c:if test="${i.index == 0 }">
				    <button type="button" data-bs-target="#demo" data-bs-slide-to="${i.index }" class="active"></button>
		  		</c:if>
		  		<c:if test="${i.index != 0 }">
				    <button type="button" data-bs-target="#demo" data-bs-slide-to="${i.index }"></button>
		  		</c:if>
		  	</c:forEach>
		  </div>
		
		
		  <!-- The slideshow/carousel -->
		  <div class="carousel-inner">
		  	<c:forEach var="vo" items="${carouselList }">
		    <div class="carousel-item active">
		      <img src="${vo.carouselUrl }" class="d-block w-100" onclick="location.href='/concertView?concertId=${vo.id}'">
		    </div>
		  	</c:forEach>
		  </div>
		
		  <!-- Left and right controls/icons -->
		  <button class="carousel-control-prev" type="button" data-bs-target="#demo" data-bs-slide="prev">
		    <span class="carousel-control-prev-icon"></span>
		  </button>
		  <button class="carousel-control-next" type="button" data-bs-target="#demo" data-bs-slide="next">
		    <span class="carousel-control-next-icon"></span>
		  </button>
		</div>
		
	</div>
	<jsp:include page="./include/footer.jsp"/>
</div>
</body>
</html>