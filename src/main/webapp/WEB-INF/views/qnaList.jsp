<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>문의 내역</title>
  <style>
    body {
      font-family: sans-serif;
    }
    .layout {
      display: flex;
    }
    .sidebar {
      width: 150px;
      background-color: #eee;
      padding: 10px;
    }
    .sidebar ul {
      list-style: none;
      padding: 0;
    }
    .sidebar li {
      margin: 10px 0;
    }
    .content {
      flex-grow: 1;
      padding: 20px;
    }
    .qna-box {
      background: #f5f5f5;
      border: 1px solid #ccc;
      border-radius: 10px;
      padding: 15px;
      margin-bottom: 15px;
    }
    .answer-box {
      background: #ffffff;
      border: 1px solid #ddd;
      border-left: 4px solid #8bc34a;
      padding: 10px;
      margin-top: 5px;
    }
    .qna-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .qna-btn {
      background: #ddd;
      padding: 5px 10px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
  </style>
</head>
<body>

<header>
  <h2>문의</h2>
</header>

<div class="layout">

  <!-- 메인 콘텐츠 -->
  <div class="content">

    <!-- 문의글쓰기 버튼 -->
    <div style="text-align: right; margin-bottom: 15px;">
      <a href="qnaInsert.jsp">
        <button class="qna-btn">🖋 문의글쓰기</button>
      </a>
    </div>

    <!-- 문의 리스트 출력 -->
    <c:forEach var="qna" items="${qnaList}">
      <div class="qna-box">
        <div class="qna-header">
          <strong>${qna.qna_title}</strong>
          <span>글쓴 날짜: <fmt:formatDate value="${qna.qna_createDate}" pattern="yyyy-MM-dd" /></span>
        </div>
        <div style="margin-top: 10px;">
          ${qna.qna_content}
        </div><br>

        <!-- 답변이 있을 경우 -->
        <c:if test="${not empty qna.content}">
            <strong>답변</strong><br />
          <div class="answer-box">
            <strong>${qna.title}</strong>  (<span>수정일: <fmt:formatDate value="${qna.updateDate}" pattern="yyyy-MM-dd" /></span>)<br>
            ${qna.content}
          </div>
        </c:if>
      </div>
    </c:forEach>

  </div>
</div>

</body>
</html>
