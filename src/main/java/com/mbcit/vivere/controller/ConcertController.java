package com.mbcit.vivere.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.mbcit.vivere.service.ConcertService;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;
import com.mbcit.vivere.vo.concertSeatVO;

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
			@RequestParam("concertDateTime") String[] concertDateTimes, ConcertVO concertVO, HttpServletRequest request,
	        @RequestParam("vipSeats") Optional<String[]> vipSeats,
	        @RequestParam("rSeats") Optional<String[]> rSeats,
	        @RequestParam("sSeats") Optional<String[]> sSeats,
	        @RequestParam("aSeats") Optional<String[]> aSeats) {
		
//		콘서트 정보 1건을 저장
		ConcertVO vo = concertVO;
		concertService.saveConcert(request, vo, file);
		
//		콘서트 시간 정보 여러건을 저장 
		String[] concertTimes = concertDateTimes;
		log.info("concertTimes[]: " + concertTimes);
		concertService.saveConcertTimes(vo, concertTimes);
		
//		콘서트 시간별 좌석등급별 좌석번호 지정 내용을 저장
//		log.info("vipSeats: "+ vipSeats.toString());
//		log.info("rSeats: "+ rSeats.toString());
//		log.info("sSeats: "+ sSeats.toString());
//		log.info("aSeats: "+ aSeats.toString());
		concertService.saveConcertSeats(vo, vipSeats, rSeats, sSeats, aSeats);
		
		return "redirect:/concertList";
	}

	@RequestMapping("/concertList")
	public String concertList(Model model, @RequestParam(value = "categoryId", required = false) Integer categoryId) {
		log.info("ConcertController의 concertList() 메소드 실행");
		List<ConcertVO> concertList = new ArrayList<>();
		
//		카테고리 아이디별로 다른 공연 목록 DB에서 가져오기
		if (categoryId == null) {
			concertList = concertService.getConcertListByTime();
		} else {
			concertList = concertService.getConcertListByTimeAndCategoryId(categoryId);
		}
		
//		공연 목록과 카테고리아이디를 model 에 담아 jsp 로 보낸다.
		model.addAttribute("concertList", concertList);
		model.addAttribute("categoryId", categoryId);
		return "/concertList";
	}
	
	@RequestMapping("/concertView")
	public String concertView(@RequestParam("concertId") int concertId, Model model) {
		log.info("ConcertController의 concertView() 메소드 실행");
//		해당 공연 1건 
		ConcertVO concertVO = concertService.getConcertById(concertId);
		concertService.setTimeAndPoster(concertVO);
//		해당 공연의 시간정보 
		List<ConcertTimeVO> conTimeList = concertService.getConcertTimes(concertId);
		
//		jsp 로 필요한 정보 보내기
		model.addAttribute("concertVO", concertVO);
		model.addAttribute("conTimeList", conTimeList);
		
		return "/concertView";
	}
	
//	========================= 콘서트 수정 및 삭제 =====================
	@RequestMapping("/updateConcert")
	public String updateConcert(@RequestParam("concertId") int concertId, Model model) {
		log.info("ConcertController의 updateConcert() 메소드 실행");
//		해당 공연 1건 
		ConcertVO concertVO = concertService.getConcertById(concertId);
		concertService.setTimeAndPoster(concertVO);
//		해당 공연의 시간정보 
		List<ConcertTimeVO> conTimeList = concertService.getConcertTimes(concertId);
//		해당 공연의 선택된 좌석등급 
		List<String> selecedSeatTypes = concertService.getSelectedSeatTypes(concertVO);
		String[] seatTypes = {"vip", "r", "s", "a"};
		log.info("selecedSeatTypes: " + selecedSeatTypes);
		
//		jsp 로 필요한 정보 보내기
		model.addAttribute("concertVO", concertVO);
		model.addAttribute("conTimeList", conTimeList);
		model.addAttribute("selectedSeatTypes", selecedSeatTypes);
		model.addAttribute("seatTypes", seatTypes);
		return "/updateConcert";
	}
	
	@RequestMapping("/updateConcertOK")
	public String updateConcertOK(@RequestParam("imageUrlUpdate") MultipartFile file, 
			@RequestParam("concertId") String concertId,
			@RequestParam("isSeatTypeChange") boolean isSeatTypeChange,
			@RequestParam("concertDateTime") String[] concertDateTimes, ConcertVO concertVO, HttpServletRequest request,
	        @RequestParam("vipSeats") Optional<String[]> vipSeats,
	        @RequestParam("rSeats") Optional<String[]> rSeats,
	        @RequestParam("sSeats") Optional<String[]> sSeats,
	        @RequestParam("aSeats") Optional<String[]> aSeats) {
		log.info("ConcertController의 updateConcertOK() 메소드 실행");
		
		int id = Integer.parseInt(concertId);
//		콘서트 정보 1건을 수정
		ConcertVO vo = concertVO;
		vo.setId(id);
		concertService.updateConcert(request, vo, file);
		
		log.info("isSeatTypeChange: "+isSeatTypeChange);
//		기존 콘서트의 좌석 정보를 삭제한다. 
			concertService.deleteConcertSeats(id);
//		콘서트 시간별 좌석등급별 좌석번호 지정 내용을 새로 생성하여 저장
			concertService.saveConcertSeats(vo, vipSeats, rSeats, sSeats, aSeats);
		return "redirect:/concertView?concertId="+id;
	}
	
