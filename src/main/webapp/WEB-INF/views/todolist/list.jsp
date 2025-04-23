<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>


<html>

<head>

<meta charset="UTF-8">
<title>다이어리목록</title>

<!-- 외부 라이브러리 및 스타일 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript"><%@ include file="../script.js" %></script>
<script src="https://kit.fontawesome.com/9bef4b10f4.js" crossorigin="anonymous"></script>
<style>
  <%@include file="../style.css"%>
</style>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.umd.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simple-jscalendar@1.4.5/source/jsCalendar.min.css">
<script src="https://cdn.jsdelivr.net/npm/simple-jscalendar@1.4.5/source/jsCalendar.min.js"></script>



<script type="text/javascript">
  $(function() {
	  
		// ====================================
		// 페이지로드, 캘린더, 데이트피커
		// ====================================
	  
	  // -------- 페이지 초기화
		initialList(); 
    countTodo(); 
		
    let today = new Date().toISOString().substring(0, 10);
    $("#duedate, #from, #to").val(today);
    let todayText = new Date().toLocaleDateString();
    $("#menuDateArea").html(todayText);
    
		// -------- 캘린더 생성 관련
	  let myCalendar = jsCalendar.new("#my-calendar"); // 캘린더 생성
	  let specialDates = listDuedate();
	  
	  myCalendar.onDateRender(function(date, element, info) {
	    let yyyy = date.getFullYear();
	    let mm = String(date.getMonth() + 1).padStart(2, '0');
	    let dd = String(date.getDate()).padStart(2, '0');
	    let value = yyyy + '-' + mm + '-' + dd;	

	    if(specialDates.includes(value)){
	      element.style.fontWeight = 'bold';
	      element.style.color = '#0f1d41'; //'#2453E3';
	      element.style.fontSize = '16px';
	    }
	  });

	  myCalendar.refresh();
	  
	  myCalendar.onDateClick(function(event, date){
	    var value = date.toLocaleDateString('sv-SE');
	    document.getElementById("selected-date").value = value;
// 	    $("#selected-date").val() = value;
	    
	    sessionStorage.setItem("status", "calendarList");
	    sessionStorage.setItem("calPickDate", value);
	    doList();
	  });
  	
	  // -------- 데이트피커 생성 관련
    let picker = new easepick.create({
      element: "#regDateInput",
      css: ["https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css"],
      zIndex: 10,
      setup(picker) {
	    picker.on('select', (e) => {
	    	let selectedDate = picker.getDate().format('YYYY-MM-DD');
	      $('#dateViewSpan').html(`\${selectedDate}에 할일이 추가됩니다`);
	      $('#dateViewSpan').show();
	    });
	  },
    });
	  
	  
    // ===============================
    // 검색창
    // ===============================
	  
    // -------- 검색어 입력하는 동안 이벤트 --------
    $("#searchWord").on("keyup", function() {
      let searchWord = $(this).val();
      if (searchWord.length != 0) {
        doSearch("title", searchWord);       
      } else {
//         let result = ajaxFunc("/todolist/selectMulti", null, null);
        doList();
      }
    });	  
	  
	  
    // ===============================
    // 정렬, 리마인더
    // ===============================

    // 정렬아이콘 클릭시 (오름차순, 내림차순)
    $("body").on("click", "#orderMethodSelect", function() {
    	// 오름차순이면 true
    	let isAsc = $(this).hasClass("fa-arrow-up-wide-short"); 
    	$(this).toggleClass("fa-arrow-up-wide-short fa-arrow-down-wide-short");
    	
      if(isAsc) {
        // 클릭해서 내림차순 상태로 변경
        sessionStorage.setItem("ordermethod", "desc");
      } else {
        sessionStorage.setItem("ordermethod", "asc");
      }
      doList();
    });
    
    // 정렬방식 선택 변경시 (마감일순, 등록일순, 제목순)
    $("body").on("change", "#orderbySelect", function() {
      sessionStorage.setItem("orderby", $("#orderbySelect").val());
      doList();
    });    
    	

    
    
    // ===============================
    // 할일추가
    // ===============================
    	
		// -------- 할일추가 제목창에서 Enter
    $(document).on('keydown', '.regTitleInput', function(e) {
    	  if (e.key == "Enter") {
    		  register();
    	  }
    });

    // -------- 할일추가에서 캘린더아이콘 클릭시
    $(document).on("click", "#regDuedate", function() {
//     	alert("!");
    	$("#regDateInput").focus();
    });
    
    // -------- 중요도 아이콘이 눌렸을 때 --------
    $("body").on("click", ".regStarInput", function() {
      $(".regStarInput").toggleClass("fa-solid");
    });	  
    
    // -------- 할일추가에서 하단화살표아이콘 클릭시
    $("body").on("click", "#etcBtn", function() {
      $("#lm-toggle").show();
    });  


    
    // ===============================
    // 테이블
    // ===============================

    // 전체 선택 체크박스 클릭 시
    $(document).on('change','#selectAllCheckbox', function() {
    	
      $('.rowCheckbox').prop('checked', this.checked);
    })

    // 각 행 체크박스 클릭 시
    $(document).on('change', '.rowCheckbox', function() {
      // 하나라도 체크 해제되면 전체선택 체크박스 해제
      if (!this.checked) {
        $('#selectAllCheckbox').prop('checked', false);
      } else {
        // 모두 체크되면 전체선택 체크박스 체크
        var allChecked = $('.rowCheckbox').length === $('.rowCheckbox:checked').length;
        $('#selectAllCheckbox').prop('checked', allChecked);
      }
    }); 
    
    // -------- 완료 체크박스 클릭
    $("body").on("click", ".finishedIcon", function() {
      let dno = $(this).data("dno");
      let finished = null;
      let solid = $(this).hasClass("fa-circle-check");
      let checked = null;
      
      // 채워져있으면 해제
      if(solid) {
        finished = 0;
        checked = false;
      } else {
        finished = 1;
        checked = true;
      }
      let data = { "dno": dno, "finished": finished };
      let result = ajaxFunc("/todolist/updateFinished", data, "text");
      if (result == "success") {
        $("#dfinishedIcon-" + dno).toggleClass("fa-circle");
        $("#dfinishedIcon-" + dno).toggleClass("fa-circle-check");
        $("#detailfinishedIcon-"+dno).toggleClass("fa-circle");
        $("#detailfinishedIcon-"+dno).toggleClass("fa-circle-check");
        $("#dtitleTd-" + dno).toggleClass("completed", checked);
        doList();
      }
    });    	
      
    // -------- 테이블에서 제목영역 클릭시 (수정모드 전환)
    $(document).on('click', '.titleTd', function() {
      let span  = $(this).children('.titleSpan');
      let input = span.siblings('.edit-input-title');
      input.val(span.text()).show().focus();
      span.hide();
    });
    
 		// -------- 테이블에서 제목영역 클릭하여 수정 후 Enter
    $(document).on('keydown', '.edit-input-title', function(e) {
      if (e.key === "Enter") {
    	  let dno = $(this).data("dno");
        let value = $(this).val();
        let span = $(this).siblings('.titleSpan');
        span.text(value).show();
        $(this).hide();
        titleModify(dno, value); 
      }
    });
 		
    // -------- 테이블에서 제목영역 클릭하여 수정 후 다른 영역 클릭시
    $(document).on('blur', '.edit-input-title', function() {
  	  let dno = $(this).data("dno");
      let value = $(this).val();
      let span = $(this).siblings('.titleSpan');
      span.text(value).show();
      $(this).hide();
      titleModify(dno, value); 
    });

    // -------- 테이블에서 날짜영역 클릭시 (수정모드 전환)
    $(document).on('click', '.duedateTd', function() {
      let span  = $(this).children('.duedateSpan');
      let input = span.siblings('.edit-input-duedate');
      input.val(span.text()).show().focus();
      span.hide();
    });
	    
 		// -------- 테이블에서 날짜영역 클릭하여 수정 후 Enter
    $(document).on('keydown', '.edit-input-duedate', function(e) {
      if (e.key === "Enter") {
    	  let dno = $(this).data("dno");
        let value = $(this).val();
        let span = $(this).siblings('.duedateSpan');
        span.text(value).show();
        $(this).hide();
        duedateModify(dno, value); 
      }
    }); 
 		
    // -------- 테이블에서 날짜영역 클릭하여 수정 후 다른 영역 클릭시
    $(document).on('blur', '.edit-input-duedate', function() {
  	  let dno = $(this).data("dno");
      let value = $(this).val();
      let span = $(this).siblings('.duedateSpan');
      span.text(value).show();
      $(this).hide();
      duedateModify(dno, value); 
    });
 		
    // -------- 중요도 아이콘이 눌렸을 때
    $("body").on("click", ".starIcon", function() {
      let dno = $(this).data("dno");
      let star = null;
      // 
      let solid = $(this).hasClass("fa-solid");
      // 채워져있으면 해제해야 함
      if(solid) {
        star = 0;
      } else {
        star = 1;
      }
      
      let data = { "dno": dno, "star": star };
      let result = ajaxFunc("/todolist/updateStar", data, "text");
      if (result == "success") {
        // checked가 true이면, "completed" 추가하고, false면 삭제
        $("#dstar-" + dno).toggleClass("fa-solid");
        $("#detailstar-"+dno).toggleClass("fa-solid");
        countTodo();
        doList();
      }
    });    

    // -------- 더보기 버튼 클릭 시 상세 보기
    $("body").on("click", ".moreBtn", function() {
      let dno = $(this).data("dno");
      let data = {"dno": dno};
      let result = ajaxFunc("/todolist/selectone", data, null);
      let html = jQuery('<div>').html(result);
      let contents = html.find("div#ajaxTodoDetail").html();
      $("#todoDetail").html(contents);
    });
    
    // -------- 삭제 버튼 클릭 시
    $("body").on("click", ".delBtn", function() {
      let dno = $(this).data("dno");
      let data = { "dno": dno };
      let result = ajaxFunc("/todolist/deleteTodo", data, "text");
      $("#todoDetail").html(""); // 삭제되면 상세보기 공간 비우기
      doList();
      countTodo();
    });

 		// -------- '선택수정' 버튼 클릭 시 모달 열기
    $("body").on('click','#multiEditBtn', function() {
      $('#editModalOverlay').fadeIn(150);
    });
 		
    // -------- '선택수정'에서 모달 '취소' 버튼 또는 오버레이 클릭 시 닫기
    $("body").on('click','#modalCancelBtn, #editModalOverlay', function(e) {
      if (e.target.id === 'editModalOverlay' || e.target.id === 'modalCancelBtn') {
        $('#editModalOverlay').fadeOut(150);
      }
    });

    // -------- '선택수정'에서 모달창 클릭 시 오버레이 닫힘 방지
    $("body").on('click','#editModal', function(e) {
      e.stopPropagation();
    });

    // -------- '선택수정'에서 폼 제출 시(수정 버튼)
    $("body").on('submit','#multiEditForm', function(e) {
      e.preventDefault();
      let finished = $('input[name="finished"]:checked').val() ?? '';
      let star = $('input[name="star"]:checked').val() ?? '';
      let duedate = $('input[name="duedate"]').val() ?? '';

      let selectedArr = $('.rowCheckbox:checked').map(function(){ return $(this).data('dno'); }).get();
      updateSelectedAll(selectedArr, finished, star, duedate);
      
      $('#editModalOverlay').fadeOut(150);
    });   
    
    // -------- '선택삭제' 버튼 클릭 시 모달 열기
    $("body").on('click','#multiDeleteBtn', function() {
      $('#deleteModalOverlay').fadeIn(150);
    });

    // -------- '선택삭제'에서 모달 '취소' 버튼 또는 오버레이 클릭 시 닫기
    $("body").on('click','#modalCancelBtn, #deleteModalOverlay', function(e) {
      if (e.target.id === 'deleteModalOverlay' || e.target.id === 'modalCancelBtn') {
        $('#deleteModalOverlay').fadeOut(150);
      }
    });

    // -------- '선택삭제'에서 모달창 클릭 시 오버레이 닫힘 방지
    $("body").on('click','#deleteModal', function(e) {
      e.stopPropagation();
    });

    // -------- '선택삭제'에서 폼 제출 시(삭제 버튼)
    $("body").on('submit','#multiDeleteForm', function(e) {
      e.preventDefault();
      let selectedArr = $('.rowCheckbox:checked').map(function(){ return $(this).data('dno'); }).get();
      deleteSelectedAll(selectedArr);
      
      $('#deleteModalOverlay').fadeOut(150);
    });   
    
    
    
    // ================================
    // 오른쪽 사이드바
    // ================================
    
    // -------- 디테일 수정 버튼 --------
    $("body").on("click", ".detailModBtn", function() {
      let dno      = $(this).data("dno");
      let title    = $("#detailtitle-" + dno).val();
      let duedate  = $("#detailduedate-" + dno).val();
      let memo     = $("#detailmemo-" + dno).val();
      let location = $("#detaillocation-" + dno).val();
      let data = {
        dno: dno, title: title,
        duedate: duedate, memo: memo, location: location
      };
      let result = ajaxFunc("/todolist/updateDetail", data, "text");
      let nowUpdateTime = new Date().toLocaleString();
      $("#nowUpdateTime").html(nowUpdateTime);
      $("#updateTimeView").show();
      
      doList();
      countTodo();
    });
    
    // -------- 디테일 삭제 버튼 --------
    $("body").on("click", ".detailDelBtn", function() {
      let dno      = $(this).data("dno");
      let data = {
        dno: dno
      };
      let result = ajaxFunc("/todolist/deleteDetail", data, "text");
      let nowUpdateTime = new Date().toLocaleString();
      $("#nowUpdateTime").html(nowUpdateTime);
      $("#updateTimeView").show();
      
      // 삭제되면 비우기
      $("#todoDetail").html("");
      doList();
      countTodo();
      
    });
  }); 

  
  
  // ====================================
  // 함수: 페이지로드, 캘린더, 데이트피커
  // ====================================
	
	// -------- |initialList()|
	// session 저장 후 페이지 로딩 함수
	function initialList() {
		sessionStorage.setItem("ordermethod", "asc");
    sessionStorage.setItem("orderby", "duedate");
    sessionStorage.setItem("status", "allList");
    doList();
  }
	
	// -------- |countTodo()|
	// 왼쪽 사이드바에서 할일 개수 함수
	function countTodo() {
    let today = new Date().toISOString().substring(0, 10);
    let data = {
      today : today
    }
    
    let result = ajaxFunc("/todolist/todoCnt", data, "text");
    
    let info = jQuery('<div>').html(result);
    
    $("#todayCnt").html(info.find("#spanTodayCnt").html());
    $("#allCnt").html(info.find("#spanAllCnt").html());
    $("#unfinishedCnt").html(info.find("#spanUnfinishedCnt").html());
    $("#starCnt").html(info.find("#spanStarCnt").html());
    $("#isDuedateCnt").html(info.find("#spanIsDuedateCnt").html());
    $("#isNotDuedateCnt").html(info.find("#spanIsNotDuedateCnt").html());
  }
  
	// -------- |listDuedate()|
  // 마감일이 설정된 할일의 마감일을 불러와 배열로 반환 함수 (캘린더에 사용)
	function listDuedate() {
	    let result = ajaxFunc("/todolist/listDuedate", null, "text");
	    let info = jQuery('<div>').html(result);
	    spans = info.find(".duedateByTodo");
	    
	    let tempList = new Array();
	    spans.each(function() {
	      tempList.push($(this).html());
	    });
	    
	    return tempList;
	  }
	
	
	
  // ===============================
  // 함수: 왼쪽 사이드바
  // ===============================
    
  // -------- |selectWhere()|
  // 왼쪽에서 추출할 메뉴 클릭시 세션에 상태를 저장하는 함수
  function selectWhere(status) {
    if (status == "onlyTodayList") {
      sessionStorage.setItem("status", "onlyTodayList");        
    } else if (status == "allList") {
      sessionStorage.setItem("status", "allList");   
    } else if (status == "unfinishedList") {
      sessionStorage.setItem("status", "unfinishedList");
    } else if (status == "starList") {
      sessionStorage.setItem("status", "starList");
    } else if (status == "isNotNullDuedateList") {
      sessionStorage.setItem("status", "isNotNullDuedateList");
    } else if (status == "isNullDuedateList") {
      sessionStorage.setItem("status", "isNullDuedateList");
    } else if (status == "searchList") {
      sessionStorage.setItem("status", "searchList");
    } else if (status == "calendarList") {
      sessionStorage.setItem("status", "calendarList");
    }
    doList();
  }	
	
  
  
  // ===============================
  // 함수: 검색창
  // ===============================
    
  // -------- |doSearch()|
  // 검색 동작시 작동하는 함수
  function doSearch(searchTypes, searchWord) {
    let orderby = sessionStorage.getItem("orderby");
    let ordermethod = sessionStorage.getItem("ordermethod");
    
    let data = {
      searchTypes: searchTypes,
      searchWord: searchWord,
      orderby: orderby,
      ordermethod: ordermethod
    };
    let result = ajaxFunc("/todolist/selectMulti", data, null);
    let html = jQuery('<div>').html(result);
    let contents = html.find("div#ajaxList").html();
    $("#todolist").html(contents);
  }
  
  
  
  // ===============================
  // 함수: 정렬, 리마인더
  // ===============================    

    
    
    
  // ===============================
  // 함수: 할일추가
  // ===============================
    
  // -------- |register()|
  // 할일추가 함수
  function register() {
    let title = $(".regTitleInput").val();
    let duedate = $("#regDateInput").val();
    let star = null;
    let isStar = $(".regStarInput").hasClass("fa-solid");
    if ($(".regStarInput").hasClass("fa-solid")) {
      star = 1;
    } else {
      star = 0;
    }
    let location = $("#addLocationInput").val();
    let memo = $("#addMemoInput").val();
    
    let data = JSON.stringify({
      title: title,
      duedate: duedate,
      star:star,
      location:location,
      memo:memo
    });
    let result = ajaxFunc2('/todolist/insertTodo', 'application/json', 'text', data);
    if (result == "success") {
      $(".regTitleInput").val("");
      doList();
      countTodo();
    }
  }
  
  
  
  // ===============================
  // 함수: 테이블
  // =============================== 
    
  // -------- |titleModify()|
  // 테이블에서 제목영역 클릭할 때 수정 함수
  function titleModify(dno, modValue) {
    let title = modValue;
    
    let data = { "dno": dno, "title": title };
    let result = ajaxFunc("/todolist/updateTitle", data, "text");
    if (result == "success") {
      doList();
    }
  }
  
  // -------- |duedateModify()|
  // 테이블에서 날짜영역 클릭할 때 수정 함수  
  function duedateModify(dno, modValue) {
    let duedate = modValue;
    
    let data = { "dno": dno, "duedate": duedate };
    let result = ajaxFunc("/todolist/updateDuedate", data, "text");
    if (result == "success") {
      doList();
    }
  }
  
  // -------- |updateSelectedAll()|
  // 선택수정 버튼 관련 함수
  function updateSelectedAll(selectedArr, finished, star, duedate) {  
    let data = JSON.stringify({
      selectedArr: selectedArr,
      finished: finished,
      star: star,
      duedate: duedate
    });
    
    let result = ajaxFunc2('/todolist/updateSelectedAll', 'application/json', 'text', data);
    if (result == "success") {
      doList();
      countTodo();
    } else {
      alert("적어도 하나는 선택해야 수정이 된단다.");
    }
  } 
  
  // -------- |deleteSelectedAll()|
  // 선택삭제 버튼 관련 함수
  function deleteSelectedAll(selectedArr) {
    let data = JSON.stringify({
      selectedArr: selectedArr,
    });
    let result = ajaxFunc2('/todolist/deleteSelectedAll', 'application/json', 'text', data);
    if (result == "success") {
      doList();
      countTodo();
    } else {
      alert("삭제할 항목이 없습니다. 선택해주세요.");
    }
  }
  
  // -------- |doList()|
  // 테이블을 보여주는 함수
  function doList() {
    let ordermethod = sessionStorage.getItem("ordermethod");
    let orderby = sessionStorage.getItem("orderby");
    let status = sessionStorage.getItem("status");
    
    let duedate = null;
    if (status == "onlyTodayList") {
      duedate = new Date().toISOString().substring(0, 10);
    } else if (status == "calendarList") {
      duedate = sessionStorage.getItem("calPickDate");
    }
    
    let data = null;
    if (status == "onlyTodayList" || status == "calendarList") {
      duedate = 
      data = {
        duedate : duedate,
        star : 'all',
        finished : 'all',
        ordermethod : ordermethod,
        orderby : orderby
      }
      $("#menuTitleArea").html($("#onlyTodayText").html());
    } else if (status == "allList") {
      data = {      
        ordermethod : ordermethod,
        orderby : orderby
      }
      $("#menuTitleArea").html($("#allText").html());
    } else if (status == "unfinishedList") {
      data = {
        duedate : 'all',
        star : 'all',
        finished : 'unchecked',  
        ordermethod : ordermethod,
        orderby : orderby
      }
      $("#menuTitleArea").html($("#unfinishedText").html());
    } else if (status == "starList") {
      data = {
        duedate : 'all',
        star : 'checked',
        finished : 'all',
        ordermethod : ordermethod,
        orderby : orderby
      }
      $("#menuTitleArea").html($("#starText").html());
    } else if (status == "isNotNullDuedateList") {
      data = {
        duedate : 'isnotnull',
        star : 'all',
        finished : 'all',  
        ordermethod : ordermethod,
        orderby : orderby
      }
      $("#menuTitleArea").html($("#isNotNullDuedateText").html());
      
    } else if (status == "isNullDuedateList") {
      data = {
        duedate : 'isnull',
        star : 'all',
        finished : 'all',  
        ordermethod : ordermethod,
        orderby : orderby
      }
      $("#menuTitleArea").html($("#isNullDuedateText").html());
      
    } else if (status == "searchList") {
      $("#menuTitleArea").html($("#searchText").html());
    }
    
    let result = ajaxFunc("/todolist/selectMulti", data, null);
    let html = jQuery('<div>').html(result);
    let contents = html.find("div#ajaxList").html();
    $("#todolist").html(contents);
  }
  
  
  
  // ================================
  // 함수: 오른쪽 사이드바
  // ================================    

  </script>

