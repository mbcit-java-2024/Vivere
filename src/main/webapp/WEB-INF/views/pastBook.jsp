<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>지난 공연 리뷰</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
body {
	font-family: 'Pretendard', sans-serif;
	background-color: #FAF8F6;
	color: #2B2B2B;
	margin: 0;
	padding: 40px;
}

h2 {
	color: #800020;
	margin-bottom: 20px;
}

.concert-box {
	background-color: #FFFFFF;
	border: 2px solid #E5CD94;
	padding: 24px 28px;
	margin-bottom: 32px;
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
}

.concert-header {
	margin-bottom: 16px;
}

.concert-info p {
	margin: 6px 0;
	font-size: 15px;
}

.concert-info strong {
	color: #800020;
}

.review-btn {
	background-color: #F5DEB3;
	color: #800020;
	padding: 6px 12px;
	border: 2px solid #D4AF37;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
	margin-right: 8px;
	margin-top: 10px;
	transition: all 0.3s;
}

.review-btn:hover {
	background-color: #E2725B;
	color: white;
	border-color: #B63330;
}

.review-form {
	display: none;
	margin-top: 16px;
	padding: 20px;
	background-color: #FAF8F6;
	border: 2px solid #E2725B;
	border-radius: 10px;
}

textarea {
	width: 100%;
	height: 80px;
	padding: 10px;
	margin-top: 10px;
	font-size: 14px;
	border: 1.5px solid #CDAA39;
	border-radius: 8px;
	resize: none;
	box-sizing: border-box;
	font-family: 'Pretendard', sans-serif;
}

textarea:focus {
	border-color: #800020;
	outline: none;
}

.review-save-btn {
	background-color: #F5DEB3;
	color: #800020;
	padding: 8px 14px;
	border: 2px solid #D4AF37;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
	margin-top: 10px;
	float: right;
	transition: all 0.3s;
}

.review-save-btn:hover {
	background-color: #E2725B;
	color: white;
	border-color: #B63330;
}

.rating {
	font-size: 24px;
	color: #ccc;
	cursor: pointer;
	user-select: none;
}

.rating .star.active {
	color: #D4AF37;
}

.review-view {
	background-color: #EFEEED;
	padding: 16px;
	border-radius: 10px;
	margin-top: 12px;
	border-left: 5px solid #800020;
}

.review-view p {
	margin: 6px 0;
}

.review-view strong {
	color: #800020;
}

.review-form button {
	display: inline-block;
	float: right;
	/* 또는 아래처럼 조정 */
	width: auto;
}
</style>

<script type="text/javascript">

function selectEditRate(id, rate) {
	  $("#edit-rate-" + id).val(rate);
	  const ratingBox = $("#editForm-" + id).find(".rating");
	  ratingBox.find(".star").each(function(index) {
	    if (index < rate) {
	      $(this).addClass("active").text("★");
	    } else {
	      $(this).removeClass("active").text("☆");
	    }
	  });
	}
