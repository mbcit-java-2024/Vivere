<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>관리자 페이지 - 문의 내역 리스트</title>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

<style>
body {
	font-family: 'Pretendard', sans-serif;
	background-color: #FAF8F6;
	color: #2B2B2B;
	margin: 0;
	padding: 40px;
}

h2 {
	color: #800020;
	margin-bottom: 30px;
}

.qna-box {
	background-color: #FFFFFF;
	border: 2px solid #E5CD94;
	padding: 24px 28px;
	margin-bottom: 28px;
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.qna-header {
	font-weight: bold;
	font-size: 18px;
	color: #800020;
	border-left: 5px solid #CDAA39;
	padding-left: 10px;
	margin-bottom: 12px;
}

.qna-content {
	font-size: 15px;
	margin-bottom: 16px;
	line-height: 1.6;
}

.answer-box {
	background-color: #EFEEED;
	border-left: 6px solid #800020;
	padding: 16px;
	border-radius: 10px;
	color: #B63330;
	font-size: 14px;
	font-weight: 500;
	box-shadow: inset 0 0 0 1px #E5CD94;
	margin-bottom: 14px;
}

.answer-box strong {
	color: #800020;
	display: block;
	margin-bottom: 6px;
}

.answer-btn {
	background-color: #F5DEB3;
	color: #800020;
	padding: 8px 14px;
	border: 2px solid #D4AF37;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
	margin-bottom: 12px;
	transition: all 0.3s;
}

.answer-btn:hover {
	background-color: #E2725B;
	color: white;
	border-color: #B63330;
}

.answer-form, .answer-edit-form {
	display: none;
	background-color: #FAF8F6;
	border: 2px solid #E2725B;
	padding: 20px;
	border-radius: 10px;
	margin-top: 12px;
}

.answer-form input[type="text"], .answer-edit-form input[type="text"],
	textarea {
	width: 100%;
	padding: 10px 12px;
	margin-bottom: 12px;
	border: 1.5px solid #CDAA39;
	border-radius: 6px;
	font-size: 14px;
	background-color: #FFFFFF;
	color: #2B2B2B;
	box-sizing: border-box;
	transition: border-color 0.3s;
}

textarea {
	resize: none;
	height: 120px;
}

textarea:focus, input[type="text"]:focus {
	border-color: #800020;
	outline: none;
}

.answer-form button, .answer-edit-form button {
	background-color: #F5DEB3;
	color: #800020;
	border: 2px solid #D4AF37;
	padding: 8px 14px;
	font-weight: bold;
	font-size: 14px;
	border-radius: 6px;
	cursor: pointer;
}

.answer-form button:hover, .answer-edit-form button:hover {
	background-color: #E2725B;
	color: white;
	border-color: #B63330;
}

/* 답변쓰기 버튼 */
.answer-btn.write {
  background-color: #F5DEB3; /* 소프트 골드 */
  color: #800020;
  border: 2px solid #D4AF37;
}

/* 답변수정 버튼 */
.answer-btn.edit {
  background-color: #E2725B; /* 뮤트 코랄 */
  color: #FFFFFF;
  border: 2px solid #CDAA39;
}

/* 공통 hover 효과 */
.answer-btn:hover {
  background-color: #B63330; /* 진한 레드 */
  color: white;
  border-color: #B63330;
}

</style>


<script type="text/javascript">

function updateQnarep(id) {
    
    let content = $("#editForm-"+id).find("textarea[name='content']").val();
    console.log('updateQnarep:::::::::::::::::::::::content::::::'+content);
    let title = $("#editForm-"+id).find("input[name='title']").val();
    console.log('updateQnarep:::::::::::::::::::::::title::::::'+title);
    let rep_id = $("#editForm-"+id).find("input[name='rep_id']").val();
    console.log('updateQnarep:::::::::::::::::::::::rep_id::::::'+rep_id);
	  
	  let param = {
	    		content: content
	    		, title: title
	    		, rep_id: rep_id
	    };

	  $.ajax({
	    url: '/updateQnarep',
	    type: 'POST',
	    contentType: 'application/json',
	    data: JSON.stringify(param),
	    beforeSend:function(){
            console.log('updateQna:::::::::beforeSend::::::::::::::::::::param' + JSON.stringify(param));
        },
	    success: function(data) {
	    	console.log('success:::::::::::111::::::::::::' + JSON.stringify(data));
	      if ('0' == data.code) {
	        alert('답변이 수정되었습니다!');
	        location.reload();
	      } else {
	        alert(data.message || '답변 수정 실패');
	      }
	    },
	    error: function(err) {
	      alert('서버 오류 발생!');
	      console.error(err);
	    }
	  });
	}


	function insertRep(id) {
	    console.log('insertRep:::::::::::::::::::::id::::::::'+id);
	    
	   	let input = $("#answerForm-"+id).find("input[name='title']").val();
	    console.log('insertRep:::::::::::::::::::::::input::::::'+input);
	   	let textarea = $("#answerForm-"+id).find("textarea[name='content']").val();
	    console.log('insertRep:::::::::::::::::::::::textarea::::::'+textarea);
	   	let qnaId = $("#answerForm-"+id).find("input[name='qnaId']").val();
	    console.log('insertRep:::::::::::::::::::::::qnaId::::::'+qnaId);
	    
	    if ('' == input) {
	    	alert('답변 제목을 입력하세요.');
	    	return;
	    }
	    if ('' == textarea) {
	    	alert('답변 내용을 입력하세요');
	    	return;
	    }
	    
	    
	    
	    let param = {
	    		title: input
	    		, content: textarea
	    		, qnaId: qnaId
	    };
	   	
	     
	    $.ajax({
	        url : '/insertRep',
	        type : 'POST',
	        dataType : "json",
	        contentType:"application/json",
	        data : JSON.stringify(param),
	        beforeSend:function(){
	            console.log('insertRep:::::::::beforeSend::::::::::::::::::::param' + JSON.stringify(param));
	        },
	        success : function(data){
	            console.log('success:::::::::::111::::::::::::' + JSON.stringify(data));
	            if ('0' == data.code) {
	            	 location.reload();
	            } else {
            		if (null != data.message) {
            			alert(data.message);
            		}
            		else {
            			alert('알수없는 에러');
            		}
	            	
	            }
	        },
	        error : function(request, status, error){
	            console.log('responseText::::::::::::::::::::::::'+request.responseText);
	        },
	        complete:function(){}
	    });
	}
	function toggleAnswerForm(id) {
	      $(".answer-form").not("#answerForm-" + id).slideUp();
	      $("#answerForm-" + id).slideToggle();
	      $(".answer-edit-form").slideUp();
	    }

	    function toggleEditForm(id) {
	      $(".answer-edit-form").not("#editForm-" + id).slideUp();
	      $("#editForm-" + id).slideToggle();
	      $(".answer-form").slideUp();
	    }

</script>
</head>
<body>
<jsp:include page="./include/header.jsp"/>
<div class="wrapper">
	<h2>📬 답변이 없는 문의</h2>

<c:forEach var="qna" items="${qnaList}">
  <c:if test="${empty qna.content}">
    <div class="qna-box">
      <div class="qna-header">문의 제목: ${qna.qna_title}</div>
      <div class="qna-content">문의 내용: ${qna.qna_content}</div>

      <button class="answer-btn write" onclick="toggleAnswerForm(${qna.qna_id})">🖋 답변쓰기</button>

      <div class="answer-form" id="answerForm-${qna.qna_id}">
        <form action="" method="">
          <input type="hidden" name="qnaId" value="${qna.qna_id}" />
          <input type="text" name="title" placeholder="답변 제목을 입력하세요" />
          <textarea name="content" placeholder="답변 내용을 입력하세요"></textarea>
          <button type="button" onclick="insertRep(${qna.qna_id})">답변저장</button>
        </form>
      </div>
    </div>
  </c:if>
</c:forEach>

<hr style="margin: 40px 0; border: none; border-top: 2px dashed #CDAA39;" />

<h2>✅ 답변이 완료된 문의</h2>

<c:forEach var="qna" items="${qnaList}">
  <c:if test="${not empty qna.content}">
    <div class="qna-box">
      <div class="qna-header">문의 제목: ${qna.qna_title}</div>
      <div class="qna-content">문의 내용: ${qna.qna_content}</div>

      <div class="answer-box">
        <strong>답변 제목: ${qna.title}</strong><br />
        답변 내용: ${qna.content}
      </div>

      <button class="answer-btn edit" onclick="toggleEditForm(${qna.rep_id})">✏ 답변 수정</button>
      <button class="answer-btn edit" onclick="location.href='/deleteRep/${qna.rep_id}'">🗑 답변 삭제</button>

      <div class="answer-edit-form" id="editForm-${qna.rep_id}">
        <form action="" method="">
          <input type="hidden" name="rep_id" value="${qna.rep_id}" />
          <input type="hidden" name="id" value="${qna.id}" />
          <input type="text" name="title" value="${qna.title}" placeholder="답변 제목" />
          <textarea name="content">${qna.content}</textarea>
          <button type="button" onclick="updateQnarep(${qna.rep_id})">수정저장</button>
        </form>
      </div>
    </div>
  </c:if>
</c:forEach>


<jsp:include page="./include/footer.jsp"/>

</div>
</body>
</html>

