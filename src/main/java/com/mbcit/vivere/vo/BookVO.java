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
    private int paymentId;
    private String bookNum;
    private int price;
    private int seatCnt;
    private String grade;
    private Date orderDate;
}
