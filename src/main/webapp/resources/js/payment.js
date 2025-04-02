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