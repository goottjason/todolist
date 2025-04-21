<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<title>To-Do List</title>

<style>
</style>
</head>
<body>
	<div id="ajaxTodoDetail">
		<div class="detailDiv">
		  <table style="width:100%; border-collapse:collapse; table-layout:fixed;">
		    <tbody>
		      <tr>
		        
		        <!-- finished -->
		        <td style="width:20%">
		          <span style="color:#4b87c6;">
                <i id="detailfinishedIcon-${todo[0].dno}"
                   class="finishedIcon fa-regular ${todo[0].finished == 1 ? 'fa-circle-check' : 'fa-circle'}" 
                   data-dno="${todo[0].dno}" style="color:#1e3050; font-size:24px;"></i>
              </span>
            </td>
            
            <!-- title -->
		        <td style="width:60%;background: #faf9f8;">
		          <input type="text" id="detailtitle-${todo[0].dno}" class="form-control"
		                 name="detailtitle" value="${todo[0].title}">
		        </td>
		        
		        <!-- star -->
		        <td class ="detailStarDiv"style="width:20%; text-align:right; vertical-align:center;background: #faf9f8;">
		          <span style="color:#4b87c6;">
                <i id="detailstar-${todo[0].dno}" class="starIcon fa-regular fa-star ${todo[0].star == 1 ? 'fa-solid' : ''}" 
                   data-dno="${todo[0].dno}" style="color:#1e3050; font-size:24px;"></i>
              </span>
		        </td>		        
		      </tr>
		      
		      <tr>
		      
            <td>기한</td>
            <td class="duedateTd" colspan=2>
	            <input type="date" id="detailduedate-${todo[0].dno}" class="form-control"
	                   name="detailtitle" value="${todo[0].duedate}">
            </td>
          </tr>
          <tr>
            <!-- location -->
            <td>위치</td>
            <td class="locationTd" colspan=2>
              <input type="text" id="detaillocation-${todo[0].dno}" class="form-control"
                     name="detaillocation" value="${todo[0].location}">
            </td>           
          </tr>
          
          <tr>
            <!-- memo -->
            <td>메모</td>
            <td class="locationTd" colspan=2>
              <textarea id="detailmemo-${todo[0].dno}" class="form-control"
                     name="detailmemo">${todo[0].memo}</textarea>
            </td>      
          </tr>
          <tr>
            <td></td>
	          <!-- mod, del -->
	          <td colspan=2>
	            <button class="detailModBtn" 
	                    data-dno="${todo[0].dno}"
	                    style="border:1px solid #b1b1a8; border-radius:4px; padding:5px 30px; background:#fff; color:#4b87c6; margin-right:2px; cursor:pointer; font-size:12px;">수정</button>
	            <button class="detailDelBtn" 
	                    data-dno="${todo[0].dno}"
	                    style="border:1px solid #e57373; border-radius:4px; padding:5px 30px; background:#fff; color:#e57373; cursor:pointer; font-size:12px;">삭제</button>

          </tr>
          <tr>
            <td colspan=3>
              <div id="updateTimeView">
                업데이트 됨 : <span id="nowUpdateTime"></span>
					    </div>
            </td>
          </tr>
		    </tbody>
		  </table>
		
		

		</div>
	</div>
</body>
</html>