package com.mbcit.vivere.vo;

import java.util.Date;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Data
@Slf4j
public class ConcertTimeVO {

	private int id;
	private int concertId;
	private Date concertTime;
}
