package com.mbcit.vivere.service;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.mbcit.vivere.dao.ConcertDAO;
import com.mbcit.vivere.vo.ConcertTimeVO;
import com.mbcit.vivere.vo.ConcertVO;
import com.mbcit.vivere.vo.concertSeatVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ConcertService {
	
	@Autowired
	private ConcertDAO concertDAO;
	
//	controller에서 file과 concertTitle을 받아 이름을 지정하고 poster 폴더에 저장한 후 그 경로를 반환하는 메소드 
	public String imageToUrl(String uploadDir, MultipartFile file, String concertTitle) throws IllegalStateException, IOException {
		log.info("uploadDir: " + uploadDir);
		File uploadFolder = new File(uploadDir);
		if (!uploadFolder.exists()) {
			uploadFolder.mkdirs(); // 폴더가 없으면 생성
		}

		// 고유한 파일명 생성 후 저장
		String fileName = concertTitle + "_" + file.getOriginalFilename();
		String filePath = uploadDir + fileName;
		log.info("fileName: " + fileName);
		log.info("filePath: " + filePath);
		file.transferTo(new File(filePath));

		return filePath;
	}

//	controller에서 file과 request와 concertVO 1건을 받아 DB의 concert 테이블에 저장하는 메소드
	public void saveConcert(HttpServletRequest request, ConcertVO vo, MultipartFile file) {

		if (file.isEmpty()) {
		}
		try {
//			이미지 경로 저장
			String filePath = imageToUrl(request.getServletContext().getRealPath("/posters/"), file, vo.getTitle());
			vo.setPosterUrl(filePath);
			vo.setTotalSeat((int) vo.getTotalSeat());
			concertDAO.insert(vo);
		} catch (IOException e) {
			e.printStackTrace();
			log.info("콘서트 저장중 문제발생");
		}
		
	}

//	공연 날짜, 시간 저장하는 메소드
	public void saveConcertTime(ConcertVO vo, String[] concertTimes) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
		ConcertVO cvo = concertDAO.selectByPosterUrl(vo.getPosterUrl());
		
		for (int i = 0; i < concertTimes.length; i++) {
			String dateTimeStr = concertTimes[i];  // "2024-03-25'T'14:30"
			Date concertTime;
			try {
				concertTime = formatter.parse(dateTimeStr);
				log.info("dateTimeStr: " + dateTimeStr);
				log.info("concertTime: " + concertTime);
				
				ConcertTimeVO concertTimeVo = new ConcertTimeVO();
				concertTimeVo.setConcertId(cvo.getId());
				concertTimeVo.setConcertTime(concertTime);
				concertDAO.insertConcertTime(concertTimeVo);

			} catch (ParseException e) {
				e.printStackTrace();
				log.info("공연 시간 저장중 문제 발생");
			} 		
		}
	}
	
//	공연 좌석등급별 좌석번호 지정 내용을 저장
	public void saveConcertSeats(ConcertVO vo, Optional<String[]> vipOptionalSeats, Optional<String[]> rOptionalSeats,
			Optional<String[]> sOptionalSeats, Optional<String[]> aOptionalSeats, Optional<String[]> eOptionalSeats) {
		log.info("ConcertService 클래스의 saveConcertSeats() 메소드");
		
//		concertId 로 concertTime 객체 리스트를 받아온다. 
		ConcertVO conVo = concertDAO.selectByPosterUrl(vo.getPosterUrl());
		List<ConcertTimeVO> conTimes = concertDAO.getConcertTimes(conVo.getId());
		log.info("conTimes: "+ conTimes);
		
		if (conVo.getEqualPrice() == 0) {
			String[] vipSeats = vipOptionalSeats.isPresent() ? vipOptionalSeats.get() : null;
			String[] rSeats = rOptionalSeats.isPresent() ? rOptionalSeats.get() : null;
			String[] sSeats = sOptionalSeats.isPresent() ? sOptionalSeats.get() : null;
			String[] aSeats = aOptionalSeats.isPresent() ? aOptionalSeats.get() : null;
			log.info("vipSeats: "+ vipSeats);
			log.info("rSeats: "+ rSeats);
			log.info("sSeats: "+ sSeats);
			log.info("aSeats: "+ aSeats);
			
//		각 concertTime 마다 반복하며 좌석 객체들을 생성하여 저장한다.
			for (ConcertTimeVO conTime : conTimes) {
				saveSeats(conVo.getId(), conTime.getId(), "VIP", vipSeats);
				saveSeats(conVo.getId(), conTime.getId(), "R",sSeats);
				saveSeats(conVo.getId(), conTime.getId(), "S", sSeats);
				saveSeats(conVo.getId(), conTime.getId(), "A", aSeats);
			}
		
		} else {
			String[] eSeats = eOptionalSeats.isPresent() ? aOptionalSeats.get() : null;
			for (ConcertTimeVO conTime : conTimes) {
				saveSeats(conVo.getId(), conTime.getId(), "equal", eSeats);
			}
		}
	}
	
//	콘서트 아이디, 등급, 좌석번호배열들을 받아 db의 concertSeats 테이블에 저장하는 메소드
    private void saveSeats(int concertId, int concertTimeId, String seatType, String[] seats) {
    	log.info("ConcertService 클래스의 saveSeats() 메소드" + seatType);
    	
    	if (seats != null) {
	    	for (String seat : seats) {
	        	concertSeatVO vo = new concertSeatVO();
	        	vo.setConcertId(concertId);
	        	vo.setConcertTimeId(concertTimeId);
	        	vo.setGrade(seatType);
	        	vo.setLineNum((char) seat.charAt(0));
	        	vo.setSeatNum(Integer.parseInt(seat.substring(1)));
	            concertDAO.insertConcertSeat(vo);
	    	}
    	}
    }
	
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
