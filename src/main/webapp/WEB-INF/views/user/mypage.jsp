<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript"><%@ include file="../script.js" %></script>
<style><%@include file="../style.css"%></style>
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



<body style="background:#f8fafc; font-family:'Pretendard','Inter','Apple SD Gothic Neo',sans-serif;">

<jsp:include page="../header.jsp"></jsp:include>

<div class="container mt-5" style="max-width:540px; margin:48px auto; background:#fff; border-radius:14px; box-shadow:0 2px 16px rgba(40,60,90,0.08); padding:36px 32px 28px 32px;">
  <div class="row" style="margin:0;">
    <h1 style="font-size:1.7rem; font-weight:700; color:#0f1d41; margin-bottom:32px; text-align:center; letter-spacing:-1px;">
      ${authUser.username} 님의 회원 정보
    </h1>
    <div class="container mt-3" style="padding:0;">
      <form action="updateinfo" method="POST">
        <table class="table table-hover" style="width:100%; border-collapse:separate; border-spacing:0 14px;">
          <tr>
            <td style="width:30%; font-weight:600; color:#0f1d41; background:#f6f8fb; border-radius:8px 0 0 8px; padding:12px 14px;">아이디</td>
            <td style="background:#f7f7fa; border-radius:0 8px 8px 0; padding:12px 14px;">${authUser.userid}</td>
          </tr>
          <tr>
            <td style="font-weight:600; color:#0f1d41; background:#f6f8fb; border-radius:8px 0 0 8px; padding:12px 14px;">비밀번호</td>
            <td style="background:#f7f7fa; border-radius:0 8px 8px 0; padding:12px 14px;">
              <input type="button" value="비밀번호 변경" onclick="pwdmodBtnClick()" style="background:#0f1d41; color:#fff; border:none; border-radius:6px; padding:7px 16px; font-size:14px; font-weight:600; cursor:pointer;">
              <div id="pwdmod" style="margin-top:12px;">
                <div style="font-size:14px; color:#888; margin-bottom:6px;">먼저, 기존 비밀번호를 입력해주세요.</div>
                <input type="password" id="mypageUserpwd" placeholder="기존 비밀번호" style="width:70%; padding:8px 12px; border:1px solid #e0e4ea; border-radius:6px; background:#f7f8fa; font-size:14px;">
                <input type="button" value="확인" onclick="existingpwdBtnClick();" style="background:#0f1d41; color:#fff; border:none; border-radius:6px; padding:7px 16px; font-size:14px; margin-left:6px; font-weight:600; cursor:pointer;">
                <div id="existingpwdErrorMsg" style="color:#d32f2f; font-size:13px; margin-top:4px;"></div>
                <div id="newUserpwdArea" style="margin-top:12px;">
                  <p style="margin-bottom:4px; font-weight:500;">새로운 비밀번호</p>
                  <input type="password" id="mypageNewUserpwd1" placeholder="새 비밀번호" name="userpwd" style="width:70%; padding:8px 12px; border:1px solid #e0e4ea; border-radius:6px; background:#f7f8fa; font-size:14px;">
                  <div id="newPwd1MsgArea" style="font-size:13px; color:#d32f2f;"></div>
                  <input type="hidden" id="mypagePwd1Valid" />
                  <p style="margin-bottom:4px; margin-top:8px; font-weight:500;">새로운 비밀번호 재확인</p>
                  <input type="password" id="mypageNewUserpwd2" placeholder="새 비밀번호 재입력" style="width:70%; padding:8px 12px; border:1px solid #e0e4ea; border-radius:6px; background:#f7f8fa; font-size:14px;">
                  <div id="newPwd2MsgArea" style="font-size:13px; color:#d32f2f;"></div>
                  <input type="hidden" id="mypagePwd2Valid" />
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td style="font-weight:600; color:#0f1d41; background:#f6f8fb; border-radius:8px 0 0 8px; padding:12px 14px;">이메일</td>
            <td style="background:#f7f7fa; border-radius:0 8px 8px 0; padding:12px 14px;">${authUser.useremail}</td>
          </tr>
          <tr>
            <td style="font-weight:600; color:#0f1d41; background:#f6f8fb; border-radius:8px 0 0 8px; padding:12px 14px;">이름</td>
            <td style="background:#f7f7fa; border-radius:0 8px 8px 0; padding:12px 14px;">
              <input id="mypageNewUsername" type="text" value="${authUser.username}" name="username" style="width:70%; padding:8px 12px; border:1px solid #e0e4ea; border-radius:6px; background:#f7f8fa; font-size:14px;">
              <div id="newUsernameMsgArea" style="font-size:13px; color:#d32f2f;"></div>
              <input type="hidden" id="mypageNameValid" />
            </td>
          </tr>
          <tr>
            <td style="font-weight:600; color:#0f1d41; background:#f6f8fb; border-radius:8px 0 0 8px; padding:12px 14px;">주소</td>
            <td style="background:#f7f7fa; border-radius:0 8px 8px 0; padding:12px 14px;">
              <input id="mypageNewUseraddr" type="text" value="${authUser.useraddr}" name="useraddr" style="width:70%; padding:8px 12px; border:1px solid #e0e4ea; border-radius:6px; background:#f7f8fa; font-size:14px;">
              <div id="newUseraddrMsgArea" style="font-size:13px; color:#d32f2f;"></div>
              <input type="hidden" id="mypageAddrValid" />
            </td>
          </tr>
        </table>
        <div style="display:flex; gap:10px; margin-top:28px;">
          <button type="submit" class="btn btn-success" onclick="return mainpageIsValid();"
            style="flex:1; background:#0f1d41; color:#fff; border:none; border-radius:7px; padding:12px 0; font-size:15px; font-weight:600; cursor:pointer;">저장</button>
          <button type="submit" class="btn btn-danger"
            style="flex:1; background:#e0e4ea; color:#0f1d41; border:none; border-radius:7px; padding:12px 0; font-size:15px; font-weight:600; cursor:pointer;">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>
<jsp:include page="../footer.jsp"></jsp:include>
</body>




</html>