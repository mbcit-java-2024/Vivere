package com.mbcit.vivere.vo;

import java.util.Date;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Data
@Slf4j
public class NoticeVO {

    private int id;
    private String title;
    private String content;
    private int status;
    private Date createDate; 
    private Date updateDate;
}
