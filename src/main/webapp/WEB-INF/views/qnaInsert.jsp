<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<style>
body {
	font-family: 'Pretendard', sans-serif;
	background-color: #FAF8F6; /* 메인배경 */
	margin: 0;
	padding: 60px 20px;
	color: #2B2B2B; /* 본문 텍스트 */
}

.form-container {
	max-width: 500px;
	margin: 0 auto;
	background-color: #EFEEED; /* 흰색에 가까운 아이보리 */
	border: 2px solid #E5CD94; /* 라이트 골드 테두리 */
	border-radius: 12px;
	padding: 30px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
}

input[type="text"], textarea {
	width: 100%;
	padding: 12px 14px;
	margin-bottom: 16px;
	border: 1.5px solid #CDAA39; /* 황토색 포인트 */
	border-radius: 8px;
	font-size: 15px;
	background-color: #FFFFFF;
	color: #2B2B2B;
	transition: border-color 0.3s;
	box-sizing: border-box;
}

input[type="text"]:focus, textarea:focus {
	border-color: #800020; /* 포커스 시 버건디 */
	outline: none;
}

textarea {
	resize: none;
	height: 140px;
}

.submit-btn {
	width: 100%;
	background-color: #F5DEB3; /* 소프트 골드 */
	color: #800020; /* 버튼 텍스트 - 버건디 */
	border: 2px solid #D4AF37; /* 포인트 골드 */
	padding: 12px;
	font-weight: bold;
	font-size: 16px;
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.3s;
}

.submit-btn:hover {
	background-color: #E2725B; /* 뮤트 코랄 hover */
	color: white;
	border-color: #B63330; /* 진한 분홍 */
}
</style>

</head>
<body>
	<form action="/qnaInsertOK" method="post">
		<!-- 여기서 이렇게하고 -->
		<div class="form-container">
			<input type="text" name="qna_title" placeholder="문의 제목 입력칸" />
			<textarea name="qna_content" placeholder="문의 내용 입력칸"></textarea>
			<button type="submit" class="submit-btn">문의 저장</button>
		</div>
	</form>
</body>
</html>


