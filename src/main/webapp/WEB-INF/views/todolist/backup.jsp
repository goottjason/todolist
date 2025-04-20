<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript"><%@ include file="../script.js" %></script>
<script src="https://kit.fontawesome.com/9bef4b10f4.js" crossorigin="anonymous"></script>
<style><%@include file="../style.css"%></style>
<title>다이어리목록</title>
<script type="text/javascript">
$(function() {
	
	$(document).on('click', '.editable-title', function() {
		  var $span = $(this);
		  var $input = $span.siblings('.edit-input');
		  $input.val($span.text()).show().focus();
		  $span.hide();
		});

		$(document).on('keydown', '.edit-input', function(e) {
		  if (e.key === "Enter") {
		    var $input = $(this);
		    var value = $input.val();
		    var $span = $input.siblings('.editable-title');
		    $span.text(value).show();
		    $input.hide();
		    modify(value); // 엔터 시 modify 함수 실행
		  }
		});

		$(document).on('blur', '.edit-input', function() {
		  var $input = $(this);
		  var $span = $input.siblings('.editable-title');
		  $span.text($input.val()).show();
		  $input.hide();
		});
	
	
	$(function() {
		  $('#sortBtn').on('click', function(e) {
		    e.stopPropagation();
		    var btnOffset = $(this).offset();
		    var btnHeight = $(this).outerHeight();
		    $('#sortModal').show();
		    // 버튼 바로 아래에 위치
		    $('#sortModal .modal-content').css({
		      left: btnOffset.left + 'px',
		      top: (btnOffset.top + btnHeight) + 'px'
		    });
		  });

		  $('.close').on('click', function(e) {
		    e.stopPropagation();
		    $('#sortModal').hide();
		  });

		  $('#sortModal .modal-content').on('click', function(e) {
		    e.stopPropagation();
		  });

		  $(document).on('click', function() {
		    $('#sortModal').hide();
		  });
		});
	
	
	
	doList();
	
	let today = new Date().toISOString().substring(0, 10);
	console.log(today);
	$("#duedate").val(today);
	$("#from").val(today);
	$("#to").val(today);
	
	
	
	
	$('input:radio[name="finished"]').change(function() {
	      doSearch();
	    });
	    $("#searchWord").on("keyup", function() {
	      let searchWord = $("#searchWord").val();
	      if (searchWord.length != 0) {
	        doSearch();       
	      } else {
	        let result = ajaxFunc("/todolist/selectall", null, null);
//	        console.log(result);
	        doList(result);
	      }
	    });
	
	
	
	
  $("#searchBtn").click(function() {   
      $("#searchFormCard").toggle();
    });
  
  $(".finishedCheckbox").change(function() {
	  
    let dno = $(this).data("dno");
    let checked = $(this).is(":checked");

    let data = {
    		"dno": dno,
        "finished" : checked
    }
    
    let result = ajaxFunc("/todolist/updateFinished", data, "text");
    
    if (result =='success') {
        if(checked) {
          $("#dlist-"+dno).addClass("completed");
        } else {
          $("#dlist-"+dno).removeClass("completed");
        }
        self.location='/todolist/list';
    }
  });
  
  $("body").on("click",".modBtn", function() {
    let dno = $(this).data("dno");
    let title = $(this).data("title");
    let duedate = $(this).data("date");
    
    console.log(dno, title, duedate);

    $("#dconbtn-"+dno).show();
    $("#dmodbtn-"+dno).hide();
    let modTitleInput = `
    <input type="text" id="dtitleinput-\${dno}">`;
    $('#dtitlediv-'+dno).replaceWith(modTitleInput);
    $('#dtitleinput-'+dno).val(title);

    let modDuedateInput = `
    <input type="date" id="dduedateinput-\${dno}">`;
    $('#dduedatediv-'+dno).replaceWith(modDuedateInput);
    $('#dduedateinput-'+dno).val(duedate);
    
  });
  
  
  $("body").on("click",".conBtn", function() {
	  let dno = $(this).data("dno");
		let title = $("#dtitleinput-"+dno).val();
		let duedate = $("#dduedateinput-"+dno).val();
		let data = {
			dno: dno,
      title: title,
      duedate: duedate
		}
		
		let result = ajaxFunc("/todolist/updateTodo", data, "text");
		
		if (result =='success') {
      self.location='/todolist/list';
    }
  });
  $("body").on("click",".detailConBtn", function() {
	    let dno = $(this).data("dno");
	    let writer = $(this).data("writer");
	    let title = $("#detailtitle-"+dno).val();
	    let duedate = $("#detailduedate-"+dno).val();
	    let memo = $("#detailmemo-"+dno).val();
	    let location = $("#detaillocation-"+dno).val();
	    let data = {
	      dno: dno,
	      writer: writer,
	      title: title,
	      duedate: duedate,
	      memo: memo,
	      location:location
	    }
	    
	    let result = ajaxFunc("/todolist/updateTodo", data, "text");
	    let today = new Date();
	    nowUpdateTime = today.toLocaleString()
	    $("#nowUpdateTime").html(nowUpdateTime);
	    $("#updateTimeView").show();
	    doList();
// 	    if (result =='success') {
// 	      self.location='/todolist/list';
// 	    }
	  });
  
  
  $("body").on("click",".delBtn", function() {
	  let dno = $(this).data("dno");
	  let data = {
			"dno": dno
	  }
	  let result = ajaxFunc("/todolist/deleteTodo", data, "text");
    if (result =='success') {
      self.location='/todolist/list';
    }
  });
  $("body").on("click", ".titleA", function() {
	  
	  let dno = $(this).data("dno");
	  console.log(dno);
	  let data = {
		      "dno": dno
		}
	  let result = ajaxFunc("/todolist/selectone", data, null);
	  let html = jQuery('<div>').html(result);
	  let contents = html.find("div#ajaxTodoDetail").html();
	//   console.log(contents);
	  $("#todoDetail").html(contents);
  })
  
  
});

