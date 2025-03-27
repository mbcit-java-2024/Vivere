<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공연 목록</title>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
</head>
<script>
	function submitCategory(categoryId) {
	    const form = document.getElementById("categoryForm");
	    form.submit();
	}
</script>
<body>
<!-- 새 공연 등록: 나중에 session에서 관리자 로그인 확인 후 관리자 계정일때만 표시 -->
<button onclick="location.href='/insertConcert'">새 공연 등록</button>
<br/>
<br/>

<!-- 카테고리 메뉴 -->
<div>
<form id="categoryForm" action="/concertList" method="get">
    <c:set var="categories" value="${{null:'전체', 0:'클래식', 1:'뮤지컬', 2:'재즈', 3:'대중음악', 4:'연극', 5:'무용', 6:'기타'}}" />
    <c:forEach var="entry" items="${categories}">
        <input type="radio" name="categoryId" value="${entry.key}"
            onclick="submitCategory(${entry.key})"
            <c:if test="${categoryId == entry.key}">checked</c:if>
        > ${entry.value}
    </c:forEach>
</form>
</div>
<br/>

<!-- 공연 리스트 : 3개에 하나 줄바꿈-->
<div style="display: flex">
	<c:forEach var="concert" items="${concertList}" varStatus="i">
		<div style="width: 30%; margin: 10px">
			<img alt="공연포스터" src="${concert.posterUrl}" style="width: 100%; ">
			<h4>${concert.title}</h4>
			<fmt:formatDate value="${concert.startDate}" pattern="yy.MM.dd" var="startDate"/>
			<fmt:formatDate value="${concert.endDate}" pattern="yy.MM.dd" var="endDate"/>
			<p>${startDate} ~ ${endDate}</p>
			<button onclick="location.href='concertView?concertId=${concert.id}'">자세히보기</button>
		</div>
		<c:if test="${i.index % 3 == 0}"><br/></c:if>
	</c:forEach>
</div>


</body>
</html>