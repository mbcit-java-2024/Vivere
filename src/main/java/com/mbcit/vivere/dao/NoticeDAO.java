package com.mbcit.vivere.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.mbcit.vivere.vo.NoticeVO;

@Mapper
public interface NoticeDAO {

	List<NoticeVO> selectNoticeList(NoticeVO noticeVO);

	void insert(NoticeVO noticeVO);

	NoticeVO selectNoticeDetail(int id);

	void updateNotice(NoticeVO noticeVO);

	void noticeDelete(int id);

}
