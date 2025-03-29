package com.mbcit.vivere.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.QnarepVO;

@Mapper
public interface QnarepDAO {

	int insert(Map<String, Object> param);

}
