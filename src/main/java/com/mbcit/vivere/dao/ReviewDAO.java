package com.mbcit.vivere.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.ReviewVO;

@Mapper
public interface ReviewDAO {

	int insert(Map<String, Object> param);

	int update(Map<String, Object> param);

	void delete(ReviewVO reviewVO);


}
