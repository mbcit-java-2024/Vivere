package com.mbcit.vivere.controller;


import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcit.vivere.eNum.Grade;
import com.mbcit.vivere.service.BookService;
import com.mbcit.vivere.service.QnAService;
import com.mbcit.vivere.service.ReviewService;
import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.ConsumerVO;
import com.mbcit.vivere.vo.QnaVO;
import com.mbcit.vivere.vo.ReviewVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {

	@Autowired
	private BookService bookService;
	@Autowired
	private QnAService qnaService;
	@Autowired
	private ReviewService reviewService;
	
	@RequestMapping("/")
	public String main() {
		log.info("MainController 의 main() 메소드 실행");
		
		return "/main";
	}
	
	@GetMapping("/pastBook")
	public String pastBook(Model model, BookVO bookVO) {
		// 수빈
		log.info("MainController 의 pastBook() 메소드 실행");
		
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<BookVO> pastBook = new ArrayList<BookVO>();
		
		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 
		
	//		if (consumerVO.getGrade() != Grade.ADMIN) {
				bookVO.setConsumerId(1); 
				result ="/pastBook";
	//		} else {
	//			consumerVO.setGrade(Grade.ADMIN);
	//			result = "/"; // 로그인 페이지로
	//		}
			pastBook = bookService.pastBook(bookVO);
			
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
			
		log.info("pastBook" + pastBook);
		model.addAttribute("pastBook", pastBook);
		return result;
	}
	
	@GetMapping("/deleteReivew/{id}")
	public String deleteReivew(Model model, BookVO bookVO, ReviewVO reviewVO, @PathVariable int id) {
		// 수빈
		log.info("MainController 의 deleteReivew() 메소드 실행::::::::id:::::::::" + id);
		
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<BookVO> pastBook = new ArrayList<BookVO>();
		
		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 
		
		//		if (consumerVO.getGrade() != Grade.ADMIN) {
					bookVO.setConsumerId(1); 
					result = "redirect:/pastBook";
		//		} else {
		//			consumerVO.setGrade(Grade.ADMIN);
		//			result = "/"; // 로그인 페이지로
		//		}
				reviewVO.setId(id);
				reviewService.delete(reviewVO);
		//		pastBook = bookService.pastBook(bookVO);
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	@GetMapping("/qnaInsert")
	public String qnaInsert(Model model, QnaVO qnaVO) {
		// 수빈 
		log.info("MainController 의 qnaInsert() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		
		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 
		
//		if (consumerVO.getGrade() != Grade.ADMIN) {
		qnaVO.setConsumerId(1); 
		result ="/qnaInsert";
//		} else {
//			consumerVO.setGrade(Grade.ADMIN);
//			result = "/managerQnaList";
//		}
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	@PostMapping("/qnaInsertOK")
	public String qnaInsertOK(Model model, QnaVO qnaVO) {
		// 수빈 
		log.info("MainController 의 qnaInsert() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		
		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 
		
//		if (consumerVO.getGrade() != Grade.ADMIN) {
		qnaVO.setConsumerId(1); 
		qnaService.insert(qnaVO);
		result = "redirect:/qnaList";
//		} else {
//			consumerVO.setGrade(Grade.ADMIN);
//			result = "/managerQnaList";
//		}
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	@GetMapping("/qnaList")
	public String qnaList(Model model, QnaVO qnaVO) {
		// 수빈 
		log.info("MainController 의 qnaList() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<QnaVO> qnaList = new ArrayList<QnaVO>();
		
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
