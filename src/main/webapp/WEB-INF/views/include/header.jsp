<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<title>Header</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<link rel="stylesheet" type="text/css" href="/resources/css/header.css" />
<script>
        function toggleDropdown() {
            const menu = document.getElementById("loginDropdown");
            menu.style.display = (menu.style.display === "block") ? "none" : "block";
        }

        function toggleGuideDropdown() {
            const menu = document.getElementById("guideDropdown");
            menu.style.display = (menu.style.display === "block") ? "none" : "block";
        }

        document.addEventListener("click", function(event) {
            const loginMenu = document.getElementById("loginDropdown");
            const loginButton = document.getElementById("dropdownButton");
            if (!loginMenu.contains(event.target) && !loginButton.contains(event.target)) {
                loginMenu.style.display = "none";
            }

            const guideMenu = document.getElementById("guideDropdown");
            const guideButton = document.getElementById("guideButton");
            if (!guideMenu.contains(event.target) && !guideButton.contains(event.target)) {
                guideMenu.style.display = "none";
            }
        });
    </script>
</head>
<body>

	<nav>
		<div class="nav-inner">
			<a href="/">로고</a> <a href="/concertList">공연</a> 
			<a href="monthly.jsp">일정(캘린더)</a>

			<!-- 이용안내 드롭다운 -->
			<div class="guide-dropdown">
				<button id="guideButton" class="dropdown-toggle"
					onclick="toggleGuideDropdown()">이용안내</button>
				<div id="guideDropdown" class="guide-dropdown-menu">
					<a href="cancel_notice.jsp">예약/취소 안내</a> 
					<a href="map.jsp">오시는 길</a> 
					<a href="info.jsp">시설 안내</a> 
					<c:if test="${not empty consumerVO.Grade eq 'ADMIN'}">
						<a href="/noticeList">공지사항</a>
					</c:if>
				</div>
			</div>

			<!-- 로그인 드롭다운 -->
			<div class="dropdown">
				<button id="dropdownButton" class="dropdown-toggle"
					onclick="toggleDropdown()">
					<c:choose>
						<c:when test="${empty loginUser}">로그인</c:when>
						<c:otherwise>${loginUser}</c:otherwise>
					</c:choose>
				</button>
				<div id="loginDropdown" class="dropdown-menu">
					<c:choose>
						<c:when test="${empty loginUser}">
							<a href="login.jsp">로그인</a>
							<a href="signIn.jsp">회원가입</a>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when test="${not empty consumerVO.Grade eq 'ADMIN'}">
									<a href="/qnaList">문의답변 쓰기</a>
									<a href="logout.jsp">로그아웃</a>
								</c:when>
								<c:otherwise>
									<a href="myPage.jsp">마이페이지</a>
									<a href="logout.jsp">로그아웃</a>
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</div>
			</div>


			<c:if test="${sessionScope.loginUser.grade eq 'ADMIN'}">
				<a href="/insertConcert">공연 등록</a>  
				<div class="rep-box" style="text-align: center;">
					<button onclick="location.href='/qnaList'">문의 답변 쓰러가기</button>
				</div>
			</c:if>
		</div>
	</nav>

	<!-- 검색창 
	<form class="search-form" action="" method="get">
		<input type="text" name="keyword" placeholder="공연 검색어를 입력하세요" />
		<button type="submit">
			<i class="fas fa-search"></i> 검색하기
		</button>
	</form>
	-->

</body>
</html>
