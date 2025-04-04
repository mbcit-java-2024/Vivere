package com.mbcit.vivere.vo;

import java.util.Date;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Data
public class CardVO {

    private int id;
    private int consumerId;
    private String bankName;
    private String pw;
    private String cardNum;
    private int cvc;
    private String validDate;
    private Date createDate;
}
