package com.todolist.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.todolist.domain.SearchDTO;
import com.todolist.domain.TodoDTO;
import com.todolist.mapper.TodolistMapper;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class TodolistServiceImpl implements TodolistService {
  private final TodolistMapper todolistMapper;
  
  @Override
  public int register(TodoDTO todoDTO) {
    return todolistMapper.insertTodo(todoDTO);
  }

  @Override
  public List<TodoDTO> viewAll(String userid) {
    return todolistMapper.selectAllTodo(userid);
  }

  @Override
  public void updateFinished(int dno, boolean finished) {
    todolistMapper.updateFinished(dno, finished);
  }

  @Override
  public void deleteTodo(int dno) {
    todolistMapper.deleteTodo(dno);
  }

  @Override
  public void updateTodo(TodoDTO todoDTO) {
    todolistMapper.updateTodo(todoDTO);
    
  }

  @Override
  public List<TodoDTO> searchTodo(SearchDTO searchDTO) {
    // TODO Auto-generated method stub
    return todolistMapper.selectSearchTodo(searchDTO);
  }

  @Override
  public List<TodoDTO> selectOne(int dno) {
    // TODO Auto-generated method stub
    return todolistMapper.selectOne(dno);
  }

  @Override
  public List<TodoDTO> selectwhere(TodoDTO todoDTO) {
    // TODO Auto-generated method stub
    log.info("$$$$$$$$$$$$$$$$$$$$${}", todoDTO);
    return todolistMapper.selectwhere(todoDTO);
  }

}
