package com.mbcit.vivere.service;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.mbcit.vivere.dao.ConsumerDAO;
import com.mbcit.vivere.eNum.Grade;
import com.mbcit.vivere.vo.ConsumerVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class LoginService {
	
    @Autowired
    private ConsumerDAO consumerDAO;

   
    public boolean isUserIdExists(String userId) {
        return consumerDAO.countByUserId(userId) > 0;
    }

	public void SignUp(ConsumerVO vo, String emailDomain, String customEmail) {
        String domain = "custom".equals(emailDomain) ? customEmail : emailDomain;

        String fullEmail = vo.getEmail() + "@" + domain;
        vo.setEmail(fullEmail);

        vo.setGrade(Grade.BRONZE);  
        vo.setCreateDate(new Date()); 
        vo.setUpdateDate(new Date()); 

       
        consumerDAO.insertConsumer(vo);		
	}
	


    public boolean checkLogin(ConsumerVO vo) {
        ConsumerVO checklogin = consumerDAO.findByUserId(vo.getUserId());

        if (checklogin != null && checklogin.getPw().equals(vo.getPw())) {
            return true;
        }

        return false;
    }

    public ConsumerVO login(ConsumerVO vo) {
        ConsumerVO dbUser = consumerDAO.findByUserId(vo.getUserId());
        
        if (dbUser != null && dbUser.getPw().equals(vo.getPw())) {
            return dbUser; 
        }
        return null; 
    }

	public String findIdByNameAndEmail(String name, String email) {
		
	    ConsumerVO user = consumerDAO.findIdByNameAndEmail(name, email);

	    if (user != null) {
	        return user.getUserId(); 
	    } else {
	        return null;
	    }		
	}

	public String findPwByIdAndEmail(String userId, String email) {
		
	    ConsumerVO user = consumerDAO.findPwByIdAndEmail(userId, email);

	    if (user != null) {
	    	return user.getPw(); 
	    } else {
	    	return null;
	    	
	    }		
	}
	
	public void updateInfo(ConsumerVO vo, String originalPw) {
		
	    if (vo.getPw() == null || vo.getPw().trim().isEmpty()) {
	        vo.setPw(originalPw);
	    }
	    consumerDAO.updateConsumer(vo);
	}
	
	public ConsumerVO findByUserId(String userId) {
	    return consumerDAO.findByUserId(userId);
	}
	
	public void deleteConsumer(String userId) {
	    consumerDAO.deleteConsumerByUserId(userId);
	}
	
}
















