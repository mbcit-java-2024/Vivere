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
    private int price;
    private int totalSeat;
    private int status;
    private String posterUrl;
    private int vipPrice;
    private int rPrice;
    private int sPrice;
    private int aPrice;
    private int vipCount;
    private int rCount;
    private int sCount;
    private int aCount;
    private Date createDate;
    private Date updateDate;

}
