<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>


<html>

<head>

<meta charset="UTF-8">
<title>다이어리목록</title>

<!-- 외부 라이브러리 및 스타일 -->
<script
  src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript"><%@ include file="../script.js" %></script>
<script src="https://kit.fontawesome.com/9bef4b10f4.js"
  crossorigin="anonymous"></script>
<style>
<%@include file="../style.css"%>
</style>
<link rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script
  src="https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.umd.min.js"></script>
<link rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/simple-jscalendar@1.4.5/source/jsCalendar.min.css">
<script
  src="https://cdn.jsdelivr.net/npm/simple-jscalendar@1.4.5/source/jsCalendar.min.js"></script>


<!-- 자바스크립트 -->
<script type="text/javascript">

  $(function() {
	  
	  <!-- 센터 초기화 -->
		// -------- 페이지 초기화 --------
		sessionStorage.setItem("ordermethod", "desc");
		sessionStorage.setItem("orderby", "duedate");
		sessionStorage.setItem("status", "allList"); // onlyTodayList, allList,	unfinishedList,	starList,	isduedateList, isNotDuedateList, searchList, calendarList
    initialList();
//     countTodo();
		
    let today = new Date().toISOString().substring(0, 10);
    $("#duedate, #from, #to").val(today);
    
    
    
	  <!-- 캘린더 관련 -->
		// -------- 캘린더 생성 관련 --------
	  // 캘린더 생성
	  var myCalendar = jsCalendar.new("#my-calendar");
	  // 기한이 있는 날짜들을 중복없이 가져와서 배열로 만들자.
	  
	  // 리스트로 반환받음
	  
	  let specialDates = listDuedate();
	  
	  // 날짜 렌더링 시 스타일 적용
	  myCalendar.onDateRender(function(date, element, info){
	    // 날짜를 YYYY-MM-DD로 변환
	    var yyyy = date.getFullYear();
	    var mm = String(date.getMonth() + 1).padStart(2, '0');
	    var dd = String(date.getDate()).padStart(2, '0');
	    var value = yyyy + '-' + mm + '-' + dd;

	    if(specialDates.includes(value)){
	      element.style.fontWeight = 'bold';
	      element.style.color = '#0f1d41'; //'#2453E3'; // 퍼플렉시티 시그니처 블루
	      element.style.fontSize = '16px';
	    }
	  });
	  
		// 스타일 적용 후 갱신 필요시
	  myCalendar.refresh();
	  
	  // 날짜 클릭 이벤트 바인딩
	  myCalendar.onDateClick(function(event, date){
	    // 원하는 형식으로 변환 (예: YYYY-MM-DD)
	    var value = date.toLocaleDateString('sv-SE');
	    document.getElementById("selected-date").value = value;
	    
	    sessionStorage.setItem("status", "calendarList");
	    sessionStorage.setItem("calPickDate", value);
	    doList();
	  });
  	
		// -------- 캘린더아이콘 클릭시 이벤트 --------
	  $(document).on('click', '#regDuedate', function() {
		  $("#datepicker").click();
	  });
	  
		
		
  	<!-- 데이트피커 관련 -->
	  let picker = new easepick.create({
      element: "#datepicker",
      css: [
         "https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css"
      ],
      zIndex: 10
    });
	  
	  
	  
	  <!-- 할일추가 영역 관련 이벤트 -->
		// -------- 엔터 클릭시 --------
    $(document).on('keydown', '.regTitleInput', function(e) {
    	  if (e.key == "Enter") {
    		  register();
    	  }
    });


	  <!-- 센터 > 목록 > 제목 -->
    // -------- 제목 영역 클릭시 수정모드로 전환 --------
    $(document).on('click', '.titleTd', function() {
      let span  = $(this).children('.titleSpan');
      let input = span.siblings('.edit-input-title');
      input.val(span.text()).show().focus();
      span.hide();
    });
    
 		// -------- 엔터 클릭시 --------
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
 		
    $(document).on('blur', '.edit-input-title', function() {
      	  let dno = $(this).data("dno");
          let value = $(this).val();
          let span = $(this).siblings('.titleSpan');
          span.text(value).show();
          $(this).hide();
          titleModify(dno, value); 

      });
	  <!-- 센터 > 목록 > 날짜 -->
	    // -------- 날짜 영역 클릭시 수정모드로 전환 --------
	    $(document).on('click', '.duedateTd', function() {
	      let span  = $(this).children('.duedateSpan');
	      let input = span.siblings('.edit-input-duedate');
	      input.val(span.text()).show().focus();
	      span.hide();
	    });
	    
	 		// -------- 엔터 클릭시 --------
	    $(document).on('keydown', '.edit-input-duedate', function(e) {
	      if (e.key === "Enter") {
	    	  let dno = $(this).data("dno");
	        let value = $(this).val();
	        let span = $(this).siblings('.duedateSpan');
	        span.text(value).show();
	        $(this).hide();
	        titleModify(dno, value); 
	      }
	    }); 		
	    $(document).on('blur', '.edit-input-duedate', function() {

		    	  let dno = $(this).data("dno");
		        let value = $(this).val();
		        let span = $(this).siblings('.duedateSpan');
		        span.text(value).show();
		        $(this).hide();
		        duedateModify(dno, value); 

	      });
 		
 		
 		
    <!-- 리마인더 모달 동작 -->
    // -------- 리마인더아이콘 클릭시 --------
    $('#reminderBtn').on('click', function(e) {
      e.stopPropagation();
      var btnOffset = $(this).offset();
      var btnHeight = $(this).outerHeight();
      $('#reminderModal').show();
      $('#reminderModal .modal-content').css({
        left: btnOffset.left + 'px',
        top: (btnOffset.top + btnHeight) + 'px'
      });
    });
		// -------- X버튼 클릭시 --------
    $('.close').on('click', function(e) {
      e.stopPropagation();
      $('#reminderModal').hide();
    });
		// -------- 모달 내부 클릭시 --------
    $('#reminderModal .modal-content').on('click', function(e) {
      e.stopPropagation();
    });
		// -------- 모달 외부 클릭시 --------
    $(document).on('click', function() {
      $('#reminderModal').hide();
      
    });

    
    
		<!-- 검색 관련 이벤트 -->
    // -------- 검색어 입력하는 동안 이벤트 --------
    $("#searchWord").on("keyup", function() {
      let searchWord = $(this).val();
      if (searchWord.length != 0) {
        doSearch("title", searchWord);       
      } else {
        let result = ajaxFunc("/todolist/selectMulti", null, null);
        doList(result);
      }
    });


    // 오더바이
    $("body").on("click", "#orderMethodSelect", function() {
    	
    	let status = $(this).hasClass("fa-arrow-up-wide-short"); // 오름차순 상태
   	  $(this).toggleClass("fa-arrow-up-wide-short");
   	  $(this).toggleClass("fa-arrow-down-wide-short");
      if(status) {
    	  // 클릭해서 내림차순 상태로 변경
    	  sessionStorage.setItem("ordermethod", "desc");
    	  console.log("내림차순으로 바뀜");
    	  doList();
    	  
      } else {
    	  sessionStorage.setItem("ordermethod", "asc");
        console.log("오름차순으로 바뀜");
        doList();
      }
      
    });
    
    
 		// '선택수정' 버튼 클릭 시 모달 열기
    $('#multiEditBtn').on('click', function() {
      $('#editModalOverlay').fadeIn(150);
    });

    // 모달 '취소' 버튼 또는 오버레이 클릭 시 닫기
    $('#modalCancelBtn, #editModalOverlay').on('click', function(e) {
      // 모달 바깥쪽(오버레이) 클릭 시에만 닫기
      if (e.target.id === 'editModalOverlay' || e.target.id === 'modalCancelBtn') {
        $('#editModalOverlay').fadeOut(150);
      }
    });

    // 모달창 클릭 시 오버레이 닫힘 방지
    $('#editModal').on('click', function(e) {
      e.stopPropagation();
    });

    // 폼 제출 시(수정 버튼)
    $('#multiEditForm').on('submit', function(e) {
      e.preventDefault();
      // 선택된 값 가져오기
      let finished = $('input[name="finished"]:checked').val() ?? '';
      let star = $('input[name="star"]:checked').val() ?? '';
      let duedate = $('input[name="duedate"]').val() ?? '';

      let selectedArr = $('.rowCheckbox:checked').map(function(){ return $(this).data('dno'); }).get();
// 			alert(duedate);
      updateSeletedAll(selectedArr, finished, star, duedate);
      
      $('#editModalOverlay').fadeOut(150);
    });   
    
    
    
    
    
    
    
    
    
    // -------- 완료 체크박스가 눌렸을 때 --------
    $("body").on("click", ".finishedIcon", function() {
      let dno = $(this).data("dno");
      let finished = null;
      let solid = $(this).hasClass("fa-circle-check");
      let checked = null;
      // 채워져있으면 해제해야 함
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
      }
    });
    
    
    $("body").on("change", "#orderbySelect", function() {
    	sessionStorage.setItem("orderby", $("#orderbySelect").val());
    	doList();
    });
    
    // -------- 중요도 아이콘이 눌렸을 때 --------
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
      }
    });
    
    $("body").on("click", ".todoDateIcon", function() {
    	$("hiddenDateInput").click();
    });
    
    // -------- 수정 버튼 --------
    $("body").on("click", ".modBtn", function() {
      let dno     = $(this).data("dno");
      let title   = $(this).data("title");
      let duedate = $(this).data("date");
      $("#dconbtn-" + dno).show();
      $("#dmodbtn-" + dno).hide();
      $('#dtitlediv-' + dno).replaceWith(
        `<input type="text" id="dtitleinput-${dno}">`
      );
      $('#dtitleinput-' + dno).val(title);
      $('#dduedatediv-' + dno).replaceWith(
        `<input type="date" id="dduedateinput-${dno}">`
      );
      $('#dduedateinput-' + dno).val(duedate);
    });

    
    // -------- 수정 확인 버튼 --------
    $("body").on("click", ".conBtn", function() {
      let dno     = $(this).data("dno");
      let title   = $("#dtitleinput-" + dno).val();
      let duedate = $("#dduedateinput-" + dno).val();
      let data = { dno: dno, title: title, duedate: duedate };
      let result = ajaxFunc("/todolist/updateTodo", data, "text");
      if (result == 'success') {
        self.location = '/todolist/list';
      }
    });

    
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
    
    // -------- 삭제 버튼 --------
    $("body").on("click", ".delBtn", function() {
      let dno = $(this).data("dno");
      let data = { "dno": dno };
      let result = ajaxFunc("/todolist/deleteTodo", data, "text");
      // 삭제되면 비우기
      $("#todoDetail").html("");
      doList();
      countTodo();
    });

    
    // -------- 더보기 클릭 시 상세 보기 --------
    $("body").on("click", ".moreBtn", function() {
      let dno = $(this).data("dno");
      let data = {"dno": dno};
      let result = ajaxFunc("/todolist/selectone", data, null);
      let html = jQuery('<div>').html(result);
      let contents = html.find("div#ajaxTodoDetail").html();
      $("#todoDetail").html(contents);
    });
    
    
 // -------- 중요도 아이콘이 눌렸을 때 --------
    $("body").on("click", ".regStarInput", function() {
    	$(".regStarInput").toggleClass("fa-solid");
    });

 
 
    // 전체 선택 체크박스 클릭 시
    $('#selectAllCheckbox').on('change', function() {
      $('.rowCheckbox').prop('checked', this.checked);
    });

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
 
 
 
 
 
 
 
 
 
 
  }); // jQuery ready end

  // ================================
  // 함수 정의
  // ================================
	
	function initialList() {
		sessionStorage.setItem("ordermethod", "desc");
    sessionStorage.setItem("orderby", "duedate");
    sessionStorage.setItem("status", "allList");
    doList();
  }
	
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
	
	
	function updateSeletedAll(selectedArr, finished, star, duedate) {	
		
		console.log(typeof(selectedArr), typeof(finished), typeof(star), typeof(duedate));
		console.log(selectedArr, finished, star, duedate);
		let data = JSON.stringify({
	    selectedArr: selectedArr,
	    finished: finished,
	    star: star,
	    duedate: duedate
		});
		let result = ajaxFunc2('/todolist/updateSeletedAll', 'application/json', 'text', data);
    if (result == "success") {
      alert("수정되었습니다.");
      doList();
    } else {
    	alert("적어도 하나는 선택해야 수정이 된단다.");
    }
	}
	// 제목 수정함수
  function titleModify(dno, modValue) {
    let title = modValue;
    
    let data = { "dno": dno, "title": title };
    let result = ajaxFunc("/todolist/updateTitle", data, "text");
    if (result == "success") {
      // 
    }
  }
  function duedateModify(dno, modValue) {
	    let duedate = modValue;
	    
	    let data = { "dno": dno, "duedate": duedate };
	    let result = ajaxFunc("/todolist/updateDuedate", data, "text");
	    if (result == "success") {
	      // 
	    }
	  }
  // 할일 등록
  function register() {
    let title = $(".regTitleInput").val();
    let duedate = $(".regDateInput").val();
    let star = null;
    console.log(title,duedate);
    let isStar = $(".regStarInput").hasClass("fa-solid");
    console.log(isStar);
    if ($(".regStarInput").hasClass("fa-solid")) {
    	star = 1;
    } else {
    	star = 0;
    }
    let data = { title: title, duedate: duedate, star: star };
    let result = ajaxFunc("/todolist/register", data, "text");
    if (result == "success") {
    	$(".regTitleInput").val("");
    	doList();
    	countTodo();
    }
  }

  
  // :doList()
  function doList() {
    let ordermethod = sessionStorage.getItem("ordermethod");
    let orderby = sessionStorage.getItem("orderby");
    let status = sessionStorage.getItem("status");
// 	  console.log("■ doList() : ", ordermethod, orderby, status);
    
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
	  } else if (status == "allList") {
		  data = {			
			  ordermethod : ordermethod,
			  orderby : orderby
		  }
	  } else if (status == "unfinishedList") {
      data = {
 		    duedate : 'all',
        star : 'all',
        finished : 'unchecked',  
        ordermethod : ordermethod,
        orderby : orderby
      }		  
	  } else if (status == "starList") {
		  data = {
        duedate : 'all',
        star : 'checked',
        finished : 'all',
        ordermethod : ordermethod,
        orderby : orderby
		  }
	  } else if (status == "isNotNullDuedateList") {
		  data = {
        duedate : 'isnotnull',
        star : 'all',
        finished : 'all',  
        ordermethod : ordermethod,
        orderby : orderby
		  }
		  
	  } else if (status == "isNullDuedateList") {
      data = {
        duedate : 'isnull',
        star : 'all',
        finished : 'all',  
        ordermethod : ordermethod,
        orderby : orderby
      }
	  } else if (status == "searchList") {
	  }
	  
