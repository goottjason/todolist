package com.todolist.domain;

import lombok.Getter;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class SelectDTO {
  private String writer;
  private String dno;
  private String title;
  private String duedate;
  private String finished;
  private String star;
  private String searchTypes;
  private String searchWord;
  private String orderby;
  private String ordermethod;
}
