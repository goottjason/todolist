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
<script
  src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link href="https://fonts.googleapis.com/css2?family=Glatic:wght@700&display=swap" rel="stylesheet">
<script src="https://kit.fontawesome.com/9bef4b10f4.js" crossorigin="anonymous"></script>

<style>
<%@include file="style.css"%>  
</style>  
  
  
<script type="text/javascript"><%@ include file="script.js" %></script>
<title>To Do</title>
<style>

</style>
<script>
  function dueChange() {
    doSearch();
  }
</script>
</head>
<body>
  <div class="headerItembox">
    <div class="headerLeft">
    <a class="navbar-brand" href="/todolist/list">
    
    <span style="font-family: 'Glatic', sans-serif; font-weight: 700; font-size: 1.4rem;">To-Do</span></a>
    </div>
    <div class="headerCenter" style="width:700px;outline:none;">
      <div id="searchBar" style="width:700px;">
        <div id="firstLine" class="search-bar" style="position:relative; width:100%; max-width:800px;">
          <input
            type="text"
            id="searchWord"
            class="form-control search-bar__input"
            name="searchWord"
            placeholder="검색어를 입력하세요"
            style="
                width:100%;
                padding:8px 12px 8px 38px;
                border:none;
                border-radius:20px;
/*                 background:#26323a; */
                color:gray;
                font-size:17px;
                box-sizing:border-box;
                outline:none;
              "
            >
          <span style="
            position:absolute;
            left:12px;
            top:50%;
            transform:translateY(-50%);
            color:#bfc6cc;
            font-size:20px;
            cursor:pointer;
          ">
            <i class="fa-solid fa-magnifying-glass"></i>
          </span>
        </div>
      </div>
    </div>
    <div class="headerRight">
      <ul>
        <c:choose>
          <c:when test="${authUser == null}">
            <li class="headerLi" style="padding: 0 10px"><a href="/user/signup" class="navbar-brand">가입</a></li>
            <li class="headerLi" style="padding: 0 10px"><a href="/user/login" class="navbar-brand"><i class="fa-solid fa-right-to-bracket" style="padding: 0 10px"></i>로그인</a></li>
          </c:when>
          <c:otherwise>
            <li class="headerLi" style="padding: 0 10px"><a href="/user/mypage" class="navbar-brand">${authUser.userid}님 MyPage</a></li>
            <li class="headerLi" style="padding: 0 10px"><a href="/user/logout" class="navbar-brand"><i class="fa-solid fa-right-from-bracket" style="padding: 0 10px"></i>로그아웃</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</body>
</html>