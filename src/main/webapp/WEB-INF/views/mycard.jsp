<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 카드 관리</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            max-width: 1200px;
            margin: 50px auto;
            gap: 40px;
        }

        .sidebar {
            width: 200px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 30px;
            height: fit-content;
            align-self: flex-start;
        }

        .sidebar a {
            display: block;
            margin-bottom: 10px;
            font-size: 14px;
            color: #555;
            text-decoration: none;
        }

        .sidebar a:hover {
            color: #f97316;
        }

        .content {
            flex-grow: 1;
        }

        .content h2 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .card-box {
            margin-top: 10px;
            font-size: 16px;
        }

        .card-item {
            background-color: #f1f1f1;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            position: relative;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .card-info {
            flex: 1;
        }

        .card-item form {
            align-self: flex-end;
        }

        .btn {
            margin-top: 10px;
            display: inline-block;
            background-color: black;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
        }

        .btn:hover {
            background-color: #333;
        }

        .btn-delete {
            background-color: black;
            color: white;
            padding: 8px 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-delete:hover {
            background-color: #333;
        }

    </style>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="./include/header.jsp"/>

	<div class="body-main">
		<c:if test="${not empty msg}">
		    <script>
		        alert("${msg}");
		    </script>
		</c:if>

		<div class="container">

		    <div class="sidebar">
		        <jsp:include page="myinfoMenu.jsp" />
		    </div>

		    <div class="content">
		        <h2>등록된 카드 정보</h2>

		        <c:choose>
		            <c:when test="${empty cardList}">
		                <p class="card-box">등록된 카드가 없습니다.</p>
		                <a href="/mycardInsert" class="btn">카드 등록하기</a>
		            </c:when>
		            <c:otherwise>
		                <div class="card-box">
		                    <c:forEach var="card" items="${cardList}">
		                        <div class="card-item">
		                            <div class="card-info">
		                                <p><strong>거래은행:</strong> ${card.bankName}</p>
		                                <p><strong>카드번호:</strong> ${card.cardNum}</p>
		                                <p><strong>유효기간:</strong> ${card.validDate}</p>
		                                <p><strong>등록일자:</strong> <fmt:formatDate value="${card.createDate}" pattern="yyyy-MM-dd" /></p>
		                            </div>
		                            <form action="/mycardDelete" method="post">
		                                <input type="hidden" name="id" value="${card.id}" />
		                                <button type="submit" class="btn-delete">삭제</button>
		                            </form>
		                        </div>
		                    </c:forEach>
		                </div>

		                <a href="/mycardInsert" class="btn">등록카드 추가</a>
		            </c:otherwise>
		        </c:choose>
		    </div>
		</div>
	</div>

	<jsp:include page="./include/footer.jsp"/>

	</div>




</body>
</html>










