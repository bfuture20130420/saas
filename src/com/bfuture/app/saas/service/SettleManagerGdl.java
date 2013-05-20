package com.bfuture.app.saas.service;

import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;

public interface SettleManagerGdl extends BaseManager{
	 public void setDao(UniversalAppDao dao);


	    public ReturnObject ExecOther(String actionType, Object o[]);
	  
	    public ReturnObject searchIns(String sgcode);
	  
	    public ReturnObject searchSettlehead(Object o[]);


}
