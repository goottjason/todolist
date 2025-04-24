package com.todolist.service;

import com.todolist.domain.UserDTO;
import com.todolist.domain.UserUpdateDTO;

public interface UserService {
  int idIsDuplicate(String userid);

  int insertUser(UserDTO user);

  UserDTO login(String userid, String userpwd);

  int existingPwdCheck(String userid, String userpwd);

  int updateInfo(UserUpdateDTO user);

  int uniqueEmailCheck(String userInputEmail);
  UserDTO selectUserById(String userid);
}
