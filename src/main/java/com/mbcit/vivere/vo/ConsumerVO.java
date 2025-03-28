package com.mbcit.vivere.vo;

import java.util.Date;

import com.mbcit.vivere.eNum.Gender;
import com.mbcit.vivere.eNum.Grade;
import com.mbcit.vivere.eNum.Receive;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Data
@Slf4j
public class ConsumerVO {

    private int id;
    private String userId;
    private String pw;
    private String name;
    private String birth;
    private Gender gender;
    private String phone;
    private String email;
    private Receive receive;
    private String address;
    private String detailAddress;
    private Grade grade; 
    private Date createDate; 
    private Date updateDate;
	
}
