package com.todolist.domain;

import java.time.LocalDate;

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
public class TodoDTO {
  private int dno;
  private String writer;
  private String title;
  private String duedate;
  private String finished;
  private String star;
  private String memo;
  private String location;
}
