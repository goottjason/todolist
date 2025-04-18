<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<title>To Do</title>
<style>
.itembox {
	display: flex;
	justify-content: space-between;
}

.left {
	width: 200px;
	height: 100%;
}

.right {
	width: 200px;
	height: 100%;
}

.center {
	width: 100%;
	height: 100%;
}
</style>
</head>
<body>
	<div class="itembox">
		<div class="left">
			<a class="navbar-brand" href="/">To do</a>
		</div>
		<div class="center">
			<div id="searchBar">검색</div>
		</div>
		<div class="right">
			<ul class="navbar-nav">
				<c:choose>
					<c:when test="${authUser == null}">
						<li class="nav-item"><a class="nav-link" href="/user/signup">가입</a>
						</li>
						<li class="nav-item"><a class="nav-link" href="/user/login">로그인</a>
						</li>
					</c:when>
					<c:otherwise>
						<li class="nav-item"><a class="nav-link" href="/user/mypage">${authUser.userid}님의
								my page</a></li>
						<li class="nav-item"><a class="nav-link" href="/user/logout">로그아웃</a>
						</li>
						<li class="nav-item"><a class="nav-link"
							href="/todolist/list">To-Do List</a></li>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
	</div>
</body>
</html>