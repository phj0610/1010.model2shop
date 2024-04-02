package com.model2.mvc.web.product;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import org.springframework.web.bind.annotation.RestController;


import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

@RestController  
@RequestMapping("/product/*")
public class ProductRestController {

	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public ProductRestController() {
		System.out.println(this.getClass());
	}

	
	@RequestMapping(value="json/getProduct/{prodNo}" , method=RequestMethod.GET )
	public Product getProduct(@PathVariable int prodNo, HttpServletResponse response, HttpServletRequest request )  throws Exception{

		System.out.println("/product/json/getPrdouct : GET");
		
	Product dbproduct = productService.getProduct(prodNo);
		
        String history = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
            for (int i = 0; i < cookies.length; i++) {
                Cookie cookie = cookies[i];
                
                if (cookie.getName().equals("history")) {
                    history = cookie.getValue();
                }
            }
        }
        
       
        // 현재 열람한 상품 번호를 기존 열람 기록에 추가
        if (history == null) {
            history = Integer.toString(prodNo);
        } else {
            history += "/" + prodNo;
        }
        
        // 쿠키에 열람 기록을 저장
        Cookie historyCookie = new Cookie("history", history);
        historyCookie.setPath("/");
        response.addCookie(historyCookie);
     
	

      return dbproduct;
	}
}


