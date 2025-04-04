package com.mbcit.vivere.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mbcit.vivere.service.ConsumerService;
import com.mbcit.vivere.service.LoginService;
import com.mbcit.vivere.vo.ConsumerVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LoginController {
	
	 @Autowired
	    private ConsumerService consumerService;
	 @Autowired
	 	private LoginService loginService;

	    @RequestMapping("/signin")
	    public String signinForm() {
	    	
	        return "/signin";
	    }

	    @RequestMapping("/signinOK")
	    public String signin(ConsumerVO vo,
	                         @RequestParam("emailDomain") String emailDomain,
	                         @RequestParam("customEmail") String customEmail, Model model) {
	    	
	    	model.addAttribute("message", "회원가입이 완료되었습니다.");
	    	
	    	loginService.SignUp(vo, emailDomain, customEmail);

	        return "/login";
	    }	    
	    
	    @RequestMapping("/checkDuplicateId")
	    @ResponseBody
	    public Map<String, Object> checkDuplicateId(@RequestParam String userId) {
	    	
	        boolean exists = loginService.isUserIdExists(userId);
	        
	        Map<String, Object> result = new HashMap<>();
	        result.put("exists", exists);
//	        System.out.println("userId: " + userId);
	        
	        return result;
	    }
	    
	    @RequestMapping("/login")
	    public String login() {
	    	
	        return "/login"; 
	    }
	    
	    @RequestMapping("/loginOK")
	    public String loginOK(ConsumerVO vo, Model model, HttpSession session) {
	        boolean isValid = loginService.checkLogin(vo);
	        
	        ConsumerVO loginUser = loginService.login(vo);

	        if (isValid) {
	        	session.setAttribute("loginUser", loginUser);
	            return "/myinfo";
	        } else {
	        	model.addAttribute("error", "아이디가 존재하지 않거나 비밀번호가 일치하지 않습니다.");
	            return "/login"; 
	        }
	    }	    
	    
	    @RequestMapping("/findIdPassword")
	    public String findIdPassword() {
	    	
	    	return "/findIdPassword"; 
	    }

	    @RequestMapping("/findId")
	    public String findId( @RequestParam String name,
	    					  @RequestParam String email, Model model) {
	    	
	    	String findId = loginService.findIdByNameAndEmail(name,email);
	    	
	    	model.addAttribute("findId",findId);
	    	
	    	return "/findId"; 
	    }
	    
	    @RequestMapping("/findPw")
	    public String findPassword( @RequestParam String userId,
	    							@RequestParam String email,Model model) {
	    	
	    	String findPw = loginService.findPwByIdAndEmail(userId,email);
	    	
	    	model.addAttribute("findPw",findPw);
	    	
	    	return "/findPw"; 
	    }

}























