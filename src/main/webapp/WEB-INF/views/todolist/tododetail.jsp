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
<style>
</style>
</head>
<body>
	<div id="ajaxTodoDetail">
		<div class="testDiv">
			<div>
			  <div>제목</div>
				<input type = "checkbox" id= "detailcheck-${todo[0].dno}" class="form-check-input finishedCheckbox" data-dno="${todo[0].dno}" <c:if test="${todo[0].finished}">checked</c:if>>
				<input type="text" class="form-control" id="detailtitle-${todo[0].dno}" name="detailtitle" value="${todo[0].title}">
			</div>
			<div>
			  <div>기한</div>
				<input type="date" class="form-control" id="detailduedate-${todo[0].dno}" name="detailduedate" value="${todo[0].duedate}">
			</div>
			<div>
			   <div>노트</div>
				<input type="text" class="form-control" id="detailmemo-${todo[0].dno}" name="detailmemo" value="${todo[0].memo}">
			</div>
			<div>
			  <div>위치</div>
				<input type="text" class="form-control" id="detaillocation-${todo[0].dno}" name="detaillocation" value="${todo[0].location}">
			</div>
			<div>
			<input id="detailconbtn-${todo[0].dno}" type="button" class="btn btn-outline-info btn-sm detailConBtn" data-dno="${todo[0].dno}" data-writer="${todo[0].writer}" value="수정하기">
			</div>
			<div id="updateTimeView">
			업데이트 됨 : <span id="nowUpdateTime"></span>
			</div>

			<!--     <ul class="list-group"> -->
			<!--        리스트 태그요소 id : dlist-1, dlist-2 ... -->
			<%--        <li id ="dlist-${todo[0].dno}" class="list-group-item d-flex align-items-center ${todo[0].finished ? 'completed' : '' }" > --%>

			<!--        </li> -->
			<!--       </ul> -->
		</div>
	</div>
</body>
</html>