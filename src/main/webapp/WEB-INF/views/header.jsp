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
<script type="text/javascript"><%@ include file="script.js" %></script>
<style><%@include file="style.css"%></style>
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
    <a class="navbar-brand" href="/">To do</a>
    </div>
    <div class="headerCenter">
      <div id="searchBar">
        <div id="firstLine" class="search-bar">
          <input type="text" class="form-control search-bar__input" id="searchWord"
            placeholder="" name="searchWord" /> <input type="hidden"
            name="searchTypes" value="title" />
        </div>
      </div>
    </div>
    <div class="headerRight">
      <ul>
        <c:choose>
          <c:when test="${authUser == null}">
            <li class="headerLi"><a href="/user/signup" class="navbar-brand">가입</a></li>
            <li class="headerLi"><a href="/user/login" class="navbar-brand">로그인</a></li>
          </c:when>
          <c:otherwise>
            <li class="headerLi"><a href="/user/mypage" class="navbar-brand">${authUser.userid}님</a></li>
            <li class="headerLi"><a href="/user/logout" class="navbar-brand">로그아웃</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</body>
</html>