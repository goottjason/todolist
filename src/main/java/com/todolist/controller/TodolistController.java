package com.todolist.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.todolist.domain.CountDTO;
import com.todolist.domain.SearchDTO;
import com.todolist.domain.SelectDTO;
import com.todolist.domain.SortDTO;
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
      SelectDTO selectDTO = new SelectDTO();
      selectDTO.setWriter(authUser.getUserid());
      selectDTO.setOrderby("duedate");
      selectDTO.setOrdermethod("asc");
      log.info("●●● selectDTO : {}", selectDTO);
      List<TodoDTO> list = todolistService.selectMulti(selectDTO);
      model.addAttribute("todoAllList", list);
      
      return "/todolist/list";
    }
  }
  
  
  //아이디어정보기술
  //타이드플로?

  @PostMapping("/selectMulti")
  public String selectMulti(SelectDTO selectDTO, HttpSession session, Model model) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    
    if (authUser == null) {
      return "/user/login";
    }
    
    selectDTO.setWriter(authUser.getUserid());
    
    log.info("●●● selectDTO : {}", selectDTO);
    
    List<TodoDTO> list = todolistService.selectMulti(selectDTO);
  
    model.addAttribute("todoAllList", list);
  
    return "/todolist/onlylist";
  }
  
  
  
  
  
  
  
  
  @PostMapping("/register") 
  @ResponseBody
  public String register(TodoDTO todoDTO, RedirectAttributes rttr, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if(authUser == null) {
      return "redirect:/user/login"; // 로그인 하지 않은 경우 로그인 페이지로 리다이렉트 
    } else {
      if(todoDTO.getDuedate().equals("")) {     
        todoDTO.setDuedate(null);
      }
      todoDTO.setWriter(authUser.getUserid());
      log.info("◆◆◆◆◆register Todo{}", todoDTO);
      
      if(todolistService.register(todoDTO) == 1) {
        rttr.addFlashAttribute("status", "success");   
      } else {
        return "fail";
      }
    }
    return "success";
  }
  
  
  
  
  
  // 체크박스 클릭시 업데이트
  @PostMapping("/updateFinished")
  @ResponseBody
  public String updateFinished(@RequestParam("dno") int dno, @RequestParam("finished") int finished, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }

    log.info("◆◆◆◆◆ dno: {}", dno);
    log.info("◆◆◆◆◆ finished: {}", finished);

    try {
      todolistService.updateFinished(dno, finished);
    } catch (Exception e) {
      e.printStackTrace();
      return "fail";
    }
    return "success";
  }
  
  // 중요도 클릭시 업데이트
  @PostMapping("/updateStar")
  @ResponseBody
  public String updateStar(@RequestParam("dno") int dno, @RequestParam("star") int star, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }

    log.info("◆◆◆◆◆ dno: {}", dno);
    log.info("◆◆◆◆◆ star: {}", star);
    try {
      todolistService.updateStar(dno, star);
    } catch (Exception e) {
      e.printStackTrace();
      return "fail";
    }
    return "success";
  }
  
  // 타이틀 클릭시 업데이트
  @PostMapping("/updateTitle")
  @ResponseBody
  public String updateTitle(@RequestParam("dno") int dno, @RequestParam("title") String title, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }

    log.info("◆◆◆◆◆ dno: {}", dno);
    log.info("◆◆◆◆◆ title: {}", title);
    try {
      todolistService.updateTitle(dno, title);
    } catch (Exception e) {
      e.printStackTrace();
      return "fail";
    }
    return "success";
  }
  
  // 디테일 사이드바에서 업데이트
  @PostMapping("/updateDetail")
  @ResponseBody // success는 뷰 이름이 아니다. 값 자체를 응답해야하므로 어노테이션 붙여준다!
  public String updateDetail(TodoDTO todoDTO, RedirectAttributes rttr, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }
    if(todoDTO.getDuedate().equals("")) {     
      todoDTO.setDuedate(null);
    }
    log.info("{◆◆◆◆◆ todoDTO : {}", todoDTO);
    todolistService.updateTodo(todoDTO);
    
    return "success";
  }
  
  // 디테일 사이드바에서 삭제
  @PostMapping("/deleteDetail")
  @ResponseBody
  public String deleteDetail(@RequestParam("dno") int dno, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }
    log.info("◆◆◆◆◆ dno: {}", dno);
    try {
      todolistService.deleteDetail(dno);
    } catch (Exception e) {
      e.printStackTrace();
      return "fail";
    }
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
  
  
  
//  @PostMapping("/selectSortBy")
//  public String selectSortBy(@RequestParam("sortBy") String sortBy, HttpSession session, Model model) {
//    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
//    if (authUser == null) {
//      return "/user/login";
//    }
//    List<TodoDTO> list = todolistService.selectSortBy(authUser.getUserid(), sortBy);
//    log.info("■■■■ {}", list);
//
//    model.addAttribute("todoAllList", list);
//    return "/todolist/onlylist";
//  }
  
  
//  @PostMapping("/selectwhere")
//  public String selectwhere(SortDTO sortDTO, HttpSession session, Model model) {
//    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
//    if (authUser == null) {
//      return "/user/login";
//    }
//    sortDTO.setWriter(authUser.getUserid());
//    log.info("★★★★★★★{}", sortDTO);
//    
//    List<TodoDTO> list = todolistService.selectwhere(sortDTO);
//    model.addAttribute("todoAllList", list);
//    log.info("■■■■■■■■{}", list);
//
//    return "/todolist/onlylist";
//  }
  
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
  
  @PostMapping("/todoCnt")
  public String todoCnt(@RequestParam("today") String today, HttpSession session, Model model) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }
    String writer = authUser.getUserid();
    List<CountDTO> countDTO = todolistService.todoCnt(writer, today);
    model.addAttribute("countList", countDTO);
    return "/todolist/countinfo";
  }
  
  @PostMapping("/listDuedate")
  public String listDuedate(HttpSession session, Model model) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }
    String writer = authUser.getUserid();
    List<TodoDTO> list = todolistService.listDuedate(writer);
    model.addAttribute("duedateList", list);
    return "/todolist/duedateinfo";
  }
  
  
  
  
}
