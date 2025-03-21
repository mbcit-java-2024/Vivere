package com.mbcit.vivere.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ConcertController {
	
	@RequestMapping("/insertConcert")
	public String insertConcert() {
		
		return "/insertConcert";
	}
	@RequestMapping("/insertConcertOK")
	public String insertConcertOK() {
		
//		콘서트 정보 1건을 저장
		
//		콘서트 시간 정보 여러건을 저장 (반복문? 체크박스로 얻어와서 반복을 돌려야하나?)
		
		
		return "";
	}

}
