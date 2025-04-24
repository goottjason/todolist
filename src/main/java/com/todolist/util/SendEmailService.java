package com.todolist.util;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


import lombok.extern.slf4j.Slf4j;


@Component
@Slf4j
public class SendEmailService {
  @Value("${email.username}")
  private String username;
  @Value("${email.password}")
  private String password;
  
  public void sendEmail(String emailAddr, String activationCode) throws FileNotFoundException, IOException, AddressException, MessagingException {
    String subject = "😊 legacydiary.com에서 보내는 회원가입 이메일 인증번호입니다.";
    String message = "회원가입을 환영합니다. 인증번호를 입력하시고, 회원가입을 완료하세요. " + "인증번호: " + activationCode;
    Properties props = new Properties();
    
    // 호스트 주소를 저장해둠
    props.put("mail.smtp.host", "smtp.naver.com"); // smtp.gmail.com
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.starttls.required", "true");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.ssl.trust", "smtp.naver.com"); // 구글 할 때는 지워
    
    
//    getAccount();
    
    
    // 세션을 생성
    Session emailSession = Session.getInstance(props, new Authenticator() {
      @Override
      protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(username, password);
      }
    });
    
    log.info("emailSession: {}", emailSession.toString());
    log.info("emailAddr {}", emailAddr);
    
    if (emailSession != null) {
      MimeMessage mime = new MimeMessage(emailSession);
      mime.setFrom(new InternetAddress("ordinary_things@naver.com")); // 보내는 사람의 메일주소를 세팅
      mime.addRecipient(RecipientType.TO, new InternetAddress(emailAddr)); // 받는 사람의 메일주소를 세팅
      
      mime.setSubject(subject); // 메일의 제목
      mime.setText(message); // 메일의 본문
//      String html = "<h1>회원가입을 환영합니다</h1><h2>인증번호 입력하세요.</h2><h3>" + activationCode + "</h3>";
//      mime.setText(html, "utf-8", "html");
      Transport.send(mime);
    }
  }

  
  public void sendReminder(String emailAddr, String message) throws FileNotFoundException, IOException, AddressException, MessagingException {
    String subject = "내일까지 해야할 일이 있습니다.";
    
    Properties props = new Properties();
    
    // 호스트 주소를 저장해둠
    props.put("mail.smtp.host", "smtp.naver.com"); // smtp.gmail.com
    props.put("mail.smtp.port", "587");
    props.put("mail.smtp.starttls.required", "true");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    props.put("mail.smtp.auth", "true");
//    props.put("mail.smtp.ssl.trust", "smtp.naver.com"); // 구글 할 때는 지워
    
    
//    getAccount();
    
    
    // 세션을 생성
    Session emailSession = Session.getInstance(props, new Authenticator() {
      @Override
      protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(username, password);
      }
    });
    
    log.info("emailSession: {}", emailSession.toString());
    log.info("emailAddr {}", emailAddr);

    
    if (emailSession != null) {
      MimeMessage mime = new MimeMessage(emailSession);
      mime.setFrom(new InternetAddress("ordinary_things@naver.com")); // 보내는 사람의 메일주소를 세팅
      mime.addRecipient(RecipientType.TO, new InternetAddress(emailAddr)); // 받는 사람의 메일주소를 세팅
      
      mime.setSubject(subject); // 메일의 제목
      mime.setText(message, "utf-8", "html");
      Transport.send(mime);
    }
  }
}