package com.mbcit.vivere.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mbcit.vivere.service.BookService;
import com.mbcit.vivere.service.ConcertService;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;
import com.mbcit.vivere.vo.concertSeatVO;

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
		
		ConcertVO concertVO = concertService.getConcertById(concertId);
		
		List<ConcertTimeVO> conTimes = concertService.getFutureConcertTimes(concertId);
		Date selDate = conTimes.get(0).getConcertTime(); // ************ selectTime 맞게 들어가려면??? ************ 
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(selDate);
		Date selectedTime = calendar.getTime();
		
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
	public Map<String, Object> getBookedSeats(@RequestParam("conTimeId") String strConTimeId) {
		System.out.println("BookController 컨트롤러의 getBookedSeats() 메소드 실행");
		System.out.println(strConTimeId);
		int conTimeId = Integer.parseInt(strConTimeId);
		
		List<String> bookedSeats = bookService.getBookedSeats(conTimeId);
//		System.out.println("seats: " + bookedSeats);
		
		List<concertSeatVO> allSeats = bookService.getConcertSeatByConTimeId(conTimeId);
//		System.out.println("seatGrade: " + allSeat);
		
	    Map<String, Object> response = new HashMap<>();
	    response.put("bookedSeats", bookedSeats);
	    response.put("allSeats", allSeats);
		
		return response;
	}
	
	@PostMapping("/payment")
	public String payment(@ModelAttribute ConcertVO concertVO, 
				Model model,
				@RequestParam("totalPrice") int totalPrice) {
		System.out.println("BookController 컨트롤러의 payment() 메소드 실행");
		System.out.println(totalPrice);
		
		
		model.addAttribute("concertVO", concertVO);
		model.addAttribute("totalPrice", totalPrice);
		
		return "/payment";
	}
	

}
