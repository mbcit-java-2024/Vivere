package com.mbcit.vivere.controller;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcit.vivere.eNum.Grade;
import com.mbcit.vivere.service.BookService;
import com.mbcit.vivere.service.QnAService;
import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.ConsumerVO;
import com.mbcit.vivere.vo.QnaVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {

	@Autowired
	private BookService bookService;
	@Autowired
	private QnAService qnaService;
	
	@RequestMapping("/")
	public String main() {
		log.info("MainController 의 main() 메소드 실행");
		
		return "/main";
	}
	
	@GetMapping("/pastBook")
	public String pastBook(Model model, BookVO bookVO) {
		// 수빈
		log.info("MainController 의 pastBook() 메소드 실행");
		
		List<BookVO> pastBook = bookService.pastBook(bookVO);
		log.info("pastBook" + pastBook);
		model.addAttribute("pastBook", pastBook);
		
		return "/pastBook";
	}
	
	
	@GetMapping("/qnaList")
	public String qnaList(Model model, QnaVO qnaVO) {
		// 수빈 
		log.info("MainController 의 qnaList() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<QnaVO> qnaList = new ArrayList<QnaVO>();
		// TODO 메모 // *****절대 지우지말것!!!!!!!! - 나중에 해야될것들임
		// 1. 로그인 여부 확인 (ProductController클래스에 orderPage메소드에 있음 -> 참고)
		// 2. 구매자일때 답변완료한 문의글과 아직 답변전인 내가 쓴 문의글 보일수있게 
		// 3. 관리자일때 답변완료한 문의글(답변 수정할수있어야하니까)과 답변전인 문의글 답변 쓸수있게
		// 4. 답변 완료한 문의글은 구매자가 질문을 수정할수없게 조건 걸기(rep_id가 null이 아닐때 qna_id 수정 불가)
		
		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 
		
//		if (consumerVO.getGrade() != Grade.ADMIN) {
//			qnaVO.setConsumerId(1); 
//			result ="/qnaList";
//		} else {
			consumerVO.setGrade(Grade.ADMIN);
			result = "/managerQnaList";
//		}
		qnaList = qnaService.qnaList(qnaVO);
		
		model.addAttribute("qnaList", qnaList);
		log.info("qnaList" + qnaList);
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	
	
}
