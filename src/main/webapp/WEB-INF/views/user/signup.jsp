<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<title>Insert title here</title>
<script type="text/javascript">


$(function() {
  // 비밀번호 체크 이벤트
  $(document).on("blur", "#userpwd1", function () {
    // 비밀번호 4~8자
    let tmpPwd = $("#userpwd1").val();
    if (tmpPwd.length < 8 || tmpPwd.length > 20) {
      outputError("비밀번호는 8~20자로 입력하세요!", $("#userpwd1"), "red");
      $("#pwdValid").val("");
    } else {
      let tmpPwd1 = $("#userpwd1").val();
      let tmpPwd2 = $("#userpwd2").val();
      if(tmpPwd2 == "") {
        outputError("아래에 다시 한번 입력해주세요.", $("#userpwd1"), "orange");
      } else {
        if(tmpPwd1 != tmpPwd2) {
          outputError("비밀번호가 일치하지 않습니다.", $("#userpwd1"), "red");
          outputError("", $("#userpwd2"), "red");
          $("#pwdValid").val("");
        } else {
          outputError("비밀번호 검증완료", $("#userpwd1"), "green");
          outputError("비밀번호가 일치합니다.", $("#userpwd2"), "green");
          $("#pwdValid").val("checked");
        }    
      }
    }
  });  
  $(document).on("blur", "#userpwd2", function () {
    let tmpPwd1 = $("#userpwd1").val();
    let tmpPwd2 = $("#userpwd2").val();
    if (tmpPwd1.length < 8 || tmpPwd1.length > 20) {
      return;
    }
    if(tmpPwd1 != tmpPwd2) { // 
      outputError("비밀번호가 일치하지 않습니다.", $("#userpwd1"), "red");
      outputError("", $("#userpwd2"), "red");
      $("#pwdValid").val("");
    } else {
      outputError("비밀번호 검증완료", $("#userpwd1"), "green");
      outputError("비밀번호가 일치합니다.", $("#userpwd2"), "green");
      $("#pwdValid").val("checked");
    }
  });
  
  // 빈칸으로 블러했을 때에만, outputError(red)
  $(document).on("blur", "#useremail", function () {
    if($("#useremail").val().length == 0) {
      outputError("이메일은 필수항목입니다.", $("#useremail"), "red");
    }
  });
  // 이메일을 입력하는 동안 주소 유효성 검증
  $(document).on("keyup", "#useremail", function () {
    let usermail = $("#useremail").val();
    console.log(useremail);
    if($("#useremail").val().length > 0) {
      outputError("올바른 이메일 형식으로 입력해주세요.", $("#useremail"), "red");
      let useremail = $("#useremail").val();
      let emailRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      if (!emailRegExp.test(useremail)) {
        outputError("올바른 이메일 형식으로 입력해주세요.", $("#useremail"), "red");
      } else {
        outputError("올바른 이메일 형식입니다.", $("#useremail"), "green");
        // 유효성 검증 완료되면, 인증하기 버튼 활성화
        $("#emailAuthBtn").show();        
      }
    }
  });
  // 인증코드를 입력하면, 보내진인증코드와 일치여부 확인
  $(document).on("keyup", "#authCodeInput", function () {
	  
  });
  
  $(document).on("blur", "#username", function () {
      console.log($("#username").val());
      if($("#username").val().length > 0) { // 
        outputError("사용가능", $("#username"), "green");
        $("#nameValid").val("checked");
      } else {
        outputError("이름은 필수 입력입니다.", $("#memberName"), "red");
        $("#nameValid").val("");
      }    
  });
});



// ▶▶▶▶▶ 이메일 관련 함수

function uniqueEmailCheck() {
	let userInputEmail = $("#useremail").val();
	  $.ajax({
	    url: "/user/uniqueEmailCheck", // 데이터가 송수신될 서버의 주소
	    type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
	    data: { "userInputEmail": userInputEmail },
	    dataType: "text", 
	    async: false,
	    success: function (data) {
	      console.log(data); // 데이터가 넘어오면 콘솔에 확인
	      if (data == 1) {
	    	  alert("중복된 이메일이 존재합니다. 다른 이메일을 입력해주세요.");
      
	      } else {
	    	  callSendEmail();
	      }
	      
	    },
	    error: function () {},
	    complete: function () {},
	  });
}

