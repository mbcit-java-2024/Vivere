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
	
	.btn-outline-danger {
		border: none;
		color: #78171C;
	}
	
	.btn-check:checked + .btn-outline-danger{
		background-color: #78171C !important; 
		border-color: #78171C;
		color: white;
	} 
	
	.btn-check:checked + .btn-outline-danger:hover :focus{
		background-color: #78171C !important; 
		border-color: #78171C;
		color: white;
	}
	
	.mg-bt {
		margin-bottom: 50px;
	}
	
</style>
<body>
<div class="wrapper">
	<jsp:include page="./include/header.jsp"/>
	<div class="body-main mg-bt">
		<div class="container">
			<!-- 카테고리 메뉴 -->
			<form id="categoryForm" action="/concertList" method="get" 
				class="mt-3 mb-3 d-flex align-items-center justify-content-between flex-wrap">
			    <div role="group" aria-label="Checkbox group">
			    <c:set var="categories" value="${{null:'전체', 0:'클래식', 1:'뮤지컬', 2:'재즈', 3:'대중음악', 4:'연극', 5:'무용', 6:'기타'}}" />
			    <c:forEach var="entry" items="${categories}" varStatus="i">
				    <input type="radio" class="btn-check" name="categoryId"  value="${entry.key}"
				    	id="option${i.index}" onclick="submitCategory(${entry.key})"
				    	<c:if test="${categoryId == entry.key}">checked</c:if>>
					<label style="width: 90px" class="btn btn-outline-danger" for="option${i.index}">${entry.value}</label>
			    </c:forEach>
			  	</div>
				<!-- 새 공연 등록: 나중에 session에서 관리자 로그인 확인 후 관리자 계정일때만 표시 -->
				<c:if test="${sessionScope.loginUser.grade eq 'ADMIN'}">
					<button style=" justify-content: right; background-color: #E5CD94; color: white; " type="button" class="btn ms-auto"
						 onclick="location.href='/insertConcert'">새 공연 등록</button>
				</c:if>
			</form>
			
			<c:if test="${empty concertList }">
				<div style="height: 300px; display: flex; padding: 100px">
				  	<marquee> 현재 해당하는 카테고리의 공연이 없습니다.</marquee>
				</div>
			</c:if>
			<!-- 공연 리스트 -->
			<div class="row row-cols-1 row-cols-md-3 g-4">
				<c:forEach var="concert" items="${concertList}" varStatus="i">
					<div class="col">
						<div class="card h-100" style="width:300px">
							<img class="card-img-top" alt="공연포스터" src="${concert.posterUrl}" style="width: 100%; ">
							<div class="card-body">
								<fmt:formatDate value="${concert.startDate}" pattern="yy. MM .dd" var="startDate"/>
								<fmt:formatDate value="${concert.endDate}" pattern="yy. MM. dd" var="endDate"/>
								<h4 class="card-title">${concert.title}</h4>
								<p class="card-text">${startDate} ~ ${endDate}</p>
						    </div>
							<button class="btn mb-2 ms-2 me-2 btn-gold" onclick="location.href='concertView?concertId=${concert.id}'">자세히보기</button>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<jsp:include page="./include/footer.jsp"/>
</div>
</body>
</html>