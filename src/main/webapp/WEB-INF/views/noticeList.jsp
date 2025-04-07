<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 공지사항</title>
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
	display: block;
	text-align: left;
	text-decoration: none;
	color: #333;
	padding-left: 10px;
}

.title-link:hover {
	text-decoration: underline;
	color: #007BFF;
}
.body-contents {
	display: flex;
	justify-content: center;
	align-items: center;
	margin-bottom: 50px;
}
.write-notice {
	padding: 8px 16px; 
	background-color: #CDAA39; 
	color: white; 
	border: none; 
	border-radius: 4px; 
	cursor: pointer; 
	margin-right: 15px;
}
.contentBox {
	width: 80%;
	min-width: 1000px;
}
</style>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="./include/header.jsp" />
		<div class="body-main body-contents">
			<div class="contentBox">
				<h2>&nbsp;&nbsp;공지사항</h2>
				<c:if test="${sessionScope.loginUser.grade eq 'ADMIN'}">
					<div style="text-align: right; margin-bottom: 20px;">
						<button class="write-notice" onclick="location.href='/noticeInsert'">
							공지작성
						</button>
					</div>
				</c:if>
				<table>
					<thead>
						<tr>
							<th style="width:100px;">번호</th>
							<th>제목</th>
							<th style="width:180px;">작성일</th>
							<c:if test="${sessionScope.loginUser.grade eq 'ADMIN'}">
								<th style="width:150px;">관리</th>
							</c:if>
							<c:if test="${sessionScope.loginUser.grade ne 'ADMIN'}">
								<th style="width:150px;">작성자</th>
							</c:if>
						</tr>
					</thead>
					<tbody>
						<c:if test="${not empty noticeList}">
							<c:forEach var="notice" items="${noticeList}">
								<c:if test="${notice.status == 1}">
									<tr>
										<td><b>공지</b></td>
										<td>
											<a class="title-link" href="/noticeDetail/${notice.id}"><b>${notice.title}</b></a>
										</td>
										<td><fmt:formatDate value="${notice.createDate}" pattern="yyyy-MM-dd HH:mm" /></td>
										<c:if test="${sessionScope.loginUser.grade eq 'ADMIN'}">
											<td>
												<button onclick="location.href='/noticeEdit/${notice.id}'">✏ 수정</button>
												<button onclick="location.href='/noticeDelete/${notice.id}'">🗑 삭제</button>
											</td>
										</c:if>
										<c:if test="${sessionScope.loginUser.grade ne 'ADMIN'}">
											<td>관리자</td>
										</c:if>
									</tr>
								</c:if>
							</c:forEach>
							<c:forEach var="notice" items="${noticeList}">
								<tr>
									<td>${notice.id}</td>
									<td><a class="title-link" href="/noticeDetail/${notice.id}">${notice.title} </a></td>
									<td><fmt:formatDate value="${notice.createDate}" pattern="yyyy-MM-dd HH:mm" /></td>
									<c:if test="${sessionScope.loginUser.grade eq 'ADMIN'}">
										<td>
											<button onclick="location.href='/noticeEdit/${notice.id}'">✏ 수정</button>
											<button onclick="location.href='/noticeDelete/${notice.id}'">🗑 삭제</button>
										</td>
									</c:if>
									<c:if test="${sessionScope.loginUser.grade ne 'ADMIN'}">
										<td>관리자</td>
									</c:if>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${empty noticeList}">
							<tr>
								<th colspan="4" style="background-color: white;">작성된 공지사항이 없습니다.</th>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
		</div>
		<jsp:include page="./include/footer.jsp" />
	</div>
</body>
</html>