// "인증하기" 버튼 클릭시 작동
function emailAuth() {
	uniqueEmailCheck();
	alert("결과", result);
  // 이메일 보내는 요청
  if (result == "success") {
	  alert("중복체크 성공");
	  
  }
  // keyup이벤트로 인증번호 일치시 인증을 완료했어요 & 인증번호 및 이메일창 비활성화
}

function emailInput() {
	console.log("keyup 먹히니?")
	  let userAuthCode = $("#authCodeInput").val();
	  $.ajax({
	    url: "/user/checkAuthCode", // 데이터가 송수신될 서버의 주소
	    type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
	    data: { "userAuthCode": userAuthCode },
	    dataType: "text", 
	    success: function (data) {
	      console.log(data); // 데이터가 넘어오면 콘솔에 확인
	      if (data == "success") {
	        outputError("인증완료", $("#useremail"), "blue");
	        // 이메일인풋, 인증인풋, 인증하기 비활성화
//	        $(".authDiv").remove();
	        $(".authDiv").hide(); 
	        $("#emailInputBtn").hide();
	        $("#emailValid").val("checked");        
	      } else {
	        outputError("인증번호가 일치하지 않습니다. 다시 입력해주세요.", $("#useremail"), "red");
	      }
	      
	    },
	    error: function () {},
	    complete: function () {},
	  });
}

function callSendEmail() {
  $.ajax({
    url: "/user/callSendEmail", // 데이터가 송수신될 서버의 주소
    type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
    data: {"useremail": $("#useremail").val()},
    dataType: "text",
    success: function (data) {
      console.log(data); // 데이터가 넘어오면 콘솔에 확인
      if (data == "success") {
    	  $(".authDiv").show();
        startTimer(); // 타이머 동작을 호출
        $("#emailAuthBtn").hide();
        $("#emailInputBtn").show();
      }
    },
    error: function () {},
    complete: function () {},
  });
}

let timeLeft = 180; // 초단위
let intervalId = null;

function startTimer() {
  // 3분(180초)부터 줄어가야 함
  // setInterval 
  clearTimer();
  timeLeft = 30;
  updateDisplay(timeLeft);
  intervalId = setInterval(function() {
    timeLeft--;
    updateDisplay(timeLeft);
    if (timeLeft <= 0) {
      // 타이머 종료
      clearTimer();
      expiredTimer();
    }
  }, 1000); // 밀리초이므로 1초 = 1000
  
}

function expiredTimer() {
  // 인증버튼 비활성화
  $("#authBtn").hide();
  
  // 타이머 종료시, 백엔드에도 인증시간이 만료되었음을 알려야 한다.
  if($("#emailValid").val() != "checked") {
    $.ajax({
      url: "/user/clearAuthCode", // 데이터가 송수신될 서버의 주소
      type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
      dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
      success: function (data) {
        console.log(data); // 데이터가 넘어오면 콘솔에 확인
        alert("인증시간이 만료. 인증메일을 다시 보냈으니, 확인해주세요.");
				callSendEmail();
				outputError("", $("#useremail"), "blue");
				startTimer();
//         $("#emailAuthBtn").show();  
      },
      error: function () {},
      complete: function () {},
    });
  }
}

function clearTimer() {
  if (intervalId != null) {    
    clearInterval(intervalId); // ID값을 전달하여 setInterval을 클리어할 수 있음
    intervalId = null; // 다시 초기세팅하듯이 돌려놓음
  }
}

function updateDisplay(seconds) {
  // 시간출력
  let min = Math.floor(seconds/60);
  let sec = String(seconds % 60).padStart(2, "0"); // 2자리인데 남은 부분은 왼쪽에 0으로 채워주는 메서드
  let remainTime = min + ":" + sec;
  $(".timer").html(remainTime);
}


