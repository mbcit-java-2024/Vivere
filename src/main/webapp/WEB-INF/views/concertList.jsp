<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공연 목록</title>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/js/bootstrap.bundle.min.js"></script>
</head>
<script>
	function submitCategory(categoryId) {
	    const form = document.getElementById("categoryForm");
	    form.submit();
	}
</script>
<style type="text/css">
	.btn-gold {
		background-color: white;
		border-color: #CDAA39;
		color: #CDAA39;
	}
	.btn-gold:hover {
		background-color: #CDAA39;
		border-color: #CDAA39;
		color: white;
	}
</style>
<body>

<div class="container">
<!-- 새 공연 등록: 나중에 session에서 관리자 로그인 확인 후 관리자 계정일때만 표시 -->
<button onclick="location.href='/insertConcert'">새 공연 등록</button>
<br/>
<br/>

<!-- 카테고리 메뉴 -->
<div>
<form id="categoryForm" action="/concertList" method="get">
    <c:set var="categories" value="${{null:'전체', 0:'클래식', 1:'뮤지컬', 2:'재즈', 3:'대중음악', 4:'연극', 5:'무용', 6:'기타'}}" />
    <c:forEach var="entry" items="${categories}" varStatus="i">
	    <input type="radio" class="btn-check" name="categoryId"  value="${entry.key}"
	    	id="option${i.index}" onclick="submitCategory(${entry.key})"
	    	<c:if test="${categoryId == entry.key}">checked</c:if>>
		<label class="btn" for="option${i.index}">${entry.value}</label>
    </c:forEach>
</form>
</div>
<br/>

<!-- 공연 리스트 -->
<div class="row row-cols-1 row-cols-md-3 g-4">
	<c:forEach var="concert" items="${concertList}" varStatus="i">
	  <div class="col">
	    <div class="card h-100" style="width:300px">
			<img class="card-img-top" alt="공연포스터" src="${concert.posterUrl}" style="width: 100%; ">
	      <div class="card-body">
			<fmt:formatDate value="${concert.startDate}" pattern="yy.MM.dd" var="startDate"/>
			<fmt:formatDate value="${concert.endDate}" pattern="yy.MM.dd" var="endDate"/>
	        <h4 class="card-title">${concert.title}</h4>
	        <p class="card-text">${startDate} ~ ${endDate}</p>
	      </div>
			<button class="btn m-2 btn-gold" onclick="location.href='concertView?concertId=${concert.id}'">자세히보기</button>
	    </div>
	  </div>
	</c:forEach>
</div>

</div>

</body>
</html>