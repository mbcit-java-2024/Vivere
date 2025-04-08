package com.mbcit.vivere.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.QnaVO;

@Mapper
public interface QnaDAO {

	List<QnaVO> qnaList(QnaVO qnaVO);

	void insert(QnaVO qnaVO);

	int update(Map<String, Object> param);

	QnaVO selectQnacontent(QnaVO qnaVO);

	void delete(QnaVO qnaVO);

	QnaVO getLatestQnaByConsumerId(int consumerId);

	boolean hasReply(int id);
	
	

}
