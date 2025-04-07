<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vivere - 공지사항</title>
<style>
label {
  font-weight: bold;
}
input[type="text"], textarea {
  width: 100%;
  padding: 10px;
  margin-top: 5px;
  margin-bottom: 20px;
  border: 1px solid #aaa;
  border-radius: 5px;
}
button {
  padding: 10px 20px;
  background-color: #CDAA39;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
.body-contents {
  width: 900px;
  margin: 50px auto;
  padding: 30px;
  border: 1px solid #ccc;
  border-radius: 10px;
}
</style>

</head>
<body>

<div class="wrapper">
	<jsp:include page="./include/header.jsp"/>
	<div class="body-main body-contents">
		<h2 style="text-align: left;">공지작성</h2>
		<form action="/noticeInsertOK" method="post">
			<div style="display: flex; justify-content: right;">
				<label>
					<input type="checkbox" name="status" value="1" checked/> 상단고정
				</label><br/>
			</div>
			<label for="title">&nbsp;제목</label><br/>
			<input type="text" name="title" id="title" required /><br/>
			
			<label for="content">&nbsp;내용</label><br/>
			<textarea name="content" id="content" rows="8" required style="resize: none; height: 500px;"></textarea><br/>
			
			
			<button type="submit">등록하기</button>
		</form>
	</div>
	<jsp:include page="./include/footer.jsp"/>
</div>
</body>
</html>
