package com.mbcit.vivere.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.concertSeatVO;

@Mapper
public interface BookDAO {

	List<concertSeatVO> selectBookedSeats(int conTimeId);
	List<BookVO> pastBook(BookVO bookVO);
	List<concertSeatVO> getConcertSeatByConTimeId(int conTimeId);
	void insertBook(BookVO bookVO);
	int getConcertSeatIdByColums(concertSeatVO concertSeatVO);
	boolean selectBookYNById(int csId);
	List<BookVO> getBooksByBookNum(String bookNum);
	List<BookVO> getBookListByConsumerId(int consumerId);
	void deleteBookById(int bookId);

}
