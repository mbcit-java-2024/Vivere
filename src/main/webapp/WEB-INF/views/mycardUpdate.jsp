<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>카드 수정</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            display: flex;
            max-width: 1200px;
            margin: 50px auto;
            gap: 40px;
        }
        .content {
            flex-grow: 1;
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
            color: #555;
        }
        input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
		.sidebar {
		    width: 200px;
		    background-color: #fff;
		    padding: 20px;
		    border-radius: 10px;
		    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
		    position: sticky;
		    top: 30px;
		    height: fit-content;
		    align-self: flex-start;
		}

		.sidebar a {
		    display: block;
		    margin-bottom: 10px;
		    font-size: 14px;
		    color: #555;
		    text-decoration: none;
		}

		.sidebar a:hover {
		    color: #f97316;
		}

        .card-inputs {
            display: flex;
            gap: 10px;
        }
        .card-inputs input {
            width: 60px;
            text-align: center;
        }
        .submit-btn {
            margin-top: 20px;
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
</head>
<body>

<div class="container">

    <jsp:include page="myinfoMenu.jsp" />

    <div class="content">
        <h2>카드 수정</h2>

        <form action="/mycardUpdateOK" method="post">
            <!-- 카드 ID (필수) -->
            <input type="hidden" name="id" value="${card.id}"/>
			
			<div class="form-group">
			    <label>은행명</label>
			    <input type="text" name="bankName" placeholder="예: 국민은행" required>
			</div>

            <!-- 카드번호 (4칸) -->
            <div class="form-group">
                <label>카드번호</label>
                <div class="card-inputs">
                    <input type="text" name="card1" maxlength="4" required>
                    <input type="text" name="card2" maxlength="4" required>
                    <input type="text" name="card3" maxlength="4" required>
                    <input type="text" name="card4" maxlength="4" required>
                </div>
            </div>

            <!-- 카드 비밀번호 -->
            <div class="form-group">
                <label>카드 비밀번호 (숫자 4자리)</label>
                <input type="password" name="pw" maxlength="4">
            </div>

            <!-- CVC -->
            <div class="form-group">
                <label>CVC</label>
                <input type="text" name="cvc" maxlength="3" required>
            </div>

            <!-- 유효기간 -->
            <div class="form-group">
                <label>유효기간 (예: 2025-12-31)</label>
                <input type="text" name="validDate" placeholder="예: 2025-12-31" required>
            </div>

            <button type="submit" class="submit-btn">수정하기</button>
        </form>
    </div>
</div>

</body>
</html>