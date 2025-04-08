<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Vivere - 공지사항</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .notice-table th {
            background-color: #f9f9f9;
            padding: 12px;
            font-weight: bold;
            vertical-align: top;
            text-align: left;
        }
        .notice-table td {
            padding: 12px;
            vertical-align: top;
        }
        .notice-content {
            white-space: pre-line;
            line-height: 1.8;
        }
    </style>
</head>
<body class="bg-light">
<div class="wrapper">
	<jsp:include page="./include/header.jsp"/>
	<div class="body-main">
		<div class="container my-5">
		    <a href="/noticeList" class="btn btn-link text-muted mb-3">
		        &larr; 목록으로 돌아가기
		    </a>
		
		    <c:set var="notice" value="${noticeDetail}" />
		
		    <table class="table table-bordered shadow bg-white rounded-4 notice-table">
		        <tbody>
		            <!-- 첫 번째 행: 제목 | 등록일 -->
		            <tr>
		                <th style="width: 100px;">제목</th>
		                <td>${notice.title}</td>
		                <th style="width: 100px;">등록일</th>
		                <td>
		                    <fmt:formatDate value="${notice.createDate}" pattern="yyyy.MM.dd" />
		                </td>
		                <th style="width: 100px;">수정일</th>
		                <td>
		                    <fmt:formatDate value="${notice.updateDate}" pattern="yyyy.MM.dd" />
		                </td>
		            </tr>
		
		            <!-- 두 번째 행: 최종 수정일 -->
		            <tr>
		            </tr>
		
		            <!-- 세 번째 행: 공지 유형 -->
		            <tr>
		                <th>공지 유형</th>
		                <td colspan="5">
		                    <c:choose>
		                        <c:when test="${notice.status == 1}">중요 공지사항</c:when>
		                        <c:otherwise>일반 공지사항</c:otherwise>
		                    </c:choose>
		                </td>
		            </tr>
		
		            <!-- 네 번째 행: 내용 -->
		            <tr>
		                <th>내용</th>
		                <td colspan="5" class="notice-content">${notice.content}</td>
		            </tr>
		        </tbody>
		    </table>
		</div>
	</div>
	<jsp:include page="./include/footer.jsp"/>
</div>
</body>
</html>
