package com.mbcit.vivere.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.ConsumerDAO;
import com.mbcit.vivere.vo.ConsumerVO;



@Service
public class ConsumerService {
	
	@Autowired
    private ConsumerDAO consumerDAO;
	
	public void updateConsumer(ConsumerVO vo) {
	    consumerDAO.updateConsumer(vo);
	}
    
}
//push를 위한 주석