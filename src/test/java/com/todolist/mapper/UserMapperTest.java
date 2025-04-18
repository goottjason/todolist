package com.todolist.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.todolist.domain.UserDTO;
import lombok.extern.slf4j.Slf4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations= {"file:src/main/webapp/WEB-INF/spring/**/root-context.xml"})
@Slf4j
public class UserMapperTest {
  @Autowired
  private UserMapper userMapper;
  
//  @Test
//  public void testInsertUser() {
//    UserDTO user = UserDTO.builder()
//        .userid("goottjason")
//        .userpwd("1234")
//        .useremail("goottjason@gmail.com")
//        .username("Jason")
//        .useraddr("서울시 금천구")
//        .build();
//    userMapper.insertUser(user);
//    log.info("▶▶▶▶▶ user : {}", user);
//  }
  @Test
  public void testSelectIdIsDuplicate() {
    int result = userMapper.selectIdIsDuplicate("gootjason");
    log.info("▶▶▶▶▶ {}", result);
  }
}
