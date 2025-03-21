package com.mbcit.vivere.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mbcit.vivere.service.ConcertService;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BookController {
	
	@Autowired
	private ConcertService concertService;
	
	@RequestMapping("/book")
	public String book(HttpServletRequest request, Model model) {
		System.out.println("BookController 컨트롤러의 book() 메소드 실행");
		
		int concertId = 1; // Test
		
		ConcertVO concertVO = concertService.getConcertById(concertId);
		List<ConcertTimeVO> conTimes = concertService.getFutureConcertTimes(concertId);
		
		model.addAttribute("concertVO", concertVO);
		model.addAttribute("conTimes", conTimes);
		
		return "/book";
	}

}