//     if (!result) 
   	let result = ajaxFunc("/todolist/selectMulti", data, null);
//     console.log("★★★★★★★★★★★★★★★★★", result);
    let html = jQuery('<div>').html(result);
    let contents = html.find("div#ajaxList").html();
    $("#todolist").html(contents);
  }

  // 조건별 목록 조회
//   function selectWhere(duedate, star, finished) {
//     if (duedate == 'today') {
//       duedate = new Date().toISOString().substring(0, 10);
//     }
//     let data = { duedate: duedate, star: star, finished: finished };
//     let result = ajaxFunc("/todolist/selectMulti", data, null);
//     let html = jQuery('<div>').html(result);
//     let contents = html.find("div#ajaxList").html();
//     $("#todolist").html(contents);
//   }
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

  // 검색
  function doSearch(searchTypes, searchWord) {
    let data = {
      searchTypes: searchTypes,
      searchWord: searchWord,
    };
    let result = ajaxFunc("/todolist/selectMulti", data, null);
    let html = jQuery('<div>').html(result);
    let contents = html.find("div#ajaxList").html();
    $("#todolist").html(contents);
  }
  
  function sortByFunc(sortBy) {
	  console.log(sortBy);
	  let data = {
			sortBy : sortBy
	  };
	  let result = ajaxFunc("/todolist/selectSortBy", data, null);
	  let html = jQuery('<div>').html(result);
    let contents = html.find("div#ajaxList").html();
    $("#todolist").html(contents);
  }
  </script>