//	콘서트 타임 1건 수정
	@PostMapping("/updateConcertTime")
	@ResponseBody
	public String updateConcertTime(@RequestParam("timeId") int timeId, 
	                                @RequestParam("newConcertDateTime") String newConcertDateTime) {
		log.info("ConcertController의 updateConcertTime() 메소드 실행");
	    try {
	        concertService.updateConcertTime(timeId, newConcertDateTime);
	        return "success";
	    } catch (Exception e) {
	        return "error";
	    }
	}
	
//	등급별 좌석 정보 넘겨주기
	@PostMapping("/getSelectedSeats")
	@ResponseBody
	public String getSelectedSeats(@RequestParam("seatType") String seatType, @RequestParam("concertId") int concertId) {
		log.info("ConcertController의 getSelectedSeats() 메소드 실행");
		String selectedSeats = concertService.getSelectedSeatsByGrade(seatType, concertId);
		log.info("selectedSeats["+seatType+"]: "+ selectedSeats);
		
		return selectedSeats;
	}
	
//	콘서트 타임 1건 추가
	@PostMapping("/addConcertTime")
	@ResponseBody
	public Map<String, Object> addConcertTime(
			@RequestParam("concertId") int concertId,
			@RequestParam("concertDateTime") String concertDateTime) {
		log.info("ConcertController의 addConcertTime() 메소드 실행");
	    Map<String, Object> response = new HashMap<>();
	    try {
	        ConcertTimeVO newConcertTime = new ConcertTimeVO();
	        newConcertTime.setConcertId(concertId);
	        newConcertTime.setConcertTime(concertService.concertTimeStringToDate(concertDateTime));
	        concertService.saveConcertTime(newConcertTime); // DB 저장
//	        DB에 저장된 데이터 불러오기
	        newConcertTime = concertService.getConcertTimeByConcertIdAndTime(newConcertTime);
	        log.info("concertTimeId: "+ newConcertTime.getId());
	        response.put("success", true);
	        response.put("concertTimeId", newConcertTime.getId()); // 저장된 ID 반환
	    } catch (Exception e) {
	        response.put("success", false);
	    }
	    return response;
	}
	
//	콘서트타임 1건 db에서 삭제 + concertTimeId 에 해당하는 concertSeat 삭제
	@PostMapping("/deleteConcertTime")
	@ResponseBody
	public String deleteConcertTime(@RequestParam("timeId") int concertTimeId) {
		log.info("ConcertController의 deleteConcertTime() 메소드 실행");
	    try {
	    	log.info("concertTimeId: "+ concertTimeId);
	        concertService.deleteConcertTime(concertTimeId);
	        return "success";
	    } catch (Exception e) {
	        return "error";
	    }
	}
	
	
//	콘서트 삭제
	@RequestMapping("/deleteConcert")
	public String deleteConcert(@RequestParam("concertId") int concertId) {
		concertService.deleteConcert(concertId);
		return"redirect:/concertList";
	}
	
}
