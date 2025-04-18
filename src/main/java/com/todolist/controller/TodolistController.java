package com.todolist.controller;

import java.time.LocalDate;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.todolist.domain.SearchDTO;
import com.todolist.domain.TodoDTO;
import com.todolist.domain.UserDTO;
import com.todolist.service.TodolistService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/todolist")
@Slf4j
@RequiredArgsConstructor
public class TodolistController {
  
  private final TodolistService todolistService;
  
  @GetMapping("/list")
  public String list(Model model, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if(authUser == null) {
      return "redirect:/user/login"; // 로그인 하지 않은 경우 로그인 페이지로 리다이렉트 
    } else {
      List<TodoDTO> list = todolistService.viewAll(authUser.getUserid());
      model.addAttribute("todoAllList", list);
      
      return "/todolist/list";
    }
  }
  
  
  @PostMapping("/register") 
  @ResponseBody
  public String register(TodoDTO todoDTO, RedirectAttributes rttr, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    log.info("◆◆◆◆◆authUser{}", authUser);
    log.info("◆◆◆◆◆todoDTO{}", todoDTO);
    if(authUser == null) {
      return "fail";
    } else {
      try {
        if(todolistService.register(todoDTO) == 1) {
          rttr.addFlashAttribute("status", "success");
        } else {
          log.info("등록 실패");
        }
      } catch (Exception e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    return "success";
  }
  
  @PostMapping("/updateFinished")
  @ResponseBody
  public String updateFinished(@RequestParam("dno") int dno, @RequestParam("finished") boolean finished) {
    log.info("◆◆◆◆◆ dno: {}", dno);
    log.info("◆◆◆◆◆ finished: {}", finished);
    todolistService.updateFinished(dno, finished);
    
    return "success";
  }
  
  @PostMapping("/updateTodo")
  @ResponseBody // success는 뷰 이름이 아니다. 값 자체를 응답해야하므로 어노테이션 붙여준다!
  public String updateTodo(TodoDTO todoDTO, RedirectAttributes rttr, HttpSession session) {
    log.info("{◆◆◆◆◆ todoDTO : {}", todoDTO);
    todolistService.updateTodo(todoDTO);
    
    return "success";
  }
  
  @PostMapping("/deleteTodo")
  @ResponseBody
  public String deleteTodo(@RequestParam("dno") int dno) {
    log.info("◆◆◆◆◆ dno: {}", dno);
    todolistService.deleteTodo(dno);
    
    return "success";
  }
  
  @PostMapping("/search")
  public String searchDiary(SearchDTO searchDTO, HttpSession session, Model model) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }
    searchDTO.setWriter(authUser.getUserid());
    log.info("▶▶▶▶▶▶▶▶▶▶검색해보자: searchDTO : {}", searchDTO);
    List<TodoDTO> todoAllList = todolistService.searchTodo(searchDTO);
    log.info("▶▶▶▶▶▶▶▶▶▶검색결과 리스트 {}", todoAllList);
    model.addAttribute("todoAllList", todoAllList);
    return "/todolist/onlylist";
  }
  
  @PostMapping("/selectall")
  public String selectall(TodoDTO todoDTO, HttpSession session, Model model) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }
    todoDTO.setWriter(authUser.getUserid());
    List<TodoDTO> list = todolistService.viewAll(authUser.getUserid());
    model.addAttribute("todoAllList", list);
    return "/todolist/onlylist";
  }
  
  @PostMapping("/selectwhere")
  public String selectwhere(TodoDTO todoDTO, HttpSession session, Model model) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }
    todoDTO.setWriter(authUser.getUserid());
    log.info("★★★★★★★{}", todoDTO);
    List<TodoDTO> list = todolistService.selectwhere(todoDTO);
    model.addAttribute("todoAllList", list);
    log.info("■■■■■■■■{}", list);

    return "/todolist/onlylist";
  }
  
  @PostMapping("/selectone")
  public String selectone(TodoDTO todoDTO, HttpSession session, Model model) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }
    todoDTO.setWriter(authUser.getUserid());
    log.info("{}", todoDTO);
    List<TodoDTO> list = todolistService.selectOne(todoDTO.getDno());
    log.info("*******************{}", list);
    model.addAttribute("todo", list);
    return "/todolist/tododetail";
  }
  
  
  
  
}
