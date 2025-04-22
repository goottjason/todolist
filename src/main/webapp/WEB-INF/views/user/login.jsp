<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>To-Do</title>
</head>



<body style="background:#f8fafc; font-family:'Pretendard','Inter','Apple SD Gothic Neo',sans-serif;">

  <jsp:include page="../header.jsp"></jsp:include>
  
  <div class="container mt-5" style="max-width:380px; margin:60px auto; background:#fff; border-radius:12px; box-shadow:0 2px 16px rgba(40,60,90,0.08); padding:36px 32px 28px 32px;">
      <div class="row" style="margin:0;">
  
      <h1 style="font-size:2rem; font-weight:700; color:#0f1d41; margin-bottom:28px; text-align:center;">로그인</h1>
      
      <c:if test="${not empty authFailMsg}">
        <div style="background:#ffe6e6; color:#d32f2f; border-radius:6px; padding:10px 14px; margin-bottom:18px; font-size:15px; text-align:center;">
          ${authFailMsg}
        </div>
        <c:remove var="authFailMsg" scope="session"/>
      </c:if>
      
      <form action="login" method="POST">
        <div class="mb-3 mt-3" style="margin-bottom:18px;">
          <label for="userid" class="form-label" style="font-weight:600; color:#333; margin-bottom:6px; display:block;">아이디</label>
          <input type="text" class="form-control" id="userid" placeholder="아이디를 입력하세요" name="userid"
            style="width:100%; padding:10px 12px; border:1px solid #e0e4ea; border-radius:7px; background:#f7f8fa; font-size:15px; margin-top:4px;">
        </div>
        <div class="mb-3" style="margin-bottom:22px;">
          <label for="userpwd" class="form-label" style="font-weight:600; color:#333; margin-bottom:6px; display:block;">비밀번호</label>
          <input type="password" class="form-control" id="userpwd" placeholder="비밀번호를 입력하세요" name="userpwd"
            style="width:100%; padding:10px 12px; border:1px solid #e0e4ea; border-radius:7px; background:#f7f8fa; font-size:15px; margin-top:4px;">
        </div>
        <div style="display:flex; gap:8px; margin-top:12px;">
          <button type="submit" class="btn btn-primary"
            style="flex:1; background:#0f1d41; color:#fff; border:none; border-radius:6px; padding:10px 0; font-size:15px; font-weight:600; cursor:pointer;">로그인</button>
          <button type="reset" class="btn btn-secondary"
            style="flex:1; background:#e0e4ea; color:#0f1d41; border:none; border-radius:6px; padding:10px 0; font-size:15px; font-weight:600; cursor:pointer;">취소</button>
        </div>
      </form>
            
    </div>
  </div>
  
  <jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>