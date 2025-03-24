package com.mbcit.vivere.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.mbcit.vivere.service.ConcertService;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ConcertController {
	
	@Autowired
	private ConcertService concertService;
	
	
	@RequestMapping("/insertConcert")
	public String insertConcert() {
		
		return "/insertConcert";
	}
	@RequestMapping("/insertConcertOK")
	public String insertConcertOK(@RequestParam("imageUrl") MultipartFile file, 
			@RequestParam("concertDateTime") String[] concertDateTimes, ConcertVO concertVO, HttpServletRequest request) {
		
//		콘서트 정보 1건을 저장
		ConcertVO vo = concertVO;
		concertService.saveConcert(request, vo, file);
		
//		콘서트 시간 정보 여러건을 저장 
		String[] concertTimes = concertDateTimes;
		log.info("concertTimes[]: " + concertTimes);
		concertService.saveConcertTime(vo, concertTimes);
		
		return "";
	}

}
