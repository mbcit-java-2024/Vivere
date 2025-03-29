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
<title>관리자 페이지 - 문의 내용 리스트</title>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

<style>
.qna-box {
	border: 1px solid #ccc;
	padding: 16px;
	margin-bottom: 20px;
	border-radius: 8px;
	background-color: #f9f9f9;
}

.qna-header {
	font-weight: bold;
	font-size: 18px;
	margin-bottom: 8px;
}

.qna-content {
	margin-bottom: 12px;
}

.answer-box {
	background-color: #eef;
	padding: 10px;
	border-radius: 6px;
	margin-bottom: 8px;
}

.answer-form, .answer-edit-form {
	display: none;
	margin-top: 10px;
}

textarea, input[type="text"] {
	width: 100%;
	padding: 8px;
	margin-bottom: 6px;
}

.answer-btn {
	margin-top: 6px;
	cursor: pointer;
}
</style>

<script type="text/javascript">
	function insertRep(id) {
	    console.log('insertRep:::::::::::::::::::::id::::::::'+id);
	    
	   	let input = $("#answerForm-"+id).find("input[name='title']").val();
	    console.log('insertRep:::::::::::::::::::::::input::::::'+input);
	   	let textarea = $("#answerForm-"+id).find("textarea[name='content']").val();
	    console.log('insertRep:::::::::::::::::::::::textarea::::::'+textarea);
	   	let qnaId = $("#answerForm-"+id).find("input[name='qnaId']").val();
	    console.log('insertRep:::::::::::::::::::::::qnaId::::::'+qnaId);
	    
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
	            	 // location.href = '/orderOKPage?orderIds=' + data.orderIds;
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

</script>
</head>
<body>
	<h2>문의 리스트 (관리자 화면)</h2>

	<c:forEach var="qna" items="${qnaList}">
		<div class="qna-box">
			<!-- 문의 제목 -->
			<div class="qna-header">${qna.qna_title}</div>

			<!-- 문의 내용 -->
			<div class="qna-content">${qna.qna_content}</div>

			<!-- 답변 여부에 따라 분기 -->
			<c:choose>
				<c:when test="${not empty qna.content}">
					<!-- 답변 내용 -->
					<div class="answer-box">
						<strong>답변 제목: ${qna.title}</strong><br /> ${qna.content}
					</div>

					<!-- 답변 수정 버튼 -->
					<button class="answer-btn" onclick="toggleEditForm(${qna.qna_id})">✏
						답변수정</button>

					<!-- 답변 수정 폼 -->
					<div class="answer-edit-form" id="editForm-${qna.qna_id}">
						<form action="/qnaRep/update" method="post">
							<input type="hidden" name="qnaId" value="${qna.qna_id}" /> <input
								type="text" name="qnatitle" value="${qna.title}"
								placeholder="답변 제목" />
							<textarea name="qnacontent">${qna.content}</textarea>
							<button type="submit">수정저장</button>
						</form>
					</div>
				</c:when>

				<c:otherwise>
					<!-- 답변쓰기 버튼 -->
					<button class="answer-btn"
						onclick="toggleAnswerForm(${qna.qna_id})">🖋 답변쓰기</button>

					<!-- 답변 입력 폼 -->
					<div class="answer-form" id="answerForm-${qna.qna_id}">
						<form action="" method="">
							<input type="hidden" name="qnaId" value="${qna.qna_id}" /> <input
								type="text" name="title" placeholder="답변 제목을 입력하세요" /> 
							<textarea name="content" placeholder="답변 내용을 입력하세요"></textarea>
							<button type="button" onclick="insertRep(${qna.qna_id})">답변저장</button>
						</form>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</c:forEach>

	<script>
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


</body>
</html>

