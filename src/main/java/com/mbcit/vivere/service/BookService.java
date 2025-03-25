package com.mbcit.vivere.service;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.BookDAO;
import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.concertSeatVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BookService {
	
	@Autowired
	private BookDAO bookDAO;
	
	public List<String> getBookedSeats(String conTimeId) {
		System.out.println("BookService 클래스의 getBookedSeats() 메소드 실행");
		List<concertSeatVO> bookSeat = bookDAO.selectBookedSeats(conTimeId);
		System.out.println("BookService 클래스의 bookSeat 생성");
//		log.info(bookSeat.toString());
		List<String> seats = new ArrayList<>();
		DecimalFormat df = new DecimalFormat("00");
		
		for (int i = 0; i < bookSeat.size(); i++) {
			char lineNum = bookSeat.get(i).getLineNum();
			int seatNum = bookSeat.get(i).getSeatNum();
			String seatName = lineNum + df.format(seatNum);
//			System.out.println(seatName); // A01 형태로 잘 찍혔음
			seats.add(seatName);
		}
		return seats;
	}

	public List<BookVO> pastBook(BookVO bookVO) {
		return bookDAO.pastBook(bookVO);
	}

}
