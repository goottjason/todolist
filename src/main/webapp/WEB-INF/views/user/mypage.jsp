<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript"><%@ include file="../script.js" %></script>
<title>내 정보 수정</title>

<script>
$(function() {

	// 비밀번호 체크 이벤트
  $("#mypageNewUserpwd1").on("blur", function () {
    let mypageNewUserpwd1 = $("#mypageNewUserpwd1").val();
    let mypageNewUserpwd2 = $("#mypageNewUserpwd2").val();
    let result = validCheckPwd1(mypageNewUserpwd1, mypageNewUserpwd2);
    if (result == "success") {
    	$("#mypagePwd1Valid").val("checked");
    	console.log("checked11 success");
    } else {
    	$("#mypagePwd1Valid").val("");
    	console.log("checked11 success");
    }
   });
  
  $("#mypageNewUserpwd2").on("blur", function () {
    let mypageNewUserpwd1 = $("#mypageNewUserpwd1").val();
    let mypageNewUserpwd2 = $("#mypageNewUserpwd2").val();
    let result = validCheckPwd2(mypageNewUserpwd1, mypageNewUserpwd2);
    if (result == "success") {
      $("#mypagePwd2Valid").val("checked");
      console.log("checked22 success");
    } else {
      $("#mypagePwd2Valid").val("");
    }
  });
	  
	$("#mypageNewUsername").on("blur", function() {
		let mypageNewUsername = $("#mypageNewUsername").val();
		let result = validCheckUsername(mypageNewUsername, "newUsernameMsgArea");  
		if (result == "success") {
      console.log("success");
      $("#mypageNameValid").val("checked");
    } else {
      console.log("fail");
      $("#mypageNameValid").val("");
    }
  });
	
	$("#mypageNewUseraddr").on("blur", function() {
    let mypageNewUseraddr = $("#mypageNewUseraddr").val();
    let result = validCheckUseraddr(mypageNewUseraddr, "newUseraddrMsgArea");
    if (result == "success") {
    	console.log("success");
    	$("#mypageAddrValid").val("checked");
    } else {
    	console.log("fail");
    	$("#mypageAddrValid").val("");
    }
	});
	
});


// 비밀번호변경버튼 클릭시 발생 이벤트
function pwdmodBtnClick() {
	console.log("접근");
	$("#pwdmod").show();
}

// 기존 비밀번호 확인 버튼 클릭시 발생 이벤트
function existingpwdBtnClick() {
	// 일치하는지 일치 하지 않는지 여부만 가져오기
	
	let userid = "${authUser.userid}";
	let userpwd = $("#mypageUserpwd").val();  
	console.log(userid, userpwd);
	
	let data = {
		"userid" : userid,
    "userpwd": userpwd 
  }
    
  let result = ajaxFunc("/user/existingpwdcheck", data, "text");
	if (result == "success") {
		// 기존 비밀번호 일치할 경우, 비밀번호 변경 아래 띄우기
		outputMsg("새로운 비밀번호를 기입하고 저장버튼을 누르면 변경됩니다.", $("#existingpwdErrorMsg"), "green");
		$("#newUserpwdArea").show();
		
	} else {
		// 기존 비밀번호가 불일치한 경우
		console.log(result);
		outputMsg("기존 비밀번호가 불일치합니다.", $("#existingpwdErrorMsg"), "red");
		$("#newUserpwdArea").hide();
	}
}

function mainpageIsValid() {
	let result = false;
  let pwd1Check = $("#mypagePwd1Valid").val();
  let pwd2Check = $("#mypagePwd2Valid").val();
  let nameCheck = $("#mypageNameValid").val();
	let addrCheck = $("#mypageAddrValid").val();
	console.log(pwd1Check, pwd2Check, nameCheck, addrCheck);
  if (pwd1Check == "checked" && pwd2Check == "checked"
		  && nameCheck == "checked" && addrCheck == "checked") {
    result = true;
  }
  return result;
}

</script>
</head>

<body>
<!-- include지시자 or 액션태그 -->
<jsp:include page="../header.jsp"></jsp:include>

<div class="container mt-5">
  <div class="row">
	  <h1>${authUser.username} 님의 회원 정보</h1>
	  <div class="container mt-3">
	    <form action="updateinfo" method="POST">
	      <table class="table table-hover">
	        <tr>
		        <td>아이디</td>
		        <td>${authUser.userid}</td>
	        </tr>
	        <tr>
            <td>비밀번호</td>
            <td>
              <input type="button" value="비밀번호 변경" onclick="pwdmodBtnClick()">
              <div id="pwdmod">
                먼저, 기존 비밀번호를 입력해주세요.
                <input type="password" id="mypageUserpwd" placeholder="Enter password">
                <input type="button" value="확인" onclick="existingpwdBtnClick();">
                <div id="existingpwdErrorMsg"></div>
                <div id="newUserpwdArea">
	                <p>새로운 비밀번호</p>
	                <input type="password" id="mypageNewUserpwd1" placeholder="Enter password" name="userpwd">
	                <div id="newPwd1MsgArea"></div>
	                <input type="hidden" id="mypagePwd1Valid" />
	                <p>새로운 비밀번호 재확인</p>
	                <input type="password" id="mypageNewUserpwd2" placeholder="Enter password">
	                <div id="newPwd2MsgArea"></div>
	                <input type="hidden" id="mypagePwd2Valid" />
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td>이메일</td>
            <td>${authUser.useremail}</td>
          </tr>
          <tr>
            <td>이름</td>
            <td>
            <input id="mypageNewUsername" type="text" value="${authUser.username}" name="username">
            <div id="newUsernameMsgArea"></div>
            <input type="hidden" id="mypageNameValid" />
            </td>
          </tr>
          <tr>
            <td>주소</td>
            <td>
            <input id="mypageNewUseraddr" type="text" value="${authUser.useraddr}" name="useraddr">
            <div id="newUseraddrMsgArea"></div>
            <input type="hidden" id="mypageAddrValid" />
            </td>
          </tr>
	      </table>
	      <button type="submit" class="btn btn-success" onclick="return mainpageIsValid();">저장</button>
        <button type="submit" class="btn btn-danger">취소</button>
	    </form>
	  </div>
  </div>
</div>
<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>