function updateReview(id) {
	console.log('updateReview:::::::::::::::::::::id::::::::'+id);
    
    let textarea = $("#editForm-"+id).find("textarea[name='content']").val();
    console.log('updateReview:::::::::::::::::::::::textarea::::::'+textarea);
    let concertId = $("#editForm-"+id).find("input[name='concertId']").val();
    console.log('updateReview:::::::::::::::::::::::concertId::::::'+concertId);
    let bookId = $("#editForm-"+id).find("input[name='bookId']").val();
    console.log('updateReview:::::::::::::::::::::::bookId::::::'+bookId);
    let rate = $("#editForm-" + id).find("input[name='rate']").val();
    console.log('updateReview::::::::::::::rate:::::::' + rate);
	  
	  let param = {
	    		content: textarea
	    		, concertId: concertId
	    		, bookId: bookId
	    		, rate: rate
	    		, review_id: $("#editForm-" + id).find("input[name='reviewId']").val()
	    };

	  $.ajax({
	    url: '/updateReview',
	    type: 'POST',
	    contentType: 'application/json',
	    data: JSON.stringify(param),
	    beforeSend:function(){
            console.log('updateReview:::::::::beforeSend::::::::::::::::::::param' + JSON.stringify(param));
        },
	    success: function(data) {
	    	console.log('success:::::::::::111::::::::::::' + JSON.stringify(data));
	      if ('0' == data.code) {
	        alert('리뷰가 수정되었습니다!');
	        location.reload();
	      } else {
	        alert(data.message || '리뷰 수정 실패');
	      }
	    },
	    error: function(err) {
	      alert('서버 오류 발생!');
	      console.error(err);
	    }
	  });
	}



	function selectrate(id, rate) {
		$("#reviewForm-"+id).find("input[name='rate']").val(rate);
	    console.log('selectrate:::::::::::::::::::::::rate::::::'+rate);
	}

	function reviewInsert(id) { 
	    console.log('reviewInsert:::::::::::::::::::::id::::::::'+id);
	    
	    let textarea = $("#reviewForm-"+id).find("textarea[name='content']").val().trim();
	    console.log('reviewInsert:::::::::::::::::::::::textarea::::::'+textarea);
	    let concertId = $("#reviewForm-"+id).find("input[name='concertId']").val();
	    console.log('reviewInsert:::::::::::::::::::::::concertId::::::'+concertId);
	    let bookId = $("#reviewForm-"+id).find("input[name='bookId']").val();
	    console.log('reviewInsert:::::::::::::::::::::::bookId::::::'+bookId);
	    let rate = $("#reviewForm-" + id).find("input[name='rate']").val();
	    console.log('reviewInsert::::::::::::::rate:::::::' + rate);
	    
	    if (0 == rate) {
	    	alert('별점을 1~5점으로 입력하세요.');
	    	return;
	    }
	    if ('' == textarea) {
	    	alert('리뷰내용을 입력하세요.');
	    	return;
	    }
	    
	    let param = {
	    		content: textarea
	    		, concertId: concertId
	    		, bookId: bookId
	    		, rate: rate
	    };
	   	
	     
	    $.ajax({
	        url : '/reviewInsert',
	        type : 'POST',
	        dataType : "json",
	        contentType:"application/json",
	        data : JSON.stringify(param),
	        beforeSend:function(){
	            console.log('reviewInsert:::::::::beforeSend::::::::::::::::::::param' + JSON.stringify(param));
	        },
	        success : function(data){
	            console.log('success:::::::::::111::::::::::::' + JSON.stringify(data));
	            if ('0' == data.code) {
	            	 location.reload();
	            } else {
            		if (null != data.message) {
            			alert(data.message);
            		}
            		else {
            			alert('알수없는 에러');
            		}
	            	
	            }
	        },
	        error : function(request, status, error){
	            console.log('responseText::::::::::::::::::::::::'+request.responseText);
	        },
	        complete:function(){}
	    });
	}

	
	$(document).ready(function() {
	    $(".rating .star").on("click", function() {
	        const clickedValue = parseInt($(this).data("value"));
	        const ratingBox = $(this).closest(".rating");
	        const id = ratingBox.data("id");

	        // 값 저장
	        $("#rate-" + id).val(clickedValue);

	        // 시각적 업데이트
	        ratingBox.find(".star").each(function(index) {
	            if (index < clickedValue) {
	                $(this).addClass("active").text("★");
	            } else {
	                $(this).removeClass("active").text("☆");
	            }
	        });
	    });
	});
	 function toggleReviewForm(id) {
		    $(".review-form").not("#reviewForm-" + id).slideUp(); // 다른 폼 닫기
		    $("#reviewForm-" + id).slideToggle(); // 클릭한 폼 토글
		  }
	 function showEditForm(id) {
		 $(".review-form").not("#editForm-" + id).slideUp();
		 $("#editForm-" + id).slideToggle(); 
		}

