<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공연 정보</title>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<!-- <link rel="stylesheet" type="text/css" href="/resources/css/reviewList.css" />-->
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/js/bootstrap.bundle.min.js"></script>
<style>
	.btn-outline-black {
	  background-color: white;
	  color: black;
	  border-color: black;
	}
	
	.btn-outline-black:hover {
	  background-color: black;
	  color: white;
	  border-color: black;
	}
	
	.btn-outline-gold {
	  background-color: white;
	  color: #CDAA39;
	  border-color: #CDAA39;
	}
	
	.btn-outline-gold:hover {
	  background-color: #CDAA39;
	  color: white;
	  border-color: #CDAA39;
	}
	
	.btn-gold {
	  background-color: #CDAA39;
	  color: white;
	  border-color: #CDAA39;
	}
	
	.btn-gold:hover {
	  background-color: white;
	  color: #CDAA39;
	  border-color: #CDAA39;
	}
    .has-concert:hover {
        background-color: #ffc107 !important;
        font-weight: bold;
    }
    
     .calendar-cell.has-concert {
        transition: background-color 0.3s ease;
    }

    .calendar-cell.has-concert:hover {
        background-color: #d6bc83 !important;
        color: #a88a2d !important;
    }

    .calendar-cell.selected {
        background-color: #78171C !important;
        color: #ffffff !important;
        font-weight: bold;
    }
    
     /* 버튼 기본 상태 */
    .btn-outline-primary {
        border-color: #78171C;
        color: #78171C;
    }

    .btn-outline-primary:hover {
        background-color: #f7dede; /* 연한 배경으로 마우스오버 효과 */
        color: #78171C;
    }

    /* 선택된 버튼 상태 */
    .btn-check:checked + .btn-outline-primary {
        background-color: #78171C;
        color: white;
        border-color: #78171C;
    }
    
