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




  <!-- 할일 테이블 -->
  <div id="ajaxList" class="table-box" style="background:#fff; border-radius:8px; box-shadow:0 2px 8px #eee; padding:16px;">
    <table style="width:100%; border-collapse:collapse; table-layout:fixed;">
      <colgroup>
        <col style="width:10%;">
        <col style="width:40%;">
        <col style="width:18%;">
        <col style="width:12%;">
        <col style="width:20%;">
      </colgroup>
      <thead>
        <tr style="border-bottom:1px solid #f0f0f0;">          
          <th style="text-align:left; padding:8px 12px;">완료</th>
          <th style="text-align:left; padding:8px 12px;">제목</th>
          <th style="text-align:left; padding:8px 12px;">기한</th>
          <th style="text-align:left; padding:8px 12px;">중요도</th>
          <th style="text-align:left; padding:8px 12px;">관리</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="todo" items="${todoAllList}" varStatus="status">
          <tr>
            <td>
              <input type="checkbox" id= "dcheck-${todo.dno}" class="form-check-input finishedCheckbox" data-dno="${todo.dno}" <c:if test="${todo.finished}">checked</c:if> name="finished" />            
            </td>
            <td style="padding:8px 12px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"
            id = "dlist-${todo.dno}" 
            class="list-group-item d-flex align-items-center ${todo.finished ? 'completed' : '' }">
              <span id="dtitlebtn-${todo.dno}" class="editable-title titleA" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="${todo.title}">${todo.title}</span>
              <input type="text" class="edit-input" style="display:none; border:none; background:transparent; font-size:inherit; width:350px; outline:none;" />
            </td>
            <td id="dduedatediv-${todo.dno}"class="duedateDiv"  style="padding:8px 12px;">${todo.duedate}</td>
            <td style="padding:8px 12px;">
              <span style="color:#4b87c6;">☆</span>
            </td>
            <td style="padding:8px 12px;">
              <button style="border:1px solid #b1b1a8; border-radius:4px; padding:1px 6px; background:#fff; color:#4b87c6; margin-right:2px; cursor:pointer; font-size:12px;">수정</button>
              <button style="border:1px solid #e57373; border-radius:4px; padding:1px 6px; background:#fff; color:#e57373; cursor:pointer; font-size:12px;">삭제</button>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>










<!-- 	<div id="ajaxList"> -->
<!-- 		<ul class="list-group"> -->
<%--         <c:forEach var="todo" items="${todoAllList}" varStatus="status"> --%>
<!--           리스트 태그요소 id : dlist-1, dlist-2 ... -->
<%--           <li id = "dlist-${todo.dno}" class="list-group-item d-flex align-items-center ${todo.finished ? 'completed' : '' }" > --%>
<!--             체크박스 태그요소 id : dcheck-1, dcheck-2 ... -->
<%--             <input type = "checkbox" id= "dcheck-${todo.dno}" class="form-check-input finishedCheckbox" data-dno="${todo.dno}" <c:if test="${todo.finished}">checked</c:if>> --%>
<!--             제목div 태그요소 id : dtitlediv-1, dtitlediv-2 ... -->
<%--             <div id="dtitlediv-${todo.dno}" class="titleDiv" > --%>
<%-- 			         <input type="button" id="dtitlebtn-${todo.dno}"  class="titleA" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="${todo.title}"> --%>
<!-- 	         </div> -->
<!--             날짜div 태그요소 id : dduedatediv-1, dduedatediv-2 ... -->
<%--             <div id="dduedatediv-${todo.dno}"class="duedateDiv" >(${todo.duedate})</div> --%>
            
            
<!--             <div><span class="star-icon" style="font-size:large; vertical-align: super"> -->
<!--             <i id="3462098" class="fa-regular fa-star fa-2xl" style="color:#1e3050" aria-hidden="false"></i></span></div> -->
            
<!--             수정버튼 태그요소 id : dmodbtn-1, dmodbtn-2 ... -->
<%--             <input id="dmodbtn-${todo.dno}" type="button" class="btn btn-outline-info btn-sm modBtn" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="수정"> --%>
<!--             완료버튼 태그요소 id: dconbtn-1, dconbtn-2 ... -->
<%--             <input id="dconbtn-${todo.dno}" type="button" class="btn btn-outline-info btn-sm conBtn" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="완료" style="display:none"> --%>
<!--             삭제버튼 태그요소 id: ddelbtn-1, ddelbtn-2 ... -->
<%--             <input id="ddelbtn-${todo.dno}" type="button" class="btn btn-outline-info btn-sm delBtn" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="삭제"> --%>
<!--           </li> -->
<%--         </c:forEach> --%>
<!--       </ul> -->
<!-- 	</div> -->

</body>
</html>