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

<style>
</style>
</head>
<body>
	<div id="ajaxDuedateInfo">
	<div>
<%-- 	 ${duedateList} --%>
	 <c:forEach var="todo" items="${duedateList}">
	   <span class="duedateByTodo">${todo.duedate}</span>
	 </c:forEach>
	</div>
<%-- 	 <span id="spanTodayCnt">${countList[0].todayCnt}</span> --%>
<%-- 	 <span id="spanAllCnt">${countList[0].allCnt}</span> --%>
<%-- 	 <span id="spanUnfinishedCnt">${countList[0].unfinishedCnt}</span> --%>
<%-- 	 <span id="spanStarCnt">${countList[0].starCnt}</span> --%>
<%-- 	 <span id="spanIsDuedateCnt">${countList[0].isDuedateCnt}</span> --%>
<%-- 	 <span id="spanIsNotDuedateCnt">${countList[0].isNotDuedateCnt}</span> --%>
	</div>
</body>
</html>