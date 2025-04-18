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

	<div id="ajaxList">
		<ul class="list-group">
        <c:forEach var="todo" items="${todoAllList}" varStatus="status">
          <!-- 리스트 태그요소 id : dlist-1, dlist-2 ... -->
          <li id = "dlist-${todo.dno}" class="list-group-item d-flex align-items-center ${todo.finished ? 'completed' : '' }" >
            <!-- 체크박스 태그요소 id : dcheck-1, dcheck-2 ... -->
            <input type = "checkbox" id= "dcheck-${todo.dno}" class="form-check-input finishedCheckbox" data-dno="${todo.dno}" <c:if test="${todo.finished}">checked</c:if>>
            <!-- 제목div 태그요소 id : dtitlediv-1, dtitlediv-2 ... -->
            <div id="dtitlediv-${todo.dno}" class="titleDiv" >
			         <input id="dtitlebtn-${todo.dno}" type="button" class="titleA" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="${todo.title}">
	         </div>
            <!-- 날짜div 태그요소 id : dduedatediv-1, dduedatediv-2 ... -->
            <div id="dduedatediv-${todo.dno}"class="duedateDiv" >(${todo.duedate})</div>
            
            
            <div><span class="star-icon" style="font-size:large; vertical-align: super">
            <i id="3462098" class="fa-regular fa-star fa-2xl" style="color:#1e3050" aria-hidden="false"></i></span></div>
            
            <!-- 수정버튼 태그요소 id : dmodbtn-1, dmodbtn-2 ... -->
            <input id="dmodbtn-${todo.dno}" type="button" class="btn btn-outline-info btn-sm modBtn" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="수정">
            <!-- 완료버튼 태그요소 id: dconbtn-1, dconbtn-2 ... -->
            <input id="dconbtn-${todo.dno}" type="button" class="btn btn-outline-info btn-sm conBtn" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="완료" style="display:none">
            <!-- 삭제버튼 태그요소 id: ddelbtn-1, ddelbtn-2 ... -->
            <input id="ddelbtn-${todo.dno}" type="button" class="btn btn-outline-info btn-sm delBtn" data-dno="${todo.dno}" data-title="${todo.title}" data-date="${todo.duedate}" value="삭제">
          </li>
        </c:forEach>
      </ul>
	</div>

</body>
</html>