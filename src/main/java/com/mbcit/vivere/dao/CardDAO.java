package com.mbcit.vivere.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.CardVO;

@Mapper
public interface CardDAO {

	List<CardVO> getCardListByConsumerId(int consumerId);

}
