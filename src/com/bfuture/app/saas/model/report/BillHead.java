package com.bfuture.app.saas.model.report;

import com.bfuture.app.basic.model.BaseObject;
import java.io.Serializable;

public class BillHead extends BaseObject
	//3039>>>>>>>>
    implements Serializable
{

    public String getFlag()
    {
        return flag;
    }

    public void setFlag(String flag)
    {
        this.flag = flag;
    }

    public String getBillno()
    {
        return billno;
    }

    public void setBillno(String billno)
    {
        this.billno = billno;
    }

    public String getSgcode()
    {
        return sgcode;
    }

    public void setSgcode(String sgcode)
    {
        this.sgcode = sgcode;
    }

    public String getShmfid()
    {
        return shmfid;
    }

    public void setShmfid(String shmfid)
    {
        this.shmfid = shmfid;
    }

    public String getVendrno()
    {
        return vendrno;
    }

    public void setVendrno(String vendrno)
    {
        this.vendrno = vendrno;
    }

    public String getSucode()
    {
        return sucode;
    }

    public void setSucode(String sucode)
    {
        this.sucode = sucode;
    }

    public static long getSerialVersionUID()
    {
        return 0x7abe8f6fa148f965L;
    }

    public BillHead()
    {
    }

    public boolean equals(Object o)
    {
        return equals((BillHead)o);
    }

    public int hashCode()
    {
        return hashCode();
    }

    public String toString()
    {
        return null;
    }

    public String getSdate()
    {
        return sdate;
    }

    public void setSdate(String sdate)
    {
        this.sdate = sdate;
    }

    public String getEdate()
    {
        return edate;
    }

    public void setEdate(String edate)
    {
        this.edate = edate;
    }

    public String getBalanceMode()
    {
        return balanceMode;
    }

    public void setBalanceMode(String balanceMode)
    {
        this.balanceMode = balanceMode;
    }
    
	public String getDjlx() {
		return djlx;
	}

	public void setDjlx(String djlx) {
		this.djlx = djlx;
	}
	
	public String getStatusname() {
		return statusname;
	}

	public void setStatusname(String statusname) {
		this.statusname = statusname;
	}	

	
	
    public String getLookstatus() {
		return lookstatus;
	}

	public void setLookstatus(String lookstatus) {
		this.lookstatus = lookstatus;
	}

	public String getSupcode() {
		return supcode;
	}

	public void setSupcode(String supcode) {
		this.supcode = supcode;
	}

	public String getBohmfid() {
		return bohmfid;
	}

	public void setBohmfid(String bohmfid) {
		this.bohmfid = bohmfid;
	}

	public String getBillstatus() {
		return billstatus;
	}

	public void setBillstatus(String billstatus) {
		this.billstatus = billstatus;
	}



	public String getSheetTitle() {
		return sheetTitle;
	}

	public void setSheetTitle(String sheetTitle) {
		this.sheetTitle = sheetTitle;
	}
	


	public String getSutype() {
		return sutype;
	}

	public void setSutype(String sutype) {
		this.sutype = sutype;
	}



	private static final long serialVersionUID = 0x7abe8f6fa148f965L;
    private String billno;
    private String sgcode;
    private String shmfid;
    private String vendrno;
    private String sucode;
    private String sdate;
    private String edate;
    private String flag;
    private String balanceMode;
    private String djlx;
    private String statusname;
    
    
    private String lookstatus;
    private String supcode;
    private String bohmfid;
    private String billstatus;
    private String sheetTitle;
    private String sutype;
    
}



