package com.mbcit.vivere.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.QnaDAO;
import com.mbcit.vivere.vo.QnaVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class QnAService {
	
	@Autowired
	private QnaDAO qnaDAO;
	
	public List<QnaVO> qnaList(QnaVO qnaVO) {
		return qnaDAO.qnaList(qnaVO);
	}


}
