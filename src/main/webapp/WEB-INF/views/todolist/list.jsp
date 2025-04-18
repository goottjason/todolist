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
	} else if (duedate == 'notnull') {
		duedate = 'notnull';
	} else if (duedate == 'null') {
		duedate = 'null';
	} else {
		duedate = '';
	}
	
	let data = {
			dno : 0,
			writer : '',
			title: '',
			duedate : duedate,
			finished : '',
			star : star,
			memo : '',
			location : ''
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

</script>
<style>
</style>
</head>

<body>
	<!-- include지시자 or 액션태그 -->
	<jsp:include page="../header.jsp"></jsp:include>

	<div class="itembox">
		<div class="left">
			<div class="container mt-3">
				<h2>사이드바</h2>
				<ul class="nav flex-column">
					<li class="nav-item"><a class="nav-link" href='javascript:void(0);' onclick="doList();">전체할일</a></li>
					<li class="nav-item"><a class="nav-link" href='javascript:void(0);' onclick="selectWhere(duedate='today', star='');">오늘할일</a></li>
					<li class="nav-item"><a class="nav-link" href='javascript:void(0);' onclick="selectWhere(duedate='', star='1');">중요</a></li>
					<li class="nav-item"><a class="nav-link" href='javascript:void(0);' onclick="selectWhere(duedate='notnull!!', star='');">기한일정</a></li>
					<li class="nav-item"><a class="nav-link" href='javascript:void(0);' onclick="selectWhere(duedate='null!!', star='');">기한미정</a></li>
					</li>
				</ul>
			</div>

		</div>
		<div class="center">
			<h1>할 일 등록</h1>
			<div class="mb-3 mt-3">
				<input type="hidden" class="form-control" id="writer"
					placeholder="작성자" name="writer" value="${authUser.userid}">
				<label for="title" class="form-label">Title :&nbsp;&nbsp;</label><span></span>
				<span id="titleError"></span> <input type="text"
					class="form-control" id="title" placeholder="제목" name="title">
			</div>
			<div class="mb-3 mt-3">
				<label for="duedate" class="form-label">dueDate
					:&nbsp;&nbsp;</label><span></span> <span id="dueDateError"></span> <input
					type="date" class="form-control" id="duedate" name="duedate">
			</div>
			<div>
				<button id="registerBtn" class="btn btn-secondary"
					onclick="register();">등록</button>
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