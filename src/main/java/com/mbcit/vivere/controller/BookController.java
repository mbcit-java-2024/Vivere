package com.mbcit.vivere.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import com.mbcit.vivere.service.CardService;
import com.mbcit.vivere.service.ConcertService;
import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.CardVO;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;
import com.mbcit.vivere.vo.ConsumerVO;
import com.mbcit.vivere.vo.concertSeatVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BookController {
	
	@Autowired
	private ConcertService concertService;
	
	@Autowired
	private BookService bookService;
	
	@Autowired
	private CardService cardService;
	
	@PostMapping("/book")
	public String book(HttpServletRequest request, Model model
					, @RequestParam int concertId, @RequestParam("selectedTime") String userSelTime
					) {
		System.out.println("BookController 컨트롤러의 book() 메소드 실행");
		
		ConsumerVO user = (ConsumerVO) request.getSession().getAttribute("loginUser");
		if (null == user) {
			return "/login";
		}
		
		ConcertVO concertVO = concertService.getConcertById(concertId);
		
		List<ConcertTimeVO> conTimes = concertService.getFutureConcertTimes(concertId);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		Date selectedTime = null;
		try {
			selectedTime = sdf.parse(userSelTime);
		} catch (ParseException e) {
			System.out.println("book컨트롤러 book 요청의 selectedTime 변환 실패");
		}

		ArrayList<Character> gHall = concertService.getGHallLine();
		ArrayList<Character> fHall = concertService.getFHallLine();
		
		model.addAttribute("gHall", gHall);
		model.addAttribute("fHall", fHall);
		model.addAttribute("concertVO", concertVO);
		model.addAttribute("conTimes", conTimes);
		model.addAttribute("selectedTime", selectedTime);
		
		return "/book";
	}
	
	// get 요청으로 book 요청을 보내면 home 화면으로 돌려보냄
	@GetMapping("/book")
	public String redirectBook() {
		return "redirect:/";
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
						@RequestParam("totalPrice") int totalPrice, 
						@RequestParam("selectedSeats") String selectedSeats,
						@RequestParam("selectedTime") String selectedTime,
						@RequestParam("conTimeId") String conTimeId,
						HttpServletRequest request,
						Model model) {
		System.out.println("BookController 컨트롤러의 payment() 메소드 실행");
		
		ConsumerVO user = (ConsumerVO) request.getSession().getAttribute("loginUser");
		if (null == user) {
			return "/login";
		}
		
		String[] seats = selectedSeats.split(", ");
		for (String seat : seats) {
//			System.out.println(seat);
			String lineNum = seat.substring(0, 1);
			String seatNum = seat.substring(1);
			if (bookService.isBooked(concertVO.getId(), conTimeId, lineNum, seatNum)) {
				return "/bookFail";
			}
		}
		
		int consumerId = user.getId();
		
		List<CardVO> cardList = cardService.getCardListById(consumerId);
		
		Date selTime = bookService.selectedTime(selectedTime);
		
		System.out.println(concertVO.getPosterUrl());
    	String relativePath = concertService.relativePath(concertVO.getPosterUrl(), "/posters/");
    	System.out.println(relativePath);
    	concertVO.setPosterUrl(relativePath);
		
    	model.addAttribute("conTimeId", conTimeId);
    	model.addAttribute("selectedTime", selectedTime);
    	model.addAttribute("cardList", cardList);
		model.addAttribute("selectedSeats", selectedSeats);
		model.addAttribute("selTime", selTime);
		model.addAttribute("concertVO", concertVO);
		model.addAttribute("totalPrice", totalPrice);
		
		return "/payment";
	}
	
	// get 요청으로 payment 요청을 보내면 home 화면으로 돌려보냄
	@GetMapping("/payment")
	public String redirectPayment() {
		return "redirect:/";
	}
	
	@PostMapping("/bookOK")
	public String bookOK(@RequestParam("concertId") String concertId,
						@RequestParam("actionCardId") String cardId,
						@RequestParam("price") String price,
						@RequestParam("selectedSeats") String selectedSeats,
						@RequestParam("selTime") String selTime,
						@RequestParam("actionPayType") String payType,
						@RequestParam("conTimeId") String conTimeId,
						HttpServletRequest request,
						Model model) {
		System.out.println("BookController 컨트롤러의 bookOK() 메소드 실행");
		
		ConsumerVO user = (ConsumerVO) request.getSession().getAttribute("loginUser");
		if (null == user) {
			return "/login";
		}
		
		String[] seats = selectedSeats.split(", ");
		for (String seat : seats) {
//			System.out.println(seat);
			String lineNum = seat.substring(0, 1);
			String seatNum = seat.substring(1);
			if (bookService.isBooked(Integer.parseInt(concertId), conTimeId, lineNum, seatNum)) {
				return "/bookFail";
			}
		}
		
//		int consumerId = (int) request.getSession().getAttribute("consumerId");
		int consumerId = user.getId();
		
		String bookNum = bookService.insertBook(consumerId, concertId, cardId, price, selectedSeats, selTime, payType, conTimeId);
		
		List<BookVO> books = bookService.getBooksByBookNum(bookNum);
//		System.out.println("books: " + books);
		
		ConcertVO conVO = concertService.getConcertById(books.get(0).getConcertId());
		conVO.setPosterUrl(concertService.relativePath(conVO.getPosterUrl(), "/posters/"));
		
		model.addAttribute("conVO", conVO);
		model.addAttribute("books", books);
		return "/bookOK";
	}
	
	// get 요청으로 bookOK 요청을 보내면 home 화면으로 돌려보냄
	@GetMapping("/bookOK")
	public String redirectBookOK() {
		return "redirect:/";
	}
	
}
