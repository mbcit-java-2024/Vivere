<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
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

        .input-row {
            display: flex;
            gap: 10px;
        }

        .input-row input {
            flex: 1;
        }

		.radio-group {
		    display: flex;
		    gap: 15px; /* 라디오 버튼 간의 간격을 조정 */
		    align-items: center; /* 라디오 버튼과 텍스트가 수평으로 정렬되도록 함 */
		    justify-content: flex-start; /* 왼쪽 정렬 */
		}

		.radio-option {
		    display: flex; 
		    align-items: center; /* 라디오 버튼과 텍스트가 한 줄로 정렬되도록 함 */
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

        .check-btn {
            background-color: #444;
            color: white;
            padding: 10px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
    </style>

	<script>
	    let isDuplicateChecked = false; // 중복 확인 여부 저장

	    function checkDuplicateId() {
	        const userId = document.getElementById("userId").value;
	        console.log("입력한 userId:", userId);

	        if (!userId) {
	            alert("아이디를 입력하세요.");
	            return;
	        }

	        fetch("/checkDuplicateId?userId=" + encodeURIComponent(userId))
	            .then(res => res.json())
	            .then(data => {
	                if (data.exists) {
	                    alert("이미 사용 중인 아이디입니다.");
	                    isDuplicateChecked = false;
	                } else {
	                    alert("사용 가능한 아이디입니다.");
	                    isDuplicateChecked = true;
	                }
	            });
	    }

	    function checkPasswordMatch() {
	        const pw = document.querySelector('input[name="pw"]').value;
	        const pwConfirm = document.querySelector('input[name="pwConfirm"]').value;
	        if (pw !== pwConfirm) {
	            alert("비밀번호가 일치하지 않습니다.");
	            return false;
	        }
	        return true;
	    }

	    function checkAgreement() {
	        const agreeAgree = document.querySelector('input[name="agree"]:checked');
	        if (!agreeAgree || agreeAgree.value === "DISAGREE") {
	            alert("개인정보 이용 동의를 반드시 동의하셔야 합니다.");
	            return false;
	        }
	        return true;
	    }

	    function multiIdCheck() {
	        if (!isDuplicateChecked) {
	            alert("아이디 중복 확인을 해주세요.");
	            return false;
	        }
	        return true;
	    }
		
		function checkPhone() {
		    const phone = document.querySelector('input[name="phone"]').value;
		    const phoneRegex = /^\d{11}$/;

		    if (!phoneRegex.test(phone)) {
		        alert("전화번호는 숫자만 입력하며, 11자리여야 합니다.");
		        return false;
		    }
		    return true;
		}
		
		
		
	</script>
</head>

<body>
<div class="container">
    <h2>회원가입</h2>
    <form action="/signinOK" method="post" onsubmit="return checkPasswordMatch() && checkAgreement() && multiIdCheck() && checkPhone()">

        <div class="form-group">
            <label>아이디</label>
            <div class="input-row">
                <input type="text" name="userId" id="userId" required>
                <button type="button" class="check-btn" onclick="checkDuplicateId()">중복 확인</button>
            </div>
        </div>

        <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="pw" placeholder="8자 이상, 영문+숫자 조합" required>
        </div>

        <div class="form-group">
            <label>비밀번호 확인</label>
            <input type="password" name="pwConfirm" required>
        </div>

        <div class="form-group">
            <label>이름</label>
            <input type="text" name="name" required>
        </div>

        <div class="form-group">
            <label>생년월일</label>
            <input type="date" name="birth" required>
        </div>

        <div class="form-group">
            <label>성별</label>
            <div class="radio-group">
                <div class="radio-option">
                    <input type="radio" name="gender" value="MALE" required>
                    <span>남자</span>
                </div>
                <div class="radio-option">
                    <input type="radio" name="gender" value="FEMALE">
                    <span>여자</span>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label>전화번호</label>
            <input type="text" name="phone" placeholder="- 없이 입력하세요" required>
        </div>

        <div class="form-group">
            <label>이메일</label>
            <div class="email-group">
                <input type="text" name="email" required> @
                <select name="emailDomain" id="emailDomain" onchange="checkEmailDomain()">
                    <option value="naver.com">naver.com</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="daum.net">daum.net</option>
                    <option value="custom">직접입력</option>
                </select>
                <input type="text" name="customEmail" id="customEmail" placeholder="도메인 직접입력">
            </div>
        </div>

        <div class="form-group">
            <label>주소</label>
            <input type="text" name="address" required>
        </div>

        <div class="form-group">
            <label>상세주소</label>
            <input type="text" name="detailAddress" required>
        </div>

		<div class="form-group">
		    <label>수신 동의</label>
		    <div class="radio-group">
		        <div class="radio-option">
		            <input type="radio" name="receive" value="AGREE">
		            <span>동의</span>
		        </div>
		        <div class="radio-option">
		            <input type="radio" name="receive" value="DISAGREE">
		            <span>비동의</span>
		        </div>
		    </div>
		</div>

		<div class="form-group">
		    <label>개인정보 이용 동의</label>
		    <div class="radio-group">
		        <div class="radio-option">
		            <input type="radio" name="agree" value="AGREE" required>
		            <span>동의</span>
		        </div>
		        <div class="radio-option">
		            <input type="radio" name="agree" value="DISAGREE">
		            <span>비동의</span>
		        </div>
		    </div>
		</div>
		
        <button type="submit" class="submit-btn">가입하기</button>
    </form>
</body>
</html>