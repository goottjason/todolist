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
<title>Diary</title>
<style>
#collapsibleNavbar {
	background-color: pink;
}

#searchBar {
	background-color: red;
}
</style>
</head>
<body>
	<nav class="navbar navbar-expand-sm bg-secondary navbar-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="/">To do</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#collapsibleNavbar">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div id="searchBar">검색</div>
			<div class="collapse navbar-collapse" id="collapsibleNavbar">
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
			<!-- end : collapse navbar-collapse -->
		</div>
		<!-- end : container-fluid -->
	</nav>
</body>
</html>