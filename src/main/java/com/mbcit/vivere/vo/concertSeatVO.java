package com.mbcit.vivere.vo;

import lombok.Data;

@Data
public class concertSeatVO {
	
	private int id;
	private int concertId;
	private int concertTimeId;
	private char lineNum;
	private int seatNum;
	private String grade;
	private boolean bookYN;

}
