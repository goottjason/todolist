package com.todolist.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class SendInsertDTO {
  private int dno;
  private String writer;
  private String title;
  private String duedate;
  private int finished;
  private int star;
  private String memo;
  private String location;

public void setDefaultValues() {
  if(title != null && title.equals("")) {     
    this.title = "내용 없음";
  }
  if(duedate != null && duedate.equals("")) {     
    this.duedate = null;
  }
  if(memo != null && memo.equals("")) {     
    this.memo = null;
  }
  if(location != null && location.equals("")) {     
    this.location = null;
  }
}  
}
