<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공연 정보</title>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<!-- 공연 디테일 페이지에 보여줄 리뷰 리스트의 css를 연결하는 코드 -->
<link rel="stylesheet" type="text/css" href="/resources/css/reviewList.css" />
</head>
<body>
<!-- 관리자 로그인 시에만 보이는 버튼 -->
<button onclick="location.href='/updateConcert?concertId=${concertVO.id}'">수정</button>
<button onclick="location.href='/concertData?concertId=${concertVO.id}'">통계</button>

<!-- 공연 정보 -->
<div style="display: flex;">
	<h3>${concertVO.title }</h3> &nbsp;&nbsp;&nbsp;
	<fmt:formatDate value="${concertVO.startDate}" pattern="yy.MM.dd" var="startDate"/>
	<fmt:formatDate value="${concertVO.endDate}" pattern="yy.MM.dd" var="endDate"/>
	<h5>${startDate} ~ ${endDate}</h5>
</div>

<div style="display: flex;">
	<div style="width: 50%">
		<img alt="공연포스터" src="${concertVO.posterUrl}" style="width: 100%; ">
	</div>
	<div style="display: 50%; margin-left: 10px;">
	<!-- ${conTimeList} 에 들어있는 공연날짜, 시간중에 보여지는 달력에서 
		선택한 날짜에 해당하는 시간만 라디오버튼으로 표시: js 로 구현해야 할듯. 
		여기서 선택된 날짜, 시간 정보를 예매하기 페이지로 가지고 넘어가야함 -->
		공연날짜 보여주는 달력
		<br/><br/>
		시간대 선택
		<br/><br/>
		<!-- 남은 좌석 표시 : Ajax로 실시간으로 꺼내오기 -->
		남은 좌석 : 
		<br/><br/>
		<!-- 예매하기 버튼 -->
		<button>예매하기</button>
	</div>
</div>

<!-- 공연소개 -->	
<div>
	${concertVO.description}
</div>


<!-- 리뷰 목록 -->
 <h2>📋 전체 리뷰 목록</h2>

  <c:forEach var="review" items="${reviewList}">
    <div class="review-box">
      <div class="review-header">
        <div class="review-rate">
          <c:forEach begin="1" end="${review.rate}" var="i">
            ★
          </c:forEach>
        </div>
        <div class="consumer">작성자: ${review.userId}</div>
      </div>
      <div class="review-content">
        ${review.content}
      </div>
      <div class="review-date">
        작성일: <fmt:formatDate value="${review.createDate}" pattern="yyyy-MM-dd HH:mm"/>
      </div>
    </div>
  </c:forEach>

</body>
</html>