package com.mbcit.vivere.dao;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;

@Mapper
public interface ConcertDAO {
	
	ConcertVO getConcertById(int id);
	List<ConcertTimeVO> getConcertTimes(int id);
	void insert(ConcertVO vo);
	ConcertVO selectByPosterUrl(String posterUrl);
	void insertConcertTime(ConcertTimeVO concertTimeVo);

}
