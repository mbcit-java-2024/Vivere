<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 완료</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 500px;
            margin: 100px auto;
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 30px;
        }

        .found-id {
            font-size: 20px;
            font-weight: bold;
            color: #000;
            margin-bottom: 30px;
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
	    <h2>아이디 찾기 완료</h2>
	    
		<c:if test="${empty findId}">
		    <div class="found-id">
		        <span style="color: dodgerblue;">일치하는 정보가 없습니다.</span>
		    </div>
			<div class="btn">
				<a href="/findIdPassword" class="btn">다시 입력하기</a>
			</div>
		</c:if>
		
		<c:if test="${not empty findId}">
		    <div class="found-id">
		        당신의 아이디는 <span style="color: dodgerblue;">${findId}</span> 입니다.
		    </div>
			<div class="btn">
			    <a href="/login" class="btn">로그인 하러 가기</a>
			</div>
		</c:if>
	
	</div>
</body>
</html>