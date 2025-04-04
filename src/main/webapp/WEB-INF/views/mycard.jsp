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

        .card-box {
            margin-top: 10px;
            font-size: 16px;
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
        <%-- sidebar include --%>
        <jsp:include page="myinfoMenu.jsp" />

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
			                <p>거래은행: ${card.bankName}</p>
			                <p>카드번호: ${card.cardNum}</p>
			                <p>유효기간: ${card.validDate}</p>
			                <p>등록일자: <fmt:formatDate value="${card.createDate}" pattern="yyyy-MM-dd" /></p>
			                <hr/>
			            </c:forEach>
			        </div>
					
					<a href="/mycardUpdate" class="btn">등록카드 변경하기</a>
			    </c:otherwise>
			</c:choose>       
		 </div>
    </div>

</body>
</html>