package com.todolist.mapper;

import org.apache.ibatis.annotations.Param;

import com.todolist.domain.UserDTO;
import com.todolist.domain.UserUpdateDTO;

public interface UserMapper {
  int insertUser(UserDTO user);
  int selectIdIsDuplicate(String userid);
  UserDTO selectAuthUser(@Param("userid") String userid, @Param("userpwd") String userpwd);
  String selectEmail(@Param("userid") String userid);
  int selectExistingPwdCheck(@Param("userid") String userid, @Param("userpwd") String userpwd);
  int updateInfo(UserUpdateDTO user);
  int uniqueEmailCheck(String userInputEmail);
  UserDTO selectUserById(String userid);
  
}
