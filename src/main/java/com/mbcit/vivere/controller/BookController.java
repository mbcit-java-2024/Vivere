package com.mbcit.vivere.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mbcit.vivere.service.BookService;
import com.mbcit.vivere.service.ConcertService;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;

import ch.qos.logback.core.recovery.ResilientSyslogOutputStream;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BookController {
	
	@Autowired
	private ConcertService concertService;
	
	@Autowired
	private BookService bookService;
	
	@RequestMapping("/book")
	public String book(HttpServletRequest request, Model model) {
		System.out.println("BookController 컨트롤러의 book() 메소드 실행");
		
		int concertId = 1; // ************ !!!concertId 가져오게 추가해야됨!!! ************ 
		Calendar calendar = Calendar.getInstance();
		Date date = concertService.getFutureConcertTimes(concertId).get(2).getConcertTime();
		calendar.setTime(date);
		System.out.println("이거 확인하셈" + calendar.getTime());
		Date selectedTime = calendar.getTime();
		
		ConcertVO concertVO = concertService.getConcertById(concertId);
		
		List<ConcertTimeVO> conTimes = concertService.getFutureConcertTimes(concertId);
//		ConcertTimeVO conTVO1 = new ConcertTimeVO(); // ************ Test ************
//		ConcertTimeVO conTVO2 = new ConcertTimeVO(); // ************ Test ************
//		ConcertTimeVO conTVO3 = new ConcertTimeVO(); // ************ Test ************
//		conTVO1.setId(1); // ************ Test ************
//		conTVO2.setId(2); // ************ Test ************
//		conTVO3.setId(3); // ************ Test ************
//		conTVO1.setConcertId(1); // ************ Test ************
//		conTVO2.setConcertId(2); // ************ Test ************
//		conTVO3.setConcertId(3); // ************ Test ************
//		conTVO1.setConcertTime(calendar1.getTime()); // ************ Test ************
//		conTVO2.setConcertTime(calendar2.getTime()); // ************ Test ************
//		conTVO3.setConcertTime(calendar3.getTime()); // ************ Test ************
//		conTimes.add(0, conTVO1); // ************ Test ************
//		conTimes.add(1, conTVO2); // ************ Test ************
//		conTimes.add(2, conTVO3); // ************ Test ************
		
		ArrayList<Character> gHall = concertService.getGHallLine();
		ArrayList<Character> fHall = concertService.getFHallLine();
		
		model.addAttribute("gHall", gHall);
		model.addAttribute("fHall", fHall);
		model.addAttribute("concertVO", concertVO);
		model.addAttribute("conTimes", conTimes);
		model.addAttribute("selectedTime", selectedTime);
		
		return "/book";
	}
	
	@GetMapping("/getBookedSeats")
	@ResponseBody
	public List<String> getBookedSeats(@RequestParam("conTimeId") String conTimeId) {
		System.out.println("BookController 컨트롤러의 getBookedSeats() 메소드 실행");
		List<String> seats = bookService.getBookedSeats(conTimeId);
//		System.out.println("이거 컨트롤러임");
		System.out.println(seats);
		return seats;
	}
	

}
