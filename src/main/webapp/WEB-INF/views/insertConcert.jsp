<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공연 등록</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $(".seatType").change(function() {
        let seatType = $(this).val();
        if (!seatType) {
            console.error("🚨 seatType 값이 비어 있습니다!");
            return;
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
		</td>
	</tr>
	<tr>
		<td>좌석 등급</td>
		<td>
		    <label><input type="checkbox" class="seatType" value="vip"> VIP</label>
		    <label><input type="checkbox" class="seatType" value="r"> R</label>
		    <label><input type="checkbox" class="seatType" value="s"> S</label>
		    <label><input type="checkbox" class="seatType" value="a"> A</label>
		
		    <div id="seatContainer"></div>
		</td>
	</tr>

</table>
	
	

</form>

</body>
</html>