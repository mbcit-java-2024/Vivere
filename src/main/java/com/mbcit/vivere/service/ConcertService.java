package com.mbcit.vivere.service;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
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
	
//	file과 concertTitle을 받아 이름을 지정하고 poster 폴더에 저장한 후 그 경로를 반환하는 메소드 
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
			Optional<String[]> sOptionalSeats, Optional<String[]> aOptionalSeats) {
		log.info("ConcertService 클래스의 saveConcertSeats() 메소드");
		
//		concertId 로 concertTime 객체 리스트를 받아온다. 
		ConcertVO conVo = concertDAO.selectByPosterUrl(vo.getPosterUrl());
		List<ConcertTimeVO> conTimes = concertDAO.getConcertTimes(conVo.getId());
		log.info("conVo: "+ conVo.toString());
		log.info("conTimes: "+ conTimes);
		log.info("equalPrice: "+ conVo.getEqualPrice());
		
		if (conVo.getEqualPrice() == 0) {
			// 좌석 등급별 좌석번호가 저장된 리스트를 배열로 받는다.
			String[] vipSeats = vipOptionalSeats.isPresent() ? vipOptionalSeats.get() : null;
			String[] rSeats = rOptionalSeats.isPresent() ? rOptionalSeats.get() : null;
			String[] sSeats = sOptionalSeats.isPresent() ? sOptionalSeats.get() : null;
			String[] aSeats = aOptionalSeats.isPresent() ? aOptionalSeats.get() : null;
//			log.info("vipSeats: "+ vipSeats + ", vipCount: "+ vipSeats.length);
//			log.info("rSeats: "+ rSeats + ", rCount: "+ rSeats.length);
//			log.info("sSeats: "+ sSeats + ", sCout: "+ sSeats.length);
//			log.info("aSeats: "+ aSeats + ", aCount: " + aSeats.length);
//			log.info("realTotalSeatCount: "+ (vipSeats.length + rSeats.length + aSeats.length + sSeats.length));
			
//			// 배열들을 selectdSeatList에 저장한다.
			String[] seatTypes = {"VIP", "R", "S", "A"};
			List<String[]> selectedSeatList = Arrays.asList(vipSeats, rSeats, sSeats, aSeats);
			
			// null 이 아닌 배열들만 좌석 객체를 생성하여 저장한다.
			int i = 0;
			for (String[] seats : selectedSeatList) {
				if(seats != null) {
					for (String seatNum : seats) {
						log.info(seatNum+" / ");
					}
					// 각 concertTime 마다 반복하며 좌석 객체들을 생성하여 저장한다.
					for (ConcertTimeVO conTime : conTimes) {
						saveSeats(conVo.getId(), conTime.getId(), seatTypes[i], seats);
					}
				} else {
					log.info( seatTypes[i] +"등급은 선택되지 않음");
				}
				i++;
			}
		
		} else {
			log.info("equal Seats 저장");
			log.info("hallType: "+conVo.getHallType());
			String[] eSeats;
			if (conVo.getHallType() == 0) {
				eSeats = generateSeats(0).toArray(new String[0]);
				log.info("eSeats: "+ eSeats.toString());
			} else {
				eSeats = generateSeats(1).toArray(new String[0]);
			}
//		각 concertTime 마다 반복하며 좌석 객체들을 생성하여 저장한다.
			for (ConcertTimeVO conTime : conTimes) {
				saveSeats(conVo.getId(), conTime.getId(), "equal", eSeats);
			}
		}
	}
	
//	공연장 타입을 입력받아 좌석번호를 리스트로 생성하는 메소드
	private List<String> generateSeats(int hallType) {
		log.info("Concert Service 클래스의 generateSeats 메소드 실행");
		List<String> seats = new ArrayList<>();
		if (hallType == 0) {
			log.info("가우디움 좌석번호 배열 생성");
			String[] rows = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L","M","N","O","P","Q","R","S","T"};
			for (String row : rows) {
				for (int i = 1; i <= 24; i++ ) {
					String seatNum = String.format("%02d", i);
					String seat = row + seatNum;
					seats.add(seat);
				}
			}
			return seats;
		}else {
			String[] rows = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L","M","N","O"};
			for (String row : rows) {
				for (int i = 1; i <= 14; i++ ) {
					String seatNum = String.format("%02d", i);
					String seat = row + seatNum;
					seats.add(seat);
				}
			}
			return seats;
		}
	}
	
