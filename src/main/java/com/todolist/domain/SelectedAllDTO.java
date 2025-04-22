package com.todolist.domain;

import lombok.Getter;

import java.util.List;


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
public class SelectedAllDTO {
	
    private List<Integer> selectedArr;
    private String finished;
    private String star;
    private String duedate;
    
    public boolean isEmptyUpdateData() {
      
      boolean isFinished = finished.equals("9");
      boolean isStar = star.equals("9");
      boolean isDuedate = duedate == null || duedate.equals("");
      
      // 셋 다 비어있으면 수행하지 않음
      return isFinished && isStar && isDuedate;
    }
}
