package com.mbcit.vivere.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.mbcit.vivere.vo.ConsumerVO;

@Mapper
public interface ConsumerDAO {

	void insertConsumer(ConsumerVO vo);
	int countByUserId(String userId);
	ConsumerVO findByUserId(String userId);
	ConsumerVO findIdByNameAndEmail(@Param("name") String name, @Param("email") String email);
	ConsumerVO findPwByIdAndEmail(@Param("userId") String userId,@Param("email") String email);
	void updateConsumer(ConsumerVO vo);
	void deleteConsumerByUserId(String userId);
}
