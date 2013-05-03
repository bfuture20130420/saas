package com.bfuture.app.saas.service.impl;

import java.util.List;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.HscBean;
import com.bfuture.app.saas.model.report.RKDocQuery;
import com.bfuture.app.saas.service.SaleSummary;

public class HscManagerImpl  extends BaseManagerImpl implements SaleSummary {
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		
		if("getHSCJXJSDHead".equals(actionType)){
			result = this.getHSCJXJSDHead(result,o);
			return result;
		}
		
		return result;
	}
	
	public ReturnObject getHSCJXJSDHead(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		StringBuffer countSql = new StringBuffer("select count(h.billno) from yw_hsc_jsdhead h ");
		StringBuffer sumSql = new StringBuffer("select cast('合计' as varchar2(10)) BILLNO,sum(h.hyftotal)hyftotal,sum(h.wyftotal)wyftotal,sum(h.jtaxtotal)bdtotal,sum(h.tctotal)bdtotal,sum(h.bdtotal)bdtotal,sum(h.bctotal)bctotal,sum(h.zktotal)zktotal,sum(h.zkasntotal)zkasntotal,sum(h.fytotal)fytotal,sum(h.yftotal)yftotal,sum(h.tztotal)tztotal,sum(h.sftotal)sftotal,sum(h.kptotal)kptotal,sum(h.fktotal)fktotal,sum(h.istemp)istemp from yw_hsc_jsdhead h ");
		StringBuffer rowsSql = new StringBuffer("select * from yw_hsc_jsdhead h ");
		
		StringBuffer whereSql = new StringBuffer(" where 1=1 ");
		if (!StringUtil.isBlank(hscBean.getSgcode())) {
			whereSql.append(" and h.sgcode = '"+hscBean.getSgcode()+"' ");
		}
		if (!StringUtil.isBlank(hscBean.getBillno())) {
			whereSql.append(" and h.billno = '"+hscBean.getBillno()+"' ");
		}
		if (!StringUtil.isBlank(hscBean.getStartDate())) {
			whereSql.append(" and to_char(h.lrdate,'yyyy-mm-dd') >= '"+hscBean.getStartDate()+"' ");
		}
		if (!StringUtil.isBlank(hscBean.getEndDate())) {
			whereSql.append(" and to_char(h.lrdate,'yyyy-mm-dd') <= '"+hscBean.getEndDate()+"' ");
		}
		if (!StringUtil.isBlank(hscBean.getSupcode())) {
			whereSql.append(" and h.supcode = '"+hscBean.getSupcode()+"' ");
		}
		if (!StringUtil.isBlank(hscBean.getDjType())) {
			whereSql.append(" and h.jscode = '"+hscBean.getDjType()+"' ");
		}
		try {
			//统计
			List countlist = dao.executeSqlCount(countSql.append(whereSql).toString());
			int countNum = Integer.parseInt(countlist.get(0).toString());
			if(countNum > 0){
				List sumList = dao.executeSql(sumSql.append(whereSql).toString());
				rowsSql.append(whereSql);
				if( hscBean.getOrder() != null && hscBean.getSort() != null ){
					rowsSql.append("order by " + hscBean.getSort()+" "+ hscBean.getOrder());
				}else{
					rowsSql.append(" order by h.BILLNO desc ");
				}
				List RowsList = dao.executeSql(rowsSql.toString(), start, limit);
				result.setTotal(countNum);
				result.setRows(RowsList);
				result.setFooter(sumList);
				result.setReturnCode(Constants.SUCCESS_FLAG);
			}
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
}
