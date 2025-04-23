package com.todolist.service;

import com.todolist.domain.UserDTO;

public interface UserService {
  int idIsDuplicate(String userid);

  int insertUser(UserDTO user);

  UserDTO login(String userid, String userpwd);

  int existingPwdCheck(String userid, String userpwd);

  void updateInfo(UserDTO user);

  int uniqueEmailCheck(String userInputEmail);
}
