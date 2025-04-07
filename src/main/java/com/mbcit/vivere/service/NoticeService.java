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
	
	public List<NoticeVO> selectNoticeList() {
		return noticeDAO.selectNoticeList();
	}
	 public void insert(NoticeVO noticeVO) {
		 noticeDAO.insert(noticeVO);
	}
	public NoticeVO selectNoticeDetail(int id) {
		return noticeDAO.selectNoticeDetail(id);
	}
	public void updateNotice(NoticeVO noticeVO) {
		noticeDAO.updateNotice(noticeVO);
	}
	public void noticeDelete(int id) {
		noticeDAO.noticeDelete(id);
	}

}
