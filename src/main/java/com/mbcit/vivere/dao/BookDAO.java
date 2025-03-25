package com.mbcit.vivere.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.concertSeatVO;

@Mapper
public interface BookDAO {

	List<concertSeatVO> selectBookedSeats(String conTimeId);

	List<BookVO> pastBook(BookVO bookVO);

}
