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
        <col style="width:10%;">
        <col style="width:40%;">
        <col style="width:18%;">
        <col style="width:12%;">
        <col style="width:20%;">
      </colgroup>
      <!-- 컬럼명 -->
      <thead>
        <tr style="border-bottom:1px solid #f0f0f0;">          
          <th style="text-align:left; padding:8px 12px;">완료</th>
          <th style="text-align:left; padding:8px 12px;">제목</th>
          <th style="text-align:left; padding:8px 12px;">기한</th>
          <th style="text-align:left; padding:8px 12px;">중요도</th>
          <th style="text-align:left; padding:8px 12px;">관리</th>
        </tr>
      </thead>
      <!-- 튜플 -->
      <tbody>
        <c:forEach var="todo" items="${todoAllList}">
          <tr>
            <!-- finished -->
            <td>
              <span style="color:#4b87c6;">
                <i id="dfinishedIcon-${todo.dno}"
                   class="finishedIcon fa-regular ${todo.finished == 1 ? 'fa-circle-check' : 'fa-circle'}" 
                   data-dno="${todo.dno}" style="color:#1e3050"></i>
              </span>        
            </td>
            
            <!-- title -->
            <td id ="dtitleTd-${todo.dno}" class="titleTd ${todo.finished == 1 ? 'completed' : '' }"
                style="padding:8px 12px;">
              <span id="dtitlebtn-${todo.dno}" class="titleSpan" 
                    data-dno="${todo.dno}" value="${todo.title}">${todo.title}</span>
              <input type="text" class="edit-input" data-dno="${todo.dno}"
                     style="display:none; border:none; background:transparent; width:300px;" />
            </td>
            
            <!-- duedate -->
            <td id="dduedatediv-${todo.dno}" class="duedateDiv"  style="padding:8px 12px;">${todo.duedate}</td>
            
            <!-- star -->
            <td style="padding:8px 12px;">
              <span style="color:#4b87c6;">
                <i id="dstar-${todo.dno}" class="starIcon fa-regular fa-star ${todo.star == 1 ? 'fa-solid' : ''}" 
                   data-dno="${todo.dno}" style="color:#1e3050"></i>
              </span>
            </td>
            <!-- mod, del -->
            <td style="padding:8px 12px;">
              <button class="moreBtn" 
                      data-dno="${todo.dno}"
                      style="border:1px solid #b1b1a8; border-radius:4px; padding:1px 6px; background:#fff; color:#4b87c6; margin-right:2px; cursor:pointer; font-size:12px;">더보기</button>
              <button class="delBtn" 
                      data-dno="${todo.dno}"
                      style="border:1px solid #e57373; border-radius:4px; padding:1px 6px; background:#fff; color:#e57373; cursor:pointer; font-size:12px;">삭제</button>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>












</body>
</html>