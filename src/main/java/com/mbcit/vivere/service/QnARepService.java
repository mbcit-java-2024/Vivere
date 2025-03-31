package com.mbcit.vivere.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.QnarepDAO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class QnARepService {
	@Autowired
	private QnarepDAO qnarepDAO;
	

	public int insert(Map<String, Object> param) {
		int resultCnt = qnarepDAO.insert(param);
		return resultCnt;
	}


	public int updateRep(Map<String, Object> param) {
		int resultCnt = qnarepDAO.updateRep(param);
		return resultCnt;
	}



}
