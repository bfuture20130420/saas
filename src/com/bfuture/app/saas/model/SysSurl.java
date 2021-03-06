package com.bfuture.app.saas.model;

// Generated 2011-3-8 10:36:54 by Hibernate Tools 3.2.2.GA

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.bfuture.app.basic.model.BaseObject;

/**
 * SysSurl generated by hbm2java
 */
@Entity
@Table(name = "SYS_SURL")
public class SysSurl extends BaseObject implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6168809643035856876L;
	private SysSurlId id;
	private String rlcode;
	private String sucode;
	private String rlname;
	private String rltype;
	private String sgcode;

	public SysSurl() {
	}

	public SysSurl(SysSurlId id) {
		this.id = id;
	}

	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "rlcode", column = @Column(name = "RLCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "sucode", column = @Column(name = "SUCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "sgcode", column = @Column(name = "SGCODE", nullable = false, length = 30))})
	public SysSurlId getId() {
		return this.id;
	}

	public void setId(SysSurlId id) {
		this.id = id;
	}

	@Override
	public boolean equals(Object o) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return id != null ? id.hashCode() : 0;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return id != null ? id.toString() : null;
	}

	@Transient
	public String getRlcode() {
		return rlcode;
	}

	public void setRlcode(String rlcode) {
		if( id == null ) id = new SysSurlId();
		id.setRlcode( rlcode );
		this.rlcode = rlcode;
	}

	@Transient
	public String getSucode() {
		return sucode;
	}

	public void setSucode(String sucode) {
		if( id == null ) id = new SysSurlId();
		id.setSucode( sucode );
		this.sucode = sucode;
	}

	@Transient
	public String getRlname() {
		return rlname;
	}

	public void setRlname(String rlname) {
		this.rlname = rlname;
	}

	@Transient
	public String getRltype() {
		return rltype;
	}

	public void setRltype(String rltype) {
		this.rltype = rltype;
	}

	@Transient
	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		if( id == null ) id = new SysSurlId();
		id.setSgcode( sgcode );
		this.sgcode = sgcode;
	}
	
}
