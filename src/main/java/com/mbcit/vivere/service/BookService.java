package com.mbcit.vivere.service;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

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
	
	public List<String> getBookedSeats(int conTimeId) {
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
		System.out.println("BookService 클래스의 pastBook() 메소드 실행");
		return bookDAO.pastBook(bookVO);
	}

	public List<concertSeatVO> getConcertSeatByConTimeId(int conTimeId) {
		System.out.println("BookService 클래스의 getConcertSeatByConTimeId() 메소드 실행");
		List<concertSeatVO> conSeat = bookDAO.getConcertSeatByConTimeId(conTimeId);
		return conSeat;
	}

	public Date selectedTime(String selectedTime) {
		System.out.println("BookService 클래스의 selectedTime() 메소드 실행");
		System.out.println("변환 전: " + selectedTime);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH시 mm분");
        Date date = null;
		try {
			date = sdf.parse(selectedTime);
		} catch (ParseException e) {
			System.out.println("selectedTime 변환 실패");
		}
        
        return date;
	}

}





