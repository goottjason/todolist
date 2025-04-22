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
public class CountDTO {
  private int todayCnt;
  private int allCnt;
  private int unfinishedCnt;
  private int starCnt;
  private int isDuedateCnt;
  private int isNotDuedateCnt;
}
