package com.bfuture.app.saas.service.impl;


import java.util.List;
import java.util.Map;

import com.bfuture.app.basic.dao.UniversalAppDao;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.report.BillHead;
import com.bfuture.app.saas.service.SettleManagerGdl;

public class SettleManagerGdlImpl extends BaseManagerImpl 
    implements SettleManagerGdl
{
	static {System.out.println("************************impllllllllllll");}
    public void setDao(UniversalAppDao dao)
    {
        this.dao = dao;
    }

    public SettleManagerGdlImpl()
    {
        if(dao == null)
            dao = (UniversalAppDao)getSpringBean("universalAppDao");
    }

    public ReturnObject ExecOther(String actionType, Object o[])
    {
        ReturnObject result = new ReturnObject();
        if("searchSettlehead".equals(actionType)){
        	result = searchSettlehead(o);
        }
        else if("serchSettledt".equals(actionType)){
        	result = serchSettledt(o);
        }else if("searchSettlekxdet".equals(actionType)){
        	result=searchSettlekxdet(o);
        }else if("uplookstatus".equals(actionType)){
        	result=uplookstatus(o);
        }
        
        return result;
    }

    public ReturnObject searchIns(String sgcode)
    {
        ReturnObject result = new ReturnObject();
        try
        {
            StringBuffer sql = new StringBuffer("SELECT OI_CN FROM ORG_INS WHERE 1=1 ");
            if(!StringUtil.isBlank(sgcode))
                sql.append(" AND OI_C='").append(sgcode).append("'");
            List lstResult = dao.executeSql(sql.toString());
            result.setRows(lstResult);
        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("YwBorderheadManagerImpl.searchIns() error:")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
            result.setReturnInfo(ex.getMessage());
        }
        return result;
    }

    public ReturnObject searchSettlehead(Object o[])
    
   
    {
    	
    	System.out.println("*******************************");

        ReturnObject result = new ReturnObject();

        try
        {
        	BillHead yb = (BillHead)o[0];
        	System.out.println("*******************************"+yb.getSucode());

            int limit = yb.getRows();
            int start = (yb.getPage() - 1) * yb.getRows();
            
       
            
        	StringBuffer sql =  new StringBuffer("select yb.JSHSGCODE,yb.sheet_no,sp.shpname,yb.saleway,yb.contract,yb.ymtime,yb.oper_name,to_char(yb.oper_date,'yyyy-mm-dd ') oper_date, yb.approve_name,to_char(yb.approve_date,'yyyy-mm-dd') approve_date,yb.notaxamt,  yb.taxamt,yb.amt,yb.initamt,yb.needamt,yb.settleamt,yb.balanceamt,yb.totdeduct_amt,yb.supcust_no,yb.sup_name,yb.memo,yb.approve_flag,  nvl(ls.look_status,'未查看' ) look_status ,to_char(yb.STARTTIME,'yyyy-mm-dd') STARTTIME, to_char(yb.ENDTIME,'yyyy-mm-dd') ENDTIME ");
        	sql.append(" from yw_gdl_jshd yb left join inf_shop sp on yb.shpno=sp.shpcode left join yw_lookstatus_3039 ls on yb.jshsgcode=ls.sgcode  and yb.sheet_no=ls.sheet_no  ");        

            StringBuffer countSql = new StringBuffer("select count(*) from yw_gdl_jshd  yb   left join inf_shop sp on yb.shpno=sp.shpcode left join yw_lookstatus_3039 ls on yb.jshsgcode=ls.sgcode  and yb.sheet_no=ls.sheet_no ");

            StringBuffer sumSql =  new StringBuffer("select cast('\u5408\u8BA1' as varchar2(32)) sheet_no, sum(notaxamt)notaxamt,sum(taxamt)taxamt,sum(amt )amt ,sum(initamt )initamt ,sum(needamt)needamt,sum( settleamt)settleamt ,sum(balanceamt) balanceamt,sum(totdeduct_amt)totdeduct_amt from yw_gdl_jshd  yb  left join inf_shop sp on yb.shpno=sp.shpcode left join yw_lookstatus_3039 ls on yb.jshsgcode=ls.sgcode  and yb.sheet_no=ls.sheet_no  ");
          
            
            /*查询条件*/   
            StringBuffer whereStr = new StringBuffer("").append(" where 1=1 and jshsgcode='").append(yb.getSgcode()).append("' ");
            if(!StringUtil.isBlank(yb.getBillno())){
            	whereStr.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
            }   
        	if(!StringUtil.isBlank(yb.getSucode())){
        		whereStr.append(" and yb.supcust_no = '").append(yb.getSucode()).append("'");
        	}
        	if(!StringUtil.isBlank(yb.getSdate()))
        		whereStr.append(" and to_char(yb.oper_date,'yyyy-mm-dd') >='").append(yb.getSdate()).append("'");
            if(!StringUtil.isBlank(yb.getEdate()))
            	whereStr.append(" and to_char(yb.oper_date,'yyyy-mm-dd') <= '").append(yb.getEdate()).append("'");
            if(!StringUtil.isBlank(yb.getBohmfid()))
            	whereStr.append(" and yb.shpno = '").append(yb.getBohmfid()).append("'");
            if(!StringUtil.isBlank(yb.getBillstatus()))
            	whereStr.append(" and yb.approve_flag = '").append(yb.getBillstatus()).append("'");
            if(!StringUtil.isBlank(yb.getLookstatus()))
            	whereStr.append(" and  nvl(ls.look_status,'未查看')= '").append(yb.getLookstatus()).append("'");
            
            List lstResult=null;
            /*总条数,合计查询*/
            countSql.append(whereStr);
            lstResult = dao.executeSql(countSql.toString());
            if(lstResult != null){
            	 result.setTotal(Integer.parseInt(((Map)lstResult.get(0)).get("COUNT(*)").toString()));
            } 
            sumSql.append(whereStr);
            lstResult = dao.executeSql(sumSql.toString());
            if(lstResult != null){
            	result.setFooter(lstResult);
            }
            
            /*分页查询*/
            if(yb.getOrder() != null && yb.getSort() != null){
            	whereStr.append(" order by "+yb.getSort()).append(" ").append(yb.getOrder());
            }else{
            	whereStr.append(" order by yb.oper_date ");
            }
            sql.append(whereStr);
            lstResult = dao.executeSql(sql.toString(), start,limit);
            log.info((new StringBuilder("lstResult 2 :")).append(lstResult).toString());
            log.info((new StringBuilder("lstResult.size() 2 :")).append(lstResult.size()).toString());
            if(lstResult != null)
            {
                result.setReturnCode("1");
                result.setRows(lstResult);
            }
        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("YwBorderheadManagerImpl.SearchYwBorderhead() error:")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
            result.setReturnInfo(ex.getMessage());
            ex.printStackTrace();
        }
        return result;
    }
    public ReturnObject serchSettledt(Object o[])
    
    
    {
    	
    	System.out.println("*******************************searchSettlehead");

        ReturnObject result = new ReturnObject();

        try
        {
        	BillHead yb = (BillHead)o[0];
            int limit = yb.getRows();
            int start = (yb.getPage() - 1) * yb.getRows();
            
            
        	System.out.println(yb.getSupcode()+"ssssssssssssssssssssssssssssssssssssss");
        	System.out.println(yb.getSdate()+yb.getEdate()+yb.getBillno()+yb.getLookstatus()+yb.getBillstatus()+yb.getBohmfid());
        	System.out.println(yb.getRows()+yb.getPage()+yb.getOrder()+yb.getSort());
            
        	StringBuffer sql =  new StringBuffer("select yb.sheet_no,yb.voucher_no,yb.item_subno,yb.item_name,yb.st_qty qty,yb.st_price price,yb.st_amt amt,yb.notax_amt,yb.tax_amt,yb.tax_rate from  YW_GDL_JSDT yb  ");

            StringBuffer countSql = new StringBuffer("select count(*) from YW_GDL_JSDT yb   ");

            StringBuffer sumSql =  new StringBuffer("select cast('\u5408\u8BA1' as varchar2(32)) sheet_no, sum(yb.st_qty)qty  ,sum(yb.st_amt)amt,sum(yb.notax_amt)notax_amt,sum(yb.tax_amt)tax_amt  from  YW_GDL_JSDT yb ");
          
            //更改状态
            String sgcode_dd=yb.getSgcode();
            String sheet_no_dd=StringUtil.isBlank(yb.getBillno())?"":yb.getBillno();
            String look_status_dd="已查看";
            StringBuffer dlSql=new StringBuffer("delete   from  YW_LOOKSTATUS_3039 yb  ");
            StringBuffer udSql=new StringBuffer("insert into  YW_LOOKSTATUS_3039 (sgcode,sheet_no,look_status) values( '"+sgcode_dd+"' ,'"+sheet_no_dd+"' ,'"+look_status_dd+"'  ) ");
          //更改状态--查询条件
            StringBuffer whereStr2=new StringBuffer("").append(" where 1=1 and yb.sgcode='").append(yb.getSgcode()).append("' ");
            
          
            
            /*查询条件*/   
            StringBuffer whereStr = new StringBuffer("").append(" where 1=1 and jsdtsgcode='").append(yb.getSgcode()).append("' ");
            if(!StringUtil.isBlank(yb.getBillno())){
            	whereStr.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
            	whereStr2.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
            } 
//            if(!StringUtil.isBlank(yb.getSupcode())){
//            	whereStr.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
//            	whereStr2.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
//            }
            //

            List lstResult=null;
            /*总条数,合计查询*/
            countSql.append(whereStr);
            lstResult = dao.executeSql(countSql.toString());
            if(lstResult != null){
            	 result.setTotal(Integer.parseInt(((Map)lstResult.get(0)).get("COUNT(*)").toString()));
            } 
            sumSql.append(whereStr);
            lstResult = dao.executeSql(sumSql.toString());
            if(lstResult != null){
            	result.setFooter(lstResult);
            }
            
            /*分页查询*/
            if(yb.getOrder() != null && yb.getSort() != null){
            	whereStr.append(" order by "+yb.getSort()).append(" ").append(yb.getOrder());
            }else{
            	whereStr.append(" order by yb.voucher_no ");
            }
            sql.append(whereStr);
            lstResult = dao.executeSql(sql.toString(), start,limit);
            log.info((new StringBuilder("lstResult 2 :")).append(lstResult).toString());
            log.info((new StringBuilder("lstResult.size() 2 :")).append(lstResult.size()).toString());
            
            //执行查看状态___供应商执行
            dlSql.append(whereStr2);
            log.info("sutype=========================="+yb.getSutype());
            if(!StringUtil.isBlank(yb.getSutype())&&yb.getSutype().equalsIgnoreCase("S")){
            	log.info("sutype=========================="+yb.getSutype());
            	 log.info("sutype=====更改为已查看====================="+yb.getLookstatus());
                if("未查看".equals(yb.getLookstatus())){
                    log.info("sutype=====更改为已查看=====================");
                	dao.updateSql_3039(dlSql.toString());
                    dao.updateSql_3039(udSql.toString());
                }

            }

            
            if(lstResult != null)
            {
                result.setReturnCode("1");
                result.setRows(lstResult);
            }

        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("YwBorderheadManagerImpl.SearchYwBorderhead() error:")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
            result.setReturnInfo(ex.getMessage());
            ex.printStackTrace();
        }
        return result;
    }
    public ReturnObject searchSettlekxdet(Object o[])
    
    
    {
    	
    	System.out.println("*******************************searchSettlehead");

        ReturnObject result = new ReturnObject();

        try
        {
        	BillHead yb = (BillHead)o[0];
//            int limit = yb.getRows();
//            int start = (yb.getPage() - 1) * yb.getRows();
//            


        	StringBuffer sql =  new StringBuffer(" select yb.jsddgcode ,yb.sheet_no ,yb.charge_name,yb.fee_amt,yb.memo from yw_gdl_jsdeduct yb  ");


            
            /*查询条件*/   
            StringBuffer whereStr = new StringBuffer("").append(" where 1=1 and yb.jsddgcode='").append(yb.getSgcode()).append("' ");
            if(!StringUtil.isBlank(yb.getBillno())){
            	whereStr.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
            }   


            List lstResult=null;


            
            /*分页查询*/
//            if(yb.getOrder() != null && yb.getSort() != null){
//            	whereStr.append(" order by "+yb.getSort()).append(" ").append(yb.getOrder());
//            }else{
//            	
//            }
            sql.append(whereStr);
       //     lstResult = dao.executeSql(sql.toString(), start,limit);
            lstResult = dao.executeSql(sql.toString());
            log.info((new StringBuilder("lstResult 2 :")).append(lstResult).toString());
            log.info((new StringBuilder("lstResult.size() 2 :")).append(lstResult.size()).toString());
            if(lstResult != null)
            {
                result.setReturnCode("1");
                result.setRows(lstResult);
            }
        }
        catch(Exception ex)
        {
            log.error((new StringBuilder("YwBorderheadManagerImpl.SearchYwBorderhead() error:")).append(ex.getMessage()).toString());
            result.setReturnCode("0");
            result.setReturnInfo(ex.getMessage());
            ex.printStackTrace();
        }
        return result;
    }

public ReturnObject   uplookstatus(Object o[])


{
	
	System.out.println("*******************************searchSettlehead");

    ReturnObject result = new ReturnObject();

    try
    {
    	BillHead yb = (BillHead)o[0];
    	
  
        
        //更改状态
        StringBuffer udSql=new StringBuffer("update YW_LOOKSTATUS_3039 yb set yb.look_status= '"+yb.getLookstatus()+"' ");
      //更改状态--查询条件
        StringBuffer whereStr2=new StringBuffer("").append(" where 1=1 and yb.sgcode='").append(yb.getSgcode()).append("' ");
        
      
        
        /*查询条件*/   
        if(!StringUtil.isBlank(yb.getBillno())){
        	whereStr2.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
        } 
//        if(!StringUtil.isBlank(yb.getSupcode())){
//        	whereStr.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
//        	whereStr2.append(" and yb.sheet_no = '").append(yb.getBillno()).append("'");
//        }
        //

        log.info("uplookstatus_sql:"+udSql);
        
        //执行状态
        udSql.append(whereStr2);
        int i=dao.updateSql_3039(udSql.toString());
        log.info("lookstatus"+yb.getLookstatus());
        if(i>=1){
        	result.setReturnCode("1");
        }else{
        	result.setReturnCode("0");
        }
            

    }
    catch(Exception ex)
    {
        log.error((new StringBuilder("YwBorderheadManagerImpl.uplookstatus() error:")).append(ex.getMessage()).toString());
        result.setReturnCode("0");
        result.setReturnInfo(ex.getMessage());
        ex.printStackTrace();
    }
    return result;
}
}