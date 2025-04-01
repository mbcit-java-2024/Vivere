package com.mbcit.vivere.vo;

import java.util.Date;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Data
@Slf4j
public class BookVO {

	private int id;
    private int consumerId;
    private int concertId;
    private int CardId;
    private String bookNum;
    private String seatNum;
    private int price;
    private int seatCnt;
    private String grade;
    private Date orderDate;
    private Date concertTime;
    private short payType;
    
    private String title;
    private int hallType;
    private String posterUrl;
    private int categoryId;
    
    private Integer review_id;
    private String content;
    private float rate;
    private Date createDate;
    private Date updateDate;
}
