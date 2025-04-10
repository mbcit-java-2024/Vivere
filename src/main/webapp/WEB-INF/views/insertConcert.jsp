<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공연 등록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/js/bootstrap.bundle.min.js"></script>

<%
	// 현재 날짜와 시간을 "yyyy-MM-dd'T'HH:mm" 형식으로 구함
	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
	java.text.SimpleDateFormat sdf1 = new java.text.SimpleDateFormat("yyyy-MM-dd");
	java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("HH:mm");
	String now = sdf.format(new java.util.Date());
	String nowDate = sdf1.format(new java.util.Date());
	String nowTime = sdf2.format(new java.util.Date());
%>
<script>

let selectedSeats = {vip: [], r: [], s: [], a: []};
let selectedHall = ""; // 선택된 공연장 (gaudium, felice)
let maxValues = {0: 480, 1: 210};
let maxValue;

/* 체크박스 검증 함수 : 좌석 체크박스가 생성/바뀔 때마다 실행함 */
// 인수: 해당 체크박스의 value, 체크인지 해제인지 알려주는 boolean, 해당 체크박스의 seatType 
function handleSeatSelection(seatName, isChecked, seatType) {
	// 체크인 경우(isChecked == true): selectedSeats[seatType] 에 seatName을 추가한다.
	if (isChecked) {
		console.log("1. selectedSeats["+seatType+"]: "+ selectedSeats[seatType])
	    if (!selectedSeats[seatType].includes(seatName)) {
	        selectedSeats[seatType].push(seatName); // 중복 방지 후 추가
	    }
		console.log("2. selectedSeats["+seatType+"]: "+ selectedSeats[seatType])
	// 나머지 type의 체크박스(가 있는지 확인하고 있다면) 중 해당 value 를 disable 한다.
	 for (let type in selectedSeats) {
		 if (type !== seatType) {
			// $("input[value='" + seatName + "']").prop("disabled", true);
			$("input.seat." + type + "[value='" + seatName + "']").prop("disabled", true);
		 }
	 }
	// 해제인 경우(else (isChecked == false)): selectedSeats[해당type] 에서 해당 value를 제거한다.
	} else {
		console.log("1. selectedSeats["+seatType+"]: "+ selectedSeats[seatType])
		selectedSeats[seatType] = selectedSeats[seatType].filter(seat => seat !== seatName);
		console.log("2. selectedSeats["+seatType+"]: "+ selectedSeats[seatType])
	// 나머지 type의 체크박스(가 있는지 확인하고 있다면 모든 체크박스) 중 해당 value disable을 해제한다.
		for (let type in selectedSeats) {
			if (selectedSeats[type].includes(seatName)) {
	                return; // 다른 등급에서 이미 선택한 경우 disable 유지
	        }
			$("input[value='" + seatName + "']").prop("disabled", false);
		}
	}
// 선택된 좌석의 개수를 실시간으로 반영 
// (selectedSeats[type].length를 input[type=number][data-type=type]의 value로 설정)
	for (let seatType in selectedSeats){
		$("input.seatCount[data-type="+seatType+"]").val(selectedSeats[seatType]?.length || 0);
	}
}

