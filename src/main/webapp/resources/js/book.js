window.onload = () => {
	
	changeTime();
	
	seatPrice = {
		    VIP: parseInt(document.getElementById("seatPrice").getAttribute("data-vip")),
		    R: parseInt(document.getElementById("seatPrice").getAttribute("data-r")),
		    S: parseInt(document.getElementById("seatPrice").getAttribute("data-s")),
		    A: parseInt(document.getElementById("seatPrice").getAttribute("data-a")),
		    equal: parseInt(document.getElementById("seatPrice").getAttribute("data-equal"))
	};
	// console.log(seatPrice);
	
};

function changeTime() {
	const selectedTimeId = document.getElementById("pickTime").value; // 선택된 공연 시간을 가져옴
	$(`input[name=conTimeId]`).prop("value", selectedTimeId);
    $.ajax({
    	url: "/getBookedSeats?conTimeId=" + selectedTimeId,  // 컨트롤러 요청 주소
      	method: "GET",
      	//data: {
    	//	conTimeId: selectedTimeId
		//},  // 선택된 공연 시간 전달
       	success: function(response) {
       		$(`input[class=checkbox]`).prop("checked", false); // 색상 테스트 후 false로
       		$(`input[class=checkbox]`).prop("disabled", false);
       		// console.log(response);
        	response.bookedSeats.forEach(function(seat) {
        		// console.log(seat);
        		$(`input[name=` + seat + `]`).prop("disabled", true);
        	});
        	response.allSeats.forEach(function(seat) {
        		const lineNum = seat.lineNum;
        		const seatNum = String(seat.seatNum).padStart(2, '0');
        		const seatName = lineNum + seatNum;
        		// console.log(seatName);
        		$(`input[name=` + seatName + `]`).prop("value", seat.grade);
        		// console.log($(`input[name=` + seatName + `]`).val());
        	});
			checkSeat();
		},
    	error: function(xhr, status, error) {
    		console.error("AJAX 요청 실패:", status, error);
    	}
	});
	// const time = $(`#pickTime option:selected`).attr("data-time");
	const time = $(`#pickTime option:selected`).text();
	// console.log(time);
	$(`input[name=selectedTime]`).prop("value", time);
}

function checkSeat() {
	let selectedSeats = [];
    $("input.checkbox:checked").each(function() {
        selectedSeats.push($(this).attr("name"));
    });
    let cnt = selectedSeats.length > 0 ? "  총 " + selectedSeats.length + "석" : "";
    $("#seatsCount").html(cnt);
    let seatText = selectedSeats.length > 0 ? selectedSeats.join(", ") : "좌석을 선택해 주세요";
    $("#pickedSeats").html(seatText);
	$("input[name=selectedSeats]").prop("value", seatText);
	
	submitChange(totalPrice());
}

function totalPrice() {
	let totalPrice = 0;
	// console.log(seatPrice);
	if (0 == seatPrice.equal) {
		$("input.checkbox:checked").each(function() {
			const seatGrade = $(this).val();
			if (seatGrade === 'VIP') {
				totalPrice += seatPrice.VIP;
			} else if (seatGrade === 'R') {
				totalPrice += seatPrice.R;
			} else if (seatGrade === 'S') {
				totalPrice += seatPrice.S;
			} else if (seatGrade === 'A') {
				totalPrice += seatPrice.A;
			}
		});
	} else {
		totalPrice = $("input.seat:checked").length * seatPrice.equal;
	}
	// console.log('totalPrice: ' + totalPrice + '원');
	$("#totalPrice").html(totalPrice + '원');
	$("#totalPrice").prop("value", totalPrice);
	
	return totalPrice;
}

function submitChange(totalPrice) {
	$("input[name=totalPrice]").prop("value", totalPrice);
	if (0 < totalPrice) {
		$("#goToPay").prop("disabled", false);
	} else {
		$("#goToPay").prop("disabled", true);
	}
}

