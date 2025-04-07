<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 100%;
            max-width: 500px;
            background: #fff;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
            color: #555;
        }

        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .radio-group {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .radio-option {
            display: flex;
            align-items: center;
        }

        .radio-option span {
            display: inline;
            white-space: nowrap;
        }

        .email-group {
            display: flex;
            gap: 5px;
            align-items: center;
        }

        #customEmail {
            display: none;
        }

        .submit-btn {
            width: 100%;
            background-color: black;
            color: white;
            padding: 12px;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .submit-btn:hover {
            background-color: #333;
        }
    </style>

    <script>
        function checkPasswordMatch() {
            const pw = document.querySelector('input[name="pw"]').value;
            const pwConfirm = document.querySelector('input[name="pwConfirm"]').value;
            if (pw && pw !== pwConfirm) {
                alert("비밀번호가 일치하지 않습니다.");
                return false;
            }
            return true;
        }

        function checkPhone() {
            const phone = document.querySelector('input[name="phone"]').value;
            const phoneRegex = /^\d{11}$/;
            if (!phoneRegex.test(phone)) {
                alert("전화번호는 숫자 11자리여야 합니다.");
                return false;
            }
            return true;
        }

        function checkBirth() {
            const birth = document.querySelector('input[name="birth"]').value;
            const birthRegex = /^\d{8}$/;
            if (!birthRegex.test(birth)) {
                alert("생년월일은 8자리(예: 20000101)로 입력해주세요.");
                return false;
            }
            return true;
        }

        function checkEmailDomain() {
            const domain = document.getElementById("emailDomain").value;
            const custom = document.getElementById("customEmail");
            if (domain === "custom") {
                custom.style.display = "inline-block";
                custom.required = true;
            } else {
                custom.style.display = "none";
                custom.required = false;
                custom.value = "";
            }
        }

        function makeEmail() {
            const front = document.getElementById("emailFront").value;
            let back = document.getElementById("emailDomain").value;
            if (back === 'custom') {
                back = document.getElementById("customEmail").value;
            }
            document.getElementById("fullEmail").value = front + "@" + back;
        }

        function confirmDelete() {
            if (confirm("정말로 탈퇴하시겠습니까?")) {
                location.href = "/deleteMyinfo";
            }
        }
    </script>
</head>
<body>
	<div class="wrapper">
		<jsp:include page="./include/header.jsp"/>

	<div class="body-main">
		<div class="container">
		    <h2>회원정보 수정</h2>
		    <form action="/myinfoUpdateOK" method="post" onsubmit="makeEmail(); return checkPasswordMatch() && checkPhone() && checkBirth();">

		        <div class="form-group">
		            <label>비밀번호 (변경 시 입력)</label>
		            <input type="password" name="pw" placeholder="변경할 비밀번호">
		        </div>

		        <div class="form-group">
		            <label>비밀번호 확인</label>
		            <input type="password" name="pwConfirm">
		        </div>

		        <div class="form-group">
		            <label>이름</label>
		            <input type="text" name="name" value="${consumer.name}" required>
		        </div>

		        <div class="form-group">
		            <label>생년월일</label>
		            <input type="text" name="birth" value="${consumer.birth}" required>
		        </div>

		        <div class="form-group">
		            <label>성별</label>
		            <div class="radio-group">
		                <div class="radio-option">
		                    <input type="radio" name="gender" value="MALE" <c:if test="${consumer.gender == 'MALE'}">checked</c:if>> <span>남자</span>
		                </div>
		                <div class="radio-option">
		                    <input type="radio" name="gender" value="FEMALE" <c:if test="${consumer.gender == 'FEMALE'}">checked</c:if>> <span>여자</span>
		                </div>
		            </div>
		        </div>

		        <div class="form-group">
		            <label>전화번호</label>
		            <input type="text" name="phone" value="${consumer.phone}" required>
		        </div>

		        <div class="form-group">
		            <label>이메일</label>
		            <div class="email-group">
		                <input type="text" id="emailFront" value="${consumer.email.split('@')[0]}" required> @
		                <select name="emailDomain" id="emailDomain" onchange="checkEmailDomain()">
		                    <option value="naver.com" <c:if test="${consumer.email.endsWith('naver.com')}">selected</c:if>>naver.com</option>
		                    <option value="gmail.com" <c:if test="${consumer.email.endsWith('gmail.com')}">selected</c:if>>gmail.com</option>
		                    <option value="daum.net" <c:if test="${consumer.email.endsWith('daum.net')}">selected</c:if>>daum.net</option>
		                    <option value="custom" <c:if test="${!consumer.email.endsWith('naver.com') && !consumer.email.endsWith('gmail.com') && !consumer.email.endsWith('daum.net')}">selected</c:if>>직접입력</option>
		                </select>
		                <input type="text" name="customEmail" id="customEmail"
		                       value="<c:if test='${!consumer.email.endsWith(\"naver.com\") && !consumer.email.endsWith(\"gmail.com\") && !consumer.email.endsWith(\"daum.net\")}'>${consumer.email.split('@')[1]}</c:if>">
		            </div>
		            
		            <input type="hidden" name="email" id="fullEmail">
		        </div>

		        <div class="form-group">
		            <label>주소</label>
		            <input type="text" name="address" value="${consumer.address}" required>
		        </div>

		        <div class="form-group">
		            <label>상세주소</label>
		            <input type="text" name="detailAddress" value="${consumer.detailAddress}" required>
		        </div>

		        <a href="#" onclick="confirmDelete()" style="display: block; margin-top: 30px; color: #888; text-align: center; text-decoration: underline;">
		            회원 탈퇴하기
		        </a>
				
				<br />

		        <button type="submit" class="submit-btn">수정하기</button>
		    </form>
			<!--push를 위한 주석-->

	</div>

	<jsp:include page="./include/footer.jsp"/>

	</div>


</div>
</body>
</html>