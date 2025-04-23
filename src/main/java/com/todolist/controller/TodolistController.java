package com.todolist.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.todolist.domain.CountDTO;
import com.todolist.domain.SearchDTO;
import com.todolist.domain.SelectDTO;
import com.todolist.domain.SelectedAllDTO;
import com.todolist.domain.SendInsertDTO;
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
      log.info("●LIST●● selectDTO : {}", selectDTO);
      List<TodoDTO> list = todolistService.selectMulti(selectDTO);
      model.addAttribute("todoAllList", list);
      
      return "/todolist/list";
    }
  }
  
  // @RequestParam: GET, 폼 전송, 간단한 값 전달
  // @RequestBody: 요청 body → 자바 객체로 변환 / 요청 데이터 받기/ REST API, AJAX, JSON 데이터 등
  // @ResponseBody: 자바 객체 → 응답 body로 변환 / 데이터 응답 보내기
  @PostMapping("/updateSelectedAll")
  @ResponseBody
  public String updateSelectedAll(@RequestBody SelectedAllDTO selectedAllDTO,HttpSession session) {
    log.info("■■■■■ DTO : {}", selectedAllDTO);
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "redirect:/user/login";
    } else {
      selectedAllDTO.setWriter(authUser.getUserid());
      // 수정할 데이터가 없는 경우
      if (selectedAllDTO.isEmptyUpdateData()) {
        return "fail";
      }
      try {
        todolistService.updateSelectedAll(selectedAllDTO);
      } catch (Exception e) {
        e.printStackTrace();
        return "fail";
      }
      return "success";
    }
  }  
  
  @PostMapping("/deleteSelectedAll")
  @ResponseBody
  public String deleteSelectedAll(@RequestBody SelectedAllDTO selectedAllDTO,HttpSession session) {
    log.info("■■■■■ DTO : {}", selectedAllDTO);
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "redirect:/user/login";
    } else {
      if (selectedAllDTO.isEmptyDeleteData()) {
        return "fail";
      } else {
        selectedAllDTO.setWriter(authUser.getUserid());
        try {
          todolistService.deleteSelectedAll(selectedAllDTO);
        } catch (Exception e) {
          e.printStackTrace();
          return "fail";
        }
        return "success";
      }
    }
    
  }  

  
  @PostMapping("/insertTodo") 
  @ResponseBody
  public String insertTodo(@RequestBody SendInsertDTO sendInsertDTO, RedirectAttributes rttr, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if(authUser == null) {
      return "redirect:/user/login"; // 로그인 하지 않은 경우 로그인 페이지로 리다이렉트 
    } else {
      sendInsertDTO.setWriter(authUser.getUserid());
      sendInsertDTO.setDefaultValues();
      
      log.info("■■■■■ sendInsertDTO : {}", sendInsertDTO);
      // dno=0, writer=goottjason, title=내용 없음, duedate=null, 
      // finished=0, star=0, memo=null, location=null
      if(todolistService.insertTodo(sendInsertDTO) == 1) {
        return "success";  
      } else {
        return "fail";
      }
    }
  }  
  
  


  @PostMapping("/selectMulti")
  public String selectMulti(SelectDTO selectDTO, HttpSession session, Model model) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    
    if (authUser == null) {
      return "/user/login";
    } else {
      selectDTO.setWriter(authUser.getUserid());
      log.info("●●● selectDTO : {}", selectDTO);
      List<TodoDTO> list = todolistService.selectMulti(selectDTO);        
      model.addAttribute("todoAllList", list);
      
      return "/todolist/onlylist";
    }
    
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
  // 타이틀 클릭시 업데이트
  @PostMapping("/updateDuedate")
  @ResponseBody
  public String updateDuedate(@RequestParam("dno") int dno, @RequestParam("duedate") String duedate, HttpSession session) {
    UserDTO authUser = (UserDTO) session.getAttribute("authUser");
    if (authUser == null) {
      return "/user/login";
    }

    log.info("◆◆◆◆◆ dno: {}", dno);
    try {
      todolistService.updateDuedate(dno, duedate);
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
