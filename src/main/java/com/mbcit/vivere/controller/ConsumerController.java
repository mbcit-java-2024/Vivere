package com.mbcit.vivere.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.mbcit.vivere.service.CardService;
import com.mbcit.vivere.service.LoginService;
import com.mbcit.vivere.vo.CardVO;
import com.mbcit.vivere.vo.ConsumerVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ConsumerController {
	
	@Autowired
	private LoginService loginService;
	@Autowired
	private CardService cardService;
	
    @RequestMapping("/myinfo")
    public String myinfo() {
    	
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
    
    
    @RequestMapping("/mycardInsertOK")
    public String insertCard(HttpServletRequest request, HttpSession session, RedirectAttributes re) {
        ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");
        
        if (loginUser == null) return "redirect:/login";

        cardService.insertCard(request, loginUser.getId()); // 모든 로직은 Service로!

        re.addFlashAttribute("msg", "카드 등록이 완료되었습니다.");
        return "redirect:/mycard";
    }
    
    @RequestMapping("/mycardDelete")
    public String deleteCard(int id, HttpSession session, RedirectAttributes re) {
        ConsumerVO loginUser = (ConsumerVO) session.getAttribute("loginUser");
        if (loginUser == null) return "redirect:/login";

        cardService.deleteCard(id, loginUser.getId());
        re.addFlashAttribute("msg", "카드가 삭제되었습니다.");
        return "redirect:/mycard";
    }


}
    
//push를 위한 주석
    





















