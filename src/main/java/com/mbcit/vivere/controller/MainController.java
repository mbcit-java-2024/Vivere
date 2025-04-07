package com.mbcit.vivere.controller;


import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.mbcit.vivere.eNum.Grade;
import com.mbcit.vivere.service.BookService;
import com.mbcit.vivere.service.ConcertService;
import com.mbcit.vivere.service.NoticeService;
import com.mbcit.vivere.service.QnARepService;
import com.mbcit.vivere.service.QnAService;
import com.mbcit.vivere.service.ReviewService;
import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.CarouselVO;
import com.mbcit.vivere.vo.ConcertVO;
import com.mbcit.vivere.vo.ConsumerVO;
import com.mbcit.vivere.vo.NoticeVO;
import com.mbcit.vivere.vo.QnaVO;
import com.mbcit.vivere.vo.QnarepVO;
import com.mbcit.vivere.vo.ReviewVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {

	@Autowired
	private BookService bookService;
	@Autowired
	private QnAService qnaService;
	@Autowired
	private ReviewService reviewService;
	@Autowired
	private QnARepService qnaRepService;
	@Autowired
	private ConcertService concertService;
	@Autowired
	private NoticeService noticeService;
	
	@RequestMapping("/")
	public String main(Model model) {
		log.info("MainController 의 main() 메소드 실행");
		
		List<CarouselVO> carouselList = concertService.getCarouselListByStatus();
		model.addAttribute("carouselList", carouselList);
		return "/main";
	}

// ===================== 표지 이미지 (carousel) ========================

	@RequestMapping("/carouselList")
	public String carouselList(Model model) {
		log.info("MainController 의 carouselList() 메소드 실행");
//		현재 상영중인 공연 리스트에 carouselUrl을 추가해서 받아가기
		List<ConcertVO> concertList = concertService.getConcertListByTime();
		for (ConcertVO vo : concertList) {
			String carouselUrl = concertService.getCarouselUrlByConcertId(vo.getId());
			log.info(vo.getId()+". "+ carouselUrl);
			if (carouselUrl != null && !carouselUrl.trim().isEmpty()){
				vo.setCarouselUrl(concertService.relativePath(concertService.getCarouselUrlByConcertId(vo.getId()),"/carousel/"));
			}else {
				vo.setCarouselUrl("");
			}
		}
		
//		현재 메인표지로 선택된 carouselList
		List<CarouselVO> carouselList = concertService.getCarouselListByStatus();
		
		model.addAttribute("concertList", concertList);
		model.addAttribute("carouselList", carouselList);
		return "/carouselList";
	}
	
	@RequestMapping("/carouselListOK")
	public String carouselListOK(@RequestParam("selectedIds") List<Integer> selectedConIds) {
		log.info("MainController 의 carouselList() 메소드 실행");
//		메인 표지로 선택된 concertId들이 든 리스트의 상태값을 1 로 바꾸기
		concertService.updateCarouselStatus(selectedConIds);

		return "redirect:/";
	}
	
//	이미지 파일과 concertId를 받아 CarouselVO 1건을 생성해서 DB에 저장
	@PostMapping("/insertCarouselOK")
	@ResponseBody
	public String insertCarouselOK( HttpServletRequest request,
			@RequestParam("concertId") int concertId,
	        @RequestParam("images") MultipartFile imageFile) throws IOException {
		log.info("MainController 의 insertCarouselOK() 메소드 실행");

	    if (imageFile.isEmpty()) {
	        return "파일이 없습니다.";
	    }
	    
	    ConcertVO conVO = concertService.getConcertById(concertId);
	    CarouselVO carVO = new CarouselVO();
	    carVO.setConcertId(concertId);
	    carVO.setCarouselUrl(concertService.imageToUrl (request.getServletContext().getRealPath("/carousel/"), imageFile, conVO.getTitle()+"_메인표지"));
	    concertService.insertCarouselUrl(carVO);

	    return "성공";
	}
	
//	이미지 파일과 concertId를 받아 CarouselVO 1건을 DB에서 수정
	@PostMapping("/updateCarouselOK")
	@ResponseBody
	public String updateCarouselOK( HttpServletRequest request,
			@RequestParam("concertId") int concertId,
			@RequestParam("images") MultipartFile imageFile) throws IOException {
		log.info("MainController 의 updateCarouselOK() 메소드 실행");
		
		if (imageFile.isEmpty()) {
			return "파일이 없습니다.";
		}
		
		ConcertVO conVO = concertService.getConcertById(concertId);
		CarouselVO carVO = concertService.getCarouselByConcertId(concertId);
		carVO.setConcertId(concertId);
		carVO.setCarouselUrl(concertService.imageToUrl (request.getServletContext().getRealPath("/carousel/"), imageFile, conVO.getTitle()+"_메인표지"));
		concertService.updateCarouselUrl(carVO);
		
		return "성공";
	}
	
//	concertId를 받아 CarouselVO 1건을 DB에서 삭제
	@PostMapping("/deleteCarousel")
	@ResponseBody
	public String deleteCarousel( @RequestParam("concertId") int concertId){
		log.info("MainController 의 deleteCarousel() 메소드 실행");
		concertService.deleteCarousel(concertId);
		return "성공";
	}
	
// ===================== 표지 이미지 (carousel) 끝 ========================
	@GetMapping("/noticeList")
	public String noticeList(Model model, NoticeVO noticeVO) {
		// 수빈
		log.info("MainController 의 noticeList() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		 consumerVO.setGrade(Grade.ADMIN);
		 result = "/noticeList"; 
		 List<NoticeVO> noticeList = noticeService.selectNoticeList(noticeVO);
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}

		model.addAttribute("noticeList", noticeList);
		return result;

	}
	@GetMapping("/noticeDetail/{id}")
	public String noticeDetail(Model model, NoticeVO noticeVO, @PathVariable int id) {
		// 수빈
		log.info("MainController 의 noticeDetail() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		 consumerVO.setGrade(Grade.ADMIN);
		 result = "/noticeDetail"; 
		 NoticeVO noticeDetail = noticeService.selectNoticeDetail(id);
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		
		model.addAttribute("noticeDetail", noticeDetail);
		return result;
		
	}
	@GetMapping("/noticeEdit/{id}")
	public String noticeEdit(Model model, NoticeVO noticeVO, @PathVariable int id) {
		// 수빈
		log.info("MainController 의 noticeEdit() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		 consumerVO.setGrade(Grade.ADMIN);
		 result = "/noticeEdit"; 
		 NoticeVO noticeDetail = noticeService.selectNoticeDetail(id);
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		
		model.addAttribute("noticeDetail", noticeDetail);
		return result;
		
	}
	@PostMapping("/noticeEditOK")
	public String noticeEditOK(Model model, NoticeVO noticeVO) {
		// 수빈
		log.info("MainController 의 noticeEditOK() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		 consumerVO.setGrade(Grade.ADMIN);
		 result = "redirect:/noticeList"; 
		 noticeService.updateNotice(noticeVO);
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		
		return result;
		
	}
	@GetMapping("/noticeInsert")
	public String noticeInsert(Model model, NoticeVO noticeVO) {
		// 수빈
		log.info("MainController 의 noticeInsert() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		 consumerVO.setGrade(Grade.ADMIN);
		 result = "/noticeInsert"; 
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		
		return result;
		
	}
	@GetMapping("/noticeDelete/{id}")
	public String noticeDelete(Model model, NoticeVO noticeVO, @PathVariable int id) {
		// 수빈
		log.info("MainController 의 noticeDelete() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		 consumerVO.setGrade(Grade.ADMIN);
		 result = "redirect:/noticeList"; 
		 noticeService.noticeDelete(id);
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		
		return result;
	}
	@PostMapping("/noticeInsertOK")
	public String noticeInsertOK(Model model, NoticeVO noticeVO) {
		// 수빈
		log.info("MainController 의 noticeInsertOK() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		 consumerVO.setGrade(Grade.ADMIN);
		 result = "redirect:/noticeList"; 
		 noticeService.insert(noticeVO);
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		
		return result;
		
	}
	@GetMapping("/pastBook")
	public String pastBook(Model model, BookVO bookVO) {
		// 수빈
		log.info("MainController 의 pastBook() 메소드 실행");

		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<BookVO> pastBook = new ArrayList<BookVO>();

		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		// if (consumerVO.getGrade() != Grade.ADMIN) {
			bookVO.setConsumerId(1);
			result = "/pastBook";
		// } else {
		// consumerVO.setGrade(Grade.ADMIN);
		// result = "/"; // 로그인 페이지로
		// }
		pastBook = bookService.pastBook(bookVO);
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}

		log.info("pastBook" + pastBook);
		model.addAttribute("pastBook", pastBook);
		return result;
	}
	
	@GetMapping("/deleteReivew/{id}")
	public String deleteReivew(Model model, BookVO bookVO, ReviewVO reviewVO, @PathVariable int id) {
		// 수빈
		log.info("MainController 의 deleteReivew() 메소드 실행::::::::id:::::::::" + id);

		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<BookVO> pastBook = new ArrayList<BookVO>();

		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

		// if (consumerVO.getGrade() != Grade.ADMIN) {
				bookVO.setConsumerId(1);
				result = "redirect:/pastBook";
		// } else {
			// consumerVO.setGrade(Grade.ADMIN);
			// result = "/"; // 로그인 페이지로
		// }
		reviewVO.setId(id);
		reviewService.delete(reviewVO);
		// pastBook = bookService.pastBook(bookVO);
//		}
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	@GetMapping("/qnaInsert")
	public String qnaInsert(Model model, QnaVO qnaVO) {
		// 수빈
		log.info("MainController 의 qnaInsert() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();

		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

	//		if (consumerVO.getGrade() != Grade.ADMIN) {
			qnaVO.setConsumerId(1);
			result = "/qnaInsert";
	//		} else {
	//			consumerVO.setGrade(Grade.ADMIN);
	//			result = "/managerQnaList";
	//		}
//		}
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	@PostMapping("/qnaInsertOK")
	public String qnaInsertOK(Model model, QnaVO qnaVO) {
		// 수빈
		log.info("MainController 의 qnaInsert() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();

		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

	//		if (consumerVO.getGrade() != Grade.ADMIN) {
			qnaVO.setConsumerId(1);
			qnaService.insert(qnaVO);
			result = "redirect:/qnaList";
	//		} else {
	//			consumerVO.setGrade(Grade.ADMIN);
	//			result = "/managerQnaList";
	//		}
//		}
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	@GetMapping("/qnaList")
	public String qnaList(Model model, QnaVO qnaVO) {
		// 수빈
		log.info("MainController 의 qnaList() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<QnaVO> qnaList = new ArrayList<QnaVO>();

		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

	//		if (consumerVO.getGrade() != Grade.ADMIN) {
				qnaVO.setConsumerId(1);
				result = "/qnaList";
	//		} else {
//				consumerVO.setGrade(Grade.ADMIN);
//				result = "/managerQnaList";
	//		}
		qnaList = qnaService.qnaList(qnaVO);

		model.addAttribute("qnaList", qnaList);
		log.info("qnaList" + qnaList);
//		}	
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	@GetMapping("/deleteQna/{id}")
	public String deleteQna(Model model, QnaVO qnaVO, @PathVariable int id) {
		// 수빈
		log.info("MainController 의 deleteQna() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<QnaVO> qnaList = new ArrayList<QnaVO>();

		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

	//		if (consumerVO.getGrade() != Grade.ADMIN) { 
			qnaVO.setConsumerId(1);
			result = "redirect:/qnaList";
	//		} else {
	//			consumerVO.setGrade(Grade.ADMIN);
	//			result = "redirect:/managerQnaList";
	//		}
		qnaVO.setId(id);
		qnaService.delete(qnaVO);
//		}
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}
	@GetMapping("/deleteRep/{id}")
	public String deleteRep(Model model, QnarepVO qnarepVO, @PathVariable int id) {
		// 수빈
		log.info("MainController 의 deleteRep() 메소드 실행");
		String result = "/";
		ConsumerVO consumerVO = new ConsumerVO();
		List<QnaVO> qnaList = new ArrayList<QnaVO>();

		// ProductController에서 로그인 여부 확인
//		HttpSession session = request.getSession(false);
//		if (session != null && session.getAttribute("userType") != null) { 
//			int userType = (int) session.getAttribute("userType"); 

	//		if (consumerVO.getGrade() != Grade.ADMIN) {
		//		qnaVO.setConsumerId(1); 
		//		result ="redirect:/qnaList"; // 회원 로그인으로 들어왔을때 관리자 로그인 페이지로 돌아갈건지 // 근데 여기 왔다는건 이미 관리자 로그인
	//		} else {
				consumerVO.setGrade(Grade.ADMIN);
				result = "redirect:/qnaList";
	//		}
		qnarepVO.setId(id);
		qnaRepService.deleteRep(qnarepVO); // 이실행문의 위치가 consumerVO.setGrade(Grade.ADMIN);위인지
//		}
//		else {
//			result = "/login"; // 로그인 페이지로
//		}
		return result;
	}

}
	
