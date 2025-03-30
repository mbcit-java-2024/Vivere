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
.concert-box {
	border: 1px solid #ccc;
	border-radius: 10px;
	padding: 15px;
	margin-bottom: 20px;
	background-color: #f9f9f9;
}

.concert-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.concert-info {
	font-size: 14px;
	line-height: 1.6;
}

.review-btn {
	background-color: #e0e0e0;
	border: none;
	padding: 5px 10px;
	cursor: pointer;
	border-radius: 5px;
}

.review-form {
	display: none;
	margin-top: 10px;
}

textarea {
	width: 100%;
	height: 60px;
	padding: 8px;
	border-radius: 5px;
	border: 1px solid #ccc;
	resize: none;
}

.review-save-btn {
	margin-top: 5px;
	float: right;
}

.rating {
	font-size: 24px;
	color: #ccc;
	cursor: pointer;
	user-select: none;
}

.rating .star.active {
	color: gold;
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
	    
	    let textarea = $("#reviewForm-"+id).find("textarea[name='content']").val();
	    console.log('reviewInsert:::::::::::::::::::::::textarea::::::'+textarea);
	    let concertId = $("#reviewForm-"+id).find("input[name='concertId']").val();
	    console.log('reviewInsert:::::::::::::::::::::::concertId::::::'+concertId);
	    let bookId = $("#reviewForm-"+id).find("input[name='bookId']").val();
	    console.log('reviewInsert:::::::::::::::::::::::bookId::::::'+bookId);
	    let rate = $("#reviewForm-" + id).find("input[name='rate']").val();
	    console.log('reviewInsert::::::::::::::rate:::::::' + rate);
	    
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
	            	 // location.href = '/orderOKPage?orderIds=' + data.orderIds;
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
</script>

</head>
<body>
	<c:forEach var="pastBook" items="${pastBook}">
		<h2>${pastBook.title }</h2>
		<div class="concert-box">
			<div class="concert-header">
				<div class="concert-info">
					<div class="concert-info">${pastBook.posterUrl }</div>

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
						<fmt:formatDate value="${pastBook.orderDate}" pattern="yyyy-MM-dd" />
					</p>
					<p>
						<strong>공연 일시:</strong>
						<fmt:formatDate value="${pastBook.concertTime}"
							pattern="yyyy-MM-dd HH:mm" />
					</p>

				</div>
			</div>


			<c:choose>
				<c:when test="${not empty pastBook.content}">
					<div class="review-view" id="reviewView-${pastBook.id}">
						<p>
							<strong>내 리뷰:</strong> <span id="reviewContent-${pastBook.id}">${pastBook.content}</span>
						</p>
						<p>
							<strong>내 별점:</strong> <span id="reviewStars-${pastBook.id}">
								<c:forEach var="i" begin="1" end="5">
									<c:choose>
										<c:when test="${i <= pastBook.rate}">★</c:when>
										<c:otherwise>☆</c:otherwise>
									</c:choose>
								</c:forEach>
							</span>
						</p>
						<div>
							<button class="review-btn" onclick="showEditForm(${pastBook.id})">✏️
								수정</button>
							<button class="review-btn" onclick="location.href='/deleteReivew/${pastBook.review_id}'">🗑
								삭제</button>
						</div>
					</div>

					<!-- ✅ 수정 폼 (기존 review-form 복사해서 항상 숨김 처리) -->
					<div class="review-form" id="editForm-${pastBook.id}"
						style="display: none;">
						<input type="hidden" name="bookId" value="${pastBook.id}" /> 
						<input
							type="hidden" name="concertId" value="${pastBook.concertId}" />
						<input
							type="hidden" name="reviewId" value="${pastBook.review_id}" />
						<input type="text" name="rate" id="edit-rate-${pastBook.id}"
							value="${pastBook.rate}" />

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
						<button type="button" class="review-save-btn"
							onclick="updateReview(${pastBook.id})">수정 완료</button>
					</div>

				</c:when>
				<c:otherwise>
					<button class="review-btn"
						onclick="toggleReviewForm(${pastBook.id})">🖋 리뷰쓰기</button>

					<div class="review-form" id="reviewForm-${pastBook.id}">
						<form action="" method="">
							<input type="hidden" name="bookId" value="${pastBook.id}" /> <input
								type="hidden" name="concertId" value="${pastBook.concertId}" />
							<input type="text" name="rate" id="rate-${pastBook.id}" value="0" />

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
							<button type="button" class="review-save-btn"
								onclick="reviewInsert(${pastBook.id})">리뷰저장</button>
						</form>
					</div>
				</c:otherwise>
			</c:choose>



		</div>
	</c:forEach>


	<script>
	 function toggleReviewForm(id) {
		    $(".review-form").not("#reviewForm-" + id).slideUp(); // 다른 폼 닫기
		    $("#reviewForm-" + id).slideToggle(); // 클릭한 폼 토글
		  }
	 function showEditForm(id) {
		  $("#reviewView-" + id).hide();
		  $("#editForm-" + id).slideDown();
		}

	</script>
</body>
</html>

