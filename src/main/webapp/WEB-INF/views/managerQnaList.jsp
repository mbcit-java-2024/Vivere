<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>관리자 페이지 - 문의 내용 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.qna-box {
	background: #f1f1f1;
	border: 1px solid #ccc;
	padding: 15px;
	margin-bottom: 20px;
	border-radius: 8px;
}

.qna-header {
	font-weight: bold;
	margin-bottom: 5px;
}

.answer-btn {
	float: right;
	background: #ddd;
	border: none;
	padding: 5px 10px;
	border-radius: 5px;
	cursor: pointer;
}

.answer-form {
	margin-top: 10px;
	display: none;
}

textarea {
	width: 100%;
	height: 60px;
	resize: none;
}

.save-btn {
	margin-top: 5px;
	float: right;
}
</style>
</head>
<body>
	<h2>문의 리스트</h2>

	<c:forEach var="qna" items="${managerQnaList}">
		<div class="qna-box">
			<div class="qna-header">
				${qna.title}
				<button class="answer-btn" onclick="toggleAnswerForm(${qna.id})">🖋
					답변쓰기</button>
			</div>
			<div class="qna-content">${qna.content}</div>

			<div class="answer-form" id="answerForm-${qna.id}">
				<form action="/qnaRep/insert" method="post">
					<input type="hidden" name="qnaId" value="${qna.id}" />
					<textarea name="content" placeholder="답변 내용을 입력하세요"></textarea>
					<button type="submit" class="save-btn">답변저장</button><br/><br/>
				</form>
			</div>
		</div>
	</c:forEach>


	<script>
	function toggleAnswerForm(id) {
	    $(".answer-form").not("#answerForm-" + id).slideUp(); // 다른 폼 닫기
	    $("#answerForm-" + id).slideToggle(); // 해당 폼 토글
	  }
	</script>
</body>
</html>

