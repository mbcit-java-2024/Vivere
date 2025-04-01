<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공연 수정</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
let ajaxRequests = [];
let selectedHall = ""; // 선택된 공연장 (gaudium, felice)
let maxValues = {0: 480, 1: 210};
let maxValue;
// 'firstRun' 변수를 사용하여 첫 실행을 추적
var firstRun = true;

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
/* ====================== 좌석 UI 업데이트: '좌석선택' 에 변화주기 =================================== */
function updateSeatSelectionUI(seatType) {
	console.log("updateSeatSelectionUI() 실행")
    let container = $("#pick_seat_"+ seatType);
    // console.log("#pick_seat_"+seatType+": "+container.length);
    container.empty();

    if (!selectedHall) {
        container.append("<p>공연장을 선택하세요.</p>");
        return;
    }

    // 공연장에 따라 출력할 레이아웃 생성 및 변수에 저장
    let seatLayout = generateSeatLayout(selectedHall, seatType);
    // console.log("seatLayout: "+ seatLayout.length);
    
    // 체크된 상태인 seatType 에 따라 각각 하나씩 추가
    container.append(seatLayout);

} // updateSeatSelectionUI()

/* ===================================== 좌석 배치 생성 함수 =================================== */

function generateSeatLayout(hallType, seatType) {
	console.log("generateSeatLayout(hallType) 실행")
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
	        }); // 체크박스 1개 생성완료
            
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

