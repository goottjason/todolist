package com.todolist.service;

import java.util.List;

import com.todolist.domain.SearchDTO;
import com.todolist.domain.SortDTO;
import com.todolist.domain.TodoDTO;

public interface TodolistService {

  int register(TodoDTO todoDTO);

  List<TodoDTO> viewAll(String userid);

  void updateFinished(int dno, boolean finished);

  void deleteTodo(int dno);

  void updateTodo(TodoDTO todoDTO);

  List<TodoDTO> searchTodo(SearchDTO searchDTO);

  List<TodoDTO> selectOne(int dno);

  List<TodoDTO> selectwhere(SortDTO sortDTO);

}
