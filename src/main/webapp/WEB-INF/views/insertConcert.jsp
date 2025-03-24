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
/* 공연 좌석 등급설정 */
$(document).ready(function() {
    $(".seatType").change(function() {
        let seatType = $(this).val();
        
        if (!seatType) {
            console.error("🚨 seatType 값이 비어 있습니다!");
            return;
        }
        
        // 'equal'이 선택된 경우, 다른 체크박스를 모두 해제
        if (seatType === "equal") {
            if ($(this).is(":checked")) {
                // 'equal'이 선택되면 다른 체크박스를 모두 해제하고 전좌석 동일가 폼만 보여줌
                $(".seatType").not(this).prop("checked", false); // 다른 모든 체크박스 해제
                $("#seatContainer").empty(); // 기존 폼 제거
                $(".seatType").not(this).prop("disabled", true); // 다른 체크박스 비활성화
                let seatForm = "<div id='seat_equal'>" +
                               "<span>전좌석 동일가: </span>" +
                               "가격: <input type='number' name='equalPrice' required>" +
                               "</div>";
                $("#seatContainer").append(seatForm);
            } else {
            	$(".seatType").prop("disabled", false); // 모든 체크박스 활성화
                // 'equal'이 해제되면 기존 폼 삭제
                $("#seat_equal").remove();
            }
            return; // 'equal' 처리 후 다른 처리 없이 종료
        }

        let seatId = "seat_" + seatType; // seatId 생성
        let upperSeatType = String(seatType).toUpperCase(); // 대문자 변환
        let countName = seatType + "Count"; // countName 생성
        let priceName = seatType + "Price"; // priceName 생성

        if ($(this).is(":checked")) {
            // 문자열 연결 방식으로 seatForm 생성
            let seatForm = "<div id='" + seatId + "'>" +
                            "<span>" + upperSeatType + ":  </span>" +
                            "좌석 개수: <input type='number' name='" + countName + "' required>" +
                            "가격: <input type='number' name='" + priceName + "' required>" +
                            "</div>";

            console.log("seatForm:", seatForm); // 디버깅 로그

            $("#seatContainer").append(seatForm);
        } else {
            $("#" + seatId).remove();
        }
    });
});

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

/* 공연 시간 설정 */
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

</head>
<body>

<form action="insertConcertOK" method="post" enctype="multipart/form-data">
<table>
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