/* ====================== 등급별 좌석 번호 선택 ======================== */
$(document).ready(function () {
    /* 좌석 체크박스(input[type=checkbox].seat)가 바뀔때마다 체크박스 검증함수 실행 */
    $(document).on('change', 'input[type="checkbox"].seat', function(){
    	// 해당 체크박스의 value 값 가져오기
    	const seatName = $(this).val(); // 좌석 이름 예: A01, A02 등
    	// 해당 체크박스의 seatType 값 가져오기
    	const seatType = $(this).attr('class').split(' ')[1]; // vip, r, s, a 등
    	// 체크박스의 변화 값 가져오기 
    	const isChecked = $(this).prop('checked'); // 체크 상태
    	
    	console.log("seatType: "+ seatType + ", seatName: "+ seatName + ", isChecked: "+ isChecked)
    	handleSeatSelection(seatName, isChecked, seatType);
    });
    
	/* =============== 공연장 선택 감지: 결과를 selectHall 변수에 넣어준다. ============= */
	 $("input[name='hallType']").change(function () {
     	selectedHall = $(this).val() === "0" ? "gaudium" : "felice";
     	let selectedValue = $(this).val(); // 선택된 라디오 버튼 값
        maxValue = maxValues[selectedValue]; // 해당 좌석 등급의 최대값 가져오기
        $(".seatCount").attr("max", maxValue); // max 값 변경
		console.log('selectedHall: '+selectedHall);
        // 공연장 변경시 기존에 선택된 좌석들 초기화
        	for (let seatType in selectedSeats){
        		selectedSeats[seatType] = [];
       	 }
	 });

    /* =========== 공연 좌석 등급설정 : class = "seatType" 인 input의 값이 바뀔때마다 실행 ========== */
    $(".seatType").change(function() {
        let seatType = $(this).val();
        
		/* =============== 공연장 선택 감지: 결과를 selectHall 변수에 넣어준다. ============= */
		 $("input[name='hallType']").change(function () {
		    selectedHall = $(this).val() === "0" ? "gaudium" : "felice";
	     	let selectedValue = $(this).val(); // 선택된 라디오 버튼 값
	        maxValue = maxValues[selectedValue]; // 해당 좌석 등급의 최대값 가져오기
	        $(".seatCount").attr("max", maxValue); // max 값 변경

			// selectedSeats 초기화
	        for (let seatType in selectedSeats){
	        	selectedSeats[seatType] = [];
	        }
	        
		    updateSeatSelectionUI();
		 });
		
        if (!seatType) {
            console.error("seatType 값이 비어 있습니다!");
            return;
        }

        // 'equal'이 선택된 경우, 다른 체크박스를 모두 해제 및 disable 
        if (seatType === "equal") {
            if ($(this).is(":checked")) {
                $(".seatType").not(this).prop("checked", false).prop("disabled", true);
                $("#seatContainer").empty().append("<div id='seat_equal'class=\"container mt-3\">"+
                		"<div class=\"d-flex align-items-center gap-3 mb-2\">"+
                		"<strong style=\"min-width: 60px;\">전좌석 동일가</strong>"+
			            "<div class=\"d-flex align-items-center\">"+ 
                		"<span class=\"me-2\">좌석 가격 </span>"+
                		"<input class='form-control' type='number' name='equalPrice' style=\"width: 100px;\" required> (원)</div></div></div>");
                $("#seatSelectionContainer").empty(); // 기존 '좌석선택' 제거
                for (let seatType in selectedSeats){
					console.log("1. selectedSeats["+seatType+"]: "+ selectedSeats[seatType])
                	selectedSeats[seatType] = [];
					console.log("2. selectedSeats["+seatType+"]: "+ selectedSeats[seatType])
                }
            } else {
                $(".seatType").prop("disabled", false);
                $("#seat_equal").remove();
            }
            return;
        }
        
        // 등급이 선택되면 '좌석등급' div 안에 좌석 개수와 가격을 입력받은 input 태그 등장
        // 좌석개수: <input type="number" name="vipCount" class="seatCount" data-type="vip">
        // 가격: <input type="number" name="vipPrice">
        let seatId = "seat_" + seatType;
        let countName = "count"+seatType.toUpperCase();
        let priceName = "price"+seatType.toUpperCase();
	
        
        if ($(this).is(":checked")) {
	        
            let seatForm = "<div id="+seatId+" class=\"container mt-3\">"+
            "<div class=\"d-flex align-items-center gap-3 mb-2\"><strong style=\"min-width: 60px;\">"+seatType.toUpperCase()+ "</strong>"+
            "<div class=\"d-flex align-items-center\">"+ 
            	"<span class=\"me-2\">좌석 개수 </span>"+
            	"<input id=\"sc\" type=\"number\" name="+ countName +" class=\"seatCount form-control\""+
            	"style=\"width: 100px;\" data-type=\""+seatType+"\" min=\"1\" max=\""+ maxValue+"\"required></div>"+
            "<div class=\"d-flex align-items-center\">"+ 
            	"<span class=\"me-2\">좌석 가격 </span>"+
           		"<input id=\"sp\" type=\"number\" name=\""+priceName+
           		"\" style=\"width: 100px;\" class=\"form-control\" required> (원)</div></div></div>";
            
            $("#seatContainer").append(seatForm);
            selectedSeats[seatType] = [];

		/*          
			let pick_seatDiv = $("<div>").attr("id", "pick_seat_"+seatType).attr("class", "divCard");
            pick_seatDiv.append("<span>"+seatType.toUpperCase()+"</span>");
		 */            
			let pick_seatDiv = "<div id=\"pick_seat_"+seatType+"\" class=\"divCard\"></div>";
 			$("#seatSelectionContainer").append(pick_seatDiv); // divCard를 추가
            updateSeatSelectionUI();
            
        } else {
            $("#" + seatId).remove();
            // selectedSeats 변동 사항에 따라 disable 된 체크박스 다시 활성화하기
			for (let seatName of selectedSeats[seatType]) {
				$("input[value='" + seatName + "']").prop("disabled", false);
			}            
            selectedSeats[seatType] = [];
			
            $("#pick_seat_" + seatType).remove();
            updateSeatSelectionUI();
        }

    /* ====================== 좌석 UI 업데이트: '좌석선택' 에 변화주기 =================================== */
	    function updateSeatSelectionUI() {
	        let container = $("#pick_seat_"+ seatType);
	        // console.log("#pick_seat_"+seatType+": "+container.length);
	        container.empty();
	
	        if (!selectedHall) {
	            container.append("<p>공연장을 선택하세요.</p>");
	            return;
	        }
	
	        // 공연장에 따라 출력할 레이아웃 생성 및 변수에 저장
	        let seatLayout = generateSeatLayout(selectedHall);
	        // console.log("seatLayout: "+ seatLayout.length);
	        
	        // 체크된 상태인 seatType 에 따라 각각 하나씩 추가
	        container.append(seatLayout);
	
	        // 선택된 좌석 개수만큼 자동 체크
	    /*     for (let seatType in selectedSeats) {
	            selectedSeats[seatType].forEach(seat => {
	                $(`input.seat[value='${seat}']`).prop("checked", true);
	            });
	        } */
	    }

    /* ===================================== 좌석 배치 생성 함수 =================================== */

	    function generateSeatLayout(hallType) {
	       // let divCard = $("<div>").addClass("divCard");
	        let divCard = $("#pick_seat_"+ seatType);
	       // console.log("generate pick_seat: " + divCard.length);
	        let pickSeat = $("<div>").attr("id", "pickSeat");
	        let rows, seatsPerRow, breakPoints;
			
	        // 홀타입별 행과 좌석수 초기화
	        if (hallType === "gaudium") {
	            rows = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T"];
	            seatsPerRow = 24;
	            breakPoints = [6, 18];
	        } else {
	            rows = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O"];
	            seatsPerRow = 14;
	            breakPoints = [7];
	        }
			
	        pickSeat.append("<div><p>"+seatType.toUpperCase()+"</p></div>");
	        // rows 에 저장된 객체 하나씩 반복하며 행 1줄 생성 실행. : for (String lineNume : rows)
	        rows.forEach((lineNum) => {
	            let rowDiv = $("<div>");
	            // 왼쪽 줄 번호
	            rowDiv.append($("<span>").addClass("lineNum clickable-span").text(lineNum).attr("id", seatType+"_"+lineNum)); 
				
	            // 체크박스 1줄 생성
	            for (let j = 1; j <= seatsPerRow; j++) {
	                let seatNum = j.toString().padStart(2, "0"); // 01, 02 형식
	                let seatName = lineNum + seatNum;
	               // console.log("forEach문 seatType: "+ seatType);
					
	               // 체크박스 1개 생성
	                let seatCheckbox = $("<input>", {
	                	id: seatType+"_"+seatName,
	                    type: "checkbox",
	                    class: lineNum + " "+ seatType + " seat",
	                    name: seatType+"Seats",
	                    value: seatName
/* 	                    change: function () {
	                    	// 좌석 체크박스가 체크/해제되면
	                        let a = $(this).attr("name"); // name 에 있는 것을 꺼내와라 = 좌석 등급
	                        let seatType = a.replace("Seats", ""); 
	                        handleSeatSelection(seatName, isChecked)
	                    }
 */	                }); // 체크박스 1개 생성완료
	                
					// 만약 value 가 selectedSeat[type]에 있으면 체크박스를 disable 시킨다.
					for (let type in selectedSeats) {
						if (selectedSeats[type].includes(seatName)) {
					        // selectedSeats에 이미 있으면 disabled 처리
					        seatCheckbox.prop("disabled", true); 
					    }
					}
	
	                // 행 div 에 체크박스를 넣는다.
	                rowDiv.append(seatCheckbox);
	
	                // 복도로 나뉜 열에 해당하면 행 div 에 체크박스 대신 공간을 넣는다.
	                if (breakPoints.includes(j)) {
	                    rowDiv.append("&nbsp;&nbsp;&nbsp;"); // 공간 추가
	                }
	            }// 체크박스 1줄 생성 for 반복문 끝
	            
	
	            rowDiv.append($("<span>").addClass("lineNum").text(lineNum)); // 오른쪽 줄 번호
	            rowDiv.append("<br/>"); // 줄바꿈
	
	            if (hallType === "gaudium" && lineNum === "J") {
	                rowDiv.append("<br/>"); // 특정 줄 이후 공간 추가
	            }
	
	            // 생성된 행 1개를 pickSeat div 에 넣기
	            pickSeat.append(rowDiv);
	        });
			
	        divCard.append(pickSeat);
	        return divCard;
	    }
   	});
    /* 끝 =========== 공연 좌석 등급설정 : class = "seatType" 인 input의 값이 바뀔때마다 실행 ========== */
   
 });
