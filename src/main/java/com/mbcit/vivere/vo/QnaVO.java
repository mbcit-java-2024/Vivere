package com.mbcit.vivere.vo;

import java.util.Date;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Data
@Slf4j
public class QnaVO {

    private int id;
    private int consumerId;
    private String title;
    private String content;
    private Date createDate; 
    private Date updateDate;
    
    private String qna_title;
    private String qna_content;
    private Date qna_createDate; 
    private Date qna_updateDate;
}
