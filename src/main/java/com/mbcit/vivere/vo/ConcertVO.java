package com.mbcit.vivere.vo;

import java.util.Date;

import lombok.Data;

@Data
public class ConcertVO {

    private int id;
    private String title;
    private int hallType;
    private String description;
    private int categoryId;
    private int totalSeat;
    private int status;
    private String posterUrl;
    private int equalPrice;
    private int priceVIP;
    private int priceR;
    private int priceS;
    private int priceA;
    private int countVIP;
    private int countR;
    private int countS;
    private int countA;
    private Date createDate;
    private Date updateDate;
    private Date startDate;
    private Date endDate;

}
