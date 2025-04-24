package com.todolist.controller;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.todolist.util.SendEmailService;
import com.todolist.domain.TodoDTO;
import com.todolist.domain.UserDTO;
import com.todolist.service.UserService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/user")
@Slf4j
@RequiredArgsConstructor
public class UserController {
  private final UserService userService;
  private final SendEmailService sendEmailService; // 메일전송담당객체 주입

  @GetMapping("/mypage")
  public String mypage(Model model, HttpSession session) {
//    
    if(session.getAttribute("authUser") != null) {
      UserDTO authUser = (UserDTO) session.getAttribute("authUser");
      authUser = userService.login(authUser.getUserid(), authUser.getUserpwd());
      return "/user/mypage";
    } else {
      return "redirect:/user/login"; // 로그인 하지 않은 경우 로그인 페이지로 리다이렉트 

    }
    
  }
  
  @GetMapping("/signup")
  public void signup() {
    
  }
  @GetMapping("/login")
  public void login() {
  }
  @GetMapping("/logout")
  public String logout(HttpSession session) {
    if(session.getAttribute("authUser") != null) {
      session.removeAttribute("authUser");
      session.invalidate();
    }
    return "redirect:/";
  }
  
  @PostMapping("/existingpwdcheck")
  @ResponseBody
  public String existingPwdCheck(@RequestParam("userid") String userid, @RequestParam("userpwd") String userpwd) {
    String result = "fail";
    log.info("■ 유저의 아이디 : {}", userid);
    log.info("■ 기존 비밀번호 : {}", userpwd);
    
    if (userService.existingPwdCheck(userid, userpwd) == 1) {
      result = "success";
    }
    
    return result;
  }
  
  
  @PostMapping("/signup")
  public String signupPost(UserDTO user, RedirectAttributes rttr) {
    log.info("회원가입하러가자! registerMember: {}", user);
    
    String result ="";
    if(userService.insertUser(user) == 1) {
      // 1이면 가입완료 >>> index.jsp로 가자.
      // 리다이렉트 할 때 status, success 붙이고 가고싶을때
      // 쿼리스트링 붙어서 감
      rttr.addFlashAttribute("signupStatus", "회원가입을 축하드립니다! 로그인 후 서비스를 이용해주세요.");
      result = "redirect:/user/login";
    } else {
      // 가입 실패하면 다시 회원가입페이지로 이동하게끔!
      rttr.addFlashAttribute("signupStatus", "일시적 장애로 회원가입에 실패하였습니다. 다시 회원가입을 부탁드립니다.");
      result = "redirect:/user/sinup";
    }
    return result;
  }
  
  @PostMapping("/updateinfo")
  public String updateInfo(UserDTO user, RedirectAttributes rttr, HttpSession session) {
//    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if(user == null) {
      return "redirect:/user/login"; // 로그인 하지 않은 경우 로그인 페이지로 리다이렉트 
    } else {
//      user.setUserid(authUser.getUserid());
      log.info("회원정보 수정 : {}", user);
      userService.updateInfo(user);
      session.setAttribute("authUser", user);
      return "redirect:/user/mypage";
    }
    
  }
  
  @PostMapping("/login")
  public String loginPost(@RequestParam("userid") String userid, @RequestParam("userpwd") String userpwd, HttpSession session, RedirectAttributes rttr) {
    String result = "";
    
    log.info("userid : {}", userid);
    log.info("userpwd : {}", userpwd);
    
    // 로그인 에러메시지 초기화
//    session.removeAttribute("authFailMsg");
    
    UserDTO authUser = userService.login(userid, userpwd);
    
    if(authUser != null) {
      // authUser가 null이 아니면, 로그인 성공
      // 세션에 추가하고, index로 이동
      session.setAttribute("authUser", authUser);

      
//      session.removeAttribute("authFailMsg");
      result = "redirect:/";
    } else {
      // authUser가 null이면, 로그인 실패
      // 아이디 또는 비밀번호가 일치하지 않습니다. 다시 입력해주세요.
      rttr.addFlashAttribute("authFailMsg", "아이디 또는 비밀번호가 일치하지 않습니다. 다시 입력해주세요.");
      result = "redirect:/user/login";
    }
    
    return result;
  }
  
  
  
  @PostMapping("/idIsDuplicate")
  @ResponseBody
  public int idIsDuplicate(@RequestParam("userid") String userid) {
    log.info("userid : {}", userid +"가 중복되는지 확인");
    if(userService.idIsDuplicate(userid) == 1) { 
      // 1이면 중복
      return 1;
    } else { 
      return 0;
    }
  }
  @PostMapping("/uniqueEmailCheck")
  @ResponseBody
  public int uniqueEmailCheck(@RequestParam("userInputEmail") String userInputEmail) {
    if(userService.uniqueEmailCheck(userInputEmail) == 1) { 
      // 1이면 중복
      return 1;
    } else { 
      return 0;
    }
  }
  
  @PostMapping("/callSendEmail")
  public ResponseEntity<String> sendEmailAuthCode(@RequestParam String useremail, HttpSession session) {
    log.info("tmpUserEmail: {}", useremail);
    String authCode = UUID.randomUUID().toString();
    log.info("authCode: {}", authCode);
    String result = "";
    try {
      sendEmailService.sendEmail(useremail, authCode);
      session.setAttribute("authCode", authCode);
      result = "success";
    } catch (IOException | MessagingException e) {
      e.printStackTrace();
      result = "fail";
    }
    return new ResponseEntity<String>(result, HttpStatus.OK);
  }
  
  @PostMapping("/checkAuthCode")
  public ResponseEntity<String> checkAuthCode(@RequestParam String userAuthCode, HttpSession session) {
    // 유저가 보낸 AuthCode와 우리가 보낸 AuthCode가 일치하는지 확인
    log.info("userAuthCode: {}", userAuthCode);
    log.info("session에 저장된 코드: {}", session.getAttribute("authCode"));
    String result = "fail";
    if (session.getAttribute("authCode") != null ) {
      String sesAuthCode = (String) session.getAttribute("authCode");
      if (userAuthCode.equals(sesAuthCode)) {
        result = "success";
      }
    }
    return new ResponseEntity<String>(result, HttpStatus.OK);
  }
  
  @PostMapping("/clearAuthCode")
  public ResponseEntity<String> clearAuthCode(HttpSession session) {
    // 세션에 저장된 인증코드를 삭제
    if(session.getAttribute("authCode") != null) {
      session.removeAttribute("authCode");
    }
    return new ResponseEntity<String>("success", HttpStatus.OK);
  }
  
  
}
