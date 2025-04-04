package com.mbcit.vivere.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mbcit.vivere.dao.NoticeDAO;
import com.mbcit.vivere.vo.NoticeVO;

@Service
public class NoticeService {
	@Autowired
	private NoticeDAO noticeDAO;
	
	public List<NoticeVO> selectNoticeList(NoticeVO noticeVO) {
		return noticeDAO.selectNoticeList(noticeVO);
	}
	 public void insert(NoticeVO noticeVO) {
		 noticeDAO.insert(noticeVO);
	}

}
