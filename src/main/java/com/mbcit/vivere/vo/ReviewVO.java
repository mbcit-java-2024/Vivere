package com.mbcit.vivere.vo;

import java.util.Date;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Data
@Slf4j
public class ReviewVO {

    private int id;
    private int consumerId;
    private int concertId;
    private String userId;
    private float rate;
    private String content;
    private Date createDate;
    private Date updateDate;
}
