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
import com.mbcit.vivere.vo.ConsumerVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class QnAController {
	@Autowired
	private QnARepService qnARepService;
	@RequestMapping(value="/insertRep", method=RequestMethod.POST) 
	public Map<String, Object> insertRep(@RequestBody Map<String, Object> param, HttpServletRequest req) {
		log.info("QnAController ========1==========insertRep::::param===" + param);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int resultCnt = 0;		
		ConsumerVO consumerVO = new ConsumerVO();
		// TODO 세션에서 추출할것!!
//		HttpSession session = req.getSession(false);
//		if (null != session   && null != session.getAttribute("id")) {
//			int consumerId = (int) session.getAttribute("id");
			consumerVO.setGrade(Grade.ADMIN);
			resultMap.put("code", "0");// 성공여부 0:성공, 그외:실패 
			resultMap.put("message", "");// 에러메세지
			log.info("QnAController ========2==========insertRep::::param===" + param);
			
			try {
				resultCnt = qnARepService.insert(param);
				log.info("QnAController ========3==========insertRep::::resultCnt===" + resultCnt);
				 
				resultMap.put("resultCnt", resultCnt); 	
				if (0 == resultCnt) {			
					resultMap.put("code", "-1");// 성공여부 0:성공, 그외:실패 
					resultMap.put("message", "등록된 자료가 없습니다.");// 에러메세지
				}
			} catch(Exception e) {		
				// 에러나서 여기 타네.. 
				log.info("QnAController ========4==========insertRep::::resultCnt===" + e.getMessage());
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
