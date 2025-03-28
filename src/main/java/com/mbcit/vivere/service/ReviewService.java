package com.mbcit.vivere.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.ReviewDAO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ReviewService {
	
	
	@Autowired
	private ReviewDAO reviewDAO;
	
	
	public int insert(Map<String, Object> param) {
		
		int resultCnt = reviewDAO.insert(param);
		
		
		return resultCnt;
	}
	

}
