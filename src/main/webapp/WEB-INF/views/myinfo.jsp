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
		    display: flex;
		    flex-direction: column;
		    justify-content: space-between;
		}

		.card .btn {
		    align-self: flex-end; 
		    margin-top: auto;     
		}
        .card h3 {
            margin-bottom: 10px;
        }

        .card p {
            margin-bottom: 10px;
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
				<div class="card">
				    <div style="display: flex; justify-content: space-between; align-items: flex-end;">
				        <div>
							<p class="info-item"><strong>이름:</strong> ${loginUser.name}</p>
							<p class="info-item"><strong>생년월일:</strong> ${loginUser.birth}</p>
							<p class="info-item"><strong>성별:</strong>
							    <c:choose>
							        <c:when test="${loginUser.gender == 'MALE'}">남자</c:when>
							        <c:when test="${loginUser.gender == 'FEMALE'}">여자</c:when>
							    </c:choose>
							</p>
				        </div>
				        <a href="/myinfoDetail" class="btn">더보기</a>
				    </div>
				</div>

				<div class="card">
				    <c:if test="${empty latestBook}">
				        <h3><strong>예매 내역이 없습니다</strong></h3>
				    </c:if>

				    <c:if test="${not empty latestBook}">
				        <h3>예매 내역</h3>
				        <div style="display: flex; gap: 20px;">
				         
				            <img src="${latestBook.posterUrl}" alt="공연 포스터" style="width: 120px; height: auto; border-radius: 5px;" />

				            
				            <div style="display: flex; flex-direction: column; justify-content: space-between; flex-grow: 1;">
				                <div>
				                    <p><strong>공연명:</strong> ${latestBook.title}</p>
				                    <p><strong>공연일:</strong> <fmt:formatDate value="${latestBook.concertTime}" pattern="yyyy-MM-dd HH:mm"/></p>
				                    <p><strong>좌석:</strong> ${latestBook.seatNum}</p>
				                </div>
				                <div style="text-align: right;">
				                    <a href="/myBook" class="btn">더보기</a>
				                </div>
				            </div>
				        </div>
				    </c:if>
				</div>		
										
				<div class="card">
		            <h3>지난 공연 </h3>
		            <a href="/pastBook" class="btn">더보기</a>
		        </div>

		        <div class="card">
		            <h3>나의 문의</h3>
		            <a href="/qnaList" class="btn">더보기</a>
		        </div>
		    </div>
		</div>
	</div>

	<jsp:include page="./include/footer.jsp"/>

	</div>




</body>
</html>