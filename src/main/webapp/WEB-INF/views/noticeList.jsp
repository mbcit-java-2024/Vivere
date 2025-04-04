<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>📢 공지사항 목록</title>
<style>
table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 30px;
}

th, td {
	border: 1px solid #ddd;
	padding: 12px;
	text-align: center;
}

th {
	background-color: #f3f3f3;
}

.title-link {
	text-decoration: none;
	color: #333;
}

.title-link:hover {
	text-decoration: underline;
	color: #007BFF;
}
</style>
</head>
<body>

	<h2>📢 공지사항 리스트</h2>
	<div style="text-align: right; margin-bottom: 20px;">
		<button onclick="location.href='/noticeInsert'"
			style="padding: 8px 16px; background-color: #CDAA39; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 15px;">
			✍ 공지사항 작성</button>
	</div>

	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성일</th>
				<th>관리</th>
			</tr>
		</thead>
		<tbody>
			<!-- 🔥 status = 1인 중요 공지 먼저 출력 -->
			<c:forEach var="notice" items="${noticeList}">
				<c:if test="${notice.status == 1}">
					<tr>
						<td>${notice.id}</td>
						<td><a class="title-link" href="/notice/view/${notice.id}"
							style="color: red; font-weight: bold;"> 🔥 ${notice.title} </a></td>
						<td><fmt:formatDate value="${notice.createDate}"
								pattern="yyyy-MM-dd HH:mm" /></td>
						<td>
							<button onclick="location.href='/editNotice/${notice.id}'">✏
								수정</button>
							<button onclick="location.href='/notice/delete/${notice.id}'">🗑
								삭제</button>
						</td>
					</tr>
				</c:if>
			</c:forEach>

			<!-- 나머지 일반 공지 출력 (status != 1) -->
			<c:forEach var="notice" items="${noticeList}">
				<c:if test="${notice.status != 1}">
					<tr>
						<td>${notice.id}</td>
						<td><a class="title-link" href="/notice/view/${notice.id}">
								${notice.title} </a></td>
						<td><fmt:formatDate value="${notice.createDate}"
								pattern="yyyy-MM-dd HH:mm" /></td>
						<td>
							<button onclick="location.href='/notice/edit/${notice.id}'">✏
								수정</button>
							<button onclick="location.href='/notice/delete/${notice.id}'">🗑
								삭제</button>
						</td>
					</tr>
				</c:if>
			</c:forEach>
		</tbody>

	</table>

</body>
</html>
