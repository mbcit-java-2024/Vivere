<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>📢 공지사항 작성</title>
<style>
form {
  width: 600px;
  margin: 50px auto;
  padding: 30px;
  border: 1px solid #ccc;
  border-radius: 10px;
}
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
</style>

</head>
<body>

<h2 style="text-align: center;">✍ 공지사항 작성</h2>

<form action="/noticeInsertOK" method="post">
  <label for="title">제목</label><br/>
  <input type="text" name="title" id="title" required /><br/>

  <label for="content">내용</label><br/>
  <textarea name="content" id="content" rows="8" required></textarea><br/>

  <label>
    <input type="checkbox" name="status" value="1" checked />
    중요한 공지사항
  </label><br/><br/>

  <button type="submit" >등록하기</button>
</form>

</body>
</html>
