package com.mbcit.vivere.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.ReviewDAO;
import com.mbcit.vivere.vo.ReviewVO;

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

	public int update(Map<String, Object> param) {
		int resultCnt = reviewDAO.update(param);

		return resultCnt;
	}

	public void delete(ReviewVO reviewVO) {
		reviewDAO.delete(reviewVO);
	}

	public List<ReviewVO> reviewListByConcert(int concertId) {
		return reviewDAO.reviewListByConcert(concertId);
	}


}
