package com.bfuture.app.saas.model;

// Generated 2011-12-7 14:38:38 by Hibernate Tools 3.2.2.GA

import java.io.Serializable;
import java.util.Date;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * YwBinstrhead generated by hbm2java
 * 入库单头
 */
@Entity
@Table(name = "YW_BINSTRHEAD")
public class YwBinstrhead implements java.io.Serializable {

	private YwBinstrheadId id;
	private String bihsupid;
	private String bihorderno;
	private Date bihjhrq;
	private Serializable bihshtime;
	private String bihmemo;
	private String temp1;
	private String temp2;
	private String temp3;
	private String temp4;
	private String temp5;
	private Serializable bihtime;
	private String bihfile;

	public YwBinstrhead() {
	}

	public YwBinstrhead(YwBinstrheadId id) {
		this.id = id;
	}

	public YwBinstrhead(YwBinstrheadId id, String bihsupid, String bihorderno,
			Date bihjhrq, Serializable bihshtime, String bihmemo, String temp1,
			String temp2, String temp3, String temp4, String temp5,
			Serializable bihtime, String bihfile) {
		this.id = id;
		this.bihsupid = bihsupid;
		this.bihorderno = bihorderno;
		this.bihjhrq = bihjhrq;
		this.bihshtime = bihshtime;
		this.bihmemo = bihmemo;
		this.temp1 = temp1;
		this.temp2 = temp2;
		this.temp3 = temp3;
		this.temp4 = temp4;
		this.temp5 = temp5;
		this.bihtime = bihtime;
		this.bihfile = bihfile;
	}

	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "bihsgcode", column = @Column(name = "BIHSGCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "bihbillno", column = @Column(name = "BIHBILLNO", nullable = false, length = 32)),
			@AttributeOverride(name = "bihshmfid", column = @Column(name = "BIHSHMFID", nullable = false, length = 30)) })
	public YwBinstrheadId getId() {
		return this.id;
	}

	public void setId(YwBinstrheadId id) {
		this.id = id;
	}

	@Column(name = "BIHSUPID", length = 24)
	public String getBihsupid() {
		return this.bihsupid;
	}

	public void setBihsupid(String bihsupid) {
		this.bihsupid = bihsupid;
	}

	@Column(name = "BIHORDERNO", length = 32)
	public String getBihorderno() {
		return this.bihorderno;
	}

	public void setBihorderno(String bihorderno) {
		this.bihorderno = bihorderno;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "BIHJHRQ", length = 7)
	public Date getBihjhrq() {
		return this.bihjhrq;
	}

	public void setBihjhrq(Date bihjhrq) {
		this.bihjhrq = bihjhrq;
	}

	@Column(name = "BIHSHTIME")
	public Serializable getBihshtime() {
		return this.bihshtime;
	}

	public void setBihshtime(Serializable bihshtime) {
		this.bihshtime = bihshtime;
	}

	@Column(name = "BIHMEMO", length = 300)
	public String getBihmemo() {
		return this.bihmemo;
	}

	public void setBihmemo(String bihmemo) {
		this.bihmemo = bihmemo;
	}

	@Column(name = "TEMP1", length = 30)
	public String getTemp1() {
		return this.temp1;
	}

	public void setTemp1(String temp1) {
		this.temp1 = temp1;
	}

	@Column(name = "TEMP2", length = 30)
	public String getTemp2() {
		return this.temp2;
	}

	public void setTemp2(String temp2) {
		this.temp2 = temp2;
	}

	@Column(name = "TEMP3", length = 30)
	public String getTemp3() {
		return this.temp3;
	}

	public void setTemp3(String temp3) {
		this.temp3 = temp3;
	}

	@Column(name = "TEMP4", length = 30)
	public String getTemp4() {
		return this.temp4;
	}

	public void setTemp4(String temp4) {
		this.temp4 = temp4;
	}

	@Column(name = "TEMP5", length = 30)
	public String getTemp5() {
		return this.temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
	}

	@Column(name = "BIHTIME")
	public Serializable getBihtime() {
		return this.bihtime;
	}

	public void setBihtime(Serializable bihtime) {
		this.bihtime = bihtime;
	}

	@Column(name = "BIHFILE", length = 64)
	public String getBihfile() {
		return this.bihfile;
	}

	public void setBihfile(String bihfile) {
		this.bihfile = bihfile;
	}

}