/* ============== 좌석 행 알파벳 클릭시 해당 행 전부 선택 ====================== */
$(document).on("click", "span.lineNum", function () {
    // span 태그 클릭 시
    	// console.log("span lineNum 클릭")
        // 클릭한 span 태그의 id 가져오기
        let seatTypeAndLineNum = $(this).attr("id").split("_"); // seatType_lineNum (vip_A)
		let seatType = seatTypeAndLineNum[0]; // vip
		let lineNum = seatTypeAndLineNum[1]; // A
		
        // 해당 그룹에 속한 모든 체크박스를 찾기
        let checkboxes = $("input."+lineNum+"."+seatType); // input.A.vip

        // disabled되지 않은 체크박스들만 필터링
        let enabledCheckboxes = checkboxes.filter(":not(:disabled)");

        // 체크박스들이 모두 체크되어 있는지 확인 (disabled 제외)
        let allChecked = enabledCheckboxes.filter(":checked").length === enabledCheckboxes.length;

     	// 새로운 체크 상태 결정 (모두 체크되어 있으면 해제, 아니면 체크)
        let newCheckedState = !allChecked;
        
     	// 체크 상태 변경 및 handleSeatSelection 실행
        checkboxes.each(function () {
        	if (!$(this).prop("disabled")) { // 체크박스가 disabled가 아닌 경우에만 상태 변경
                $(this).prop("checked", newCheckedState); // 체크 상태 변경
                handleSeatSelection($(this).val(), newCheckedState, seatType); // 상태 변경 후 실행
            }
        });
        
});



