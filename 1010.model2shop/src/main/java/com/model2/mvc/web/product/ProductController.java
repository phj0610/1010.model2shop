package com.model2.mvc.web.product;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.product.ProductService;

@Controller
@RequestMapping("/product/*")
public class ProductController {

	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public ProductController() {
		System.out.println(this.getClass());
	}

		@Value("#{commonProperties['pageUnit']}")
	//@Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	//@Value("#{commonProperties['pageSize'] ?: 2}")
	int pageSize;
	

	//addproductView.do
	@RequestMapping(value = "addProduct", method=RequestMethod.GET)
	public String addProduct() throws Exception {

		System.out.println("/addProductView : GET");
		
		return "forward:/product/addProductView.jsp";
	}
	
	@RequestMapping(value ="addProduct" , method=RequestMethod.POST)
	public String addProduct(@ModelAttribute("product") Product product, Model model ) throws Exception {
		
		System.out.println("/addProduct : POST");
		
		productService.addProduct(product);
		 model.addAttribute("product",product);
		 
		 
		return "forward:/product/addProduct.jsp";
	}
	
	@RequestMapping(value ="listProduct")
	public String listProduct( @ModelAttribute("search") Search search , Model model , HttpServletRequest request) throws Exception{
		
		
	      System.out.println("/listProduct : GET/POST");

		
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		// Business logic 수행
		Map<String , Object> map=productService.getProductList(search);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		// Model 과 View 연결
		request.getAttribute("menu");
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		
		return "forward:/product/listProduct.jsp";
	}
	
	@RequestMapping(value="getProduct" , method=RequestMethod.GET )
	public String getProduct(@RequestParam("prodNo") int prodNo, Model model, HttpServletResponse response, HttpServletRequest request )  throws Exception{

		System.out.println("product/getPrdouct : GET");
		
		Product product = productService.getProduct(prodNo);
		
		model.addAttribute("product", product);
		
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
        // 기본적으로 상품 상세 정보 화면으로 포워드
      
        if (request.getParameter("menu").equals("manage")) {
            return "forward:/product/updateProductView.jsp";
        } 
        else {
        	return  "forward:/product/getProduct.jsp";
        }
       
    
}
	
	
	//updateProductView.do
	   @RequestMapping(value="updateProduct", method=RequestMethod.GET )
	   public String updateProduct( @RequestParam("prodNo") int prodNo , Model model ) throws Exception{

	      System.out.println("/updateProductView : GET");
	      //Business Logic
	      Product product = productService.getProduct(prodNo);
	      // Model 과 View 연결
	      model.addAttribute("product", product);
	      
	      return "forward:/product/updateProductView.jsp";
	   }
	   
	   
	@RequestMapping(value="updateProduct", method=RequestMethod.POST )
	public String updateProduct(@ModelAttribute("product") Product product, Model model ) throws Exception {
		
		System.out.println("/updateProduct ");
		
		productService.updateProduct(product);
		
		
		 model.addAttribute("product",product);
		return  "forward:/product/getProduct.jsp";

	}
	
	
}







