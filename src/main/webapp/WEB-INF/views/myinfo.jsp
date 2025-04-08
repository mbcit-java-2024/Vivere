<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
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
            gap: 30px;
        }

        .main {
            flex-grow: 1;
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

        .card {
            background-color: #fff;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
        }

        .info-box {
            background-color: #f1f1f1;
            padding: 15px 20px;
            border-radius: 8px;
            position: relative;
        }

        .info-box p {
            margin: 6px 0;
        }

        .btn-box {
            display: flex;
            justify-content: flex-end;
            margin-top: 15px;
        }

        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: black;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn:hover {
            background-color: #333;
        }

        .latest-book {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .latest-book img {
            width: 100px;
            height: auto;
            flex-shrink: 0;
            border-radius: 6px;
        }

        h3 {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="./include/header.jsp"/>

    <div class="body-main">
        <div class="container">
            <div class="sidebar">
                <jsp:include page="myinfoMenu.jsp"/>
            </div>

            <div class="main">

                <!-- 내 정보 -->
                <div class="card">
                    <h3>내 정보</h3>
                    <div class="info-box">
                        <p><strong>이름:</strong> ${loginUser.name}</p>
                        <p><strong>등급:</strong> ${loginUser.grade}</p>
                        <p><strong>생년월일:</strong> ${loginUser.birth}</p>
                        <p><strong>성별:</strong>
                            <c:choose>
                                <c:when test="${loginUser.gender == 'MALE'}">남자</c:when>
                                <c:when test="${loginUser.gender == 'FEMALE'}">여자</c:when>
                            </c:choose>
                        </p>
                        <div class="btn-box">
                            <a href="/myinfoDetail" class="btn">더보기</a>
                        </div>
                    </div>
                </div>

                <!-- 최신 예매 내역 -->
                <div class="card">
                    <h3>최신 예매 내역</h3>
                    <c:choose>
                        <c:when test="${empty latestBook}">
                            <div class="info-box">
                                <p><strong>예매 내역이 없습니다.</strong></p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="info-box">
                                <div class="latest-book">
                                    <img src="${latestBook.posterUrl}" alt="공연 포스터"/>
                                    <div>
                                        <p><strong>공연명:</strong> ${latestBook.title}</p>
                                        <p><strong>공연일:</strong>
                                            <fmt:formatDate value="${latestBook.concertTime}" pattern="yyyy-MM-dd HH:mm"/>
                                        </p>
                                        <p><strong>좌석:</strong> ${latestBook.seatNum}</p>
                                    </div>
                                </div>
                                <div class="btn-box">
                                    <a href="/myBook" class="btn">더보기</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 나의 문의 -->
                <div class="card">
                    <h3>나의 문의</h3>
                    <div class="info-box">
                        <c:choose>
                            <c:when test="${empty latestQna}">
                                <p><strong>등록된 문의가 없습니다.</strong></p>
                            </c:when>
                            <c:otherwise>
                                <p><strong>제목:</strong> ${latestQna.title}</p>
                                <p><strong>작성일:</strong>
                                    <fmt:formatDate value="${latestQna.createDate}" pattern="yyyy-MM-dd"/>
                                </p>
                                <p><strong>답변 상태:</strong>
                                    <c:choose>
                                        <c:when test="${latestQna.hasReply}">답변 완료</c:when>
                                        <c:otherwise>미답변</c:otherwise>
                                    </c:choose>
                                </p>
                            </c:otherwise>
                        </c:choose>
                        <div class="btn-box">
                            <a href="/qnaList" class="btn">더보기</a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="./include/footer.jsp"/>
</div>
</body>
</html>