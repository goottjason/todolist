package com.todolist.util;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.todolist.domain.TodoDTO;
import com.todolist.mapper.TodolistMapper;
import com.todolist.mapper.UserMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class EmailReminderScheduler {

  private final UserMapper userMapper;
  private final TodolistMapper todolistMapper;
  private final SendEmailService sendEmailService;
  
//  @Scheduled(cron = "0 0/1 * * * * ")
  public void reminderSchedule() throws AddressException, FileNotFoundException, IOException, MessagingException {
    // 내일이 마감인 글 조회
    List<TodoDTO> list = todolistMapper.selectTodoDueTommorrow();
    log.info("★★★★{}", list);
    
    Map<String, List<TodoDTO>> todoMap = new HashMap<>();
    
    for(TodoDTO dto : list) {
      if(!todoMap.containsKey(dto.getWriter())) {
        todoMap.put(dto.getWriter(), new ArrayList<TodoDTO>());
      }
      todoMap.get(dto.getWriter()).add(dto);
    }
    
    for(Map.Entry<String, List<TodoDTO>> entry : todoMap.entrySet()) {
      String userid = entry.getKey();
      String useremail = userMapper.selectEmail(userid);
      log.info("●●●●●●●●●●{}, {}", userid, useremail);
      StringBuilder sb = new StringBuilder();
      sb.append("내일까지 해야할 일");
      for(TodoDTO dto : entry.getValue()) {
        sb.append("●").append(dto.getTitle());
      }
      sb.append(userid+ "님, 완료하세요");
      
      sendEmailService.sendReminder(useremail, sb.toString());
    }
  }
}
