<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
   <meta charset="EUC-KR">
   <title>상품 목록 조회</title>
   
   <link rel="stylesheet" href="/css/admin.css" type="text/css">
   
   <!-- CDN(Content Delivery Network) 호스트 사용 -->
   <script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
   <script type="text/javascript">
   
    function fncGetProductList(currentPage) {
        $("#currentPage").val(page);
        $("form").attr("method", "POST").attr("action", "/product/listProduct?menu=${param.menu}").submit();
    }
    
//     $(function() {
//         // 제품 클릭 시 상세 정보 가져오기
//         $(".ct_list_pop td:nth-child(3)").on("click", function() {
//             var prodNo = $(this).closest("tr").find('input[name="prodNo"]').val();
            
//             // AJAX 요청 보내기
//             $.ajax({
//                 url: "/product/json/getProduct/" + prodNo,
//                 method: "GET",
//                 dataType: "json",
//                 success: function(JSONData , status) {
//                    alert(status);
                
//                     var displayValue = "<h3>" +
//                         "상품명 : " + JSONData.prodName + "<br>" +
//                         "상품상세정보 : " + JSONData.prodDetail + "<br>" +
//                         "가격 : " + JSONData.price + "<br>" +
//                         "</h3>";
                    
//                     $("h3").remove();
//                     $("#" + prodNo + "").html(displayValue);
//                 }
//             });
//         });
   
