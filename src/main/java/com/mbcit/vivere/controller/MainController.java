package com.mbcit.vivere.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcit.vivere.service.BookService;
import com.mbcit.vivere.service.QnAService;
import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.ConcertVO;
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
		// 수빈 - 구매자 입장에서 문의 내역 보기
		log.info("MainController 의 qnaList() 메소드 실행");
		
		
		List<QnaVO> qnaList = qnaService.qnaList(qnaVO);
		log.info("qnaList" + qnaList);
		model.addAttribute("qnaList", qnaList);
		
		
		return "/qnaList";
	}
	
	@GetMapping("managerQnaList")
	public String managerQnaList(Model model, QnaVO qnaVO) {
		// 수빈 - 관리자 입장에서 문의 내용 보기
		log.info("MainController 의 managerQnaList() 메소드 실행");
		
		
		List<QnaVO> managerQnaList = qnaService.managerQnaList(qnaVO);
		log.info("managerQnaList" + managerQnaList);
		model.addAttribute("managerQnaList", managerQnaList);
		
		
		return "/managerQnaList";
	}
	
}
