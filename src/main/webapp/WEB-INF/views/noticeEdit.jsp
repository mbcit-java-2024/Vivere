<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .form-label {
            font-weight: bold;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="./include/header.jsp"/>

<div class="wrapper">

<div class="container my-5">
    <h2 class="mb-4">✏ 공지사항 수정</h2>

    <c:set var="notice" value="${noticeDetail}" />
    <form action="/noticeEditOK" method="post">
        <!-- notice id (hidden) -->
        <input type="hidden" name="id" value="${notice.id}" />

        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" value="${notice.title}" required />
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">내용</label>
            <textarea class="form-control" id="content" name="content" rows="8" required>${notice.content}</textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">공지 유형</label><br/>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="status" id="important" value="1"
                       <c:if test="${notice.status == 1}">checked</c:if> />
                <label class="form-check-label" for="important">중요 공지사항</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="status" id="normal" value="0"
                       <c:if test="${notice.status != 1}">checked</c:if> />
                <label class="form-check-label" for="normal">일반 공지사항</label>
            </div>
        </div>

        <div class="mb-3 text-muted">
            <div>작성일: <fmt:formatDate value="${notice.createDate}" pattern="yyyy-MM-dd HH:mm" /></div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary">💾 저장</button>
            <a href="/noticeList" class="btn btn-secondary ms-2">↩ 목록</a>
        </div>
    </form>
</div>
<jsp:include page="./include/footer.jsp"/>
</div>

</body>
</html>
