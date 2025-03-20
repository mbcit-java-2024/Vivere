package com.mbcit.vivere.vo;

import java.util.Date;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Data
@Slf4j
public class QnarepVO {

    private int id;
    private int qnaId;
    private String title;
    private String content;
    private Date createDate; 
    private Date updateDate;
}