function register() {
	let title = $("#title").val();
	let duedate = $("#duedate").val();
	let writer = $("#writer").val()
	console.log("register()", title, duedate, writer);
	let data = {
		writer: writer,
	  title: title,
	  duedate: duedate,
	}
	let result = ajaxFunc("/todolist/register", data, "text");
	if (result == "success") {
		self.location='/todolist/list';
	}
}
 
function doList() {
	let result = ajaxFunc("/todolist/selectall", null, null);
	let html = jQuery('<div>').html(result);
  let contents = html.find("div#ajaxList").html();
//   console.log(contents);
  $("#todolist").html(contents);
}

function selectWhere(duedate, star) {
	console.log(duedate, star);
	if (duedate == 'today') {
		let today = new Date().toISOString().substring(0, 10);
		duedate = today;
	}
	
	let data = {
			duedate : duedate,
			star : star,
	}
	let result = ajaxFunc("/todolist/selectwhere", data, null);
	let html = jQuery('<div>').html(result);
  let contents = html.find("div#ajaxList").html();
  $("#todolist").html(contents);
	
}

function doSearch() {
  let searchTypes = "title";
  let searchWord = $("#searchWord").val();
  let finished = $('input:radio[name="finished"]:checked').val();
  let from = $("#from").val();
  let to = $("#to").val();
  console.log(searchTypes, searchWord, finished, from, to);
  let data = {
	searchTypes : searchTypes,
    searchWord : searchWord,
    finished : finished,
    from : from,
    to : to
  }
  let result = ajaxFunc("/todolist/search", data, null);
  let html = jQuery('<div>').html(result);
  let contents = html.find("div#ajaxList").html();
  console.log(contents);
  $("#todolist").html(contents);
}

function modify(newValue) {
	  // 원하는 동작을 여기에 작성
	  alert('수정된 값: ' + newValue);
	}

</script>
<style>
.modal {
  display: none;
  position: fixed;
  left: 0; top: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(0,0,0,0.1);
  z-index: 1000;
}
.modal-content {
  background: #fff;
  border-radius: 8px;
  padding: 16px 24px;
  box-shadow: 0 2px 16px rgba(0,0,0,0.15);
  min-width: 180px;
  max-width: 30vw;
  position: absolute;
}
.close {
  position: absolute;
  right: 12px; top: 8px;
  font-size: 20px;
  cursor: pointer;
}

.edit-input {
  border: none;
  background: transparent;
  font-size: inherit;
  width: 80px;
  outline: none;
  padding: 0;
}
.editable-title {
  cursor: pointer;
}
</style>
</head>

