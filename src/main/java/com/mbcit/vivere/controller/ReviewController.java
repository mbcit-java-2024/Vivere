package com.mbcit.vivere.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.mbcit.vivere.eNum.Grade;
import com.mbcit.vivere.service.QnARepService;
import com.mbcit.vivere.service.ReviewService;
import com.mbcit.vivere.vo.ConsumerVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class ReviewController {
	@Autowired
	private ReviewService reviewService;

	@RequestMapping(value = "/reviewInsert", method = RequestMethod.POST)
	public Map<String, Object> reviewInsert(@RequestBody Map<String, Object> param, HttpServletRequest req) {
		log.info("ReviewController ========1==========reviewInsert::::param===" + param);

		Map<String, Object> resultMap = new HashMap<String, Object>();
		int resultCnt = 0;
		ConsumerVO consumerVO = new ConsumerVO();
		// TODO 세션에서 추출할것!!
//		HttpSession session = req.getSession(false);
//		if (null != session   && null != session.getAttribute("id")) {
//			int consumerId = (int) session.getAttribute("id");
		param.put("consumerId", 1);
		resultMap.put("code", "0");// 성공여부 0:성공, 그외:실패
		resultMap.put("message", "");// 에러메세지
		log.info("ReviewController ========2==========reviewInsert::::param===" + param);

		try {
			resultCnt = reviewService.insert(param);
			log.info("ReviewController ========3==========reviewInsert::::resultCnt===" + resultCnt);

			resultMap.put("resultCnt", resultCnt);
			if (0 == resultCnt) {
				resultMap.put("code", "-1");// 성공여부 0:성공, 그외:실패
				resultMap.put("message", "등록된 자료가 없습니다.");// 에러메세지
			}
		} catch (Exception e) {
			log.info("ReviewController ========4==========reviewInsert::::resultCnt===" + e.getMessage());
			resultMap.put("code", "-1");// 성공여부 0:성공, 그외:실패
			resultMap.put("message", e.getMessage());// 에러메세지
			resultMap.put("resultCnt", resultCnt);
		}
//		}  else { 
//			resultMap.put("code", "-1");// 성공여부 0:성공, 그외:실패
//			resultMap.put("message", "로그인하십시오.");// 에러메세지
//			resultMap.put("resultCnt", resultCnt);

//		}

		return resultMap;
	}
	@RequestMapping(value = "/updateReview", method = RequestMethod.POST)
	public Map<String, Object> updateReview(@RequestBody Map<String, Object> param, HttpServletRequest req) {
		log.info("ReviewController ========1==========updateReview::::param===" + param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int resultCnt = 0;
		ConsumerVO consumerVO = new ConsumerVO();
		// TODO 세션에서 추출할것!!
//		HttpSession session = req.getSession(false);
//		if (null != session   && null != session.getAttribute("id")) {
//			int consumerId = (int) session.getAttribute("id");
		param.put("consumerId", 1);
		resultMap.put("code", "0");// 성공여부 0:성공, 그외:실패
		resultMap.put("message", "");// 에러메세지
		log.info("ReviewController ========2==========updateReview::::param===" + param);
		
		try {
			resultCnt = reviewService.update(param);
			log.info("ReviewController ========3==========updateReview::::resultCnt===" + resultCnt);
			resultMap.put("resultCnt", resultCnt);
			if (0 == resultCnt) {
				resultMap.put("code", "-1");// 성공여부 0:성공, 그외:실패
				resultMap.put("message", "등록된 자료가 없습니다.");// 에러메세지
			}
		} catch (Exception e) {
			log.info("ReviewController ========4==========updateReview::::resultCnt===" + e.getMessage());
			resultMap.put("code", "-1");// 성공여부 0:성공, 그외:실패
			resultMap.put("message", e.getMessage());// 에러메세지
			resultMap.put("resultCnt", resultCnt);
		}
//		}  else { 
//			resultMap.put("code", "-1");// 성공여부 0:성공, 그외:실패
//			resultMap.put("message", "로그인하십시오.");// 에러메세지
//			resultMap.put("resultCnt", resultCnt);
		
//		}
		
		return resultMap;
	}

}
