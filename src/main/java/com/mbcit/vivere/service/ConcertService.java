package com.mbcit.vivere.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.ConcertDAO;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ConcertService {
	
	@Autowired
	private ConcertDAO concertDAO;
	
	
	public ConcertVO getConcertById(int id) {
		System.out.println("ConcertService 클래스의 getConcertById() 메소드 실행");
		ConcertVO concertVO = concertDAO.getConcertById(id);
		return concertVO;
	}

//	concertTime 전체 List를 가져오는 메소드
	public List<ConcertTimeVO> getConcertTimes(int id) {
		System.out.println("ConcertService 클래스의 getConcertTimes() 메소드 실행");
		List<ConcertTimeVO> conTimes = concertDAO.getConcertTimes(id);
		return conTimes;
	}
	
//	지난 concertTime List를 가져오는 메소드
	public List<ConcertTimeVO> getPastConcertTimes(int id) {
		System.out.println("ConcertService 클래스의 getPastConcertTimes() 메소드 실행");
		List<ConcertTimeVO> conTimes = getConcertTimes(id);
		Date now = new Date();
		for (int i = 0; i < conTimes.size(); i++) {
			ConcertTimeVO ct = conTimes.get(i);
			if (ct.getConcertTime().before(now)) {
				conTimes.remove(i);
				i--;
			}
		}		
		return conTimes;
	}
	
//	아직 하지않은 공연의 concertTime List를 가져오는 메소드
	public List<ConcertTimeVO> getFutureConcertTimes(int id) {
		System.out.println("ConcertService 클래스의 getFutureConcertTimes() 메소드 실행");
		List<ConcertTimeVO> conTimes = getConcertTimes(id);
		Date now = new Date();
		for (int i = 0; i < conTimes.size(); i++) {
			ConcertTimeVO ct = conTimes.get(i);
			if (ct.getConcertTime().after(now)) {
				conTimes.remove(i);
				i--;
			}
		}
		return conTimes;
	}

	public ArrayList<Character> getGHallLine() {
		ArrayList<Character> gHall = new ArrayList<>();
		for (int i = 65; i < 85; i++) {
			gHall.add((char) i);
		}
		return gHall;
	}
	
	public ArrayList<Character> getFHallLine() {
		ArrayList<Character> fHall = new ArrayList<>();
		for (int i = 65; i < 80; i++) {
			fHall.add((char) i);
		}
		return fHall;
	}
	

}
