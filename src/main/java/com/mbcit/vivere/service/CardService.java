package com.mbcit.vivere.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.CardDAO;
import com.mbcit.vivere.vo.CardVO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class CardService {

	@Autowired
	private CardDAO cardDAO;

	public List<CardVO> getCardListById(int consumerId) {
		List<CardVO> cardList = cardDAO.getCardListByConsumerId(consumerId);
		return cardList;
	}

	public void insertCard(CardVO cardVO) {
		cardDAO.insertCard(cardVO);
		
	}

	public CardVO getCardByConsumerId(int consumerId) {
		return cardDAO.getCardByConsumerId(consumerId);
	}

	public void insertCard(HttpServletRequest request, int consumerId) {
	    CardVO card = new CardVO();

	    card.setConsumerId(consumerId);
	    card.setPw(request.getParameter("pw"));

	    String cardNum = request.getParameter("card1") + "-" +
	                     request.getParameter("card2") + "-" +
	                     request.getParameter("card3") + "-" +
	                     request.getParameter("card4");

	    card.setCardNum(cardNum); 
	    card.setCvc(Integer.parseInt(request.getParameter("cvc")));
	    card.setBankName(request.getParameter("bankName"));

	    try {
	        String validDateStr = request.getParameter("validDate");
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        Date validDate = sdf.parse(validDateStr);
	        card.setValidDate(validDate);

	        card.setCreateDate(new Date());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    System.out.println("등록된 카드번호: " + card.getCardNum()); // ✅ 확인용 출력
	    cardDAO.insertCard(card);
	}
	
	public void deleteCard(int cardId, int consumerId) {
	    CardVO card = cardDAO.getCardById(cardId);
	    if (card != null && card.getConsumerId() == consumerId) {
	        cardDAO.deleteCard(cardId);
	    }
	}
}
// push를 위한 주석