/* ======================== totalSeat 값 변경 ================================ */
$(document).ready(function() {
    // 라디오 버튼이 선택될 때마다 실행
    $("input[name='hallType']").change(function() {
        if ($("#hall0").is(":checked")) {
            // 가우디움홀 선택 시
            $("#totalSeat").val("480");  // hidden input 값 변경
        } else if ($("#hall1").is(":checked")) {
            // 펠리체홀 선택 시
            $("#totalSeat").val("210");  // hidden input 값 변경
        }
    });
});

/* ====================== 공연 시간 설정 ================================== */
function addTimeInput() {
    var div = document.createElement("div");
    div.innerHTML = `
        <input type="datetime-local" name="concertDateTime" min="<%= now %>" required>
        <button class="btn btn-sm btn-outline-danger" type="button" onclick="removeInput(this)">삭제</button>
    `;
    document.getElementById("timeInputs").appendChild(div);
}

function removeInput(button) {
    button.parentElement.remove();
}

/* ========================== 제출전 조건 확인 ============================ */
$(document).ready(function() {
	  // submit 버튼 클릭 시 실행할 동작
	$('#submitBtn').click(function() {
	    // 제출을 막기 전에 조건을 검사하거나 추가 로직을 넣을 수 있음
	    var isFormValid = confirmSubmit(); // 예시로 폼 유효성 검사 함수
	    
	    if (isFormValid) {
	// 조건 3: required 속성이 부여된 input에 값이 있는지 확인
			if (!$('#myForm')[0].checkValidity()) {
			   	alert("필수 입력 항목을 채워주세요.");
			 	return false;
			}else{
				console.log("제출 조건 확인 함수 실행: 조건3 클리어")
		      	$('#myForm')[0].submit(); // 실제로 제출하고 싶을 때는 이 코드 사용
			}
	    } else {
	      //  alert("confirmSubmit()결과: false");
	      event.preventDefault(); // 폼 제출을 막음
	    }
  	});


	/* ====================== 좌석 목록 생성 함수 ================= */
	function generateSeatList(startRow, endRow, seatsPerRow) {
	    console.log("좌석목록 생성 함수 실행")
	    let seatList = [];
	    for (let row = startRow.charCodeAt(0); row <= endRow.charCodeAt(0); row++) {
	        let rowLetter = String.fromCharCode(row);
	        for (let num = 1; num <= seatsPerRow; num++) {
	            let seatNum = num.toString().padStart(2, "0"); // 01, 02...
	            seatList.push(rowLetter + seatNum);
	        }
	    }
	    return seatList;
	}
	
	/* ========================== 제출조건 확인 함수 ==========================*/
	function confirmSubmit() {
	    console.log("제출 조건 확인 함수 실행")
	
	    let selectedSeatTypes = $(".seatType:checked").map(function() {
	        return this.value;
	    }).get();
	    console.log("selectedSeatTypes: "+ selectedSeatTypes);
		
	    if (typeof selectedHall === "undefined" || !selectedHall) {
	        alert("공연장을 선택하세요.");
	        return false;
	    }
	    
	    if ($(".seatType:checked").val() == "equal") {
	    	console.log("selectedSeatType: "+ $(".seatType:checked").val());
	    	return true;
	    }else{
	    	
	    	// 조건 0: 좌석 등급이 선택되었는가?
    	    var checkboxes = document.querySelectorAll(".seatType");
		    var isChecked = Array.from(checkboxes).some(cb => cb.checked); // 하나라도 체크됐는지 확인
		
		    if (!isChecked) {
		        alert("최소 하나의 좌석 등급을 선택해야 합니다.");
		        event.preventDefault(); // 제출 방지
		        return false;
		    }
	    	
		    // 조건 1: 생성된 체크박스(좌석)이 모두 선택되었는가?
			let allSeats = [];
			let allSelectedSeats = []
		    .concat(
		        selectedSeats["vip"] || [],
		        selectedSeats["r"] || [],
		        selectedSeats["s"] || [],
		        selectedSeats["a"] || []
		    );
			
		    if (selectedHall === "gaudium") {
		    	allSeats = generateSeatList("A", "T", 24);
			    console.log("allSeats: "+allSeats);
			    console.log("allSelectedSeats: "+allSelectedSeats);
		    	let areArraysEqual = JSON.stringify(allSelectedSeats.sort()) === JSON.stringify(allSeats.sort());
				if (!areArraysEqual){
				    //console.log("allSeats: "+allSeats); // 전체좌석번호
				    console.log("allSelectedSeats: "+allSelectedSeats); // 선택된 전체좌석번호
				    console.log("selectedTotalSeats: "+ allSelectedSeats.length) // 선택된 전체 좌석 개수
			        alert("가우디움홀: 모든 좌석을 선택해주세요.");
					return false;
				} else {
				    console.log("selectedTotalSeats: "+ allSelectedSeats.length) // 선택된 전체좌석번호
				    for (let seatType in selectedSeats){
					    console.log(selectedSeats[seatType].length)
				    }
				    console.log("제출 조건 확인 함수 실행: 조건1 클리어")
				}
				
		    } else {
				allSeats = generateSeatList("A", "O", 14);
			    console.log("allSeats1: "+allSeats);
			    console.log("allSelectedSeats1: " + allSelectedSeats);
		    	let areArraysEqual = JSON.stringify(allSelectedSeats.sort()) === JSON.stringify(allSeats.sort());
				if (!areArraysEqual){
				    //console.log("allSeats2: "+allSeats); // 전체좌석번호
				    console.log("allSelectedSeats2: "+allSelectedSeats); // 선택된 전체좌석번호
				    console.log("selectedTotalSeats: "+ allSelectedSeats.length) // 선택된 전체 좌석 개수
			        alert("펠리체홀: 모든 좌석을 선택해주세요.");
					return false;
				} else {
				    console.log("selectedTotalSeats: "+ allSelectedSeats.length) // 선택된 전체좌석번호
				    for (let seatType in selectedSeats){
					    console.log(selectedSeats[seatType].length)
				    }
				    console.log("제출 조건 확인 함수 실행: 조건1 클리어")
				} 	
		    }
		
		    // 조건 2: 각 좌석등급 별 체크박스에 체크된 수(selectedSeats[type].length) 와 
		    //	입력된 수량($(".seatCount[data-type=seatType]").val())이 같고 그 합이 전체좌석의 수와 같은가?
		    let sum1 = 0; // 체크된 체크박스 개수
		    let sum2 = 0; // 직접 입력된 좌석 등급별 좌석수 
		    
		    for (let seatType of selectedSeatTypes){
		    	sum1 += selectedSeats[seatType].length;
		    	sum2 += parseInt($(".seatCount[data-type=" + seatType + "]").val(), 10);
		    }
		    
		    let totalSeatCount = $("#totalSeat").val();
		    console.log("sum1: "+sum1 +", sum2: "+sum2+", totalSeat: "+ totalSeatCount);
		
	   		if (sum1 != totalSeatCount || sum2 != totalSeatCount) {
		        alert("좌석 등급 별 좌석수를 확인해주십시오. \n 입력된 좌석수: "+sum2+", 총 좌석수: "+totalSeatCount);
		        return false;
		    } else {
			    console.log("제출 조건 확인 함수 실행: 조건2 클리어")
		    }

	    }
        
   		return true;
	}
});
</script>

