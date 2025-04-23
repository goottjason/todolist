package com.todolist.service;

import org.springframework.stereotype.Service;

import com.todolist.domain.UserDTO;
import com.todolist.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
  
  private final UserMapper userMapper;
  
  @Override
  public int idIsDuplicate(String userid) {
    return userMapper.selectIdIsDuplicate(userid);
  }
  @Override
  public int uniqueEmailCheck(String userInputEmail) {
    // TODO Auto-generated method stub
    return userMapper.uniqueEmailCheck(userInputEmail);
  }
  @Override
  public int insertUser(UserDTO user) {
    return userMapper.insertUser(user);
  }

  @Override
  public UserDTO login(String userid, String userpwd) {
    return userMapper.selectAuthUser(userid, userpwd);
  }

  @Override
  public int existingPwdCheck(String userid, String userpwd) {
    return userMapper.selectExistingPwdCheck(userid, userpwd);
  }

  @Override
  public void updateInfo(UserDTO user) {
    userMapper.updateInfo(user);    
  }



}