</head>


<body>


	<!-- 헤더 영역 -->
	<jsp:include page="../header.jsp"></jsp:include>

	<!-- 페이지 전체 레이아웃 -->
	<div class="itembox">

		<!-- 왼쪽 사이드바 -->
		<div class="left">

			<div class="left-menu"
				style="background: #fff; border-radius: 8px; box-shadow: 0 1px 4px rgba(44, 62, 80, 0.07); max-width: 100%; padding: 0; font-family: 'Pretendard', 'Inter', sans-serif; border: 1px solid #f2f4f6;">
				<ul style="list-style: none; margin: 0; padding: 0;">
					<li
						style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
						<a href="javascript:void(0);"
						onclick="selectWhere('onlyTodayList');"
						style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">
            
            <span id="onlyTodayText"> 
              <i class="fa-solid fa-calendar-plus" style="padding:0 10px; width:40px"></i>
              오늘 To-Do</span></a>
            
            <span id="todayCnt"
						style="color: #b3b3b3; font-size: 15px;"></span>
					</li>
					<li
						style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
						<a href="javascript:void(0);" onclick="selectWhere('allList');"
						style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">
            <span id="allText">
            <i class="fa-solid fa-box" style="padding:0 10px; width:40px"></i>
            모든 To-Do</span></a> <span id="allCnt" style="color: #b3b3b3; font-size: 15px;"></span>
					</li>
					<li
						style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
						<a href="javascript:void(0);"
						onclick="selectWhere('unfinishedList');"
						style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">
            <span id="unfinishedText">
            <i class="fa-regular fa-circle" style="padding:0 10px; width:40px"></i>
            미완료된 To-Do</span></a> <span id="unfinishedCnt"
						style="color: #b3b3b3; font-size: 15px;"></span>
					</li>
					<li
						style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
						<a href="javascript:void(0);" onclick="selectWhere('starList');"
						style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">
            <span id="starText">
            <i class="fa-solid fa-star" style="padding:0 10px; width:40px"></i>
            중요한 To-Do</span></a> <span id="starCnt"
						style="color: #b3b3b3; font-size: 15px;"></span>
					</li>
					<li
						style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
						<a href="javascript:void(0);"
						onclick="selectWhere('isNotNullDuedateList');"
						style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">
            <span id="isNotNullDuedateText">
            <i class="fa-solid fa-timeline" style="padding:0 10px; width:40px"></i>
            기한이 있는 To-Do</span></a> <span id="isDuedateCnt"
						style="color: #b3b3b3; font-size: 15px;"></span>
					</li>
					<li style="display: flex; align-items: center; padding: 13px 18px;">
						<a href="javascript:void(0);"
						onclick="selectWhere('isNullDuedateList');"
						style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">
            <span id="isNullDuedateText">
            <i class="fa-solid fa-bars-staggered" style="padding:0 10px; width:40px"></i>
            기한이 없는 To-Do</span></a> <span id="isNotDuedateCnt"
						style="color: #b3b3b3; font-size: 15px;"></span>
					</li>
				</ul>
			</div>


			<div id="my-calendar"></div>
			<input type="hidden" id="selected-date" readonly
				style="margin-top: 10px;">

		</div>

		<!-- 중앙 메인 영역 -->
		<div class="center">

			<div
				style="padding: 28px 32px 18px 32px; border-radius: 6px; display: flex; align-items: flex-start; justify-content: space-between; min-height: 72px; box-sizing: border-box;">
				<!-- 좌측: 아이콘 + 제목 + 날짜 -->
				<div style="display: flex; align-items: flex-start; gap: 12px;">
			
					<div>
						<div id="menuTitleArea" style="font-size: 23px; font-weight: 700; color: #222; line-height: 1.4;"></div>
						<div id="menuDateArea" style="font-size: 16px; color: #888; margin-top: 2px; padding: 0 0 0 50px; text-align:left">4월 21일, 월요일</div>
            
					</div>
				</div>
				<!-- 우측: 정렬/등록일순/그룹 -->
				<div style="display: flex; align-items: center; gap: 18px;">
					<label
						style="font-size: 15px; color: #888; display: flex; align-items: center; gap: 2px; cursor: pointer;">
						<button
							style="background: #b1b1b1; color: #fff; border: none; border-radius: 6px; padding: 2px 10px; font-size: 15px; font-family: inherit; cursor: pointer; margin-right: 6px;">
							<i id="orderMethodSelect" class="fa-solid fa-arrow-up-wide-short"></i>
							<!--<i class="fa-solid fa-arrow-down-wide-short"></i> -->
						</button>
					</label> 
          <select id="orderbySelect" name="orderbySelect"
						style="width: 130px;font-size: 12px; padding: 3px 8px; border: 1px solid #b7c1c7; border-radius: 5px; background: #fff; color: #222; outline: none; cursor: pointer;">
						<option value="duedate">마감일순</option>
						<option value="dno">등록일순</option>
						<option value="title">제목순</option>
					</select>

				</div>
			</div>




















			<!-- 할일 추가 바 -->
			<div class="todo-box">
				<div class="todo-input-row">
					<input class="regTitleInput" type="text" placeholder="이곳에 할일을 추가해보세요" />
				</div>
				<div class="todo-footer">
					<div class="todo-icons">

						<!-- 날짜 설정 -->

            <span class="icon">
              <input type="date" id="regDateInput" style="opacity:0; width:1px; height:1px; position:absolute; left:100; top:100;">
              <label for="regDateInput">
                <i id="regDuedate" class="fa-solid fa-calendar-days" style="color: #1e3050; cursor:pointer;pointer-events: auto;"></i>
                </label>
            </span>
						<!-- 중요도 설정 -->
						<span> <i class="fa-regular fa-star regStarInput"
							style="color: #1e3050"></i>
						</span>
						<!-- 그 외 설정하기 모달창 -->
						<span class="icon"> <i id="etcBtn"
							class="fa-regular fa-circle-down"
							style="color: #1e3050; cursor: pointer"></i>
						</span>
            <span id=dateViewSpan style="display:none;color:#757575"></span>
					</div>
					<button class="add-btn" onclick="register();">추가</button>
				</div>
        <div id="lm-toggle" class="todo-footer" style="display: none;">
          <div class="todo-icons" style="display: flex; align-items: center; gap: 32px;">
            <!-- 위치 -->
            <div style="display: flex; align-items: center; gap: 8px;">
              <span style="padding-right: 4px;">위치</span>
              <input type="text" id="addLocationInput" style="width: 140px;">
            </div>
            <!-- 메모 -->
            <div style="display: flex; align-items: center; gap: 8px;">
              <span style="padding-right: 4px;">메모</span>
              <input type="text" id="addMemoInput" style="width: 200px;">
            </div>
          </div>
        </div>
			</div>



			<div id="todolist"></div>
		</div>

		<!-- 우측 상세 영역 -->
		<div class="right">
			<div id="todoDetail"></div>
		</div>
	</div>

	<!-- 푸터 영역 -->
	<jsp:include page="../footer.jsp"></jsp:include>


	<!-- 모달 오버레이 및 모달창 -->
	<div id="editModalOverlay"
		style="display: none; position: fixed; left: 0; top: 0; width: 100vw; height: 100vh; background: rgba(0, 0, 0, 0.3); z-index: 9999;">
		<div id="editModal"
			style="position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); background: #fff; border-radius: 10px; box-shadow: 0 4px 24px #0002; padding: 32px 32px 24px 32px; min-width: 340px; max-width: 90vw; text-align: center;">
			<h3 style="margin-bottom: 24px; color: #0f1d41;">선택한 할일 일괄 수정</h3>
			<form id="multiEditForm">
				<div style="margin-bottom: 18px; text-align: left;">
					<label style="font-weight: 500; margin-right: 16px;">완료 상태</label>
					<label style="margin-right: 10px;"> <input type="radio"
						name="finished" value="1"> 완료로 변경
					</label> <label> <input type="radio" name="finished" value="0">
						미완료로 변경
					</label> <label> <input type="radio" name="finished" value="9"
						checked> 그대로 두기
					</label>
				</div>
				<div style="margin-bottom: 18px; text-align: left;">
					<label style="font-weight: 500; margin-right: 16px;">중요도</label> <label
						style="margin-right: 10px;"> <input type="radio"
						name="star" value="1"> 중요로 변경
					</label> <label> <input type="radio" name="star" value="0">
						중요 해제
					</label> <label> <input type="radio" name="star" value="9" checked>
						그대로 두기
					</label>
				</div>
				<div style="margin-bottom: 18px; text-align: left;">
					<label style="font-weight: 500; margin-right: 16px;">마감일</label> <input
						type="date" name="duedate"
						style="padding: 4px 8px; border-radius: 4px; border: 1px solid #ccc;">
					<span style="font-size: 14px"><br>그대로 두려면 날짜를 선택하지 마세요</span>
				</div>
				<div style="margin-top: 28px;">
					<button type="submit"
						style="background: #1976d2; color: #fff; border: none; border-radius: 6px; padding: 8px 24px; font-size: 16px; font-weight: 500; margin-right: 10px; cursor: pointer;">
						수정</button>
					<button type="button" id="modalCancelBtn"
						style="background: #fff; color: #1976d2; border: 1.5px solid #1976d2; border-radius: 6px; padding: 8px 24px; font-size: 16px; font-weight: 500; cursor: pointer;">
						취소</button>
				</div>
			</form>
		</div>
	</div>
