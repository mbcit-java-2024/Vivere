<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매자 페이지 - 문의 내역</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
* {
	box-sizing: border-box;
}
body {
	font-family: 'Pretendard', sans-serif;
	background-color: #FAF8F6;
	color: #2B2B2B;
	margin: 0;
	padding: 40px;
}

.top-bar {
	margin-bottom: 24px;
	text-align: right;
}

.btn {
	background-color: #F5DEB3;
	color: #800020;
	padding: 8px 14px;
	border: 2px solid #D4AF37;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
	transition: all 0.3s;
}

.btn:hover {
	background-color: #E2725B; /* 코랄 강조 */
	color: white;
	border-color: #B63330;
}

.qna-box {
	background-color: #FFFFFF;
	border: 1.5px solid #F5DEB3;
	padding: 24px 28px;
	margin-bottom: 24px;
	border-radius: 12px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.qna-title {
	font-weight: bold;
	font-size: 17px;
	color: #800020; /* 메인 컬러 */
	margin-bottom: 10px;
	border-left: 5px solid #CDAA39;
	padding-left: 10px;
}

.qna-content {
	font-size: 15px;
	margin-bottom: 14px;
	line-height: 1.6;
	color: #2B2B2B;
}

.answer-box {
	background-color: #EFEED;
	border-left: 6px solid #800020; /* 버건디 강조 */
	padding: 16px;
	border-radius: 8px;
	color: #B63330;
	font-size: 14px;
	font-weight: 500;
	box-shadow: inset 0 0 0 1px #E5CD94;
}

/* ✨ 답변 제목 강조용 */
.answer-box strong {
	color: #800020;
	display: block;
	margin-bottom: 4px;
}

/* ✍ 수정 폼 */
.edit-form {
	display: none;
	margin-top: 16px;
	padding: 18px;
	background-color: #FAF8F6;
	border: 2px solid #E2725B;
	border-radius: 10px;
	box-sizing: border-box; /* ✅ 추가해주자 */
}

textarea, input[type="text"] {
	width: 100%;
	padding: 10px;
	margin-bottom: 10px;
	border: 1.5px solid #ccc;
	border-radius: 6px;
	font-size: 14px;
	background-color: #FFFFFF;
	color: #2B2B2B;
	box-sizing: border-box; /* ✅ 요거 추가하면 해결됨 */
	transition: border-color 0.2s;
}


textarea:focus, input[type="text"]:focus {
	border-color: #800020; /* 버건디 강조 */
	outline: none;
}

.edit-form button {
	background-color: #F5DEB3;
	color: #800020;
	padding: 8px 14px;
	border: 2px solid #D4AF37;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
}

.edit-form button:hover {
	background-color: #E2725B;
	color: white;
	border-color: #B63330;
}

/* ❗ 답변 없음 안내 (차콜 배경 + 코랄 텍스트) */
.no-answer-box {
	background-color: #2C2C2C;
	color: #E2725B;
	padding: 10px;
	border-radius: 8px;
	font-size: 14px;
	margin-top: 12px;
	margin-bottom: 14px; /* ✅ 이 줄 추가 */
	font-weight: 500;
}


/* 강조 텍스트 */
.sub-point {
	color: #E2725B;
	font-weight: bold;
}
</style>



<script>

function updateQna(id) {
	console.log('updateQna:::::::::::::::::::::id::::::::'+id);
    
    let content = $("#editForm-"+id).find("textarea[name='qna_content']").val();
    console.log('updateQna:::::::::::::::::::::::content::::::'+content);
    let title = $("#editForm-"+id).find("input[name='qna_title']").val();
    console.log('updateQna:::::::::::::::::::::::title::::::'+title);
    let qnaId = $("#editForm-"+id).find("input[name='qnaId']").val();
    console.log('updateQna:::::::::::::::::::::::qnaId::::::'+qnaId);
	  
	  let param = {
	    		qna_content: content
	    		, qna_title: title
	    		, qna_id: qnaId
	    };

	  $.ajax({
	    url: '/updateQna',
	    type: 'POST',
	    contentType: 'application/json',
	    data: JSON.stringify(param),
	    beforeSend:function(){
            console.log('updateQna:::::::::beforeSend::::::::::::::::::::param' + JSON.stringify(param));
        },
	    success: function(data) {
	    	console.log('success:::::::::::111::::::::::::' + JSON.stringify(data));
	      if ('0' == data.code) {
	        alert('문의가 수정되었습니다!');
	        location.reload();
	      } else {
	        alert(data.message || '문의 수정 실패');
	      }
	    },
	    error: function(err) {
	      alert('서버 오류 발생!');
	      console.error(err);
	    }
	  });
	}


    function toggleEditForm(id) {
      $(".edit-form").not("#editForm-" + id).slideUp();
      $("#editForm-" + id).slideToggle();
    }
  </script>
</head>
<body>
	<div class="top-bar">
		<button class="btn" onclick="location.href='/qnaInsert'">✉
			문의글쓰기</button>
	</div>

	<h2 class="section-title">📭 답변 대기 중인 문의</h2>

<c:forEach var="qna" items="${qnaList}">
  <c:if test="${empty qna.content}">
    <!-- 답변 없는 문의 -->
    <div class="qna-box">
      <div class="qna-title">문의 제목: ${qna.qna_title}</div>
      <div class="qna-content">문의 내용: ${qna.qna_content}</div>

      <div class="no-answer-box">
        ⏳ 아직 답변이 등록되지 않았습니다.
      </div>

      <button class="btn" onclick="toggleEditForm(${qna.qna_id})">✏ 문의 수정</button>

      <div class="edit-form" id="editForm-${qna.qna_id}">
        <form action="/qna/update" method="post">
          <input type="hidden" name="qnaId" value="${qna.qna_id}" />
          <input type="text" name="qna_title" value="${qna.qna_title}" />
          <textarea name="qna_content" style="resize: none;">${qna.qna_content}</textarea>
          <button type="button" onclick="updateQna(${qna.qna_id})">수정 저장</button>
        </form>
      </div>
    </div>
  </c:if>
</c:forEach>

<hr style="margin: 40px 0; border: none; border-top: 2px dashed #CDAA39;" />

<h2 class="section-title">✅ 답변이 완료된 문의</h2>

<c:forEach var="qna" items="${qnaList}">
  <c:if test="${not empty qna.content}">
    <!-- 답변이 있는 문의 -->
    <div class="qna-box">
      <div class="qna-title">문의 제목: ${qna.qna_title}</div>
      <div class="qna-content">문의 내용: ${qna.qna_content}</div>

      <div class="answer-box">
        <strong>답변 제목: ${qna.title}</strong><br />
        답변 내용: ${qna.content}
      </div>
    </div>
  </c:if>
</c:forEach>



</body>
</html>
