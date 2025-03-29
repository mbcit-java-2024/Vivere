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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.qna-box {
	border: 1px solid #ccc;
	padding: 16px;
	margin-bottom: 20px;
	border-radius: 8px;
	background-color: #f9f9f9;
}

.qna-title {
	font-weight: bold;
	background-color: #eee;
	padding: 10px;
	margin-bottom: 8px;
}

.qna-content {
	margin-bottom: 10px;
}

.answer-box {
	background-color: #e6f5ff;
	padding: 10px;
	border-radius: 6px;
}

.edit-form {
	display: none;
	margin-top: 10px;
}

textarea, input[type="text"] {
	width: 100%;
	padding: 8px;
	margin-bottom: 6px;
}

.btn {
	padding: 6px 10px;
	cursor: pointer;
	margin-top: 6px;
}

.top-bar {
	margin-bottom: 20px;
}
</style>

<script>
    function toggleEditForm(id) {
      $(".edit-form").not("#editForm-" + id).slideUp();
      $("#editForm-" + id).slideToggle();
    }
  </script>
</head>
<body>
	<div class="top-bar">
		<button class="btn" onclick="location.href='/qna/write'">✉
			문의글쓰기</button>
	</div>

	<c:forEach var="qna" items="${qnaList}">
		<div class="qna-box">
			<div class="qna-title">${qna.qna_title}</div>
			<div class="qna-content">${qna.qna_content}</div>

			<c:choose>
				<c:when test="${not empty qna.content}">
					<div class="answer-box">
						<strong>답변 제목: ${qna.title}</strong><br /> ${qna.content}
					</div>
				</c:when>

				<c:otherwise>
					<button class="btn" onclick="toggleEditForm(${qna.qna_id})">✏
						문의 수정</button>
					<div class="edit-form" id="editForm-${qna.qna_id}">
						<form action="/qna/update" method="post">
							<input type="hidden" name="qnaId" value="${qna.qna_id}" /> <input
								type="text" name="qna_title" value="${qna.qna_title}" />
							<textarea name="qna_content">${qna.qna_content}</textarea>
							<button type="submit">수정 저장</button>
						</form>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</c:forEach>


</body>
</html>
