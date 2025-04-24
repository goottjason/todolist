package com.todolist.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class UserUpdateDTO {
  private String userid;
  private String userpwd;
  private String useremail;
  private String username;
  private String useraddr;
}
