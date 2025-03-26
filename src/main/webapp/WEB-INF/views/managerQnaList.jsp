<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>관리자 페이지 - 문의 내용 리스트</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>

</style>
</head>
<body>
	<h2>문의 리스트 (관리자 화면)</h2>

<c:forEach var="qna" items="${qnaList}">
  <div class="qna-box">

    <!-- 문의 제목 -->
    <div class="qna-header">
      ${qna.qna_title}
    </div>

    <!-- 문의 내용 -->
    <div class="qna-content">
      ${qna.qna_content}
    </div>

    <!-- 답변 여부 분기 -->
    <c:choose>
      <c:when test="${not empty qna.content}">
        <div class="answer-box">
          <strong>${qna.title}</strong><br/>
          ${qna.content}
        </div>

        <button class="answer-btn" onclick="toggleEditForm(${qna.qna_id})">✏ 답변수정</button>
        <div class="answer-edit-form" id="editForm-${qna.qna_id}">
          <form action="/qnaRep/update" method="post">
            <input type="hidden" name="qnaId" value="${qna.qna_id}" />
            <textarea name="content">${qna.content}</textarea>
            <button type="submit">수정저장</button>
          </form>
        </div>
      </c:when>

      <c:otherwise>
        <button class="answer-btn" onclick="toggleAnswerForm(${qna.qna_id})">🖋 답변쓰기</button>

        <div class="answer-form" id="answerForm-${qna.qna_id}">
          <form action="/qnaRep/insert" method="post">
            <input type="hidden" name="qnaId" value="${qna.qna_id}" />
            <textarea name="content" placeholder="답변 내용을 입력하세요"></textarea>
            <button type="submit">답변저장</button>
          </form>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</c:forEach>
<script>
function toggleAnswerForm(id) {
  $(".answer-form").not("#answerForm-" + id).slideUp();
  $("#answerForm-" + id).slideToggle();
  $(".answer-edit-form").slideUp(); // 수정 폼은 닫기
}

function toggleEditForm(id) {
  $(".answer-edit-form").not("#editForm-" + id).slideUp();
  $("#editForm-" + id).slideToggle();
  $(".answer-form").slideUp(); // 답변쓰기 폼은 닫기
}
</script>


</body>
</html>

