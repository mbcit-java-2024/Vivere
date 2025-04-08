<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>예매 내역</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
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

        .booking-card {
            background-color: #f1f1f1;
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .booking-inner {
            display: flex;
            gap: 30px;
        }

		.poster {
		    width: 120px;
		    height: 180px;
		    object-fit: cover;
		    flex-shrink: 0;
		}
        .booking-info {
            flex-grow: 1;
        }

        .booking-info h3 {
            margin: 0 0 10px;
        }

        .booking-info p {
            margin: 5px 0;
        }

        .btn-delete {
            background-color: black;
            color: white;
            padding: 8px 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 15px;
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
                <h2>예매 내역</h2>

                <c:if test="${empty bookList}">
                    <p>예매 내역이 없습니다.</p>
                </c:if>

                <c:forEach var="book" items="${bookList}">
                    <div class="booking-card">
                        <div class="booking-inner">
                            <img src="${book.posterUrl}" alt="공연 포스터" class="poster" />

                            <div class="booking-info">
                                <h3>${book.title}</h3>
                                <p><strong>공연일:</strong> <fmt:formatDate value="${book.concertTime}" pattern="yyyy-MM-dd HH:mm" /></p>
                                <p><strong>좌석:</strong> ${book.seatNum}</p>
                                <p><strong>예매번호:</strong> ${book.bookNum}</p>
                                <p><strong>결제금액:</strong> <fmt:formatNumber value="${book.price}" pattern="#,###원" /></p>
                                <p><strong>예매일자:</strong> <fmt:formatDate value="${book.orderDate}" pattern="yyyy-MM-dd" /></p>

								<form action="/myBookDelete" method="post">
								    <input type="hidden" name="bookNum" value="${book.bookNum}" />
								    <button type="submit" class="btn-delete">예매 취소</button>
								</form>
							</div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <jsp:include page="./include/footer.jsp"/>
</div>
</body>
</html>