<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 정보</title>
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

        .main {
            flex-grow: 1;
        }

        h2 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .content {
            background-color: #f1f1f1;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        .info-item {
            margin-bottom: 15px;
            font-size: 16px;
        }

        .info-item strong {
			font-weight:bold;
            color: #333;
			margin-top: 0;
        }

        .btn {
            display: inline-block;
            background-color: black;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            margin-top: 30px;
        }

        .btn:hover {
            background-color: #333;
        }
    </style>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="./include/header.jsp"/>

	<div class="body-main">
		<div class="container">
		    <div class="sidebar">
		        <jsp:include page="myinfoMenu.jsp" />
		    </div>

		    <div class="main">
		        <h2>내 정보</h2>
		        <div class="content">
		            <p class="info-item"><strong>이름:</strong> ${loginUser.name}</p>
		            <p class="info-item"><strong>생년월일:</strong> ${loginUser.birth}</p>
		            <p class="info-item"><strong>성별:</strong>
		                <c:choose>
		                    <c:when test="${loginUser.gender == 'MALE'}">남자</c:when>
		                    <c:when test="${loginUser.gender == 'FEMALE'}">여자</c:when>
		                </c:choose>
		            </p>
		            <p class="info-item"><strong>등급:</strong> ${loginUser.grade}</p>
		            <p class="info-item"><strong>이메일:</strong> ${loginUser.email}</p>
		            <p class="info-item"><strong>전화번호:</strong> ${loginUser.phone}</p>
		            <p class="info-item"><strong>주소:</strong> ${loginUser.address} ${loginUser.detailAddress}</p>

		            <a href="/myinfoUpdate" class="btn">수정하기</a>
		        </div>
		    </div>
		</div>
		<!--주석-->

	</div>

	<jsp:include page="./include/footer.jsp"/>

	</div>



</body>
</html>