//	콘서트 아이디, 등급, 좌석번호배열들을 받아 db의 concertSeats 테이블에 저장하는 메소드
    private void saveSeats(int concertId, int concertTimeId, String seatType, String[] seats) {
    	log.info("ConcertService 클래스의 saveSeats() 메소드" + seatType + concertTimeId);
    	log.info("seatType: " + seatType);
    	
  	log.info("seatList: " + seats.toString());
    	
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
    
//	ConcertVO를 받아 각 콘서트 객체의 공연시작일과 마지막일을 넣어주고 포스터url을 상대경로로 바꿔주는 메소드    
    public ConcertVO setTimeAndPoster(ConcertVO vo){
    	log.info("ConcertService 클래스의 setTimeAndPoster(ConcertVO) 메소드 실행");
    	// 콘서트 아이디로 콘서트 시간 정보를 가져온다. 
    	List<ConcertTimeVO> conTimes = concertDAO.getConcertTimes(vo.getId());
    	vo.setStartDate(conTimes.get(0).getConcertTime());
    	vo.setEndDate(conTimes.get(conTimes.size() - 1).getConcertTime());
    	
    	// ConcertVO 마다 posterUrl 을 상대경로로 바꿔준다.
    	File file = new File(vo.getPosterUrl());
    	String fileName = file.getName(); // 파일명만 추출
    	String relativePath = "/posters/" + fileName;
    	log.info("이미지 상대 경로: " + relativePath);
    	vo.setPosterUrl(relativePath);
    	
    	return vo;
    }
//	List<ConcertVO>를 받아 각 콘서트 객체의 공연시작일과 마지막일을 넣어주고 포스터url을 상대경로로 바꿔주는 메소드    
    public List<ConcertVO> setTimeAndPoster (List<ConcertVO> concertList){
    	log.info("ConcertService 클래스의 setTimeAndPoster(List<ConcertVO>) 메소드 실행");
    	// ConcertVO 마다 startDate와 endDate 값을 넣어준다.
    	for (ConcertVO vo : concertList) {
    		setTimeAndPoster(vo);
    	}
    	return concertList;
    }
    
//  현재 공연중인 콘서트 리스트를 가져와서 리턴하는 메소드
	public List<ConcertVO> getConcertListByTime() {
		List<ConcertVO> concertList = concertDAO.getConcertListByTime();
		setTimeAndPoster(concertList);
		return concertList;
	}
	
//  카테고리 아이디를 받아서 현재 공연중인 콘서트 리스트를 가져와서 리턴하는 메소드
	public List<ConcertVO> getConcertListByTimeAndCategoryId(int categoryId) {
		List<ConcertVO> concertList = concertDAO.getConcertListByTimeAndCategoryId(categoryId);
		setTimeAndPoster(concertList);
		return concertList;
	}
    
//  콘서트 아이디로 콘서트 객체 1개를 가져오는 메소드
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
	
//	아직 하지않은 공연의 concertTime List를 가져오는 메소드
	public List<ConcertTimeVO> getFutureConcertTimes(int id) {
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
	
//	지난 concertTime List를 가져오는 메소드
	public List<ConcertTimeVO> getPastConcertTimes(int id) {
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

//	cocertId를 받아 DB의 concert, concerttime, concertseat 테이블에서 해당하는 데이터와 
//	posters 폴더의 포스터 이미지를 삭제하는 메소드
	public void deleteConcert(int concertId) {
		// 이미지 파일 삭제 (poster 폴더에 있는 파일 삭제)
		String absolutePath = concertDAO.getConcertById(concertId).getPosterUrl(); // DB에 저장된 절대 경로
		if (absolutePath != null && !absolutePath.isEmpty()) {
			File file = new File(absolutePath);
			if (file.exists()) {
				file.delete(); // 이미지 파일 삭제
			}
		}
		concertDAO.deleteConcert(concertId);
		concertDAO.deleteConcertTimesById(concertId);
		concertDAO.deleteConcertSeatsById(concertId);
	}







	

}
