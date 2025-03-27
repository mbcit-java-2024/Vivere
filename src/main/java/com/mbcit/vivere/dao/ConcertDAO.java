package com.mbcit.vivere.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;
import com.mbcit.vivere.vo.concertSeatVO;

@Mapper
public interface ConcertDAO {
	
	ConcertVO getConcertById(int id);
	List<ConcertTimeVO> getConcertTimes(int id);
	void insert(ConcertVO vo);
	ConcertVO selectByPosterUrl(String posterUrl);
	void insertConcertTime(ConcertTimeVO concertTimeVo);
	void insertConcertSeat(concertSeatVO vo);
	List<ConcertVO> getConcertListByTime();
	List<ConcertVO> getConcertListByTimeAndCategoryId(int categoryId);
	

}
