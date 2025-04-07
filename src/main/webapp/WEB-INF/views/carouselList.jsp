<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>표지 사진 등록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/js/bootstrap.bundle.min.js"></script>
<style>
    .drop-area {
        transition: background-color 0.3s ease;
        cursor: pointer;
    }
    .drop-area.bg-light {
        background-color: #f0f0f0;
    }
	.btn-secondary {
	  background-color: black; /* 기본보다 어두운 파랑 */
	  border-color: black;
	}
	.btn-secondary:hover {
	  background-color: white; /* 기본보다 어두운 파랑 */
	  border-color: black;
	  color: black;
	}
</style>
<script>
$(document).ready(function () {
    const allowedExtensions = ['jpg', 'jpeg', 'png'];
    let selectedFile = null;

    function validateFile(file, callback) {
        const extension = file.name.split('.').pop().toLowerCase();
        if (!allowedExtensions.includes(extension)) {
            alert("jpg, jpeg, png 파일만 업로드 가능합니다.");
            return callback(false);
        }

        const reader = new FileReader();
        reader.onload = function (e) {
            const img = new Image();
            img.onload = function () {
                if (img.width !== 1280 || img.height < 700) {
                    alert("이미지 사이즈는 1280x700px 이어야 합니다.");
                    return callback(false);
                }
                return callback(true);
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }

    function bindDropEvents(dropAreaId, inputId, fileNameId) {
        const dropArea = $(dropAreaId);
        const fileInput = $(inputId);
        const fileNameDisplay = $(fileNameId);

        dropArea.off(); // 기존 이벤트 제거

        dropArea.on('click', function () {
            fileInput.click();
        });

        fileInput.on('change', function (e) {
            const file = e.target.files[0];
            if (!file) return;

            validateFile(file, function (isValid) {
                if (isValid) {
                    selectedFile = file;
                    fileNameDisplay.text(file.name);
                } else {
                    fileInput.val('');
                    selectedFile = null;
                    fileNameDisplay.text('');
                }
            });
        });

        dropArea.on('dragover', function (e) {
            e.preventDefault();
            dropArea.addClass('bg-light');
        });

        dropArea.on('dragleave', function (e) {
            e.preventDefault();
            dropArea.removeClass('bg-light');
        });

        dropArea.on('drop', function (e) {
            e.preventDefault();
            dropArea.removeClass('bg-light');

            const file = e.originalEvent.dataTransfer.files[0];
            if (!file) return;

            validateFile(file, function (isValid) {
                if (isValid) {
                    selectedFile = file;
                    fileNameDisplay.text(file.name);
                } else {
                    selectedFile = null;
                    fileNameDisplay.text('');
                }
            });
        });
    }

    $('.open-insert-btn').on('click', function () {
        selectedFile = null;
        $('#uploadConcertId').val($(this).data('id'));
        $('#fileNameUpload').text('');
        $('#uploadModal').modal('show');
    });

    $('.open-update-btn').on('click', function () {
        selectedFile = null;
        $('#updateConcertId').val($(this).data('id'));
        $('#fileNameUpdate').text('');
        $('#updateModal').modal('show');
    });

    bindDropEvents('#dropAreaUpload', '#modalImageInput', '#fileNameUpload');
    bindDropEvents('#dropAreaUpdate', '#modalImageUpdate', '#fileNameUpdate');

    $('#uploadBtn').on('click', function () {
        if (!selectedFile) return alert("파일을 선택해주세요.");

        const concertId = $('#uploadConcertId').val();
        const formData = new FormData();
        formData.append("concertId", concertId);
        formData.append("images", selectedFile);

        $.ajax({
            url: "/insertCarouselOK",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function () {
                alert("업로드 성공!");
                $('#uploadModal').modal('hide');
                location.reload();
            },
            error: function () {
                alert("업로드 실패!");
            }
        });
    });

    $('#updateBtn').on('click', function () {
        if (!selectedFile) return alert("파일을 선택해주세요.");

        const concertId = $('#updateConcertId').val();
        const formData = new FormData();
        formData.append("concertId", concertId);
        formData.append("images", selectedFile);

        $.ajax({
            url: "/updateCarouselOK",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function () {
                alert("수정 성공!");
                $('#updateModal').modal('hide');
                location.reload();
            },
            error: function () {
                alert("수정 실패!");
            }
        });
    });

    $('.deleteBtn').on('click', function () {
    	console.log('삭제 클릭')
        const concertId = $(this).data('id');
        const formData = new FormData();
        formData.append("concertId", concertId);
        $.ajax({
            url: "/deleteCarousel",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function () {
                alert("삭제 성공!");
                location.reload();
            },
            error: function () {
                alert("삭제 실패!");
            }
        });
    });
    
    // main 에 걸 공연 1개 이상 선택 확인
    $('#myForm').on('submit', function(e) {
        // 체크된 체크박스 개수 확인
        const checkedCount = $('input[name="selectedIds"]:checked').length;
        
        if (checkedCount === 0) {
          alert("하나 이상의 공연을 선택해주세요.");
          e.preventDefault(); // 폼 제출 막기
        }
      });

});
</script>
</head>

<body>

<form id="myForm" action="/carouselListOK" method="post">
<div class="d-flex justify-content-between align-items-center my-2 container">
<table class="table mt-5">
	<thead >
		<tr >
              <th style="width: 200px; text-align: center;" > 공연제목 선택 <br/><br/> </th>
              <th style="width: 600px; text-align: center; "> 메인 표지 이미지파일 등록 <br/><br/></th>
              <td style="width: 200px text-align: center;"> <br/><br/></td>
		</tr>
	</thead>
<c:forEach var="concertVO" items="${concertList}">
      <tbody>
        <tr>
          <td scope="row" style="width: 200px">
            <c:set var="hasCarousel" value="false" />
			
			  <!-- carList 안의 concertId와 con.id 비교 -->
			  <c:forEach var="car" items="${carouselList}">
			    <c:if test="${car.concertId == concertVO.id}">
			      <c:set var="hasCarousel" value="true" />
			    </c:if>
			  </c:forEach>
			  
          <c:if test="${hasCarousel}">
          	<input type="checkbox" class="btn-check" id="btn-check-${concertVO.id }" 
          		name="selectedIds" value="${concertVO.id }" checked="checked">
			<label class="btn" for="btn-check-${concertVO.id }">${concertVO.title}</label>
          </c:if>
          <c:if test="${not hasCarousel}">
          	<input type="checkbox" class="btn-check" id="btn-check-${concertVO.id }" 
          		name="selectedIds" value="${concertVO.id }">
			<label class="btn" for="btn-check-${concertVO.id }">${concertVO.title}</label>
          </c:if>
          </td>
          <c:choose>
            <c:when test="${not empty concertVO.carouselUrl}">
              <td style="width: 600px">메인표지: ${concertVO.carouselUrl}</td>
              <td>
                <button type="button" style="background-color: #CDAA39; border-color: #CDAA39" class="btn btn-sm btn-primary open-update-btn" data-id="${concertVO.id}">수정</button>
                <button type="button" style="background-color: #78171C; border-color: #78171C" class="btn btn-sm btn-primary deleteBtn" id="deleteBtn_${concertVO.id}" data-id="${concertVO.id}">삭제</button>
              </td>
            </c:when>
            <c:otherwise>
              <td style="width: 600px"></td>
              <td>
                <button type="button" class="btn btn-sm btn-primary open-insert-btn btn-dark" data-id="${concertVO.id}">파일등록</button>
              </td>
            </c:otherwise>
          </c:choose>
        </tr>
      </tbody>
</c:forEach>
</table>
</div>
<div style="display: flex; justify-content: center;">
	<button class="btn m-2 btn-secondary" type="submit">저장하기</button>
	<button class="btn m-2 btn-outline-dark" style="border-color: black;" type="button" onclick="location.href='/'">메인홈으로</button>
</div>              
</form>

<!-- Upload Modal -->
<div class="modal fade" id="uploadModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="uploadForm">
        <div class="modal-header">
          <h5 class="modal-title">이미지 업로드</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
        	<p>이미지 사이즈는 1280x700px 이어야 합니다.</p>
          <input type="hidden" id="uploadConcertId">
          <input type="file" id="modalImageInput" accept="image/*" hidden>
          <div id="dropAreaUpload" class="drop-area border border-secondary rounded p-3 text-center">
            여기에 이미지를 드래그하거나 클릭해서 선택하세요.
          </div>
          <div id="fileNameUpload" class="mt-2 text-muted"></div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
          <button type="button" class="btn btn-primary" id="uploadBtn">업로드</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Update Modal -->
<div class="modal fade" id="updateModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form id="updateForm">
        <div class="modal-header">
          <h5 class="modal-title">이미지 수정</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
        	<p>이미지 사이즈는 1280x700px 이어야 합니다.</p>
          <input type="hidden" id="updateConcertId">
          <input type="file" id="modalImageUpdate" accept="image/*" hidden>
          <div id="dropAreaUpdate" class="drop-area border border-secondary rounded p-3 text-center">
            여기에 이미지를 드래그하거나 클릭해서 선택하세요.
          </div>
          <div id="fileNameUpdate" class="mt-2 text-muted"></div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
          <button type="button" style="background-color: #CDAA39; border-color: #CDAA39;" class="btn btn-primary" id="updateBtn">수정</button>
        </div>
      </form>
    </div>
  </div>
</div>

</body>
</html>
