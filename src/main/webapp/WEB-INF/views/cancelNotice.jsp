<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 자주하는질문</title>

<style>
.faq-item {
    border: 1px solid #ddd;
    margin-bottom: 10px;
    padding: 10px;
    padding-top: 20px;
    border-radius: 5px;
    cursor: pointer;
    background-color: white;
    width: 1000px;
}
.faq-answer {
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.2s ease-in-out, padding 0.3s ease-in-out;
    margin: 5px;
    padding: 0 10px;
}
.contents {
	margin: 0px auto 50px;
}
strong {
	margin-left: 5px;
}
#consumerFAQ {
	margin: 50px 0px 30px;
	font-size: 28px; 
	font-weight: bold;
	text-align: left;
}
</style>
    
<script>

    function toggleAnswer(id) {
        var answers = document.querySelectorAll('.faq-answer');

        answers.forEach(answer => {
            if (answer.id === id) {
                if (answer.style.maxHeight === "0px" || answer.style.maxHeight === "") {
                    answer.style.maxHeight = answer.scrollHeight + "px";
                } else {
                    answer.style.maxHeight = "0px";
                }
            } else {
                answer.style.maxHeight = "0px";
            }
        });
    }
</script>
	
</head>
<body>
	<div class="wrapper">
	<jsp:include page="./include/header.jsp"/>
		<div class="body-main contents">
			<!-- 제목글 -->
			<div id="consumerFAQ">&nbsp;&nbsp;자주하는질문 (FAQ)</div>
			<div class="faq-item" onclick="toggleAnswer('faq1')">
			    <strong>Q. 예매한 티켓의 부분 취소가 가능한가요?</strong>
			    <div id="faq1" class="faq-answer">
			        &nbsp;&nbsp;&nbsp;아쉽게도 부분 취소는 불가능합니다.<br/>
					&nbsp;&nbsp;&nbsp;예매하신 티켓을 취소하실 경우, 전체 예매 건에 대해 취소만 가능합니다.<br/>
					&nbsp;&nbsp;&nbsp;※ 좌석 일부만 선택적으로 취소하실 수 없습니다.
			    </div>
			</div>
			
			<div class="faq-item" onclick="toggleAnswer('faq2')">
			    <strong>Q. 티켓 환불은 어떻게 되나요?</strong>
			    <div id="faq2" class="faq-answer">
			        &nbsp;&nbsp;&nbsp;티켓 환불은 아래 환불 규정에 따라 처리됩니다.
			        <ul>
			        	<li>예매 후 7일 이내 & 공연 10일 전까지	전액 환불 (수수료 없음)</li>
			        	<li>공연 9일 ~ 3일 전까지 티켓 금액의 10% 공제</li>
			        	<li>공연 2일 ~ 1일 전까지 티켓 금액의 20% 공제</li>
			        	<li>공연 당일 환불 불가</li>
			        </ul>
			        &nbsp;&nbsp;&nbsp;※ 예매일 기준 7일 이내라도 공연 3일 전 이내일 경우 수수료가 부과됩니다.<br/>
					&nbsp;&nbsp;&nbsp;※ 공연 시작 이후에는 환불이 불가합니다.<br/>
			    </div>
			</div>
			
			<div class="faq-item" onclick="toggleAnswer('faq3')">
			    <strong>Q. 예매 취소는 어디서 하나요?</strong>
			    <div id="faq3" class="faq-answer">
			        &nbsp;&nbsp;&nbsp;[마이페이지 > 예매내역]에서 직접 취소하실 수 있습니다.<br/>
					&nbsp;&nbsp;&nbsp;또는 고객센터(1588-1234)로 문의해 주세요.<br/>
					&nbsp;&nbsp;&nbsp;※ 운영시간: 평일 오전 9시 ~ 오후 6시
			    </div>
			</div>
			
			<div class="faq-item" onclick="toggleAnswer('faq4')">
			    <strong>Q. 예매한 티켓을 다른 사람에게 양도할 수 있나요?</strong>
			    <div id="faq4" class="faq-answer">
			        &nbsp;&nbsp;&nbsp;티켓 양도는 원칙적으로 불가능합니다.<br/>
					&nbsp;&nbsp;&nbsp;다만, 실물 티켓 수령 후 타인에게 전달하는 것은 공연장 정책에 따라 가능할 수 있습니다.<br/>
					&nbsp;&nbsp;&nbsp;※ 일부 공연은 본인 확인이 필요할 수 있으므로 주의해 주세요.
			    </div>
			</div>
			
			<div id="sellerFAQ" class="faq-item" onclick="toggleAnswer('faq5')">
			    <strong>Q. 티켓을 분실했어요. 재발급이 가능한가요?</strong>
			    <div id="faq5" class="faq-answer">
			        &nbsp;&nbsp;&nbsp;실물 티켓은 분실 시 재발급이 불가능합니다.<br/>
					&nbsp;&nbsp;&nbsp;모바일 티켓을 이용하거나, 마이페이지에서 PDF 티켓을 출력해 주세요.<br/>
					&nbsp;&nbsp;&nbsp;※ 실물 티켓을 사용해야 하는 공연의 경우, 고객센터로 문의 바랍니다.
			    </div>
			</div>
		</div>
		<jsp:include page="./include/footer.jsp"/>
	</div>
</body>
</html>