<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<title>Diary</title>

</head>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">
			<c:choose>
				<c:when test="${authUser == null }">
					<script>
						$(function() {
							// 로그인 페이지로 이동
							this.location = '/user/login';
						});
					</script>
				</c:when>
				<c:otherwise>
					<script>
						$(function() {
							// 리스트 페이지로 이동
							this.location = '/todolist/list';
						});
					</script>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>

</body>
</html>