function idCheck() {
  let userid = $("#userid").val();
  console.log(userid);
  // 아이디 : 필수 & 중복 불가 & 길이(4~8자)
  if (userid.length > 0) {
    if (userid.length < 8 || userid.length > 20) {
      outputError("아이디는 8~20자 사이로 입력하세요", $("#userid"), "red");
      $("#idValid").val("");
    } else {
      // 아이디 중복 체크 (같은 페이지 내에서 요청을 보내고 받으려면, ajax가 필요함)  
      $.ajax({
        url: "/user/idIsDuplicate", // 데이터가 송수신될 서버의 주소
        type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
        data: { // 보낼 데이터
          "userid": userid
        },
        dataType: "text", // 수신받을 데이터 타입 (MIME TYPE)
        // async: false, // 동기 통신 방식
        success: function (data) {
          // 통신이 성공하면 수행할 함수
          console.log(data); // 데이터가 넘어오면 콘솔에 확인
          if (data == 0) {
            outputError("사용 가능한 아이디입니다.", $("#userid"), "green");
            $("#idValid").val("checked");
            // 중복확인
          } else {
            outputError("중복된 아이디입니다. 다른 아이디를 입력해주세요.", $("#userid"), "red");  
            $("#idValid").val("");
          }
        },
        error: function () {},
        complete: function () {},
      });      
    }
  } else {
    // 빈칸으로 두고 blur
    outputError("아이디는 필수항목입니다.", $("#userid"), "red");
  }

}


function outputError(errorMsg, tagObj, color) {
  // input요소 넘어오면, 그 이전 요소를 잡아준다. (span)
  let errTag = $(tagObj).closest('.mb-3').find('.errorMsg');
  $(errTag).html(errorMsg);
  $(errTag).css("color", color); // 인라인으로 첨부됨
  $(tagObj).css("border-color", color);
}

function idValid() {
  let result = false;
  
  if ($("#idValid").val() == "checked") {
    result = true;
  }
  return result;
}
function pwdValid() {
  let result = false;
  if ($("#pwdValid").val() == "checked") {
    result = true;
  }
  return result;
}

function emailValid() {
  let result = false;
  if ($("#emailValid").val() == "checked") {
    result = true;
  }
  return result;
}
function nameValid() {
  let result = false;
  if ($("#nameValid").val() == "checked") {
    result = true;
  }
  return result;
}
function addrValid() {
    let result = true;
    return result;
}


function isValid() {
  let result = false;
  let idCheck = idValid();
  let pwdCheck = pwdValid();
  let emailCheck = emailValid();
  let nameCheck = nameValid();
  let addrCheck = addrValid();
  console.log(idCheck, pwdCheck, emailCheck, nameCheck);
  if (idCheck && pwdCheck && emailCheck && nameCheck) {
    result = true;
  }
  return result;
}
</script>


<style>
  .timer { color: red }
</style>
</head>



