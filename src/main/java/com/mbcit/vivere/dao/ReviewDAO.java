package com.mbcit.vivere.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ReviewDAO {

	int insert(Map<String, Object> param);


}
