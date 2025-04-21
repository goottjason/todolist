package com.todolist.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.todolist.domain.SearchDTO;
import com.todolist.domain.SortDTO;
import com.todolist.domain.TodoDTO;

public interface TodolistMapper {
  int insertTodo(TodoDTO todoDTO);

  List<TodoDTO> selectAllTodo(@Param("userid") String userid);
  
  // 체크박스 클릭시 업데이트
  void updateFinished(@Param("dno") int dno, @Param("finished") int finished);

  // 중요도 클릭시 업데이트
  void updateStar(@Param("dno") int dno, @Param("star") int star);

  // 타이틀 클릭시 업데이트
  void updateTitle(@Param("dno") int dno, @Param("title") String title);
  
  // 디테일 사이드바에서 삭제
  void deleteDetail(int dno);

  void deleteTodo(@Param("dno") int dno);

  void updateFinished(TodoDTO todoDTO);

  void updateTodo(TodoDTO todoDTO);

  List<TodoDTO> selectSearchTodo(SearchDTO searchDTO);

  List<TodoDTO> selectTodoDueTommorrow();
  
  List<TodoDTO> selectOne(@Param("dno") int dno);

  List<TodoDTO> selectwhere(SortDTO sortDTO);

  List<TodoDTO> selectSortBy(@Param("writer") String writer, @Param("sortBy") String sortBy);

}
