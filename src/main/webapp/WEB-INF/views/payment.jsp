<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 결제</title>

<style type="text/css">
	.main {
		display: flex;
		flex-direction: column;
		justify-content: center;
		align-items: center;
	}
	.box {
		border: 1px solid black;
		width: 900px;
		font-weight: bold;
		padding: 10px;
		margin: 10px;
		border-radius: 10px;
		background-color: #FCFCFC;
		box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
	}
	.subTitle {
		width: 900px;
		margin-bottom: 10px;
		display: flex;
		justify-content: center;
		align-items: center;
		border-radius: 5px;
		background-color: #78171C;
		color: white;
		height: 30px;
	}
	.mg-left {
		margin-left: 10px;
	}
	.text-gray {
		font-weight: normal;
		color: gray;
		font-size: 14px;
	}
	#discount {
		width: 100%;
		height: 25px;
		text-align: center;
	}
	.price {
		text-align: right;
		padding-right: 10px;
	}
	.tableTitle {
		padding-left: 10px;
		text-align: left;
		width: 160px;
	}
	.button {
		width: 50%;
		height: 50px;
		border-radius: 5px;
		font-weight: bold;
		font-size: 18px;
		border: 0;
		color: white;
		background-color: #78171C;
		cursor: pointer;
		transition: all 0.3s ease-in-out;
	}
	.pay {
		 background-color: #CDAA39;
	}
	.pay:hover {
		width:100%;
		height:52px;
	}
	.creditCardBox {
		border: 1px solid black;
		border-radius: 5px;
		height: 200px;
		margin: 10px 10px;
		padding: 20px;
		background-color: #DEDEDE;
		display: flex;
		flex-wrap: nowrap;
		overflow-x: auto;
		overflow-y: hidden;
		white-space: nowrap;
		justify-content: left;
		align-items: center;
	}
	.creditCard {
		border: 1px solid black;
		border-radius: 10px;
		width: 240px;
		height: 160px;
		background-color: white;
		box-shadow: 2px 2px 8px rgba(0, 0, 0, 0.2);
		justify-content: center; /* 수평 중앙 정렬 */
		align-items: center;
		display:flex;
		flex-shrink: 0;
		text-align: center;
	}
	#radioCard, #radioRemit {
		display: none;
	}
</style>

<script type="text/javascript">
	window.onload = () => {
		changeDiscount();
		changePayType();
	};
	
	// 할인 선택시 실행 될 함수
	function changeDiscount() {
	    let discountRate = document.getElementById("discount").value;
	    let totalPriceElement = document.getElementById("totalPrice");
	    let discPriceElement = document.getElementById("discPrice");
	    let originalPrice = parseInt(totalPriceElement.getAttribute("data-original"));
	    let infoDisc = document.getElementById("infoDisc");
	    let discTitle = document.getElementById("discTitle");
	    let discPrice = document.getElementById("discPrice");
	    
	    if (discountRate == "0") {
	        infoDisc.style.display = "none";
	        discTitle.style.display = "none";
	        discPrice.style.display = "none";
	        
	    } else {
	        infoDisc.style.display = "block";
	        discTitle.style.display = "table-cell";
	        discPrice.style.display = "table-cell";
	    }
	    
	    let discountedPrice = originalPrice * (1 - discountRate / 100);
	    let discountPrice = originalPrice - discountedPrice;
	    
	    discPriceElement.innerHTML = "- " + discountPrice.toLocaleString() + "원";
	    totalPriceElement.innerHTML = discountedPrice.toLocaleString() + "원";
	    
	    document.getElementById("actionPrice").value = discountedPrice;
	}
	
	// 결제 수단 선택시 열릴 메뉴
	function changePayType() {
	    let radioCard = document.getElementById("radioCard"); // 신용카드 정보 영역
	    let radioRemit = document.getElementById("radioRemit"); // 무통장입금 정보 영역
		let actionPayType = document.getElementById("actionPayType");
	    // 현재 선택된 결제 수단 가져오기
	    let selectedPayment = document.querySelector('input[name="payType"]:checked');

	    if (selectedPayment) {
	        if (selectedPayment.value === "0") {
	            radioCard.style.display = "flex";
	            radioRemit.style.display = "none";
	        } else if (selectedPayment.value === "1") {
	            radioCard.style.display = "none";
	            radioRemit.style.display = "block";
	        }
	    	document.getElementById("actionPayType").value = selectedPayment.value;
	    }
	}
	
	// 선택한 카드 id 넘기기
	function selectCardId(cardId) {
		document.getElementById("actionCardId").value = cardId;
	}
	
	function submitAction() {
		const payType = document.getElementById("actionPayType").value;
		const cardId = document.getElementById("actionCardId").value;
		
		if('0' != payType && '1' != payType ) {
			alert('결제 수단을 선택하세요')
			return false;
		} else if ('0' === payType && null === cardId
				|| '0' === payType && '' === cardId) {
			alert('결제할 카드를 선택하세요')
			return false;
		}
		
		return true;
	}
	
</script>

</head>
<body>

<fmt:formatDate value="${selTime}" pattern="yyyy년 MM월 dd일" var="selectDate"/>
<fmt:formatDate value="${selTime}" pattern="HH시mm분" var="selectTime"/>

