package com.todolist.service;

import java.util.List;

import com.todolist.domain.SearchDTO;
import com.todolist.domain.SortDTO;
import com.todolist.domain.TodoDTO;

public interface TodolistService {

  int register(TodoDTO todoDTO);

  List<TodoDTO> viewAll(String userid);
  
  
  // 체크박스 클릭시 업데이트
  void updateFinished(int dno, int finished);

  // 중요도 클릭시 업데이트
  void updateStar(int dno, int star);
  
  // 타이틀 클릭시 업데이트
  void updateTitle(int dno, String title);

  // 디테일 사이드바에서 삭제
  void deleteDetail(int dno);
  
  
  void deleteTodo(int dno);

  void updateTodo(TodoDTO todoDTO);

  List<TodoDTO> searchTodo(SearchDTO searchDTO);

  List<TodoDTO> selectOne(int dno);

  List<TodoDTO> selectwhere(SortDTO sortDTO);

  List<TodoDTO> selectSortBy(String writer, String sortBy);


}
