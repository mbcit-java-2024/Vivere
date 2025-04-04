package com.mbcit.vivere.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.CarouselVO;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;
import com.mbcit.vivere.vo.concertSeatVO;

@Mapper
public interface ConcertDAO {
	
//	concert
	ConcertVO getConcertById(int id);
	void insert(ConcertVO vo);
	ConcertVO selectByPosterUrl(String posterUrl);
	List<ConcertVO> getConcertListByTime();
	List<ConcertVO> getConcertListByTimeAndCategoryId(int categoryId);
	void deleteConcert(int concertId);
	void updateWithoutPoster(ConcertVO vo);
//	concertTime	
	List<ConcertTimeVO> getConcertTimes(int id);
	void insertConcertTime(ConcertTimeVO concertTimeVo);
	void deleteConcertTimesByConcertId(int concertId);
	void deleteConcertTimeById(int concertTimeId);
	ConcertTimeVO getConcertTimeByConcertIdAndTime(ConcertTimeVO co);
	ConcertTimeVO getConcertTimeById(int timeId);
	int getConcertTimeIdByConcertId(int concertId);
//	concertSeat
	void insertConcertSeat(concertSeatVO vo);
	void deleteConcertSeatsByConcertId(int concertId);
	void updateConcertTime(ConcertTimeVO vo);
	void deleteConcertSeatsByConcertTimeId(int concertTimeId);
	List<concertSeatVO> getConcertSeatListByGrade(concertSeatVO vo);
	void update(ConcertVO vo);
	String getGrade(concertSeatVO concertSeatVO);
	void updateBookYN(concertSeatVO concertSeatVO);
//	carousel
	CarouselVO getCarouselByConcertId(int concertId);
	void insertCarousel(CarouselVO carVO);
	List<CarouselVO> getCarouselListByStatus();
	void updateCarouselUrl(CarouselVO carVO);
	void deleteCarouselUrl(int concertId);
	void resetCarouselStatus();
	void updateCarouselStatus(int concertId);
	

}
