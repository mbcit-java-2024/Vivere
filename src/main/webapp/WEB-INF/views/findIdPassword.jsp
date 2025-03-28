<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디/비밀번호 찾기</title>
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
            margin-bottom: 25px;
            font-size: 24px;
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
            margin-top: 30px;
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

        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin: 30px 0 15px;
            color: #222;
            border-bottom: 2px solid #ddd;
            padding-bottom: 5px;
        }
		
		a {
		    color: #888;
		    text-decoration: underline;
		    font-size: 14px;
		    font-weight: normal;
		    display: inline;
		    margin: 0 auto;
		}
		
		a:hover {
		    text-decoration: underline;
		    color: #555; 
		}


		.btn {
		    text-align: center;
		    margin-top: 20px;
		}

    </style>
</head>
<body>
	<div class="container">
	    <h2>아이디 / 비밀번호 찾기</h2>
	
	    <form action="/findId" method="post">
	        <div class="section-title">아이디 찾기</div>
	        <div class="form-group">
	            <label for="name">이름</label>
	            <input type="text" name="name" id="name" required>
	        </div>
	        <div class="form-group">
	            <label for="email">이메일</label>
	            <input type="text" name="email" id="email" required>
	        </div>
	        <button type="submit" class="submit-btn">아이디 찾기</button>
	    </form>
	
	    <form action="/findPw" method="post" style="margin-top: 40px;">
	        <div class="section-title">비밀번호 찾기</div>
	        <div class="form-group">
	            <label for="userId">아이디</label>
	            <input type="text" name="userId" id="userId" required>
	        </div>
	        <div class="form-group">
	            <label for="emailPw">이메일</label>
	            <input type="text" name="email" id="emailPw" required>
	        </div>
	        <button type="submit" class="submit-btn">비밀번호 찾기</button>
	    </form>
		<div class="btn">
			<a href="/login">로그인창으로  돌아가기</a>
		</div>
	</div>
</body>
</html>