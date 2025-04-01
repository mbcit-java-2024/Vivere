package com.mbcit.vivere.service;

import java.util.List;

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
	
}
