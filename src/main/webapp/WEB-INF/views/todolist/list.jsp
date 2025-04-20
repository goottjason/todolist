<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <!-- 외부 라이브러리 및 스타일 -->
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script type="text/javascript"><%@ include file="../script.js" %></script>
  <script src="https://kit.fontawesome.com/9bef4b10f4.js" crossorigin="anonymous"></script>
  <style><%@include file="list_style.css"%></style>
  
  
  
  <title>다이어리목록</title>
  
  

  <script type="text/javascript">
  
  // ================================
  // jQuery 이벤트 및 동작 초기화
  // ================================
  $(function() {

    // -------- 인라인 제목 수정 --------
    $(document).on('click', '.editable-title', function() {
      var $span  = $(this);
      var $input = $span.siblings('.edit-input');
      $input.val($span.text()).show().focus();
      $span.hide();
    });

    $(document).on('keydown', '.edit-input', function(e) {
      if (e.key === "Enter") {
        var $input = $(this);
        var value  = $input.val();
        var $span  = $input.siblings('.editable-title');
        $span.text(value).show();
        $input.hide();
        modify(value); // 엔터 시 수정 함수 호출
      }
    });

    $(document).on('blur', '.edit-input', function() {
      var $input = $(this);
      var $span  = $input.siblings('.editable-title');
      $span.text($input.val()).show();
      $input.hide();
    });

    
    // -------- 정렬 모달 동작 --------
    $('#sortBtn').on('click', function(e) {
      e.stopPropagation();
      var btnOffset = $(this).offset();
      var btnHeight = $(this).outerHeight();
      $('#sortModal').show();
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

    
    // -------- 페이지 초기화 --------
    doList();
    let today = new Date().toISOString().substring(0, 10);
    $("#duedate, #from, #to").val(today);

    
    // -------- 검색 및 필터 --------
    $('input:radio[name="finished"]').change(function() {
      doSearch();
    });

    $("#searchWord").on("keyup", function() {
      let searchWord = $(this).val();
      if (searchWord.length != 0) {
        doSearch();       
      } else {
        let result = ajaxFunc("/todolist/selectall", null, null);
        doList(result);
      }
    });

    $("#searchBtn").click(function() {   
      $("#searchFormCard").toggle();
    });

    
    // -------- 완료 체크박스 --------
    $(".finishedCheckbox").change(function() {
      let dno = $(this).data("dno");
      let checked = $(this).is(":checked");
      let data = { "dno": dno, "finished": checked };
      let result = ajaxFunc("/todolist/updateFinished", data, "text");
      if (result == 'success') {
        $("#dlist-" + dno).toggleClass("completed", checked);
        self.location = '/todolist/list';
      }
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

    
    // -------- 상세 수정 확인 버튼 --------
    $("body").on("click", ".detailConBtn", function() {
      let dno      = $(this).data("dno");
      let writer   = $(this).data("writer");
      let title    = $("#detailtitle-" + dno).val();
      let duedate  = $("#detailduedate-" + dno).val();
      let memo     = $("#detailmemo-" + dno).val();
      let location = $("#detaillocation-" + dno).val();
      let data = {
        dno: dno, writer: writer, title: title,
        duedate: duedate, memo: memo, location: location
      };
      let result = ajaxFunc("/todolist/updateTodo", data, "text");
      let nowUpdateTime = new Date().toLocaleString();
      $("#nowUpdateTime").html(nowUpdateTime);
      $("#updateTimeView").show();
      doList();
    });

    
    // -------- 삭제 버튼 --------
    $("body").on("click", ".delBtn", function() {
      let dno = $(this).data("dno");
      let data = { "dno": dno };
      let result = ajaxFunc("/todolist/deleteTodo", data, "text");
      if (result == 'success') {
        self.location = '/todolist/list';
      }
    });

    
    // -------- 제목 클릭 시 상세 보기 --------
    $("body").on("click", ".titleA", function() {
      let dno = $(this).data("dno");
      let data = { "dno": dno };
      let result = ajaxFunc("/todolist/selectone", data, null);
      let html = jQuery('<div>').html(result);
      let contents = html.find("div#ajaxTodoDetail").html();
      $("#todoDetail").html(contents);
    });

  }); // jQuery ready end

  // ================================
  // 함수 정의
  // ================================

  // 할일 등록
  function register() {
    let title = $("#title").val();
    let duedate = $("#duedate").val();
    let writer = $("#writer").val();
    let data = { writer: writer, title: title, duedate: duedate };
    let result = ajaxFunc("/todolist/register", data, "text");
    if (result == "success") {
      self.location = '/todolist/list';
    }
  }

  // 할일 목록 조회
  function doList(result) {
    if (!result) result = ajaxFunc("/todolist/selectall", null, null);
    let html = jQuery('<div>').html(result);
    let contents = html.find("div#ajaxList").html();
    $("#todolist").html(contents);
  }

  // 조건별 목록 조회
  function selectWhere(duedate, star) {
    if (duedate == 'today') {
      duedate = new Date().toISOString().substring(0, 10);
    }
    let data = { duedate: duedate, star: star };
    let result = ajaxFunc("/todolist/selectwhere", data, null);
    let html = jQuery('<div>').html(result);
    let contents = html.find("div#ajaxList").html();
    $("#todolist").html(contents);
  }

  // 검색
  function doSearch() {
    let searchTypes = "title";
    let searchWord = $("#searchWord").val();
    let finished = $('input:radio[name="finished"]:checked').val();
    let from = $("#from").val();
    let to = $("#to").val();
    let data = {
      searchTypes: searchTypes,
      searchWord: searchWord,
      finished: finished,
      from: from,
      to: to
    };
    let result = ajaxFunc("/todolist/search", data, null);
    let html = jQuery('<div>').html(result);
    let contents = html.find("div#ajaxList").html();
    $("#todolist").html(contents);
  }

  // 인라인 수정 콜백
  function modify(newValue) {
    // 원하는 동작을 여기에 작성
    alert('수정된 값: ' + newValue);
  }
  </script>
</head>





<body>
  <!-- 정렬기준 모달 -->
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

  <!-- 헤더 영역 -->
  <jsp:include page="../header.jsp"></jsp:include>

  <!-- 페이지 전체 레이아웃 -->
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

    <!-- 중앙 메인 영역 -->
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

      

      <div id="todolist"></div>
    </div>

    <!-- 우측 상세 영역 -->
    <div class="right">
      <div id="todoDetail"></div>
    </div>
  </div>

  <!-- 푸터 영역 -->
  <jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>










