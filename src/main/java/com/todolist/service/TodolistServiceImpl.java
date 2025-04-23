package com.todolist.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.todolist.domain.CountDTO;
import com.todolist.domain.SearchDTO;
import com.todolist.domain.SelectDTO;
import com.todolist.domain.SelectedAllDTO;
import com.todolist.domain.SendInsertDTO;
import com.todolist.domain.SortDTO;
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
  public int insertTodo(SendInsertDTO sendInsertDTO) {
    return todolistMapper.insertTodo(sendInsertDTO);
  }

  @Override
  public List<TodoDTO> viewAll(String userid) {
    return todolistMapper.selectAllTodo(userid);
  }

  // 체크박스 클릭시 업데이트
  @Override
  public void updateFinished(int dno, int finished) {
    todolistMapper.updateFinished(dno, finished);
  }
  
  // 체크박스 클릭시 업데이트
  @Override
  public void updateStar(int dno, int star) {
    todolistMapper.updateStar(dno, star);
  }

  // 타이틀 클릭시 업데이트
  @Override
  public void updateTitle(int dno, String title) {
    todolistMapper.updateTitle(dno, title);
  }

	@Override
	public void updateDuedate(int dno, String duedate) {
		todolistMapper.updateDuedate(dno, duedate);
		
	}
  // 디테일 사이드바에서 삭제
  @Override
  public void deleteDetail(int dno) {
    todolistMapper.deleteDetail(dno);
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
  public List<TodoDTO> selectwhere(SortDTO sortDTO) {
    // TODO Auto-generated method stub
    return todolistMapper.selectwhere(sortDTO);
  }

  @Override
  public List<TodoDTO> selectSortBy(String writer, String sortBy) {
    // TODO Auto-generated method stub
    return todolistMapper.selectSortBy(writer, sortBy);
  }

  @Override
  public List<CountDTO> todoCnt(String writer, String today) {
    // TODO Auto-generated method stub
    return todolistMapper.selectTodoCnt(writer, today);
  }

  @Override
  public List<TodoDTO> listDuedate(String writer) {
    // TODO Auto-generated method stub
    return todolistMapper.selectListDuedate(writer);
  }

  @Override
  public List<TodoDTO> selectMulti(SelectDTO selectDTO) {
    // TODO Auto-generated method stub
    return todolistMapper.selectMulti(selectDTO);
  }

  @Override
  public void updateSelectedAll(SelectedAllDTO selectedAllDTO) {
    todolistMapper.updateSelectedAll(selectedAllDTO);
    
  }

  @Override
  public void deleteSelectedAll(SelectedAllDTO selectedAllDTO) {
    todolistMapper.deleteSelectedAll(selectedAllDTO);
    
  }





}