<style type="text/css">
	
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
	.clickable-span {
	  cursor: pointer; /* 커서를 선택 모양으로 변경 */
	}
	
	.seat {
		margin: 0px;
	}
	.divCard {
		border: 1px solid black;
		padding: 20px;
		width: auto;
		height: auto;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.lineNum {
		color: gray;
		width: 15px;
		display: inline-block;
		text-align: center;
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
	.btn-black {
	  background-color: black;
	  color: white;
	  border-color: black;
	}
	
	.btn-black:hover {
	  background-color: white;
	  color: black;
	  border-color: black;
	}
</style>
</head>
<body>

<div class="container">
<div class="card m-4 p-4">
	<div class="mb-4 text-center">
		<h5>공연 등록</h5>
	</div>
<form id="myForm" action="insertConcertOK" method="post" enctype="multipart/form-data" onsubmit="return confirmSubmit()">
	<div class="mb-3 row">
		<label for="title" class="col-sm-2 col-form-label">제목</label>
	    <div class="col-sm-10">
			<input id="title" class="form-control"  type="text" name="title" placeholder="공연 제목입력" required></td>
		</div>
	</div>
	<div class="mb-3 row">
		<label class="col-sm-2 col-form-label">공연 장르</label>
		<div class="col-sm-10">	
			<%
				String[] category = {"클래식", "뮤지컬", "재즈", "대중음악", "연극", "무용", "기타"};
				for (int i=0; i<category.length; i++){
			%>
			<input class="btn-check"  type="radio" name="categoryId" id="option<%=i%>" value="<%=i%>" required>
			<label class="btn" for="option<%=i%>"><%=category[i]%></label> 
			<%
				}
			%>
		</div>
	</div>
	<div class="mb-3 row">
		<label class="col-sm-2 col-form-label">공연 장르</label>
		<div class="col-sm-10">	
			<input class="btn-check" type="radio" name="hallType" id="hall0" value="0">
			<label class="btn" for="hall0">가우디움홀</label> 
			<input class="btn-check" type="radio" name="hallType" id="hall1" value="1">
			<label class="btn" for="hall1">펠리체홀</label> 
			<input type="hidden" name="totalSeat" id="totalSeat" value="">
		</div>
	</div>
	<div class="mb-3 row">
		<label class="col-sm-2 col-form-label">공연 장르</label>
		<div class="col-sm-10">	
			    <input id="vip" type="checkbox" class="seatType btn-check" value="vip"> 
			    <label class="btn" for="vip">VIP</label>
			    <input id="r" type="checkbox" class="seatType btn-check" value="r"> 
			    <label class="btn" for="r">R</label>
			    <input id="s" type="checkbox" class="seatType btn-check" value="s"> 
			    <label class="btn" for="s">S</label>
			    <input id="a" type="checkbox" class="seatType btn-check" value="a"> 
			    <label class="btn" for="a">A</label>
			    <input id="equal" type="checkbox" class="seatType btn-check" value="equal"> 
			    <label class="btn" for="equal">equal</label>
		</div>
	</div>
    <div class="mb-3 row align-items-center">
		<label class="col-sm-2 col-form-label ">수량/가격</label>
	    <div class="col-sm-10 pt-1">
			<div id="seatContainer"></div>
		</div>
	</div>
	<div class="mb-3 row align-items-center">
		<label class="col-sm-2 col-form-label ">좌석 선택</label>
	    <div class="col-sm-10 pt-1">
	        <div id="seatSelectionContainer"></div> <!-- 동적 좌석 리스트 표시 -->
		</div>
	</div>
	<div class="mb-3 row">
		<label class="col-sm-2 col-form-label">공연 날짜/시간</label>
		   <div class="col-sm-10 pt-1">
	 	       <button class="btn btn-sm btn-outline-gold mb-2" type="button" onclick="addTimeInput()">시간 추가</button><br>
		    <div id="timeInputs">
		        <div>
		            <input type="datetime-local" name="concertDateTime" min="<%= now %>" required>
		            <button class="btn btn-sm btn-outline-danger" type="button" onclick="removeInput(this)">삭제</button>
		        </div>
		    </div>
		</div>
	</div>
	<div class="mb-3 row">
		<label class="col-sm-2 col-form-label">공연 포스터</label>
	    <div class="col-sm-10 pt-1 align-items-center">
			<input class="form-control" type="file" name="imageUrl" required="required">
		</div>
	</div>
	<div class="mb-3 row">
		<label class="col-sm-2 col-form-label">공연 정보/설명</label>
	    <div class="col-sm-10 pt-1 align-items-center">
			<textarea rows="5" name="description" style="resize: none; width: 99%;" required="required"></textarea>
		</div>
	</div>
	<div class="mb-4 text-center">
		<button style="width: 200px;" class="btn btn-gold" type="submit" id="submitBtn">저장</button>
		<button class="btn btn-black" style="width: 200px; type="button" onclick="history.back()">뒤로가기</button>
	</div>
</form>
</div>
</div>
</body>
</html>