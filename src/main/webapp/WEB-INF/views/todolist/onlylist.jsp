<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>To-Do List</title>
<script type="text/javascript">
	
</script>
<script src="https://kit.fontawesome.com/9bef4b10f4.js" crossorigin="anonymous"></script>
<style>
</style>
</head>
<body>
<!-- 할일 테이블 영역 -->
<div id="ajaxList" class="table-box" style="background:#fff; border-radius:8px; box-shadow:0 2px 8px #eee; padding:16px;">
  <table style="width:100%; border-collapse:collapse; table-layout:fixed;">
    <!-- 열 비율 -->
    <colgroup>
      <col style="width:5%;">  <!-- 체크박스 컬럼 -->
      <col style="width:8%;">
      <col style="width:55%;">
      <col style="width:19%;">
      <col style="width:14%;">
      <col style="width:14%;">
    </colgroup>
    <!-- 컬럼명 -->
    <thead>
      <tr style="border-bottom:1px solid #f0f0f0;">
        <th style="text-align:center; padding:8px 0;">
          <input type="checkbox" id="selectAllCheckbox" />
        </th>
        <th style="text-align:center; padding:8px 12px;">완료</th>
        <th style="text-align:center; padding:8px 12px;">제목</th>
        <th style="text-align:center; padding:8px 12px;">기한</th>
        <th style="text-align:center; padding:8px 12px;">중요도</th>
        <th style="text-align:center; padding:8px 12px;">관리</th>
      </tr>
    </thead>
    <!-- 튜플 -->
    <tbody>
      <c:forEach var="todo" items="${todoAllList}">
        <tr>
          <!-- 체크박스 -->
          <td style="text-align:center;">
            <input type="checkbox" class="rowCheckbox" data-dno="${todo.dno}" />
          </td>
          <!-- finished -->
          <td style="text-align:center;">
            <span style="color:#4b87c6;">
              <i id="dfinishedIcon-${todo.dno}"
                 class="finishedIcon fa-regular ${todo.finished == 1 ? 'fa-circle-check' : 'fa-circle'}" 
                 data-dno="${todo.dno}" style="color:#1e3050"></i>
            </span>        
          </td>
          <!-- title -->
          <td id ="dtitleTd-${todo.dno}" class="titleTd ${todo.finished == 1 ? 'completed' : '' }"
              style="text-align:left;padding:8px 12px;cursor:pointer"
              onmouseover="this.style.background='#E1E1E1';" 
              onmouseout="this.style.background='#fff';">
            <span id="dtitlebtn-${todo.dno}" class="titleSpan" 
                  data-dno="${todo.dno}" value="${todo.title}">${todo.title}</span>
            <input type="text" class="edit-input-title" data-dno="${todo.dno}"
                   style="display:none; border:none; background:transparent; width:100%;" />
          </td>
          <!-- duedate -->
          <td id="dduedateTd-${todo.dno}" class="duedateTd" 
          style="text-align:center;padding:8px 12px;cursor:pointer"
          onmouseover="this.style.background='#E1E1E1';" 
              onmouseout="this.style.background='#fff';">
          <span id="dduedatebtn-${todo.dno}" class="duedateSpan" 
                  data-dno="${todo.dno}" value="${todo.duedate}"
                  style="color: ${todo.duedate < '2025-04-23' ? '#ec407a': todo.duedate == '2025-04-23' ? '#0f1d41' : '#1976d2'}">
                  ${todo.duedate}
                  </span>
            <input type="date" class="edit-input-duedate" data-dno="${todo.dno}"
                   style="display:none; border:none; background:transparent; width:100%;" />

          </td>
          <!-- star -->
          <td style="text-align:center;padding:8px 12px;"
          >
            <span style="color:#4b87c6;">
              <i id="dstar-${todo.dno}" class="starIcon fa-regular fa-star ${todo.star == 1 ? 'fa-solid' : ''}" 
                 data-dno="${todo.dno}" style="color:#1e3050"></i>
            </span>
          </td>
          <!-- mod, del -->
          <td style="text-align:center;padding:8px 12px;">
            <button class="moreBtn" 
                    data-dno="${todo.dno}"
                    style="border:1px solid #b1b1a8; border-radius:4px; padding:1px 6px; background:#fff; color:#777b7c; margin-right:2px; cursor:pointer; font-size:12px;">더보기</button>
            <button class="delBtn" 
                    data-dno="${todo.dno}"
                    style="border:1px solid #e57373; border-radius:4px; padding:1px 6px; background:#fff; color:#e57373; cursor:pointer; font-size:12px;">삭제</button>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
  
  <div style="margin-top:20px; text-align:left;">
  <button id="multiEditBtn"
    style="
      background:#fff;
      color:#1976d2;
      border:2px solid #1976d2;
      border-radius:6px;
      padding:8px 18px;
      font-size:15px;
      font-weight:500;
      margin-right:8px;
      cursor:pointer;
      transition:background 0.2s, border 0.2s;
    "
    onmouseover="this.style.background='#1976d2';this.style.color='#fff';"
    onmouseout="this.style.background='#fff';this.style.color='#1976d2'"
  >선택수정</button>

  <button id="multiDeleteBtn"
    style="
      background:#fff;
      color:#e53935;
      border:2px solid #e53935;
      border-radius:6px;
      padding:8px 18px;
      font-size:15px;
      font-weight:500;
      cursor:pointer;
      transition:background 0.2s, color 0.2s;
    "
    onmouseover="this.style.background='#e53935';this.style.color='#fff';"
    onmouseout="this.style.background='#fff';this.style.color='#e53935';"
  >선택삭제</button>
</div>
  
</div>

</body>
</html>