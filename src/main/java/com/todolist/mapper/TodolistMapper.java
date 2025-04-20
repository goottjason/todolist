package com.todolist.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.todolist.domain.SearchDTO;
import com.todolist.domain.SortDTO;
import com.todolist.domain.TodoDTO;

public interface TodolistMapper {
  int insertTodo(TodoDTO todoDTO);

  List<TodoDTO> selectAllTodo(String userid);

  void updateFinished(@Param("dno") int dno, @Param("finished") boolean finished);

  void deleteTodo(@Param("dno") int dno);

  void updateFinished(TodoDTO todoDTO);

  void updateTodo(TodoDTO todoDTO);

  List<TodoDTO> selectSearchTodo(SearchDTO searchDTO);

  List<TodoDTO> selectTodoDueTommorrow();
  
  List<TodoDTO> selectOne(@Param("dno") int dno);

  List<TodoDTO> selectwhere(SortDTO sortDTO);
}