</head>





<body>

  <!-- 리마인더 모달 -->
  <div id="reminderModal" class="modal">
    <div class="modal-content">
      <span class="close">&times;</span>
      <h2>리마인더 설정...... [토글]</h2>

      <table>
        <tr>

          <td>
            <form>
              <select name="language">
                <option value="none">=== 선택 ===</option>
                <option value="korean" selected>1일 내</option>
                <option value="english">2일 내</option>
                <option value="chinese">1주 내</option>
                <option value="spanish">1개월 내</option>
                <option value="spanish">3개월 내</option>
              </select>
            </form>
          </td>
          <td>마감예정 미리알림</td>
        </tr>
      </table>
      <table>
        <tr>
          <td>
            <form>
              <select name="language">
                <option value="none">=== 선택 ===</option>
                <option value="korean" selected>매일</option>
                <option value="english">매주 일요일</option>
                <option value="chinese">매달 1일</option>
              </select>
            </form>
          </td>
          <td><input type="datetime"></td>
          <td>에 이메일로 알림설정</td>
        </tr>
      </table>
      <div>[v] 중요한 할일만 알림 받기!</div>
    </div>
  </div>

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
            style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">오늘
              To-Do</a> <span id="todayCnt" style="color: #b3b3b3; font-size: 15px;"></span>
          </li>
          <li
            style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
            <a href="javascript:void(0);" onclick="selectWhere('allList');"
            style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">모든
              To-Do</a> <span id="allCnt" style="color: #b3b3b3; font-size: 15px;"></span>
          </li>
          <li
            style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
            <a href="javascript:void(0);" onclick="selectWhere('unfinishedList');"
            style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">미완료된 To-Do</a>
            <span id="unfinishedCnt" style="color: #b3b3b3; font-size: 15px;"></span>
          </li>
          <li
            style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
            <a href="javascript:void(0);" onclick="selectWhere('starList');"
            style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">중요한
              할 To-Do</a> 
              <span id="starCnt" style="color: #b3b3b3; font-size: 15px;"></span>
          </li>
          <li
            style="display: flex; align-items: center; padding: 13px 18px; border-bottom: 1px solid #f6f6f6;">
            <a href="javascript:void(0);" onclick="selectWhere('isNotNullDuedateList');"
            style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">기한이
              있는 To-Do</a>
              <span id="isDuedateCnt" style="color: #b3b3b3; font-size: 15px;"></span>
          </li>
          <li
            style="display: flex; align-items: center; padding: 13px 18px;">
            <a href="javascript:void(0);"
            onclick="selectWhere('isNullDuedateList');"
            style="flex: 1; text-decoration: none; color: #222; font-size: 15px; margin-left: 10px;">기한이
              없는 To-Do</a>
              <span id="isNotDuedateCnt" style="color: #b3b3b3; font-size: 15px;"></span>
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
          <span><i class="fa-solid fa-rainbow"></i></span>
          <div>
            <div
              style="font-size: 20px; font-weight: 700; color: #222; line-height: 1.4;">오늘
              할 일</div>
            <div style="font-size: 13px; color: #888; margin-top: 2px;">4월
              21일, 월요일</div>
          </div>
        </div>
        <!-- 우측: 정렬/등록일순/그룹 -->
        <div style="display: flex; align-items: center; gap: 18px;">
          <label
            style="font-size: 15px; color: #888; display: flex; align-items: center; gap: 2px; cursor: pointer;">
            <button
              style="background: #d1d1d1; color: #fff; border: none; border-radius: 6px; padding: 2px 10px; font-size: 15px; font-family: inherit; cursor: pointer; margin-right: 6px;">
              <i id="orderMethodSelect" class="fa-solid fa-arrow-up-wide-short"></i>
              <!--<i class="fa-solid fa-arrow-down-wide-short"></i> -->
            </button>
          </label>
          <select id="orderbySelect" name="orderbySelect"
            style="font-size: 12px; padding: 3px 8px; border: 1px solid #b7c1c7; border-radius: 5px; background: #fff; color: #222; outline: none; cursor: pointer; margin-right: 33px">
            <option value="duedate">마감일순</option>
            <option value="dno">등록일순</option>
            <option value="title">제목순</option>
          </select>
          <label
            style="font-size: 15px; color: #888; display: flex; align-items: center; gap: 4px; cursor: pointer;">
            <button id="reminderBtn"
              style="background: #ebc023; color: #fff; border: none; border-radius: 6px; padding: 2px 10px; font-size: 15px; font-family: inherit; cursor: pointer; margin-right: 1px;">
              <i class="fa-solid fa-bell"></i>
            </button>
          </label>
        </div>
      </div>




















      <!-- 할일 추가 바 -->
      <div class="todo-box">
        <div class="todo-input-row">
          <input class="regTitleInput" type="text" placeholder="할일 추가" />
        </div>
        <div class="todo-footer">
          <div class="todo-icons">

            <!-- 날짜 설정 -->
            <span class="icon"> <i id="regDuedate"
              class="fa-solid fa-calendar-days" style="color: #1e3050"></i>
              <input type="hidden" id="datepicker" class="regDateInput">
            </span>

            <!-- 중요도 설정 -->
            <span> <i class="fa-regular fa-star regStarInput"
              style="color: #1e3050"></i>
            </span>
            <!-- 그 외 설정하기 모달창 -->
            <span class="icon"> <i class="fa-solid fa-bars"
              style="color: #1e3050; cursor: pointer"></i>
            </span>
          </div>
          <button class="add-btn" onclick="register();">추가</button>
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
       style="display:none; position:fixed; left:0; top:0; width:100vw; height:100vh; 
              background:rgba(0,0,0,0.3); z-index:9999;">
  <div id="editModal"
       style="position:absolute; left:50%; top:50%; transform:translate(-50%,-50%);
              background:#fff; border-radius:10px; box-shadow:0 4px 24px #0002;
              padding:32px 32px 24px 32px; min-width:340px; max-width:90vw; text-align:center;">
    <h3 style="margin-bottom:24px; color:#0f1d41;">선택한 할일 일괄 수정</h3>
    <form id="multiEditForm">
      <div style="margin-bottom:18px; text-align:left;">
        <label style="font-weight:500; margin-right:16px;">완료 상태</label>
        <label style="margin-right:10px;">
          <input type="radio" name="finished" value="1"> 완료로 변경
        </label>
        <label>
          <input type="radio" name="finished" value="0"> 미완료로 변경
        </label>
        <label>
          <input type="radio" name="finished" value="9" checked > 그대로 두기
        </label>
      </div>
      <div style="margin-bottom:18px; text-align:left;">
        <label style="font-weight:500; margin-right:16px;">중요도</label>
        <label style="margin-right:10px;">
          <input type="radio" name="star" value="1"> 중요로 변경
        </label>
        <label>
          <input type="radio" name="star" value="0"> 중요 해제
        </label>
        <label>
          <input type="radio" name="star" value="9" checked > 그대로 두기
        </label>
      </div>
      <div style="margin-bottom:18px; text-align:left;">
        <label style="font-weight:500; margin-right:16px;">마감일</label>
        <input type="date" name="duedate" style="padding:4px 8px; border-radius:4px; border:1px solid #ccc;">
        <span style="font-size:14px"><br>그대로 두려면 날짜를 선택하지 마세요</span>
      </div>
      <div style="margin-top:28px;">
        <button type="submit" style="
          background:#1976d2; color:#fff; border:none; border-radius:6px;
          padding:8px 24px; font-size:16px; font-weight:500; margin-right:10px; cursor:pointer;">
          수정
        </button>
        <button type="button" id="modalCancelBtn" style="
          background:#fff; color:#1976d2; border:1.5px solid #1976d2; border-radius:6px;
          padding:8px 24px; font-size:16px; font-weight:500; cursor:pointer;">
          취소
        </button>
      </div>
    </form>
  </div>
</div>
  
  
  
</body>
</html>










