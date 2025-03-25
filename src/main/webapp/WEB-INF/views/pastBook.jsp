<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>지난 공연 리뷰</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.concert-box {
	border: 1px solid #ccc;
	border-radius: 10px;
	padding: 15px;
	margin-bottom: 20px;
	background-color: #f9f9f9;
}

.concert-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.concert-info {
	font-size: 14px;
	line-height: 1.6;
}

.review-btn {
	background-color: #e0e0e0;
	border: none;
	padding: 5px 10px;
	cursor: pointer;
	border-radius: 5px;
}

.review-form {
	display: none;
	margin-top: 10px;
}

textarea {
	width: 100%;
	height: 60px;
	padding: 8px;
	border-radius: 5px;
	border: 1px solid #ccc;
	resize: none;
}

.review-save-btn {
	margin-top: 5px;
	float: right;
}
</style>
</head>
<body>
	<c:forEach var="pastBook" items="${pastBook}">
		<h2>${pastBook.title }</h2>
		<div class="concert-box">
			<div class="concert-header">
				<div class="concert-info">
					<div class="concert-info">${pastBook.posterUrl }</div>

					<p>
						<strong>공연 번호:</strong> ${pastBook.id}
					</p>
					<p>
						<strong>홀 타입:</strong>
						<c:if test="${pastBook.hallType eq 0}">가우디우홀</c:if>
						<c:if test="${pastBook.hallType eq 1}">펠리체홀</c:if>


					</p>
					<p>
						<strong>장르 타입: <c:if test="${pastBook.categoryId eq 1}">클래식</c:if>
							<c:if test="${pastBook.categoryId eq 2}">뮤지컬</c:if> <c:if
								test="${pastBook.categoryId eq 3}">재즈</c:if> <c:if
								test="${pastBook.categoryId eq 4}">대중음악</c:if> <c:if
								test="${pastBook.categoryId eq 5}">연극</c:if> <c:if
								test="${pastBook.categoryId eq 6}">무용</c:if> <c:if
								test="${pastBook.categoryId eq 7}">기타</c:if></strong>

					</p>
					<p>
						<strong>좌석 번호:</strong> ${pastBook.seatNum}
					</p>
					<p>
						<strong>예매 일자:</strong>
						<fmt:formatDate value="${pastBook.orderDate}" pattern="yyyy-MM-dd" />
					</p>
					<p>
						<strong>공연 일시:</strong>
						<fmt:formatDate value="${pastBook.concertTime}"
							pattern="yyyy-MM-dd HH:mm" />
					</p>
				</div>
			</div>
			<button class="review-btn" onclick="toggleReviewForm(${pastBook.id})">🖋
				리뷰쓰기</button>

			<div class="review-form" id="reviewForm-${pastBook.id}">
				<form action="/review/save" method="post">
					<input type="hidden" name="bookId" value="${pastBook.id}" />
					<button type="submit" class="review-save-btn"
						onclick="reviewInsert(id)">리뷰저장</button>
					<br />
					<br />
					<textarea name="content" placeholder="리뷰를 입력하세요..."></textarea>
				</form>
			</div>
		</div>
	</c:forEach>


	<script>
	 function toggleReviewForm(id) {
		    $(".review-form").not("#reviewForm-" + id).slideUp(); // 다른 폼 닫기
		    $("#reviewForm-" + id).slideToggle(); // 클릭한 폼 토글
		  }
	</script>
</body>
</html>

