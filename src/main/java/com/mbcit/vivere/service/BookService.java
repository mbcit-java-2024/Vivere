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
import com.mbcit.vivere.dao.ConcertDAO;
import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.concertSeatVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BookService {
	
	@Autowired
	private BookDAO bookDAO;
	
	@Autowired
	private ConcertDAO concertDAO;
	
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

	public String insertBook(int consumerId, String concertId, String cardId, String price, String selectedSeats,
							String selTime, String payType, String conTimeId) {
		System.out.println("BookService 클래스의 insertBook() 메소드 실행");
		
		String[] seats = selectedSeats.split(", ");
		System.out.println("이게 selTime 변환전: " + selTime);
		
		String consumerIdStr = String.format("%3s", consumerId).replace(' ', '0');
		String concertIdStr = String.format("%3s", concertId).replace(' ', '0');
		SimpleDateFormat sdfNow = new SimpleDateFormat("yyMMddHHmmss");
		Date now = new Date();
		String OrderDateStr = sdfNow.format(now);
//		bookNum 규칙 = consumerId(000) + concertId(000) + orderDate(yyMMdd) (총 12자리)
		String bookNum = consumerIdStr + concertIdStr + OrderDateStr;
		ConcertTimeVO conTimeVO = concertDAO.getConcertTimeById(Integer.parseInt(conTimeId));
		
		for (int i = 0; i < seats.length; i++) {
			
			char lineNum = seats[i].substring(0, 1).charAt(0);
			int seatNum = Integer.parseInt(seats[i].substring(1));
			concertSeatVO conSeat = new concertSeatVO();
			conSeat.setConcertId(Integer.parseInt(concertId));
			conSeat.setConcertTimeId(conTimeVO.getId());
			conSeat.setLineNum(lineNum);
			conSeat.setSeatNum(seatNum);
			String grade = concertDAO.getGrade(conSeat);
			
			BookVO book = new BookVO();
			book.setConsumerId(consumerId);
			book.setConcertId(Integer.parseInt(concertId));
			if (cardId.equals("") || null == cardId) {
				book.setCardId(0); // 0 이면 무통장입금 사용
			} else {
				book.setCardId(Integer.parseInt(cardId));
			}
			book.setBookNum(bookNum);
			book.setPrice(Integer.parseInt(price));
			book.setSeatNum(seats[i]);
			book.setGrade(grade);
			book.setOrderDate(now);
			book.setConcertTime(conTimeVO.getConcertTime());
			book.setPayType(Short.parseShort(payType));
			
			System.out.println("bookVO" + i + ": " + book);
			
			concertDAO.updateBookYN(conSeat);
//			System.out.println("updateBookYN 실행 완료");
			bookDAO.insertBook(book);
		}
		return bookNum;
	}
	
	public boolean isBooked(int concertId, String conTimeId, String lineNum, String seatNum) {
		System.out.println("BookService 클래스의 isBooked() 메소드 실행");
		
		int csId = getConcertSeatIdByColumns(concertId, conTimeId, lineNum, seatNum);
		boolean isBook = bookDAO.selectBookYNById(csId);
		if (isBook) {
			return true;
		}
		return false;
	}

	private int getConcertSeatIdByColumns(int concertId, String conTimeId, String lineNum, String seatNum) {
		System.out.println("BookService 클래스의 getConcertSeatIdByColums() 메소드 실행");
		
		concertSeatVO conseat = new concertSeatVO();
		conseat.setConcertId(concertId);
		conseat.setConcertTimeId(Integer.parseInt(conTimeId));
		conseat.setLineNum(lineNum.charAt(0));
		conseat.setSeatNum(Integer.parseInt(seatNum));
		
		int csId = bookDAO.getConcertSeatIdByColums(conseat);
		
		return csId;
	}

	public List<BookVO> getBooksByBookNum(String bookNum) {
		
		return bookDAO.getBooksByBookNum(bookNum);
	}

	 public List<BookVO> getBookListByConsumerId(int consumerId) {
		 
	        return bookDAO.getBookListByConsumerId(consumerId);
	        
	    }

	public void deleteBookById(int bookId) {
		bookDAO.deleteBookById(bookId);
		
	}

	public BookVO getLatestBookByConsumerId(int consumerId) {
	    return bookDAO.getLatestBookByConsumerId(consumerId);
	}



}





