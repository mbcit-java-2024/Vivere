package com.mbcit.vivere.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mbcit.vivere.service.BookService;
import com.mbcit.vivere.service.CardService;
import com.mbcit.vivere.service.ConcertService;
import com.mbcit.vivere.service.LoginService;
import com.mbcit.vivere.vo.BookVO;
import com.mbcit.vivere.vo.CardVO;
import com.mbcit.vivere.vo.ConcertVO;
import com.mbcit.vivere.vo.ConsumerVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ConsumerController {
	
	@Autowired
	private LoginService loginService;
	@Autowired
	private CardService cardService;
	@Autowired
	private BookService bookService;
	@Autowired
	private ConcertService concertService;
	
	@RequestMapping("/myinfo")
	public String myinfo(HttpSession session, Model model) {
	    ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");
	    if (loginUser == null) return "redirect:/login";

	    List<BookVO> bookList = bookService.getBookListByConsumerId(loginUser.getId());

	    if (!bookList.isEmpty()) {
	        BookVO latestBook = bookList.get(0);

	        ConcertVO concert = concertService.getConcertById(latestBook.getConcertId());
	        if (concert != null) {
	            // 포스터 경로 상대 경로로 설정
	            String relative = concertService.relativePath(concert.getPosterUrl(), "/posters/");
	            latestBook.setPosterUrl(relative);
	            latestBook.setTitle(concert.getTitle());
	        }

	        model.addAttribute("latestBook", latestBook);
	    }

	    model.addAttribute("loginUser", loginUser);
	    return "/myinfo";
	}	
	
	
	@RequestMapping("/myinfoDetail")
    public String myinfodetail() {
    	
    	return "/myinfoDetail";
    }

    @RequestMapping("/myinfoUpdate")
    public String myinfoUpdate(HttpSession session, Model model) {
        ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");

        if (loginUser == null) return "redirect:/login";

        model.addAttribute("consumer", loginUser);  
        
        return "/myinfoUpdate";
    }    
    
    @RequestMapping("/myinfoUpdateOK")
    public String myinfoUpdateOK(ConsumerVO vo, HttpSession session, RedirectAttributes re) {
        ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");

        if (loginUser == null) return "redirect:/login";

        vo.setUserId(loginUser.getUserId());

        loginService.updateInfo(vo, loginUser.getPw());

        ConsumerVO updated = loginService.findByUserId(vo.getUserId());
        session.setAttribute("loginUser", updated);

        re.addFlashAttribute("msg", "개인정보 수정이 완료되었습니다.");
        return "redirect:/myinfo";
    }    
    @RequestMapping("/mycard")
    public String myCard(Model model, HttpSession session) {
        ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");
        
        if (loginUser != null) {
            List<CardVO> cardList = cardService.getCardListById(loginUser.getId());
            model.addAttribute("cardList", cardList);
        }

        return "/mycard";
    }
    @RequestMapping("/deleteMyinfo")
    public String deleteAccount(HttpSession session) {
    	ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");
    	
    	if (loginUser != null) {
    		loginService.deleteConsumer(loginUser.getUserId()); // 회원 삭제 서비스 호출
    		session.invalidate(); // 세션 초기화
    	}
    	
    	return "redirect:/"; // 메인 페이지로 이동
    }
    
    
    @RequestMapping("/mycardInsert")
    public String insertCard(Model model, HttpSession session) {
    	
    	return "/mycardInsert";
    }
    
    @RequestMapping("/mycardInsertToBook")
    public String insertCardToBook(Model model, HttpSession session) {
    	
    	return "/mycardInsertToBook";
    }
    
    
    @RequestMapping("/mycardInsertOK")
    public String insertCard(HttpServletRequest request, HttpSession session, RedirectAttributes re) {
        ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");
        
        if (loginUser == null) return "redirect:/login";

        cardService.insertCard(request, loginUser.getId());

        re.addFlashAttribute("msg", "카드 등록이 완료되었습니다.");
        return "redirect:/mycard";
    }
    
    @RequestMapping("/mycardInsertOKToBook")
    @ResponseBody
    public String insertCardToBook(HttpServletRequest request, HttpSession session, RedirectAttributes re) {
    	ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");
    	
    	if (loginUser == null) return "redirect:/login";
    	
    	cardService.insertCard(request, loginUser.getId());
    	
    	return "<script>alert('카드가 등록되었습니다.');window.close();</script>";
    }
    
    @RequestMapping("/mycardDelete")
    public String deleteCard(int id, HttpSession session, RedirectAttributes re) {
        ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        cardService.deleteCard(id, loginUser.getId());
        re.addFlashAttribute("msg", "카드가 삭제되었습니다.");
        return "redirect:/mycard";
    }
    @RequestMapping("/myBook")
    public String myBook(HttpSession session, Model model) {
        ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");

        if (loginUser == null) return "redirect:/login";
        
        List<BookVO> bookList = bookService.getBookListByConsumerId(loginUser.getId());
        
        
        for (BookVO book : bookList) {
            if (book.getPosterUrl() == null) {
                ConcertVO concert = concertService.getConcertById(book.getConcertId());
                if (concert != null && concert.getPosterUrl() != null) {
                    String relative = concertService.relativePath(concert.getPosterUrl(), "/posters/");
                    book.setPosterUrl(relative);
                }
                if (concert.getTitle() != null) {
                    book.setTitle(concert.getTitle());
                }
            }
        }       
        model.addAttribute("bookList", bookList);

        return "/myBook"; 
    }
    
    @RequestMapping("/myBookDelete")
    public String deleteBook(HttpSession session, HttpServletRequest request, RedirectAttributes re) {


        int bookId = Integer.parseInt(request.getParameter("id"));

        bookService.deleteBookById(bookId); 

        re.addFlashAttribute("msg", "예매가 취소되었습니다.");

        return "redirect:/myBook";
        
    }
    
}

    

    





















