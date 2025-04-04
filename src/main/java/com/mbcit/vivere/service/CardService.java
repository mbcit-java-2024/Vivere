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
	public void updateCard(CardVO cardVO) {
		cardDAO.updateCard(cardVO);
		
	}

	public void insertCard(HttpServletRequest request, int consumerId) {
	    String card1 = request.getParameter("card1");
	    String card2 = request.getParameter("card2");
	    String card3 = request.getParameter("card3");
	    String card4 = request.getParameter("card4");

	    String pw = request.getParameter("pw");
	    String cvcStr = request.getParameter("cvc");
	    String validDate = request.getParameter("validDate");

	    String fullCardNum = card1 + "-" + card2 + "-" + card3 + "-" + card4;

	    CardVO card = new CardVO();
	    card.setConsumerId(consumerId);
	    card.setCardNum(fullCardNum);
	    card.setPw(pw);
	    card.setCvc(Integer.parseInt(cvcStr));
	    card.setValidDate(validDate);
	    card.setBankName(request.getParameter("bankName"));

	    cardDAO.insertCard(card);
	}

	public void updateCard(HttpServletRequest request, int consumerId) {
	    String card1 = request.getParameter("card1");
	    String card2 = request.getParameter("card2");
	    String card3 = request.getParameter("card3");
	    String card4 = request.getParameter("card4");
	    String fullCardNum = card1 + "-" + card2 + "-" + card3 + "-" + card4;

	    CardVO cardVO = new CardVO();
	    cardVO.setId(Integer.parseInt(request.getParameter("id")));
	    cardVO.setConsumerId(consumerId);
	    cardVO.setCardNum(fullCardNum);
	    cardVO.setPw(request.getParameter("pw"));
	    cardVO.setCvc(Integer.parseInt(request.getParameter("cvc")));
	    cardVO.setValidDate(request.getParameter("validDate"));
	    cardVO.setBankName(request.getParameter("bankName"));

	    cardDAO.updateCard(cardVO);
	}	
}
