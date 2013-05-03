package com.bfuture.app.saas.model;

import java.io.Serializable;

import com.bfuture.app.basic.model.BaseObject;

public class HscBean extends BaseObject implements Serializable{
	
	//辅助参数
	private String sgcode;
	private String billno;
	private String startDate;
	private String endDate;
	private String supcode;
	private String djType;
	
	public String getSgcode() {
		return sgcode;
	}
	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}
	public String getBillno() {
		return billno;
	}
	public void setBillno(String billno) {
		this.billno = billno;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getSupcode() {
		return supcode;
	}
	public void setSupcode(String supcode) {
		this.supcode = supcode;
	}
	public String getDjType() {
		return djType;
	}
	public void setDjType(String djType) {
		this.djType = djType;
	}
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public boolean equals(Object o) {
		// TODO Auto-generated method stub
		return false;
	}
	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return 0;
	}
	
	

}
