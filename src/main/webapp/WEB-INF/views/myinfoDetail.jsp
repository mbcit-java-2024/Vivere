<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        /* 기존 스타일 그대로 유지 */
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
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }

        .content h2 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .btn {
            margin-top: 30px;
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
    </style>
</head>
<body>
	
	<c:if test="${not empty msg}">
	    <script>
	        alert("${msg}");
	    </script>
	</c:if>

    <div class="container">
   
        <jsp:include page="myinfoMenu.jsp" />

        <div class="content">
            <h2>내 정보</h2>

            <p><strong>이름:</strong> ${loginUser.name}</p>
            <p><strong>생년월일:</strong> ${loginUser.birth}</p>
            <p><strong>성별:</strong> 
                <c:choose>
                    <c:when test="${loginUser.gender == 'MALE'}">남자</c:when>
                    <c:when test="${loginUser.gender == 'FEMALE'}">여자</c:when>
                </c:choose>
            </p>
            <p><strong>등급:</strong> ${loginUser.grade}</p>
            <p><strong>이메일:</strong> ${loginUser.email}</p>
            <p><strong>전화번호:</strong> ${loginUser.phone}</p>
            <p><strong>주소:</strong> ${loginUser.address} ${loginUser.detailAddress}</p>			

            <a href="/myinfoUpdate" class="btn">수정하기</a>
        </div>
    </div>

</body>
</html>