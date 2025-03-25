<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공연 등록</title>
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
/* ====================== 등급별 좌석 번호 선택 ======================== */
$(document).ready(function () {
    let selectedSeats = {}; // 등급별 선택된 좌석 "등급" : [] 객체로 저장
    let selectedHall = ""; // 선택된 공연장 (gaudium, felice)
    let maxValues = {
            0: 480,
            1: 210,
     };
    let maxValue;
    
	/* =============== 공연장 선택 감지: 결과를 selectHall 변수에 넣어준다. ============= */
	 $("input[name='hallType']").change(function () {
     	selectedHall = $(this).val() === "0" ? "gaudium" : "felice";
     	let selectedValue = $(this).val(); // 선택된 라디오 버튼 값
        maxValue = maxValues[selectedValue]; // 해당 좌석 등급의 최대값 가져오기
        $(".seatCount").attr("max", maxValue); // max 값 변경
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
                $("#seatContainer").empty().append("<div id='seat_equal'><span> 전좌석 동일가: </span> 가격: <input type='number' name='equalPrice' required></div>");
                $("#seatSelectionContainer").empty(); // 기존 좌석 선택 제거
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
        let priceName = "price"+.toUpperCase();
	
        
        if ($(this).is(":checked")) {
	        
            let seatForm = "<div id="+seatId+"><span>"+seatType.toUpperCase()+": </span>"+
            " 좌석 개수: <input type=\"number\" name="+ countName +" class=\"seatCount\""+
            	" data-type=\""+seatType+"\" min=\"1\" max=\""+ maxValue+"\"required>"+
            "가격: <input type=\"number\" name=\""+priceName+"\" required></div>";
            
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
            delete selectedSeats[seatType];
            
            $("#pick_seat_" + seatType).remove();
            updateSeatSelectionUI();
        }

    /* ====================== 좌석 UI 업데이트: '좌석선택' 에 변화주기 =================================== */
	    function updateSeatSelectionUI() {
	        let container = $("#pick_seat_"+ seatType);
	        console.log("#pick_seat_"+seatType+": "+container.length);
	        container.empty();
	
	        if (!selectedHall) {
	            container.append("<p>공연장을 선택하세요.</p>");
	            return;
	        }
	
	        // 공연장에 따라 출력할 레이아웃 생성 및 변수에 저장
	        let seatLayout = generateSeatLayout(selectedHall);
	        console.log("seatLayout: "+ seatLayout.length);
	        
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
	        console.log("generate pick_seat: " + divCard.length);
	        let pickSeat = $("<div>").attr("id", "pickSeat");
	        let rows, seatsPerRow, breakPoints;
			
	        // 홀타입별 행과 좌석수 초기화
	        if (hallType === "gaudium") {
	            rows = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"];
	            seatsPerRow = 24;
	            breakPoints = [6, 18];
	        } else {
	            rows = ["A", "B", "C", "D", "E", "F", "G"];
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
	                console.log("forEach문 seatType: "+ seatType);
	
	                // 알파벳 lineNum 을 누르면 해당 행 전부 체크된 체크박스로 출력
	                
	                let seatCheckbox = $("<input>", {
	                	id: seatType+"_"+seatName,
	                    type: "checkbox",
	                    class: lineNum+" "+seatType,
	                    name: seatType+"Seats",
	                    value: seatName,
	                    change: function () {
	                    	// 좌석 체크박스가 체크/해제되면
	                        let a = $(this).attr("name"); // name 에 있는 것을 꺼내와라 = 좌석 등급
	                        let seatType = a.replace("Seats", ""); 
	                        if (this.checked) {
	                            selectedSeats[seatType].push(this.value);
	                        } else {
	                            selectedSeats[seatType] = selectedSeats[seatType].filter(s => s !== this.value);
	                        }
	                    }
	                }); // 체크박스 1개 생성완료
	                
	
	                // 행 div 에 체크박스를 넣는다.
	                rowDiv.append(seatCheckbox);
	
	                // 복도로 나뉜 열에 해당하면 행 div 에 체크박스 대신 공간을 넣는다.
	                if (breakPoints.includes(j)) {
	                    rowDiv.append("&nbsp;&nbsp;&nbsp;"); // 공간 추가
	                }
	            } // 체크박스 1줄 생성 for 문 끝
	            
	
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
/* 좌석 행 알파벳 클릭시 해당 행 전부 선택 */
$(document).on("click", "span.lineNum", function () {
    // span 태그 클릭 시
    	console.log("span lineNum 클릭")
        // 클릭한 span 태그의 id 가져오기
        let seatTypeAndLineNum = $(this).attr("id").split("_"); // seatType_lineNum (vip_A)
		let seatType = seatTypeAndLineNum[0]; // vip
		let lineNum = seatTypeAndLineNum[1]; // A
		
        // 해당 그룹에 속한 모든 체크박스를 찾기
        let checkboxes = $("input."+lineNum+"."+seatType); // input.A.vip

        // 체크박스들이 모두 체크되어 있는지 확인
        let allChecked = checkboxes.filter(":checked").length === checkboxes.length;

        // 모두 체크되어 있으면, 모두 체크 해제
        if (allChecked) {
            checkboxes.prop("checked", false);
        } else {
            // 그렇지 않으면, 모두 체크
            checkboxes.prop("checked", true);
        }
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
        <button type="button" onclick="removeInput(this)">삭제</button>
    `;
    document.getElementById("timeInputs").appendChild(div);
}

function removeInput(button) {
    button.parentElement.remove();
}

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
		height: 400px;
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

<form action="insertConcertOK" method="post" enctype="multipart/form-data">
<table >
	<tr>
		<td>제목</td>
		<td> <input type="text" name="title" placeholder="공연 제목입력"></td>
	</tr>
	<tr>
		<td>공연 장르</td>
		<td> 
		<%
			String[] category = {"클래식", "뮤지컬", "재즈", "대중음악", "연극", "무용", "기타"};
			for (int i=0; i<category.length; i++){
		%>
		<input type="radio" name="categoryId" id="option<%=i%>" value="<%=i%>">
		<label for="option<%=i%>"><%=category[i]%></label> 
		<%
			}
		%>
		</td>
	</tr>
	<tr>
		<td>공연장(hall)</td>
		<td>
			<input type="radio" name="hallType" id="hall0" value="0">
			<label for="hall0">가우디움홀</label> 
			<input type="radio" name="hallType" id="hall1" value="1">
			<label for="hall1">펠리체홀</label> 
			<input type="hidden" name="totalSeat" id="totalSeat" value="">
		</td>
	</tr>
	<tr>
		<td>좌석 등급</td>
		<td>
		    <label><input type="checkbox" class="seatType" value="vip"> VIP</label>
		    <label><input type="checkbox" class="seatType" value="r"> R</label>
		    <label><input type="checkbox" class="seatType" value="s"> S</label>
		    <label><input type="checkbox" class="seatType" value="a"> A</label>
		    <label><input type="checkbox" class="seatType" value="equal"> equal</label>
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
	        <div>
	            <input type="datetime-local" name="concertDateTime" min="<%= now %>" required>
	            <button type="button" onclick="removeInput(this)">삭제</button>
	            
	        </div>
    
	    </div>
		</td>
	</tr>
	<tr>
		<td>공연 포스터</td>
		<td>
			<input type="file" name="imageUrl" required="required">
		</td>
	</tr>
	<tr>
		<td>설명</td>
		<td>
			<textarea rows="5" name="description" style="resize: none; width: 99%;" required="required"></textarea>
		</td>
	</tr> 
              
</table>
	
	<input type="submit" value="저장">

</form>

</body>
</html>