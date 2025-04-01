package com.mbcit.vivere.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.QnarepVO;

@Mapper
public interface QnarepDAO {

	int insert(Map<String, Object> param);

	int updateRep(Map<String, Object> param);

	void deleteRep(QnarepVO qnarepVO);

}
