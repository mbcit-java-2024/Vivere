package com.mbcit.vivere.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
		
		int concertId = 1; // ************ Test ************
		Calendar calendar1 = Calendar.getInstance(); // ************ Test ************
		Calendar calendar2 = Calendar.getInstance(); // ************ Test ************
		Calendar calendar3 = Calendar.getInstance(); // ************ Test ************
		calendar1.set(2025, Calendar.MARCH, 28, 15, 30, 0); // ************ Test ************
		calendar2.set(2025, Calendar.MARCH, 28, 20, 30, 0); // ************ Test ************
		calendar3.set(2025, Calendar.APRIL, 2, 15, 30, 0); // ************ Test ************
		Date selectedTime = calendar3.getTime(); // ************ Test ************
		
		ConcertVO concertVO = concertService.getConcertById(concertId);
		
		concertVO = new ConcertVO(); // ************ Test ************
		concertVO.setTitle("지킬앤하이드"); // ************ Test ************
		concertVO.setHallType(0); // ************ Test ************
		
		List<ConcertTimeVO> conTimes = concertService.getFutureConcertTimes(concertId);
		ConcertTimeVO conTVO1 = new ConcertTimeVO(); // ************ Test ************
		ConcertTimeVO conTVO2 = new ConcertTimeVO(); // ************ Test ************
		ConcertTimeVO conTVO3 = new ConcertTimeVO(); // ************ Test ************
		conTVO1.setConcertTime(calendar1.getTime()); // ************ Test ************
		conTVO2.setConcertTime(calendar2.getTime()); // ************ Test ************
		conTVO3.setConcertTime(calendar3.getTime()); // ************ Test ************
		conTimes.add(0, conTVO1); // ************ Test ************
		conTimes.add(1, conTVO2); // ************ Test ************
		conTimes.add(2, conTVO3); // ************ Test ************
		
		log.info("concertVO: " + concertVO); // ************ Test ************
		log.info("conTimes: " + conTimes); // ************ Test ************
		log.info("selectedTime: " + selectedTime); // ************ Test ************
		
		ArrayList<Character> gHall = concertService.getGHallLine();
		ArrayList<Character> fHall = concertService.getFHallLine();
		
		model.addAttribute("gHall", gHall);
		model.addAttribute("fHall", fHall);
		model.addAttribute("concertVO", concertVO);
		model.addAttribute("conTimes", conTimes);
		model.addAttribute("selectedTime", selectedTime);
		
		return "/book";
	}

}
