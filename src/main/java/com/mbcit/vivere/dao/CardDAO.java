package com.mbcit.vivere.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;

import com.mbcit.vivere.vo.CardVO;

@Mapper
public interface CardDAO {
	

	List<CardVO> getCardListByConsumerId(int consumerId);

	void insertCard(CardVO cardVO);

	CardVO getCardByConsumerId(int consumerId);

	void deleteCard(int id);

	CardVO getCardById(int cardId);
	
	
}
//push를 위한 주석