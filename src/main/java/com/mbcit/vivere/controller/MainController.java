package com.mbcit.vivere.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {

	@RequestMapping("/")
	public String main() {
		log.info("MainController 의 main() 메소드 실행");
		
		return "/main";
	}
}
