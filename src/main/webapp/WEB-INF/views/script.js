

function ajaxFunc(url, data, dataType=null) {
  let result = "";
  $.ajax({
    url : url, 
    type : "POST", 
    data : data,
    dataType : dataType,
    async : false,
    success : function(data) {
      result = data;
    },
    error : function() {
    },
    complete : function() {
    },
  }); 
  return result;
}


function ajaxFunc2(url, contentType, dataType, data) {
  let result = "";
  $.ajax({
    url : url,
    type : "POST",
    contentType: contentType, // 클라이언트가 서버로 보내는 데이터타입
    dataType : dataType, // 서버로부터 받을 응답 데이터의 타입
    data : data,
    async : false,
    success : function(data) {
      result = data;
    },
    error : function() {
    },
    complete : function() {
    },
  }); 
  return result;
}



function outputMsg(errorMsg, tagObj, color) {
  // tagObj 요소의, 그 다음 요소에 출력
  let errTag = $(tagObj);
  $(errTag).html(errorMsg);
  $(errTag).css("color", color);
  $(tagObj).css("border-color", color);
}

function validCheckPwd1 (pwd1, pwd2) {
  // 비밀번호 8~20자
  if (pwd1.length < 8 || pwd1.length > 20) {
    outputMsg("비밀번호는 8~20자로 입력하세요!", $("#newPwd1MsgArea"), "red");
    return "fail";
  } else {
    if(pwd2 == "") {
      outputMsg("아래에 다시 한번 입력해주세요.", $("#newPwd1MsgArea"), "orange");
      return "success";
    } else {
      if(pwd1 != pwd2) {
        outputMsg("비밀번호가 일치하지 않습니다.", $("#newPwd1MsgArea"), "red");
        outputMsg("", $("#newPwd2MsgArea"), "red");
        return "fail";
      } else {
        outputMsg("비밀번호 검증완료", $("#newPwd1MsgArea"), "green");
        outputMsg("비밀번호가 일치합니다.", $("#newPwd2MsgArea"), "green");
        return "success";
      }    
    }
  }
}

function validCheckPwd2 (pwd1, pwd2) {
  if (pwd1.length < 8 || pwd1.length > 20) {
    outputMsg("비밀번호는 8~20자로 입력하세요!", $("#newPwd1MsgArea"), "red");
    return "fail";
  }
  if(pwd1 != pwd2) { // 
    outputMsg("비밀번호가 일치하지 않습니다.", $("#newPwd1MsgArea"), "red");
    outputMsg("", $("#newPwd2MsgArea"), "red");
    return "fail";
  } else {
    outputMsg("비밀번호 검증완료", $("#newPwd1MsgArea"), "green");
    outputMsg("비밀번호가 일치합니다.", $("#newPwd2MsgArea"), "green");
    return "success";
  }
}

function validCheckUsername (username, id) {
  if(username.length > 0) { // 
    outputMsg("사용가능", $("#"+id), "green");
    return "success";
  } else {
    outputMsg("이름은 필수 입력입니다.", $("#"+id), "red");
    return "fail";
    
  }
}

function validCheckUseraddr(useraddr, id) {
  if(useraddr.length > 0) { // 
    outputMsg("사용가능", $("#"+id), "green");
    return "success";
  } else {
    outputMsg("주소는 필수 입력입니다.", $("#"+id), "red");
    return "fail";
  }
}