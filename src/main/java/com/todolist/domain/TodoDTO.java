package com.todolist.domain;

import lombok.Getter;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;


@NoArgsConstructor
@AllArgsConstructor
//@RequiredArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class TodoDTO {
  private int dno;
  private String writer;
  private String title;
  private String duedate;
  private int finished;
  private int star;
  private String memo;
  private String location;
  
//  TodoDTO() {
////    SetDefaultValues();
//  }

  private void SetDefaultValues() {
    if(title.equals("")) {     
      this.title = "내용 없음";
    }
    if(duedate.equals("")) {     
      this.duedate = null;
    }
    if(memo.equals("")) {     
      this.memo = null;
    }
    if(location.equals("")) {     
      this.location = null;
    }
  }
  
  
}