<body>
  <jsp:include page="../header.jsp"></jsp:include>
  <div class="container mt-5">
    <div class="row" style="max-width: 550px; margin: 0 auto; padding: 30px; background-color: #f8f9fa; border-radius: 10px; box-shadow: 0 0 15px rgba(0,0,0,0.1);">
      <div style="color: #dc3545; font-size: 14px; margin-bottom: 10px;">${signupStatus}</div>
      <h3 style="text-align: center; margin-bottom: 25px; color: #0f1d41; font-weight: 600; padding-bottom: 15px;">회원가입</h3>
      <form action="signup" method="POST" style="width: 100%;">
        <div class="mb-3 mt-3" style="margin-bottom: 20px; position: relative;">
          <label for="userid" style="display: block; font-weight: 500; margin-bottom: 8px; color: #333;">아이디 :&nbsp;&nbsp;<span class="errorMsg" style="color: #dc3545; font-size: 13px;"></span></label>
          
          <div style="display: flex; gap: 10px;">
            <input type="text" class="form-control" id="userid" placeholder="Enter ID" name="userid" style="flex: 1; padding: 10px; border: 1px solid #ced4da; border-radius: 5px; font-size: 14px;">
            <button type="button" class="btn btn-success" onclick="idCheck();" style="white-space: nowrap; background-color: #0f1d41; color: white; border: none; border-radius: 5px; padding: 8px 15px; cursor: pointer; font-size: 14px;">중복확인</button>
          </div>
          <input type="hidden" id="idValid" />
        </div>
        <div class="mb-3" style="margin-bottom: 20px; position: relative;">
          <label for="userpwd1" style="display: block; font-weight: 500; margin-bottom: 8px; color: #333;">비밀번호 :&nbsp;&nbsp;
          <span class="errorMsg" style="color: #dc3545; font-size: 13px;"></span></label>
          <div>
          <input type="password" class="form-control" id="userpwd1" placeholder="Enter password" name="userpwd" style="width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 5px; font-size: 14px;">
          </div>
        </div>
        <div class="mb-3" style="margin-bottom: 20px; position: relative;">
          <label for="userpwd2" style="display: block; font-weight: 500; margin-bottom: 8px; color: #333;">비밀번호 재입력 :&nbsp;&nbsp;<span class="errorMsg" style="color: #dc3545; font-size: 13px;"></span></label>
          <input type="password" class="form-control" id="userpwd2" placeholder="Enter password again" style="width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 5px; font-size: 14px;">
          <input type="hidden" id="pwdValid" />
        </div>
        
        <div class="mb-3 mt-3" style="margin-bottom: 20px; position: relative;">
          <label for="useremail" style="display: block; font-weight: 500; margin-bottom: 8px; color: #333;">이메일 :&nbsp;&nbsp;<span class="errorMsg" style="color: #dc3545; font-size: 13px;"></span></label>
          <div style="display: flex; gap: 10px; margin-bottom: 10px;">
            <input type="email" class="form-control" id="useremail" placeholder="Enter your email" name="useremail" style="flex: 1; padding: 10px; border: 1px solid #ced4da; border-radius: 5px; font-size: 14px;">
            <button type="button" class="btn btn-success" onclick="emailAuth();" id="emailAuthBtn" style="display:none; white-space: nowrap; background-color: #28a745; color: white; border: none; border-radius: 5px; padding: 8px 15px; cursor: pointer; font-size: 14px;">인증하기</button>
          </div>
          <div class="authDiv mt-2" style="display:none; margin-top: 10px;">
            <div style="display: flex; gap: 10px; align-items: center;">
              <input type="text" class="form-control" id="authCodeInput" placeholder="인증번호를 입력하세요." style="flex: 1; padding: 10px; border: 1px solid #ced4da; border-radius: 5px; font-size: 14px;" />
              <div class="d-flex align-items-center" style="color: #dc3545; font-weight: 500;">
                <span class="timer">3:00</span>
              </div>
            </div>
            <button type="button" class="btn btn-success" onclick="emailInput();" id="emailInputBtn" style="display:none; background-color: #28a745; color: white; border: none; border-radius: 5px; padding: 8px 15px; cursor: pointer; font-size: 14px; margin-top: 10px;">입력완료</button>
          </div>
          <input type="hidden" id="emailValid" />
        </div> 
        <div class="mb-3 mt-3" style="margin-bottom: 20px; position: relative;">
          <label for="username" style="display: block; font-weight: 500; margin-bottom: 8px; color: #333;">이름 :&nbsp;&nbsp;
          <span class="errorMsg" style="color: #dc3545; font-size: 13px;"></span></label>

          <input type="text" class="form-control" id="username" placeholder="Enter your name" name="username" style="width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 5px; font-size: 14px;">
          <input type="hidden" id="nameValid" />
          
        </div>
        <div class="mb-3 mt-3" style="margin-bottom: 25px; position: relative;">
          <label for="useraddr" style="display: block; font-weight: 500; margin-bottom: 8px; color: #333;">주소 :&nbsp;&nbsp;
          <span class="errorMsg" style="color: #dc3545; font-size: 13px;"></span></label>
          <input type="text" class="form-control" id="useraddr" placeholder="Enter your address" name="useraddr" style="width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 5px; font-size: 14px;">
          <input type="hidden" id="addrValid" />
        </div>
        <div style="display: flex; gap: 10px; justify-content: center; margin-top: 15px;">
          <button type="submit" class="btn btn-success" onclick="return isValid();" style="background-color: #32691e; color: white; border: none; border-radius: 5px; padding: 10px 30px; cursor: pointer; font-weight: 500; transition: background-color 0.3s;">가입하기</button>
          <button type="reset" class="btn btn-danger" style="background-color: #dc3545; color: white; border: none; border-radius: 5px; padding: 10px 30px; cursor: pointer; font-weight: 500; transition: background-color 0.3s;">취소</button>
        </div>
      </form>
    </div>  
  
  
  
  
  
  
  
  
  
  
  
  
    
  </div>
  <jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>