<!-- 모달 오버레이 및 모달창 -->
  <div id="deleteModalOverlay"
    style="display: none; position: fixed; left: 0; top: 0; width: 100vw; height: 100vh; background: rgba(0, 0, 0, 0.3); z-index: 9999;">
    <div id="deleteModal"
      style="position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); background: #fff; border-radius: 10px; box-shadow: 0 4px 24px #0002; padding: 32px 32px 24px 32px; min-width: 340px; max-width: 90vw; text-align: center;">
      <h3 style="margin-bottom: 24px; color: #0f1d41;">선택 항목 일괄 삭제</h3>
      <form id="multiDeleteForm">
        <div style="margin-bottom: 18px; text-align: left;">
          <label style="font-weight: 500; margin-right: 26px;">정말로 삭제하시겠습니까?</label>
        </div>
        
        <div style="margin-top: 28px;">
          <button type="submit"
            style="background: #1976d2; color: #fff; border: none; border-radius: 6px; padding: 8px 24px; font-size: 16px; font-weight: 500; margin-right: 10px; cursor: pointer;">
            삭제</button>
          <button type="button" id="modalCancelBtn"
            style="background: #fff; color: #1976d2; border: 1.5px solid #1976d2; border-radius: 6px; padding: 8px 24px; font-size: 16px; font-weight: 500; cursor: pointer;">
            취소</button>
        </div>
      </form>
    </div>
  </div>


</body>
</html>