</script>

</head>
<body>
<jsp:include page="./include/header.jsp"/>

<div class="wrapper">
	<!-- ✅ 리뷰가 있는 공연 -->
	<h2 class="section-title">✅ 리뷰 작성 완료된 공연</h2>
	<c:forEach var="pastBook" items="${pastBook}">
		<c:if test="${not empty pastBook.review_id}">
			<div class="concert-box">
				<!-- 공연 정보 공통 -->
				<h3>${pastBook.title}</h3>
				<div class="concert-header">
					<div class="concert-info">
						<p>
							<strong>공연 번호:</strong> ${pastBook.id} 
						</p>
						<p>
							<strong>홀 타입:</strong>
							<c:if test="${pastBook.hallType eq 0}">가우디우홀</c:if>
							<c:if test="${pastBook.hallType eq 1}">펠리체홀</c:if>
						</p>
						<p>
							<strong>장르 타입: <c:if test="${pastBook.categoryId eq 1}">클래식</c:if>
								<c:if test="${pastBook.categoryId eq 2}">뮤지컬</c:if> <c:if
									test="${pastBook.categoryId eq 3}">재즈</c:if> <c:if
									test="${pastBook.categoryId eq 4}">대중음악</c:if> <c:if
									test="${pastBook.categoryId eq 5}">연극</c:if> <c:if
									test="${pastBook.categoryId eq 6}">무용</c:if> <c:if
									test="${pastBook.categoryId eq 7}">기타</c:if></strong>

						</p>
						<p>
							<strong>좌석 번호:</strong> ${pastBook.seatNum}
						</p>
						<p>
							<strong>예매 일자:</strong>
							<fmt:formatDate value="${pastBook.orderDate}"
								pattern="yyyy-MM-dd" />
						</p>
						<p>
							<strong>공연 일시:</strong>
							<fmt:formatDate value="${pastBook.concertTime}"
								pattern="yyyy-MM-dd HH:mm" />
						</p>
					</div>
				</div>

				<!-- 작성된 리뷰 출력 -->
				<div class="review-view" id="reviewView-${pastBook.id}">
					<p>
						<strong>내 리뷰:</strong> ${pastBook.content}
					</p>
					<p>
						<strong>내 별점:</strong>
						<c:forEach var="i" begin="1" end="5">
							<span class="star<c:if test='${i <= pastBook.rate}'> active</c:if>" style="font-size: 24px;">
							<c:choose>
								<c:when test="${i <= pastBook.rate}">★</c:when>
								<c:otherwise>☆</c:otherwise>
							</c:choose>
							</span>
							<%-- <c:choose>
								<c:when test="${i <= pastBook.rate}">★</c:when>
								<c:otherwise>☆</c:otherwise>
							</c:choose> --%>
						</c:forEach>
					</p>
					<button class="review-btn" onclick="showEditForm(${pastBook.id})">✏
						수정</button>
					<button class="review-btn"
						onclick="location.href='/deleteReivew/${pastBook.review_id}'">🗑
						삭제</button>
				</div>

				<div class="review-form" id="editForm-${pastBook.id}"
					style="display: none;">
					<input type="hidden" name="bookId" value="${pastBook.id}" /> <input
						type="hidden" name="concertId" value="${pastBook.concertId}" /> <input
						type="hidden" name="reviewId" value="${pastBook.review_id}" /> <input
						type="hidden" name="rate" id="edit-rate-${pastBook.id}"
						value="${pastBook.rate}" />
					<button type="button" class="review-save-btn"
						onclick="updateReview(${pastBook.id})">수정 완료</button>

					<div class="rating" data-id="${pastBook.id}">
						<span class="star" data-value="1"
							onclick="selectEditRate(${pastBook.id},1)">☆</span> <span
							class="star" data-value="2"
							onclick="selectEditRate(${pastBook.id},2)">☆</span> <span
							class="star" data-value="3"
							onclick="selectEditRate(${pastBook.id},3)">☆</span> <span
							class="star" data-value="4"
							onclick="selectEditRate(${pastBook.id},4)">☆</span> <span
							class="star" data-value="5"
							onclick="selectEditRate(${pastBook.id},5)">☆</span>
					</div>
					<br />
					<textarea name="content" placeholder="리뷰 수정">${pastBook.content}</textarea>
				</div>
			</div>
		</c:if>
	</c:forEach>

	<hr
		style="margin: 40px 0; border: none; border-top: 2px dashed #CDAA39;" />

	<!-- ❗ 리뷰가 없는 공연 -->
	<h2 class="section-title">📝 리뷰 쓰기 전인 공연</h2>
	<c:forEach var="pastBook" items="${pastBook}">
		<c:if test="${empty pastBook.review_id}">
			<div class="concert-box">
				<!-- 공연 정보 공통 -->
				<h3>${pastBook.title}</h3>
				<div class="concert-header">
					<div class="concert-info">
						<p>
							<strong>공연 번호:</strong> ${pastBook.id}
						</p>
						<p>
							<strong>홀 타입:</strong>
							<c:if test="${pastBook.hallType eq 0}">가우디우홀</c:if>
							<c:if test="${pastBook.hallType eq 1}">펠리체홀</c:if>
						</p>
						<p>
							<strong>장르 타입: <c:if test="${pastBook.categoryId eq 1}">클래식</c:if>
								<c:if test="${pastBook.categoryId eq 2}">뮤지컬</c:if> <c:if
									test="${pastBook.categoryId eq 3}">재즈</c:if> <c:if
									test="${pastBook.categoryId eq 4}">대중음악</c:if> <c:if
									test="${pastBook.categoryId eq 5}">연극</c:if> <c:if
									test="${pastBook.categoryId eq 6}">무용</c:if> <c:if
									test="${pastBook.categoryId eq 7}">기타</c:if></strong>

						</p>
						<p>
							<strong>좌석 번호:</strong> ${pastBook.seatNum}
						</p>
						<p>
							<strong>예매 일자:</strong>
							<fmt:formatDate value="${pastBook.orderDate}"
								pattern="yyyy-MM-dd" />
						</p>
						<p>
							<strong>공연 일시:</strong>
							<fmt:formatDate value="${pastBook.concertTime}"
								pattern="yyyy-MM-dd HH:mm" />
						</p>
					</div>
				</div>

				<button class="review-btn"
					onclick="toggleReviewForm(${pastBook.id})">🖋 리뷰쓰기</button>

				<div class="review-form" id="reviewForm-${pastBook.id}">
					<form action="" method="post">
						<input type="hidden" name="bookId" value="${pastBook.id}" /> <input
							type="hidden" name="concertId" value="${pastBook.concertId}" />
						<input type="hidden" name="rate" id="rate-${pastBook.id}"
							value="0" />
						<button type="button" class="review-save-btn"
							onclick="reviewInsert(${pastBook.id})">리뷰저장</button>

						<div class="rating" data-id="${pastBook.id}">
							<span class="star" data-value="1"
								onclick="selectrate(${pastBook.id},1)">☆</span> <span
								class="star" data-value="2"
								onclick="selectrate(${pastBook.id},2)">☆</span> <span
								class="star" data-value="3"
								onclick="selectrate(${pastBook.id},3)">☆</span> <span
								class="star" data-value="4"
								onclick="selectrate(${pastBook.id},4)">☆</span> <span
								class="star" data-value="5"
								onclick="selectrate(${pastBook.id},5)">☆</span>
						</div>

						<br />
						<textarea name="content" placeholder="리뷰를 입력하세요..."></textarea>

					</form>
				</div>

			</div>
		</c:if>
	</c:forEach>
<jsp:include page="./include/footer.jsp"/>
</div>
</body>
</html>