<body>



  <!-- 정렬기준 모달 요소 -->
  <div id="sortModal" class="modal">
    <div class="modal-content">
      <span class="close">&times;</span>
      <h2>정렬 기준 선택</h2>
      <ul>
        <li>중요도</li>
        <li>기한</li>
        <li>제목</li>
        <li>만든 날짜</li>
      </ul>
    </div>
  </div>



	<!-- 헤더영역 -->
	<jsp:include page="../header.jsp"></jsp:include>



  <!-- 페이지 영역 -->
	<div class="itembox">
  
  
  
    <!-- 왼쪽 사이드바 -->
		<div class="left">
			<div class="container mt-3">
				<ul class="nav flex-column">
					<li class="nav-item">
            <a class="nav-link" href='javascript:void(0);' onclick="selectWhere(duedate='today', star='all');">오늘 할 일</a>
          </li>
					<li class="nav-item">
            <a class="nav-link" href='javascript:void(0);' onclick="doList();">모두</a>
          </li>
					<li class="nav-item">
            <a class="nav-link" href='javascript:void(0);' onclick="selectWhere(duedate='all', star='checked');">중요</a>
          </li>
					<li class="nav-item">
            <a class="nav-link" href='javascript:void(0);' onclick="selectWhere(duedate='isnotnull', star='all');">기한일정</a>
          </li>
					<li class="nav-item">
            <a class="nav-link" href='javascript:void(0);' onclick="selectWhere(duedate='isnull', star='all');">기한미정</a>
          </li>
				</ul>
			</div>
		</div>
    
    
    <!-- 중앙 -->
		<div class="center">
    
    
    
      <!-- 할일 추가 바 --> 
      <div class="todo-box">
        <div class="todo-input-row">
          <span class="circle"></span>
          <input class="todo-input" type="text" placeholder="작업 추가" />
        </div>
        <div class="todo-footer">
          <div class="todo-icons">
            <span class="icon">🗓️</span>
            <span class="icon">
              <i id="3462098" class="fa-regular fa-star" style="color:#1e3050" aria-hidden="false"></i>
            </span>
            <span class="icon">➕</span>
          </div>
          <button class="add-btn" onclick="register();">추가</button>
        </div>
      </div>



<div class="table-box" style="background:#fff; border-radius:8px; box-shadow:0 2px 8px #eee; padding:16px;">
  <table style="width:100%; border-collapse:collapse; table-layout:fixed;">
    <!-- 컬럼 너비 고정 -->
    <colgroup>
      <col style="width:50%;">
      <col style="width:18%;">
      <col style="width:12%;">
      <col style="width:20%;">
    </colgroup>
    
    <!-- 컬럼 영역 -->
    <thead>
      <tr style="border-bottom:1px solid #f0f0f0;">
        <th style="text-align:left; padding:8px 12px;">제목</th>
        <th style="text-align:left; padding:8px 12px;">기한</th>
        <th style="text-align:left; padding:8px 12px;">중요도</th>
        <th style="text-align:left; padding:8px 12px;">관리</th>
      </tr>
    </thead>
    
    <!-- 내용 -->
    <tbody>
      <tr>
        <td style="padding:8px 12px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
  <input type="radio" name="todo1" />
  <span class="editable-title" tabindex="0">일정등록</span>
  <input type="text" class="edit-input" style="display:none; border:none; background:transparent; font-size:inherit; width:80px; outline:none;" />
</td>
        <td style="padding:8px 12px;">2025.04.25.</td>
        <td style="padding:8px 12px;">
          <span style="color:#4b87c6;">☆</span>
        </td>
        <td style="padding:8px 12px;">
          <button style="border:1px solid #b1b1a8; border-radius:4px; padding:1px 6px; background:#fff; color:#4b87c6; margin-right:2px; cursor:pointer; font-size:12px;">수정</button>
          <button style="border:1px solid #e57373; border-radius:4px; padding:1px 6px; background:#fff; color:#e57373; cursor:pointer; font-size:12px;">삭제</button>
        </td>
      </tr>
      <tr>
        <td style="padding:8px 12px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
          <input type="radio" name="todo1" />
          일정등록
        </td>
        <td style="padding:8px 12px;">2025.04.25.</td>
        <td style="padding:8px 12px;">
          <span style="color:#4b87c6;">☆</span>
        </td>
        <td style="padding:8px 12px;">
          <button style="border:1px solid #b1b1a8; border-radius:4px; padding:1px 6px; background:#fff; color:#4b87c6; margin-right:2px; cursor:pointer; font-size:12px;">수정</button>
          <button style="border:1px solid #e57373; border-radius:4px; padding:1px 6px; background:#fff; color:#e57373; cursor:pointer; font-size:12px;">삭제</button>
        </td>
      </tr>
    </tbody>
  </table>
</div>








			<hr>
			<h1>To Do</h1>
			<div id="todolist"></div>
		</div>
		<div class="right">
		  <div id="todoDetail"></div>
		</div>
	</div>

	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>