<form action="/bookOK" method="post" onsubmit="return submitAction()">
	<div class="main">
		<!-- 공연 및 예매정보 표시 -->
		<div class="box">
			<div class="subTitle">
				예매 정보
			</div>
			<div class="mg-left" style="display: flex;">
				<div>
					<img src="${concertVO.posterUrl}" height="200" style="margin-right: 30px;"/>
				</div>
				<div>
					<h2>${concertVO.title}</h2>
					${selectDate}<br/><br/>
					${selectTime}<br/><br/>
					${selectedSeats}<br/>
				</div>
			</div>
		</div>
		
		<!-- 할인 선택 -->
		<div class="box">
			<div class="subTitle">
				할인 선택
			</div>
			<div class="mg-left">
				<div style="margin-right: 10px;"><br/>
					<select id="discount" onchange="changeDiscount()">
						<option value="0" selected="selected">해당 없음</option>
						<option value="40">청소년 할인 40%</option>
						<option value="40">장애인 할인 40%</option>
						<option value="60">국가 유공자 할인 60%</option>
					</select>
					<br/><br/>
					<div id="infoDisc" class="text-gray" style="border:1px solid black; border-radius: 10px; margin-bottom: 10px;">
						<ul>
							<li>할인 대상자는 반드시 해당 증빙 서류를 지참해야 하며, 미지참 시 할인 적용이 불가능합니다.</li>
							<li>하나의 예매 건당 중복 할인은 적용되지 않습니다.</li>
							<li>청소년 할인은 나이를 확인할 수 있는 학생증 또는 신분증 제시가 필수입니다.</li>
							<li>장애인 및 국가유공자 할인은 관련 증빙 서류 확인 후 적용됩니다.</li>
							<li>기타 할인 혜택은 공연장 정책에 따라 변경될 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 결제 수단 -->
		<div class="box">
			<div class="subTitle">
				결제 수단
			</div>
			<div class="mg-left" style="font-weight: normal;">
				<input type="radio" name="payType" onchange="changePayType()" value="0"/> 신용카드
				<input type="radio" name="payType" onchange="changePayType()" value="1"/> 무통장입금
				<div id="radioCard" class="creditCardBox payType">
					<c:forEach items="${cardList}" var="card">
						<div class="creditCard">
							<input type="radio" name="selectedCard" value="${card.id}" id="card${status.index}" onchange="selectCardId(this.value)"/>
							<label for="card${status.index}">
								${fn:substring(card.cardNum, 0, 4)} **** **** ****
							</label>
						</div>&nbsp;&nbsp;
					</c:forEach>
					<a class="creditCard">
						+ 카드 추가 하기
					</a>
				</div>
				<div id="radioRemit" class="text-gray payType mg-left" style="border:1px solid black; border-radius: 5px; margin: 10px; padding: 5px;">
					<ul>
						<li>무통장 입금 예매시 '결제하기 버튼 클릭' 이후 30분 내로 지정 계좌로 입금 확인이 되지 않을 시 예약이 취소됩니다.</li>
						<li>입금 시, 예약자명과 동일한 이름으로 입금해 주셔야 정확한 입금 확인이 가능합니다.</li>
						<li>입금자명이 다를 경우, 고객센터에 문의해 주시기 바랍니다.</li>
						<li>부분 입금이 있을 경우, 결제가 완료되지 않은 것으로 처리되며, 전체 금액이 입금된 후 예약이 확정됩니다.</li>
						<li>입금 후, 예약이 완료되면 별도의 확인 문자가 발송되며, 영업일 기준으로 [1~2일] 소요될 수 있습니다.</li>
						<li>입금 전 반드시 제공된 계좌번호와 예금주명을 정확히 확인해 주세요.</li>
					</ul>
				</div>
			</div><br/>
		</div>
		
		<!-- 결제 정보 -->
		<div class="box">
			<div class="subTitle">
				결제 금액
			</div>
			<table style="width:800px; margin-left: 50px;">
				<tr>
					<td class="tableTitle">&nbsp;총 금액</td>
					<td class="price"><fmt:formatNumber value="${totalPrice}" pattern="#,##0"/>원</td>
				</tr>
				<tr>
					<td id="discTitle" class="tableTitle" style="display: none;">&nbsp;할인 금액</td>
					<td id="discPrice" class="price" style="display: none;"></td>
				</tr>
				<tr>
					<td colspan="2"><hr/></td>
				</tr>
				<tr>
					<td class="tableTitle"><h2>결제 금액</h2></td>
					<td class="price"><h2 id="totalPrice" data-original="${totalPrice}"></h2></td>
				</tr>
			</table>
		</div>
		
		<input type="hidden" name="conTimeId" value="${conTimeId}"/>
		<input type="hidden" name="concertId" value="${concertVO.id}"/>
		<input type="hidden" name="actionCardId" id="actionCardId"/>
		<input type="hidden" name="price" id="actionPrice"/>
		<input type="hidden" name="selectedSeats" value="${selectedSeats}"/>
		<input type="hidden" name="selTime" value="${selTime}"/>
		<input type="hidden" name="actionPayType" id="actionPayType"/>
		
		<div style="display: flex; border: none; padding: 0; margin: 10px 0px 20px; width: 910px;">
			<input class="button" type="button" value="뒤로가기" onclick="history.back()"/>&nbsp;
			<input class="button pay" type="submit" value="결제하기" onclick="bookNow()"/>
		</div>
	</div>
</form>

</body>
</html>