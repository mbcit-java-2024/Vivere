package com.mbcit.vivere.service;

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
	    String cardNum = String.join("-",
	        request.getParameter("card1"),
	        request.getParameter("card2"),
	        request.getParameter("card3"),
	        request.getParameter("card4")
	    );

	    CardVO card = new CardVO();
	    card.setConsumerId(consumerId);
	    card.setCardNum(cardNum);
	    card.setPw(request.getParameter("pw"));
	    card.setCvc(Integer.parseInt(request.getParameter("cvc")));
	    card.setValidDate(request.getParameter("validDate"));
	    card.setBankName(request.getParameter("bankName"));

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
