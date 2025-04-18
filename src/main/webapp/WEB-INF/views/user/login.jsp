<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- include지시자 or 액션태그 -->
	<jsp:include page="../header.jsp"></jsp:include>
	
	<div class="container mt-5">
  		<div class="row">
	
			<h1>로그인</h1>
			<c:if test="${not empty authFailMsg}">
			  <!-- 로그인실패 메시지 띄우고, authFailMsg 세션 삭제하기 -->
				<div>${authFailMsg}</div>
				<c:remove var="authFailMsg" scope="session"/>
			</c:if>
			
			<form action="login" method="POST">
			  <div class="mb-3 mt-3">
			    <label for="userid" class="form-label">아이디 :</label>
			    <input type="text" class="form-control" id="userid" placeholder="Enter userid" name="userid">
			  </div>
			  <div class="mb-3">
			    <label for="userpwd" class="form-label">Password:</label>
			    <input type="password" class="form-control" id="userpwd" placeholder="Enter password" name="userpwd">
			  </div>
			  <button type="submit" class="btn btn-primary">로그인</button>
			  <button type="reset" class="btn btn-secondary">취소</button>
			</form>
						
		</div>
	</div>
	
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>