//     });

      $(function(){
      
       $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
      //Debug..
      alert(  $( "td.ct_btn01:contains('검색')" ).html() );
      fncGetProductList(1);
   });
   
   //이렇게 하면 검색 시 엔터 키 먹음
    $( "input[name='searchKeyword']" ).keypress(function(event) {
          // 엔터 키 코드는 13입니다.
          if (event.which === 13) {
              // 엔터 키가 눌렸을 때 검색 이벤트 실행
             fncGetProductList(1);
          }
      });
   });
   
    $(function() {
          $(".ct_list_pop td:nth-child(3)").on("click", function() {
//              alert($(this));
//              alert($(this).find('input[name^="prodNo"]').html());
//              alert($(this).find('input[name^="prodNo"]').val());
              var prodNo = $(this).find('input[name^="prodNo"]').val();
              // hidden input을 추가하여 form에 'prodNo' 값을 함께 전송합니다.
              $(this).append('<input type="hidden" name^="prodNo" value="' + prodNo + '">');
              // form을 제출합니다.
//               $(this).closest("form").submit();
            
              
              $.ajax(
                    {
                       // url : path
                       // url ? n = v  parameter
                       url : "/product/json/getProduct/"+prodNo+"/${menu}" ,
                     method : "GET" ,
                     dataType : "json" ,
                     headers : {
                        "Accept" : "application/json",
                        "Content-Type" : "application/json"
                     },
                     success : function(JSONData , status) {
                        alert(status);
                        
                        var displayValue = "<h8>"
                                                +"상품명 : "+JSONData.prodName+ "<br/>"
                                                +"상세정보 : "+JSONData.prodDetail+ "<br/>"
                                                +"가격 : "+JSONData.price+ "<br/>"
                                                +"등록일 : "+JSONData.manuDate+ "<br/>"
                                                +"상품번호 : "+JSONData.prodNo+ "<br/>"
                                                +"</h8>";
                                                
                        $("h8").remove();
                        $( "#"+prodNo+"" ).html(displayValue);   
                     }
                    });
             /*  self.location="/product/getProduct?menu=${param.menu}&prodNo="+prodNo;
          */

          }); 
          

       //==> userId LINK Event End User 에게 보일수 있도록 

      $( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
      $("h7").css("color" , "red");
      
      //==> 아래와 같이 정의한 이유는 ??
      $(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
   });   
<!--  <a href="/product/${ menuType eq 'manage' ? 'updateProduct' : 'getProduct'}?prodNo=${ product.prodNo }&menu=${param.menu}"  -->
   
</script>

</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<%-- <form name="detailForm" action="/listProduct.do?menu=<%= request.getParameter("menu")%>" method="post">
<form name="detailForm" action="/product/listProduct?menu=${param.menu}" method="post">--%>


<form name= "detailForm">
<table width="100%" height="37" border="0" cellpadding="0"   cellspacing="0">
   <tr>
      <td width="15" height="37">
         <img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
      </td>
      <td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
         <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
               <td width="93%" class="ct_ttl01">

             <c:choose>
          <c:when test="${param.menu != null && param.menu == 'manage'}">
              상품 관리
          </c:when>
          <c:when test="${param.menu == null || param.menu == 'null' || param.menu == 'search'}">
              상품 목록조회
          </c:when>
      </c:choose>
       
       
               </td>
            </tr>
         </table>
      </td>
      <td width="12" height="37">
         <img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
      </td>
   </tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
   <tr>
      
      <td align="right">
      
      <%--
         <%
      if(search.getSearchCondition() != null) {
      %>
         <select name="searchCondition" class="ct_input_g" style="width:80px">
            <option value ="0" <%= (searchCondition.equals("0") ? "selected" : "") %>>상품번호</option>
            <option value ="1" <%= (searchCondition.equals("1") ? "selected" : "") %>>상품명</option>
            <option value ="2" <%= (searchCondition.equals("2") ? "selected" : "") %>>상품가격</option>    
            <%}else{%>
                  <select name="searchCondition" class="ct_input_g" style="width:80px">
                  <option value = "0" >상품번호</option>
                  <option value = "1" >상품명</option>
                  <option value = "2" >상품가격</option>
                  
                  <% } %>
             --%>
                  <c:choose>
          <c:when test="${! empty search.searchCondition}">
              <select name="searchCondition" class="ct_input_g" style="width:80px">
                  <option value="0" ${search.searchCondition == '0' ? 'selected' : ''}>상품번호</option>
                  <option value="1" ${search.searchCondition == '1' ? 'selected' : ''}>상품명</option>
                  <option value="2" ${search.searchCondition == '2' ? 'selected' : ''}>상품가격</option>
              </select>
          </c:when>
          <c:otherwise>
              <select name="searchCondition" class="ct_input_g" style="width:80px">
                  <option value="0">상품번호</option>
                  <option value="1">상품명</option>
                  <option value="2">상품가격</option>
              </select>
          </c:otherwise>
      </c:choose>
            
           
<%--         <input type="text" name="searchKeyword" value="<%= searchKeyword %>" class="ct_input_g" style="width:200px; height:19px" />
  --%>        <input type="text" name="searchKeyword" value="${search.searchKeyword  }" class="ct_input_g" style="width:200px; height:19px" />
      </td>
      
      <td align="right" width="70">
         <table border="0" cellspacing="0" cellpadding="0">
            <tr>
               <td width="17" height="23">
                  <img src="/images/ct_btnbg01.gif" width="17" height="23">
               </td>
               <td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
                 <a href="javascript:fncGetProductList(1);">검색</a>
               </td>
               <td width="14" height="23">
                  <img src="/images/ct_btnbg03.gif" width="14" height="23">
               </td>
            </tr>
         </table>
      </td>
   </tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
   <tr>
    <%--   <td colspan="11" >전체 <%= resultPage.getTotalCount()%>건수, 현재<%= resultPage.getCurrentPage() %> 페이지</td>
  --%>    <td colspan="11" >전체${resultPage.totalCount }건수, 현재${resultPage.currentPage}  페이지</td>
  
   </tr>
   <tr>
      <td class="ct_list_b" width="100">No</td>
      <td class="ct_line02"></td>
      <td class="ct_list_b" width="150">상품명</td>
      <td class="ct_line02"></td>
      <td class="ct_list_b" width="150">가격</td>
      <td class="ct_line02"></td>
      <td class="ct_list_b">등록일</td>   
      <td class="ct_line02"></td>
      <td class="ct_list_b">현재상태</td>   
   </tr>
   <tr>
      <td colspan="11" bgcolor="808285" height="1"></td>
   </tr>

<c:set var="i" value="0" />
            <c:forEach var="product" items="${list}">
               <c:set var="i" value="${ i+1 }" />
               <tr class="ct_list_pop">
                  <td align="center">${ i }</td>
                     <td></td>
                  <td align="left">
               
                  <input type="hidden" name="prodNo" value="${product.prodNo}">
                     <!--  <a href="/product/${ menuType eq 'manage' ? 'updateProduct' : 'getProduct'}?prodNo=${ product.prodNo }&menu=${param.menu}" >
                         -->        ${product.prodName}
                            </td>   
                                 
                  <td></td>
                  <td align="left">${product.price }</td>
                  <td></td>
                  <td align="left">${product.regDate}</td>
                  <td></td>
         
                   <td align="left">배송중</td>
                      
    </tr>
    <tr>
        <td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
<!--         <td colspan="11" bgcolor="D6D7D6" height="1"></td> -->
    </tr>
</c:forEach>
   </table>


<tr>
    <td colspan="11" bgcolor="D6D7D6" height="1"></td>
</tr>


       
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
   <tr>
      <td align="center">
      <input type = "hidden" id="currentPage" name="currentPage" value =""/>
         
          <div style="text-align: center; margin-top: 10px;">

         
         <jsp:include page="../common/listpageNavigator.jsp"/>   
            </div>
       </td>
       
   </tr>
   
</table>

<!--  페이지 Navigator 끝 -->

</form>

</div>
</body>
</html>