$(document).ready(function() {
    if (firstRun) {
    	let concertId = document.getElementById('concertId').value;
    	/* ==================== 기존 좌석 설정 정보 넣어주기 =================== */
    	  	selectedHall = $("input[name='hallType']:checked").val() === "0" ? "gaudium" : "felice";
    	    
    		if ($(".seatType:checked").val() === "equal") {
    	            $(".seatType").not($(".seatType:checked")).prop("checked", false).prop("disabled", true);
    	            $("#seatContainer").empty().append("<div id='seat_equal'><span> 전좌석 동일가: </span> 가격: <input type='number' name='equalPrice' required value='${concertVO.equalPrice}'></div>");
    	    }else{
    	    	
    	    //	ajax로 기존에 선택된 좌석 배치 selectedSeats[type] 에 넣어주기
    	    for (let seatType in selectedSeats){
    	    	 let request = $.ajax({
    		        url: "/getSelectedSeats",
    		        type: "POST",
    		        data: { seatType: seatType, concertId: concertId },
    		        dataType: "text",  // JSON 대신 'text' 사용
    		        success: function(response) {
    		            console.log(response); // 원본 데이터 확인
    		            if (response && response.trim() !== ""){
    			          let dataArray = response.split(","); // 쉼표로 분할하여 배열 생성
    		              selectedSeats[seatType] = dataArray;
    		            }
    		        },
    		        error: function(xhr, status, error) {
    		            console.error("AJAX 오류 발생:", error);
    		        }
    		    });
    			ajaxRequests.push(request); // 요청을 배열에 저장
    	    }
    	    $.when.apply($, ajaxRequests).done(function () {
    	        for (let seatType in selectedSeats) {
    	        	console.log('selectedSeats['+seatType+'].length: '+ selectedSeats[seatType].length)
    	        	console.log('selectedSeats['+seatType+']: '+ selectedSeats[seatType])
    	            // 불러온 selectedSeats 데이터에 맞게 체크 박스 활성화
    	            if (selectedSeats[seatType].length > 0 ){
    	            		
    	        	    // 좌석개수: <input type="number" name="vipCount" class="seatCount" data-type="vip">
    	        	    // 가격: <input type="number" name="vipPrice">
    	        	    let seatId = "seat_" + seatType;
    	        	    let countName = "count"+seatType.toUpperCase();
    	        	    let priceName = "price"+seatType.toUpperCase();
    	        	    let elCount = '';
    	        	    let elPrice = '';
    	        	    if (seatType === "vip"){
    	        	    	elCount = ${concertVO.countVIP};
    	        			elPrice = ${concertVO.priceVIP};
    	        	    } else if (seatType === "r"){
    	        	    	elCount = ${concertVO.countR};
    	        			elPrice = ${concertVO.priceR};
    	        	    } else if (seatType === "s"){
    	        	    	elCount = ${concertVO.countS};
    	        			elPrice = ${concertVO.priceS};
    	        	    } else if (seatType === "a"){
    	        	    	elCount = ${concertVO.countA};
    	        			elPrice = ${concertVO.priceA};
    	        	    }
    	        	
    	                let seatForm = "<div id="+seatId+"><span>"+seatType.toUpperCase()+": </span>"+
    	                " 좌석 개수: <input type=\"number\" name="+ countName +" class=\"seatCount\""+
    	                	" data-type=\""+seatType+"\" min=\"1\" max=\""+ maxValue+"\" value=\""+elCount+"\"required>"+
    	                "가격: <input type=\"number\" name=\""+priceName+"\" value=\""+elPrice+"\" required></div>";
    	                
    	                $("#seatContainer").append(seatForm);
    	        	
    	        		let pick_seatDiv = "<div id=\"pick_seat_"+seatType+"\" class=\"divCard\"></div>";
    	        		$("#seatSelectionContainer").append(pick_seatDiv); // divCard를 추가
    	                
    	        		updateSeatSelectionUI();
    	        	
    	        	/* ====================== 좌석 UI 업데이트: '좌석선택' 에 변화주기 =================================== */
    	        	    function updateSeatSelectionUI() {
    	        	        let container = $("#pick_seat_"+ seatType);
    	        	        // console.log("#pick_seat_"+seatType+": "+container.length);
    	        	        container.empty();
    	        	
    	        	        // 공연장에 따라 출력할 레이아웃 생성 및 변수에 저장
    	        	        let seatLayout = generateSeatLayout(selectedHall);
    	        	        // console.log("seatLayout: "+ seatLayout.length);
    	        	        
    	        	        // 체크된 상태인 seatType 에 따라 각각 하나씩 추가
    	        	        container.append(seatLayout);
    	        	
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
    	       			                }); // 체크박스 1개 생성완료
    	        	                
    	        					// 만약 value 가 selectedSeat[type]에 있으면 체크박스를 체크 혹은 disable 시킨다.
    	        					for (let type in selectedSeats) {
    	        						if (selectedSeats[type].includes(seatName) && seatType != type) {
    	        				        // 해당하는 seatType 이 아닌 selectedSeats에 이미 있으면 disabled 처리
    	        					        seatCheckbox.prop("disabled", true); 
    	        					    } else if (selectedSeats[type].includes(seatName) && seatType == type){
    	        				        // 해당하는 seatType 이 아닌 selectedSeats에 이미 있으면 체크 처리
    	        					        seatCheckbox.prop("checked", true); 
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
    	        		} // generateSeatLayout 끝
    	            } // selectedSeats[seatType] && selectedSeats[seatType].length > 0 끝	
    	        } // for 반복 끝 
    		
    	    }); // $.when.apply 끝
    	    } // === else 끝
    	/* ===================================== 기존 데이터 집어넣기 끝 ==================================== */
        firstRun = false;
    }
    
/* ====================== 등급별 좌석 번호 선택 ======================== */
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
		console.log("공연장 변경 감지")
     	selectedHall = $(this).val() === "0" ? "gaudium" : "felice";
     	let selectedValue = $(this).val(); // 선택된 라디오 버튼 값
        maxValue = maxValues[selectedValue]; // 해당 좌석 등급의 최대값 가져오기
        $(".seatCount").attr("max", maxValue); // max 값 변경
    	console.log("hallType: "+ selectedValue)
		
        // 공연장 변경시 기존에 선택된 좌석들 초기화
        	for (let seatType in selectedSeats){
			console.log("selectedSeats 초기화: "+seatType);
        		selectedSeats[seatType] = [];
			console.log("selectedSeats["+seatType+"]: "+ selectedSeats[seatType]);
		    updateSeatSelectionUI(seatType);
       	 }
//    	$(".seat").prop("checked", false);
	  	$(".seat").prop("disabled", false);
       	
	 });

    /* =========== 공연 좌석 등급설정 : class = "seatType" 인 input의 값이 바뀔때마다 실행 ========== */
    $(".seatType").change(function() {
        let seatType = $(this).val();
        
		/* =============== 공연장 선택 감지: 결과를 selectHall 변수에 넣어준다. ============= */
		 $("input[name='hallType']").change(function () {
			console.log("공연장 변경 감지")
		    selectedHall = $(this).val() === "0" ? "gaudium" : "felice";
	     	let selectedValue = $(this).val(); // 선택된 라디오 버튼 값
	        maxValue = maxValues[selectedValue]; // 해당 좌석 등급의 최대값 가져오기
	        $(".seatCount").attr("max", maxValue); // max 값 변경
			console.log("selectedHall: "+ selectedHall);

			// selectedSeats 초기화
	        for (let seatType in selectedSeats){
			console.log("selectedSeats 초기화: "+seatType);
	        	selectedSeats[seatType] = [];
	        }
		    updateSeatSelectionUI(seatType);
	        
		 });
		
        if (!seatType) {
            console.error("seatType 값이 비어 있습니다!");
            return;
        }

        // 'equal'이 선택된 경우, 다른 체크박스를 모두 해제 및 disable 
        if (seatType === "equal") {
            if ($(this).is(":checked")) {
                $(".seatType").not(this).prop("checked", false).prop("disabled", true);
                $("#seatContainer").empty().append("<div id='seat_equal'><span> 전좌석 동일가: </span> 가격: <input type='number' name='equalPrice' required></div>");
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
	        
            let seatForm = "<div id="+seatId+"><span>"+seatType.toUpperCase()+": </span>"+
            " 좌석 개수: <input type=\"number\" name="+ countName +" class=\"seatCount\""+
            	" data-type=\""+seatType+"\" min=\"1\" max=\""+ maxValue+"\"required>"+
            "가격: <input type=\"number\" name=\""+priceName+"\" required></div>";
            
            $("#seatContainer").append(seatForm);
            selectedSeats[seatType] = [];

			let pick_seatDiv = "<div id=\"pick_seat_"+seatType+"\" class=\"divCard\"></div>";
 			$("#seatSelectionContainer").append(pick_seatDiv); // divCard를 추가
            updateSeatSelectionUI(seatType);
            
        } else {
            $("#" + seatId).remove();
            // selectedSeats 변동 사항에 따라 disable 된 체크박스 다시 활성화하기
			for (let seatName of selectedSeats[seatType]) {
				$("input[value='" + seatName + "']").prop("disabled", false);
			}            
            selectedSeats[seatType] = [];
			
            $("#pick_seat_" + seatType).remove();
            updateSeatSelectionUI(seatType);
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

/* ====================== 공연 시간 수정 ================================== */
/* 공연 시간 추가 */
function addTimeInput() {
   	console.log("addTimeInput() 함수 실행")
    var div = document.createElement("div");
    div.innerHTML = `
        <input type="datetime-local" name="concertDateTime" min="<%= now %>" onchange="addConcertTime(this)" required>
        <button type="button" onclick="removeInput(this)">삭제</button>
    `;
    document.getElementById("timeInputs").appendChild(div);
}

/* 추가한 공연시간 저장 */
function addConcertTime(input) {
   	console.log("addConcertTime() 함수 실행")
   	
    var timeDiv = input.parentElement; // input이 속한 div
    var concertDateTime = input.value;
    var concertId = document.getElementById('concertId').value;
   	console.log("입력된 concertDateTime: "+ concertDateTime)
   	console.log("concertId: " + concertId); // 콘솔에 값 확인

    if (!concertDateTime) {
    	console.log("입력된 값 없음")
    	return; // 값이 없으면 아무것도 안 함
    }

    // 이미 저장된 값이면 
    var existingId = timeDiv.querySelector("input[name='concertTimeId']");
   	console.log("existingId: "+ existingId)
    if (existingId) {
    	// 공연 시간 수정 함수 실행
    	console.log("DB에 있는 시간 수정 실행")
    	updateConcertTime(input);
    	return;
    }else{
	   	console.log("새 시간 생성 및 저장")
	    $.ajax({
	        type: "POST",
	        url: "/addConcertTime",
	        data: { concertId: concertId, concertDateTime: concertDateTime },
	        contentType: "application/x-www-form-urlencoded",
	        success: function(response) {
	            if (response.success) {
			   	console.log("새 시간 저장 성공")
	                // DB에 저장된 concertTimeId를 hidden input으로 추가
	                var hiddenInput = document.createElement("input");
	                hiddenInput.type = "hidden";
	                hiddenInput.name = "concertTimeId";
	                hiddenInput.value = response.concertTimeId; // 서버에서 반환한 ID
	
	                timeDiv.appendChild(hiddenInput);
				   	console.log("concertTimeId hidden input 넣기 성공")
	                return;
	            } else {
	                alert("저장 실패!");
	            }
	        }
	    });
    }
}

/* 공연 시간 수정 */
function updateConcertTime(input) {
   	console.log("updateConcertTime() 함수 실행")
    let timeDiv = input.parentElement;
    let concertTimeId = timeDiv.querySelector("input[name='concertTimeId']").value;
    let newDateTime = input.value;

    $.ajax({
        type: "POST",
        url: "/updateConcertTime",
        data: { timeId: concertTimeId, newConcertDateTime: newDateTime },
        success: function(response) {
            if (response !== "success") {
                alert("수정 실패!");
            }
        }
    });
}

/* 공연 시간 삭제 */
function removeInput(button) {
	let timeDiv = button.parentElement; // 삭제할 div
	let concertTimeId = timeDiv.querySelector("input[name='concertTimeId']")?.value;
    
	 if (concertTimeId) { // 기존 DB에 있는 데이터라면 AJAX로 삭제
         $.ajax({
             type: "POST",
             url: "/deleteConcertTime",
             data: { timeId: concertTimeId },
             success: function(response) {
                 if (response === "success") {
                     timeDiv.remove(); // 화면에서 삭제
                 } else {
                     alert("삭제 실패!");
                 }
             }
         });
     } else {
         timeDiv.remove(); // 새로 추가된 입력창이라면 그냥 화면에서만 삭제
     }
 
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
	
	/* ========================== 수정 제출조건 확인 함수 ==========================*/
	function confirmSubmit() {
	    console.log("제출 조건 확인 함수 실행")
	    
	    let selectedSeatTypes = $(".seatType:checked").map(function() {
	        return this.value;
	    }).get();
	    console.log("selectedSeatTypes: "+ selectedSeatTypes);
		
	    selectedHall = $("input[name='hallType']:checked").val() === "0" ? "gaudium" : "felice";
    	console.log("selectedHall: "+ selectedHall);

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
		        alert("최소 하나의 좌석 유형을 선택해야 합니다.");
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
</style>
</head>
<body>

<form id="myForm" action="updateConcertOK" method="post" enctype="multipart/form-data" onsubmit="return confirmSubmit()">
	<input type="hidden" id="concertId" name="concertId" value="${concertVO.id}">
	<table >
		<tr>
			<td>제목</td>
			<td> <input type="text" name="title" placeholder="공연 제목입력" value="${concertVO.title }" required></td>
		</tr>
		<tr>
			<td>공연 장르</td>
			<td> 
			<%
				String[] category = {"클래식", "뮤지컬", "재즈", "대중음악", "연극", "무용", "기타"};
				for (int i=0; i<category.length; i++){
					request.setAttribute("i", i);
			%>
			<c:if test="${concertVO.categoryId == i}">
				<input type="radio" name="categoryId" id="option<%=i%>" value="<%=i%>" checked="checked" required>
				<label for="option<%=i%>"><%=category[i]%></label> 
			</c:if>
			<c:if test="${concertVO.categoryId != i}">
				<input type="radio" name="categoryId" id="option<%=i%>" value="<%=i%>" required>
				<label for="option<%=i%>"><%=category[i]%></label> 
			</c:if>
			<%
				}
			%>
			</td>
		</tr>
		<tr>
			<td>공연장(hall)</td>
			<td>
			<c:if test="${concertVO.hallType == 0}">
				<input type="radio" name="hallType" id="hall0" value="0" checked="checked">
				<label for="hall0">가우디움홀</label> 
				<input type="radio" name="hallType" id="hall1" value="1">
				<label for="hall1">펠리체홀</label> 
				<input type="hidden" name="totalSeat" id="totalSeat" value="480">
			</c:if>
			<c:if test="${concertVO.hallType == 1}">
				<input type="radio" name="hallType" id="hall0" value="0">
				<label for="hall0">가우디움홀</label> 
				<input type="radio" name="hallType" id="hall1" value="1"  checked="checked">
				<label for="hall1">펠리체홀</label> 
				<input type="hidden" name="totalSeat" id="totalSeat" value="210">
			</c:if>
			</td>
		</tr>
		<tr>
			<td>좌석 등급</td>
			<td>
				<c:if test="${not empty selectedSeatTypes}">
					<c:forEach var="seatType" items="${seatTypes}">
						<c:if test="${selectedSeatTypes.contains(seatType)}">
						    <label><input type="checkbox" class="seatType" value=${seatType } checked="checked"> ${fn:toUpperCase(seatType)}</label>
						</c:if>
						<c:if test="${not selectedSeatTypes.contains(seatType)}">
						    <label><input type="checkbox" class="seatType" value=${seatType }> ${fn:toUpperCase(seatType)}</label>
						</c:if>
					</c:forEach>
			   		<label><input type="checkbox" class="seatType" value="equal"> equal</label>
				</c:if>
				<c:if test="${empty selectedSeatTypes}">
			    	<label><input type="checkbox" class="seatType" value="vip"> VIP</label>
				    <label><input type="checkbox" class="seatType" value="r"> R</label>
				    <label><input type="checkbox" class="seatType" value="s"> S</label>
				    <label><input type="checkbox" class="seatType" value="a"> A</label>
				    <label><input type="checkbox" class="seatType" value="equal" checked="checked"> equal</label>
				</c:if>
			    <div id="seatContainer"></div>
	 		</td>
		</tr>
		<tr>
		    <td>좌석 선택</td>
		    <td>
		        <div id="seatSelectionContainer"></div> <!-- 동적 좌석 리스트 표시 -->
		    </td>
		</tr>
		<tr>
			<td>공연 날짜/시간</td>
			<td>
		    <div id="timeInputs">
		            <button type="button" onclick="addTimeInput()">시간 추가</button><br>
		        <c:forEach var="conTime" items="${conTimeList}">
		        <fmt:formatDate value="${conTime.concertTime}" pattern="yyyy-MM-dd'T'HH:mm" var="dateTime"/>
		        <div>
		        	<input type="hidden" name="concertTimeId" value="${conTime.id}">
		            <input type="datetime-local" name="concertDateTime" min="<%= now %>" value="${dateTime}" onchange="addConcertTime(this)" required>
		            <button type="button" onclick="removeInput(this)">삭제</button>
		        </div>
		        </c:forEach>
		            
	    
		    </div>
			</td>
		</tr>
		<tr>
			<td>공연 포스터</td>
			<td>
				<img alt="공연포스터" src="${concertVO.posterUrl}" style="width: 300px; ">
				<input type="file" name="imageUrlUpdate" >
			</td>
		</tr>
		<tr>
			<td>설명</td>
			<td>
				<textarea rows="5" name="description" style="resize: none; width: 99%;" required="required">${concertVO.description }
				</textarea>
			</td>
		</tr> 
	              
	</table>
	<input type="hidden" id="isSeatTypeChange" name="isSeatTypeChange" value="false">
	<button type="submit" id="submitBtn">저장</button>
	<button type="button" onclick="location.href='deleteConcert?concertId=${concertVO.id}'">삭제</button>
</form>

</body>
</html>