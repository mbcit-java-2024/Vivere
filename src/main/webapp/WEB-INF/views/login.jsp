<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
	
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
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

        input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
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

        .link-group {
            text-align: center;
            margin-top: 20px;
        }

        .link-group a {
            color: #888;
            font-size: 14px;
            text-decoration: none;
        }

        .link-group a:hover {
            text-decoration: underline;
            color: #555; 
        }
    </style>
</head>

<body>
	<c:if test="${not empty message}">
	    <script>
	        alert("${message}");
	    </script>
	</c:if>
	
	<c:if test="${not empty error}">
	    <script>
	        alert("${error}");
	    </script>
	</c:if>
	
	<div class="container">
	    <h2>로그인</h2>
	    <form action="/loginOK" method="post">
	
	        <div class="form-group">
	            <label for="userId">아이디</label>
	            <input type="text" id="userId" name="userId" required>
	        </div>
	
	        <div class="form-group">
	            <label for="pw">비밀번호</label>
	            <input type="password" id="pw" name="pw" required>
	        </div>
	
	       
	        <button type="submit" class="submit-btn">로그인</button>
	
	    
	        <div class="link-group">
	            <a href="/signin">회원가입</a> /
	            <a href="/findIdPassword">아이디/비밀번호 찾기</a>
	        </div>
			
	    </form>
	</div>
</body>
</html>