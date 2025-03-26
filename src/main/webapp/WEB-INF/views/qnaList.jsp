<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매자 페이지 - 문의 내역</title>
<style>
</style>
</head>
<body>
	<!-- 문의 내역 + 버튼 영역 -->
	<div
		>
		<h2 >내 문의 내역</h2>
		<a href="/qna/write">
			<button
				>
				✍ 문의글쓰기</button>
		</a>
	</div>

	<c:forEach var="qna" items="${qnaList}">
		<div class="qna-box"
			>

			<!-- 문의 제목 및 작성일 -->
			<div class="qna-header">
				<strong>${qna.qna_title}</strong> <span >작성일:
					<fmt:formatDate value="${qna.qna_createDate}" pattern="yyyy-MM-dd" />
				</span>
			</div>

			<!-- 문의 내용 -->
			<div class="qna-content">
				${qna.qna_content}</div>

			<!-- 답변 여부에 따라 표시 -->
			<c:choose>
				<c:when test="${not empty qna.content}">
					<!-- 답변이 있는 경우 -->
					<div class="answer-box"
						>
						<strong>답변</strong> <span >답변일: <fmt:formatDate
								value="${qna.updateDate}" pattern="yyyy-MM-dd" /></span><br />
						<div>${qna.title}</div>
						<div >${qna.content}</div>
					</div>
				</c:when>
				<c:otherwise>
					<div class="answer-box"
						>
						<strong>아직 답변이 등록되지 않았습니다.</strong>
					</div>
					<div>
						<a href="/qna/edit?qnaId=${qna.qna_id}">
							<button
								>
								✏ 문의글 수정</button>
						</a>
					</div>
				</c:otherwise>
			</c:choose>

		</div>
	</c:forEach>


	<script>
		
	</script>

</body>
</html>