</style>
</head>
<!-- header -->
<body>
<div class="wrapper">
<jsp:include page="./include/header.jsp"/>
	<div class="body-main">
		<div class="container " >
		
			<!-- 공연 정보 -->
			<div class="card p-3 mt-3">
				<div class="mb-2">
				<h2 class="display-4 float-start p-3">${concertVO.title }</h2> &nbsp;&nbsp;&nbsp;
				<fmt:formatDate value="${concertVO.startDate}" pattern="yy.MM.dd" var="startDate"/>
				<fmt:formatDate value="${concertVO.endDate}" pattern="yy.MM.dd" var="endDate"/>
				<h5 class="float-end">${startDate} ~ ${endDate}</h5>
				</div>
			
				<div class="container p-0" style="display: flex;">
					<div style="width: 50%">
						<img alt="공연포스터" src="${concertVO.posterUrl}" style="width: 100%; ">
					</div>
					<div style="width: 50%; margin-left: 10px; padding-left: 5px; padding-right: 5px;">
			            <h5 class="mb-2">공연 일정</h5>
					
					    <form id="timeForm" method="post" action="/book">
					        <input type="hidden" name="concertId" value="${concertVO.id}" />
					
					        <!-- 달력 -->
					        <div class="card p-3 mb-4">
					            <div class="d-flex justify-content-between align-items-center mb-3">
					                <button type="button" id="prevMonth" class="btn btn-outline-secondary">&lt;</button>
					                <h4 id="currentMonth">2025년 4월</h4>
					                <button type="button" id="nextMonth" class="btn btn-outline-secondary">&gt;</button>
					            </div>
					            <div class="row text-center fw-bold mb-2">
					                <div class="col">일</div>
					                <div class="col">월</div>
					                <div class="col">화</div>
					                <div class="col">수</div>
					                <div class="col">목</div>
					                <div class="col">금</div>
					                <div class="col">토</div>
					            </div>
					            <div id="calendar"></div>
					        </div>
					
					        <!-- 시간 선택 -->
					        <div id="timeSelector" class="mb-2 d-grid gap-2">
					            <h5><label class="form-label">공연 시간</label></h5>
					            <div id="timeButtons" class="d-flex flex-wrap gap-2 mb-4"></div>
					<script>
					    const today = new Date();
					    let currentYear = today.getFullYear();
					    let currentMonth = today.getMonth();
					
					    // JSTL 데이터를 JavaScript 배열로 변환
					    const conTimeList = [
						  <c:forEach var="ct" items="${conTimeList}" varStatus="status">
						  {
						    id: '${ct.id}',
						    concertId: '${ct.concertId}',
						    dateTime: '<fmt:formatDate value="${ct.concertTime}" pattern="yyyy-MM-dd'T'HH:mm" />'
						  }<c:if test="${!status.last}">,</c:if>
						  </c:forEach>
						];
					
					    // 날짜만 추출해서 고유 날짜 리스트 생성
					    const concertDates = [...new Set(conTimeList.map(c => c.dateTime.split('T')[0].trim()))];
					    const maxDate = new Date(Math.max(...concertDates.map(d => new Date(d))));
					    const maxYear = maxDate.getFullYear();
					    const maxMonth = maxDate.getMonth();
					
					    function renderCalendar(year, month) {
					        $("#calendar").empty();
					        $("#currentMonth").text(year + "년 " + (month + 1) + "월");
		
					        const firstDay = new Date(year, month, 1);
					        const lastDate = new Date(year, month + 1, 0).getDate();
					        const startWeekday = firstDay.getDay();
		
					        const today = new Date();
					        today.setHours(0, 0, 0, 0); // 날짜 비교용 (시간 제거)
					        
					        let dayCounter = 1;
					        let finished = false;
		
					        for (let row = 0; row < 6 && !finished; row++) {
					            const weekRow = $('<div class="row g-2 mb-1"></div>');
					            let hasVisibleDay = false;
		
					            for (let col = 0; col < 7; col++) {
					                const cell = $('<div class="col text-center p-2 border rounded calendar-cell"></div>');
		
					                if (row === 0 && col < startWeekday) {
					                    cell.html('&nbsp;');
					                    cell.addClass("text-muted");
					                } else if (dayCounter <= lastDate) {
					                    hasVisibleDay = true;
		
					                    const dateStr = year + '-' + String(month + 1).padStart(2, '0') + '-' + String(dayCounter).padStart(2, '0');
					                    const hasConcert = concertDates.includes(dateStr);
		
					                    cell.text(dayCounter);
					                    cell.attr('data-date', dateStr);
		
					                    if (hasConcert) {
					                    	const concertDate = new Date(dateStr);
					                        if (concertDate < today) {
					                            // 지난 공연 날짜: 클릭 불가, 회색 표시
					                            cell.css({
					                                backgroundColor: "#e9ecef", // 회색톤
					                                color: "#6c757d", // 회색 글씨
					                                cursor: "not-allowed"
					                            }).addClass("text-muted disabled");
					                        } else {
						                        cell.addClass("has-concert");
						                        cell.css({
						                            backgroundColor: "#CDAA39",
						                            color: "white",
						                            cursor: "pointer"
						                        });
		
						                        cell.on("click", function () {
						                            showTimesForDate(dateStr);
						                            $(".calendar-cell").removeClass("selected");
						                            $(this).addClass("selected");
						                        });
					                        }
					                    } else {
					                        cell.addClass("text-muted");
					                    }
		
					                    dayCounter++;
					                } else {
					                    cell.html('&nbsp;');
					                    cell.addClass("text-muted");
					                }
		
					                weekRow.append(cell);
					            }
		
					            if (hasVisibleDay) {
					                $("#calendar").append(weekRow);
					            }
					        }
					    }
					
					    function showTimesForDate(dateStr) {
					        $("#timeButtons").empty();
					
					        const matchedTimes = conTimeList.filter(c => c.dateTime.startsWith(dateStr));
					        matchedTimes.forEach((c, idx) => {
					            const time = c.dateTime.split('T')[1].substring(0, 5);
					            const inputId = 'btn-check-' + idx;
					            const nameAttr = 'selectedTime';
					
					            const btnCheck =
					                '<input type="radio" class="btn-check" id="' + inputId + '" name="' + nameAttr + '" value="' + c.dateTime + '" autocomplete="off">' +
					                '<label class="btn btn-outline-primary" for="' + inputId + '">' + time + '</label>';
					            $("#timeButtons").append(btnCheck);
					        });
					    }
					
					    // 월 이동
					    $("#prevMonth").on("click", function () {
					        if (currentYear > today.getFullYear() || (currentYear === today.getFullYear() && currentMonth > today.getMonth())) {
					            currentMonth--;
					            if (currentMonth < 0) {
					                currentMonth = 11;
					                currentYear--;
					            }
					            renderCalendar(currentYear, currentMonth);
					        }
					    });
					
					    $("#nextMonth").on("click", function () {
					        if (currentYear < maxYear || (currentYear === maxYear && currentMonth < maxMonth)) {
					            currentMonth++;
					            if (currentMonth > 11) {
					                currentMonth = 0;
					                currentYear++;
					            }
					            renderCalendar(currentYear, currentMonth);
					        }
					    });
					
					    renderCalendar(currentYear, currentMonth);
					    
					    $("#timeForm").on("submit", function (e) {
					        const selected = $("input[name='selectedTime']:checked").val();
					        if (!selected) {
					            e.preventDefault(); // 제출 막기
					            alert("공연 시간을 선택해주세요!");
					        }
					    });
					</script>
		
						<!-- 남은 좌석 표시 : Ajax로 실시간으로 꺼내오기 
						<div class="m-2">
						남은 좌석 : 
						</div>
						-->
						<c:choose>
					    <c:when test="${sessionScope.loginUser.grade eq 'ADMIN'}">
							<!-- 관리자 로그인 시에만 보이는 버튼 -->
							<button  type="button" class="btn btn-outline-black"
								onclick="location.href='/updateConcert?concertId=${concertVO.id}'">수정</button>
							<button type="button" class="btn btn-outline-gold"
								onclick="location.href='/concertData?concertId=${concertVO.id}'">통계</button>
					    </c:when>
					    <c:otherwise>
							<!-- 예매하기 버튼 -->
					        <button type="submit" class="btn btn-lg btn-gold" style="margin: 0px;">예매하기</button>
					    </c:otherwise>
						</c:choose>
						</div>
					    </form>
					</div>
					</div>
				</div>
			</div>
			
		<div class="container mt-2" >
			<!-- 공연소개 -->
			<div class="card p-3 mt-3">
			<h3>공연 소개</h3>
			<div>
				${concertVO.description}
			</div>
			</div>	
		</div>
		
		<div class="container mb-4 mt-4" >
			<div class="card p-3 mt-3">
			<h3>전체 리뷰 목록</h3>
			
			  <c:forEach var="review" items="${reviewList}">
			    <div class="review-box">
			      <div class="review-header">
			        <div class="review-rate">
			          <c:forEach begin="1" end="${review.rate}" var="i">
			            ★
			          </c:forEach>
			        </div>
			        <div class="consumer">작성자: ${review.userId}</div>
			      </div>
			      <div class="review-content">
			        ${review.content}
			      </div>
			      <div class="review-date">
			        작성일: <fmt:formatDate value="${review.createDate}" pattern="yyyy-MM-dd HH:mm"/>
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