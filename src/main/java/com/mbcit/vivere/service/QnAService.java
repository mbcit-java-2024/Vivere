package com.mbcit.vivere.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.QnaDAO;
import com.mbcit.vivere.vo.QnaVO;
import com.mbcit.vivere.vo.QnarepVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class QnAService {
	
	@Autowired
	private QnaDAO qnaDAO;
	
	public List<QnaVO> qnaList(QnaVO qnaVO) {
		return qnaDAO.qnaList(qnaVO);
	}

	public void insert(QnaVO qnaVO) {
		qnaDAO.insert(qnaVO);
	}

	public int update(Map<String, Object> param) {
		return qnaDAO.update(param);
	}

	public void delete(QnaVO qnaVO) {
		qnaDAO.delete(qnaVO);
	}




}
