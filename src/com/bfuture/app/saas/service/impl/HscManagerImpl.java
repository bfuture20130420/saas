package com.bfuture.app.saas.service.impl;

import java.util.List;
import java.util.UUID;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.HscBean;
import com.bfuture.app.saas.service.HscManager;

public class HscManagerImpl  extends BaseManagerImpl implements HscManager {
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if("getHSCJXJSDHead".equals(actionType)){
			result = this.getHSCJXJSDHead(result,o);
			return result;
		}else if("getywdj".equals(actionType)){
			result = this.getywdj(result, o);
			return result;
		}else if("getywmx".equals(actionType)){
			result = this.getywmx(result, o);
			return result;
		}else if("getfsltj".equals(actionType)){
			result = this.getfsltj(result, o);
			return result;
		}else if("getkkmx".equals(actionType)){
			result = this.getkkmx(result, o);
			return result;
		}else if("getfsltjsum".equals(actionType)){
			result = this.getfsltjsum(result, o);
			return result;
		}else if("getHSCKCYJ".equals(actionType)){//好收成库存预警
			result = this.getHSCKCYJ(result, o);
			return result;
		}else if("getHSCDDMZL".equals(actionType)){//好收成订单满足率
			result = this.getHSCDDMZL(result, o);
			return result;
		}else if("saveHSCLSSSPCXSQ".equals(actionType)){
			result = this.saveHSCLSSSPCXSQ(result, o);
			return result;
		}else if("getHSCLSSSPCXSQ".equals(actionType)){
			result = this.getHSCLSSSPCXSQ(result, o);
			return result;
		}else if("updateppStatus".equals(actionType)){
			result = this.updateppStatus(result, o);
			return result;
		}else if("deleteUUID".equals(actionType)){
			result = this.deleteUUID(result, o);
			return result;
		}
		return result;
	}
	
	public ReturnObject getHSCJXJSDHead(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		StringBuffer countSql = new StringBuffer("select count(h.billno) from yw_hsc_jsdhead h ");
		StringBuffer sumSql = new StringBuffer("select cast('合计' as varchar2(10)) billno,sum(h.hyftotal)hyftotal,sum(h.wyftotal)wyftotal,sum(h.jtaxtotal)bdtotal,sum(h.tctotal)bdtotal,sum(h.bdtotal)bdtotal,sum(h.bctotal)bctotal,sum(h.zktotal)zktotal,sum(h.zkasntotal)zkasntotal,sum(h.fytotal)fytotal,sum(h.yftotal)yftotal,sum(h.tztotal)tztotal,sum(h.sftotal)sftotal,sum(h.kptotal)kptotal,sum(h.fktotal)fktotal,sum(h.istemp)istemp from yw_hsc_jsdhead h ");
		StringBuffer rowsSql = new StringBuffer("select h.*,(h.orgcode || '-' || h.orgname)orgnameall,case when h.jzdate is null then '-' else to_char(h.jzdate,'yyyy-mm-dd') end jztime from yw_hsc_jsdhead h ");
		
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
				List rowsList = dao.executeSql(rowsSql.toString(), start, limit);
				result.setTotal(countNum);
				result.setRows(rowsList);
				result.setFooter(sumList);
				result.setReturnCode(Constants.SUCCESS_FLAG);
			}
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
	
	public ReturnObject getywdj(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		StringBuffer sumSql = new StringBuffer("select cast('合计' as varchar2(10)) yworgname,sum(b.hjtotal)hjtotal,sum(b.wjtotal)wjtotal,sum(b.jtaxtotal)jtaxtotal,sum(b.fscount)fscount from yw_hsc_jsdbody b ");
		StringBuffer rowsSql = new StringBuffer("select b.yworgcode || '-' || b.yworgname yworgname,b.ywbillno,b.ywtype || '-' || b.remark remark,to_date(substr(b.ywbillno, 9, 8),'yyyy-mm-dd')jzdate,sum(b.hjtotal)hjtotal,sum(b.wjtotal)wjtotal,sum(b.jtaxtotal)jtaxtotal,sum(b.fscount)fscount from yw_hsc_jsdbody b ");
		
		StringBuffer whereSql = new StringBuffer(" where 1=1 ");
		if (!StringUtil.isBlank(hscBean.getBillno())) {
			whereSql.append(" and b.billno = '"+hscBean.getBillno()+"' ");
		}
		try {
			//统计
			sumSql.append(whereSql);
			List sumList = dao.executeSql(sumSql.toString());
			
			//分页查询
			rowsSql.append(whereSql);
			rowsSql.append(" group by b.yworgcode || '-' || b.yworgname,b.ywbillno,b.ywtype || '-' || b.remark,to_date(substr(b.ywbillno, 9, 8),'yyyy-mm-dd') ");
			
			List countList = dao.executeSql(rowsSql.toString());
			
			if( hscBean.getOrder() != null && hscBean.getSort() != null ){
				rowsSql.append("order by " + hscBean.getSort()+" "+ hscBean.getOrder());
			}else{
				rowsSql.append(" order by sum(b.hjtotal) desc ");
			}
			List rowslist = dao.executeSql(rowsSql.toString(), start, limit);
			
			result.setTotal(countList.size());
			result.setRows(rowslist);
			result.setFooter(sumList);
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
	
	public ReturnObject getywmx(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		StringBuffer countSql = new StringBuffer(" select count(b.ywbillno) from yw_hsc_jsdbody b ");
		StringBuffer sumSql = new StringBuffer("select cast('合计' as varchar2(10)) yworgname,sum(b.hjtotal)hjtotal,sum(b.wjtotal)wjtotal,sum(b.jtaxtotal)jtaxtotal,sum(b.fscount)fscount from yw_hsc_jsdbody b ");
		StringBuffer rowsSql = new StringBuffer("select b.yworgcode || '-' || b.yworgname yworgname,b.ywtype || '-' || b.remark remark,b.ywbillno,b.plucode,b.pluname,b.barcode,b.unit,b.spec,b.hjprice,b.wjprice,b.jtaxrate,b.fscount,b.hjtotal,b.wjtotal,b.jtaxtotal,b.yhtotal from yw_hsc_jsdbody b ");
		
		StringBuffer whereSql = new StringBuffer(" where 1=1 ");
		if (!StringUtil.isBlank(hscBean.getBillno())) {
			whereSql.append(" and b.billno = '"+hscBean.getBillno()+"' ");
		}
		try {
			//统计
			sumSql.append(whereSql);
			List sumList = dao.executeSql(sumSql.toString());
			countSql.append(whereSql);
			List countList = dao.executeSqlCount(countSql.toString());
			int countNum = Integer.parseInt(countList.get(0).toString());
			//分页查询
			rowsSql.append(whereSql);
			
			
			if( hscBean.getOrder() != null && hscBean.getSort() != null ){
				rowsSql.append("order by " + hscBean.getSort()+" "+ hscBean.getOrder());
			}else{
				rowsSql.append(" order by b.hjtotal desc ");
			}
			List rowslist = dao.executeSql(rowsSql.toString(), start, limit);
			
			result.setTotal(countNum);
			result.setRows(rowslist);
			result.setFooter(sumList);
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
	
	public ReturnObject getkkmx(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		StringBuffer countSql = new StringBuffer(" select count(f.billno) from yw_hsc_jsdfee f ");
		StringBuffer sumSql = new StringBuffer(" select cast('合计' as varchar2(10))kxname,sum(ratebase)ratebase from yw_hsc_jsdfee f ");
		StringBuffer rowsSql = new StringBuffer(" select * from yw_hsc_jsdfee f ");
		
		StringBuffer whereSql = new StringBuffer(" where 1=1 ");
		if (!StringUtil.isBlank(hscBean.getBillno())) {
			whereSql.append(" and f.billno = '"+hscBean.getBillno()+"' ");
		}
		if (!StringUtil.isBlank(hscBean.getOrgcode())) {
			whereSql.append(" and f.yworgcode = '"+hscBean.getOrgcode()+"' ");
		}
		try {
			//统计
			sumSql.append(whereSql);
			List sumList = dao.executeSql(sumSql.toString());
			
			countSql.append(whereSql);
			int countNum = Integer.parseInt(dao.executeSqlCount(countSql.toString()).get(0).toString());
			
			//分页查询
			rowsSql.append(whereSql);
			List rowslist = dao.executeSql(rowsSql.toString(), start, limit);
			
			result.setTotal(countNum);
			result.setRows(rowslist);
			result.setFooter(sumList);
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}

	public ReturnObject getfsltj(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		StringBuffer sumSql = new StringBuffer(" select cast('合计' as varchar2(10))jtaxrate,sum(b.jtaxtotal)jtaxtotal,sum(b.hjtotal)hjtotal,sum(b.wjtotal)wjtotal from yw_hsc_jsdbody b ");
		StringBuffer rowsSql = new StringBuffer(" select b.jtaxrate,sum(b.jtaxtotal)jtaxtotal,sum(b.hjtotal)hjtotal,sum(b.wjtotal)wjtotal from yw_hsc_jsdbody b ");
		StringBuffer whereSql = new StringBuffer(" where 1=1 ");
		if (!StringUtil.isBlank(hscBean.getBillno())) {
			whereSql.append(" and b.billno = '"+hscBean.getBillno()+"' ");
		}
		try {
			//统计
			sumSql.append(whereSql);
			List sumList = dao.executeSql(sumSql.toString());
			
			rowsSql.append(whereSql);
			rowsSql.append(" group by b.jtaxrate ");
			int countNum = dao.executeSql(rowsSql.toString()).size();
			//分页查询
			List rowslist = dao.executeSql(rowsSql.toString(), start, limit);
			result.setTotal(countNum);
			result.setRows(rowslist);
			result.setFooter(sumList);
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
	
	public ReturnObject getfsltjsum(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		StringBuffer sumSql = new StringBuffer("select cast('合计' as varchar2(10))yworgname,sum(decode(b.jtaxrate,13,b.jtaxtotal,0))tax1,sum(decode(b.jtaxrate,17,b.jtaxtotal,0))tax2,sum(b.hjtotal)hjtotal,sum(b.wjtotal)wjtotal from yw_hsc_jsdbody b ");
		StringBuffer rowsSql = new StringBuffer("select b.yworgname,b.ywbillno,b.remark,sum(decode(b.jtaxrate,13,b.jtaxtotal,0))tax1,sum(decode(b.jtaxrate,17,b.jtaxtotal,0))tax2,sum(b.hjtotal)hjtotal,sum(b.wjtotal)wjtotal from yw_hsc_jsdbody b ");
		StringBuffer whereSql = new StringBuffer(" where 1=1 ");
		if (!StringUtil.isBlank(hscBean.getBillno())) {
			whereSql.append(" and b.billno = '"+hscBean.getBillno()+"' ");
		}
		try {
			//统计
			sumSql.append(whereSql);
			List sumList = dao.executeSql(sumSql.toString());
			
			rowsSql.append(whereSql);
			rowsSql.append(" group by b.yworgname,b.ywbillno,b.remark ");
			int countNum = dao.executeSql(rowsSql.toString()).size();
			//分页查询
			List rowslist = dao.executeSql(rowsSql.toString(), start, limit);
			result.setTotal(countNum);
			result.setRows(rowslist);
			result.setFooter(sumList);
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
	
	public ReturnObject getHSCKCYJ(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		String sumSql = "select cast('合计' as varchar2(10))orgnameall,sum(kcsl)kcsl,sum(kcje)kcje,sum(xs.xssl)xssl,sum(xs.xsje)xsje from (select w.zssgcode,w.zsmfid,w.zsgdid,w.zsbarcode,sum(zskcsl)kcsl,sum(zskcje)kcje from yw_zrstock3040 w group by w.zssgcode,w.zsmfid,w.zsgdid,w.zsbarcode)kc "
				       + "left join (select gs.gssgcode,gs.gsmfid,gs.gsgdid,gs.gsbarcode,max(gs.gsrq)zjxsrq,sum(gs.gsxssl)xssl,sum(gs.gshsjjje)xsje from yw_goodssale3040 gs where to_char(gs.gsrq,'yyyy-mm-dd')>= '"+hscBean.getStartDate()+"' and to_char(gs.gsrq,'yyyy-mm-dd')<= '"+hscBean.getEndDate()+"' group by gs.gssgcode,gs.gsmfid,gs.gsgdid,gs.gsbarcode)xs on kc.zssgcode = xs.gssgcode and kc.zsmfid = xs.gsmfid and kc.zsgdid = xs.gsgdid and kc.zsbarcode = xs.gsbarcode "
				       + "left join (select bid.bidsgcode,bid.bidgdid,bid.bidbarcode,max(bih.bihshtime)zjjhrq from yw_binstrdetail bid left join yw_binstrhead bih on bid.bidsgcode = bih.bihsgcode and bid.bidbillno = bih.bihbillno and bid.bidshmfid = bih.bihshmfid where bih.bihsgcode='"+hscBean.getSgcode()+"' group by bid.bidsgcode,bid.bidgdid,bid.bidbarcode)rk on kc.zssgcode = rk.bidsgcode and kc.zsgdid = rk.bidgdid and kc.zsbarcode = rk.bidbarcode "
				       + "left join inf_goods gd on kc.zssgcode = gd.gdsgcode and kc.zsgdid = gd.gdid and kc.zsbarcode = gd.gdbarcode left join inf_shop sp on kc.zssgcode=sp.sgcode and kc.zsmfid = sp.shpcode ";
		String rowsSql = "select kc.*,kc.zsmfid || '-' || sp.shpname orgnameall,to_char(xs.zjxsrq,'yyyy-mm-dd')zjxsrq,xs.xssl,xs.xsje,to_char(rk.zjjhrq,'yyyy-mm-dd')zjjhrq,gd.gdname,gd.gdcatid,gd.gdcatname,gd.gdcatid || '-' || gd.gdcatname catnameall,gd.temp3 ppid,gd.gdppname,gd.temp3 || '-' || gd.gdppname ppnameall,gd.gdspec,gd.gdunit,round(xs.xssl/(to_date('"+hscBean.getEndDate()+"','yyyy-mm-dd')-to_date('"+hscBean.getStartDate()+"','yyyy-mm-dd')+1),2) rjxl,"
					   + "round((case when kc.kcsl<0 then 0 else kc.kcsl end )*(to_date('"+hscBean.getEndDate()+"','yyyy-mm-dd')-to_date('"+hscBean.getStartDate()+"','yyyy-mm-dd')+1)/(case when xs.xssl = 0  then 1 when xs.xssl is null then 1 else xs.xssl end),2) kxts,round(xs.xsje/(case when kc.kcje=0 then 1 when kc.kcje is null then 1 else kc.kcje end),2)zzl,"
					   + "round((to_date('"+hscBean.getEndDate()+"','yyyy-mm-dd')-to_date('"+hscBean.getStartDate()+"','yyyy-mm-dd')+1)*kc.kcje/(case when xs.xsje = 0 then 1 when xs.xsje is null then 1 else xs.xsje end),2)zzts "
					   + "from (select w.zssgcode,w.zsmfid,w.zsgdid,w.zsbarcode,sum(zskcsl)kcsl,sum(zskcje)kcje from yw_zrstock3040 w group by w.zssgcode,w.zsmfid,w.zsgdid,w.zsbarcode)kc "
					   + "left join (select gs.gssgcode,gs.gsmfid,gs.gsgdid,gs.gsbarcode,max(gs.gsrq)zjxsrq,sum(gs.gsxssl)xssl,sum(gs.gshsjjje)xsje from yw_goodssale3040 gs where to_char(gs.gsrq,'yyyy-mm-dd')>= '"+hscBean.getStartDate()+"' and to_char(gs.gsrq,'yyyy-mm-dd')<= '"+hscBean.getEndDate()+"' group by gs.gssgcode,gs.gsmfid,gs.gsgdid,gs.gsbarcode)xs on kc.zssgcode = xs.gssgcode and kc.zsmfid = xs.gsmfid and kc.zsgdid = xs.gsgdid and kc.zsbarcode = xs.gsbarcode "
					   + "left join (select bid.bidsgcode,bid.bidgdid,bid.bidbarcode,max(bih.bihshtime)zjjhrq from yw_binstrdetail bid left join yw_binstrhead bih on bid.bidsgcode = bih.bihsgcode and bid.bidbillno = bih.bihbillno and bid.bidshmfid = bih.bihshmfid where bih.bihsgcode='"+hscBean.getSgcode()+"' group by bid.bidsgcode,bid.bidgdid,bid.bidbarcode)rk on kc.zssgcode = rk.bidsgcode and kc.zsgdid = rk.bidgdid and kc.zsbarcode = rk.bidbarcode "
					   + "left join inf_goods gd on kc.zssgcode = gd.gdsgcode and kc.zsgdid = gd.gdid and kc.zsbarcode = gd.gdbarcode left join inf_shop sp on kc.zssgcode=sp.sgcode and kc.zsmfid = sp.shpcode ";
		
		String whereSql = " where 1=1 ";
		if (!StringUtil.isBlank(hscBean.getOrgcode())) {
			whereSql += " and kc.zsmfid = '"+hscBean.getOrgcode()+"' ";
		}
		if (!StringUtil.isBlank(hscBean.getSupcode())) {
			whereSql += " and kc.zssupid = '"+hscBean.getSupcode()+"' ";
		}
		if (!StringUtil.isBlank(hscBean.getPpid())) {
			whereSql += " and gd.temp3 = '"+hscBean.getPpid()+"' ";
		}
		if (!StringUtil.isBlank(hscBean.getCatid())) {
			whereSql += " and gd.gdcatid = '"+hscBean.getCatid()+"' ";
		}
		if (!StringUtil.isBlank(hscBean.getYjDays())) {
			whereSql += " and round(kc.kcsl*(to_date('"+hscBean.getEndDate()+"','yyyy-mm-dd')-to_date('"+hscBean.getStartDate()+"','yyyy-mm-dd')+1)/(case when xs.xssl = 0  then 1 when xs.xssl is null then 1 else xs.xssl end),2) <= to_number('"+hscBean.getYjDays()+"') ";
		}
		try {
			//统计
			sumSql = sumSql + whereSql ;
			List sumList = dao.executeSql(sumSql);
			
			//分页查询
			rowsSql = rowsSql + whereSql;
			rowsSql = "select * from ("+rowsSql+")";
			int countNum = dao.executeSql(rowsSql).size();
			
			if( hscBean.getOrder() != null && hscBean.getSort() != null ){
				rowsSql +="order by " + hscBean.getSort()+" "+hscBean.getOrder();
			}
			
			List rowslist = dao.executeSql(rowsSql, start, limit);
			
			result.setTotal(countNum);
			result.setRows(rowslist);
			result.setFooter(sumList);
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
	
	public ReturnObject getHSCDDMZL(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		String whereSql_1 = " ";
		String whereSql_2 = " ";
		
		if (!StringUtil.isBlank(hscBean.getOrgcode())) {
			whereSql_1 += " and t.orgcode = '"+hscBean.getOrgcode()+"' ";
			whereSql_2 += " and ord.orgcode = '"+hscBean.getOrgcode()+"' ";
		}
		if (!StringUtil.isBlank(hscBean.getSupcode())) {
			whereSql_1 += " and t.supcode = '"+hscBean.getSupcode()+"' ";
			whereSql_2 += " and ord.supcode = '"+hscBean.getSupcode()+"' ";
		}
		String sumSql = "select cast('合计' as varchar2(10))orgnameall,sum(a.ddzs)ddzs,sum(lxdds)lxdds,sum(wqlxdds)wqlxdds,sum(zsdhdds),sum(dhsl)dhsl,sum(sjsl)sjsl，sum(zsdhdds)zsdhdds,round(sum(lxdds)/sum(a.ddzs) * 100,2)ddzxl,round(sum(wqlxdds)/sum(a.ddzs) * 100,2)ddmzl,round(sum(zsdhdds)/sum(a.ddzs) * 100,2)ddzsl "
				   + "from (select t.orgcode, t.orgname,t.supcode,t.supname, count(*) ddzs,count(case when t.ywstatus = 2 THEN 1 else null end) lxdds,count(case when t.ywstatus = 2 and t.sdcount >= t.cgcount THEN 1 else null end) wqlxdds,"
				   + "count(case when t.dhdate < t.zddate THEN 1 else null end) zsdhdds,sum(t.cgcount) dhsl,sum(t.sdcount) sjsl from yw_hsc_dddhl t where to_char(t.lrdate,'yyyy-mm-dd')>='"+hscBean.getStartDate()+"' and to_char(t.lrdate,'yyyy-mm-dd')<='"+hscBean.getEndDate()+"' "+whereSql_1
				   + "group by t.orgcode, t.orgname,t.supcode,t.supname) a left join (select ord.orgcode,ord.supcode, avg( floor( to_date(ord.dhdate,'YYYY-MM-DD') - to_date(ord.zddate,'YYYY-MM-DD') ) + 1 ) zzts "
				   + "from yw_hsc_dddhl ord where to_char(ord.lrdate,'yyyy-mm-dd')>='"+hscBean.getStartDate()+"' and to_char(ord.lrdate,'yyyy-mm-dd')<='"+hscBean.getEndDate()+"' and ord.ywstatus = 2 "+whereSql_2+"group by ord.orgcode,ord.supcode) b on a.orgcode = b.orgcode and a.supcode=b.supcode";
	
		String rowsSql = "select a.*,(a.orgcode || '-' || a.orgname)orgnameall,(a.supcode ||'-'||a.supname)supnameall,round(a.lxdds/ddzs * 100,2) ddzxl,round(a.wqlxdds/ddzs * 100,2)ddmzl,round(a.zsdhdds/ddzs * 100,2)ddzsl,round(b.zzts,2)zzts "
					   + "from (select t.orgcode, t.orgname,t.supcode,t.supname, count(*) ddzs,count(case when t.ywstatus = 2 THEN 1 else null end) lxdds,count(case when t.ywstatus = 2 and t.sdcount >= t.cgcount THEN 1 else null end) wqlxdds,"
					   + "count(case when t.dhdate < t.zddate THEN 1 else null end) zsdhdds,sum(t.cgcount) dhsl,sum(t.sdcount) sjsl from yw_hsc_dddhl t where to_char(t.lrdate,'yyyy-mm-dd')>='"+hscBean.getStartDate()+"' and to_char(t.lrdate,'yyyy-mm-dd')<='"+hscBean.getEndDate()+"' " + whereSql_1
					   + "group by t.orgcode, t.orgname,t.supcode,t.supname) a left join (select ord.orgcode,ord.supcode, avg( floor( to_date(ord.dhdate,'YYYY-MM-DD') - to_date(ord.zddate,'YYYY-MM-DD') ) + 1 ) zzts "
					   + "from yw_hsc_dddhl ord where to_char(ord.lrdate,'yyyy-mm-dd')>='"+hscBean.getStartDate()+"' and to_char(ord.lrdate,'yyyy-mm-dd')<='"+hscBean.getEndDate()+"' and ord.ywstatus = 2 "+whereSql_2+"group by ord.orgcode,ord.supcode) b on a.orgcode = b.orgcode and a.supcode=b.supcode";
		try {
			//统计
			List sumList = dao.executeSql(sumSql.toString());
			int countNum = dao.executeSql(rowsSql.toString()).size();
			//分页查询
			List rowslist = dao.executeSql(rowsSql.toString(), start, limit);
			result.setTotal(countNum);
			result.setRows(rowslist);
			result.setFooter(sumList);
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception e){
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
	
	public ReturnObject saveHSCLSSSPCXSQ(ReturnObject result ,Object[] o){
		try {
			HscBean hscBean = (HscBean) o[0];
			String uuid = UUID.randomUUID().toString();
			String sgcode = hscBean.getSgcode();
			String supcode = hscBean.getSupcode();
			String validdate = hscBean.getValidDate();
			String uploadfile = hscBean.getUploadFile();
			String insertSql = " insert into YW_HSC_LSSSPCXSQ(uuid,sgcode,supcode,applydate,validdate,uploadfile,ppstatus) values('"+uuid+"','"+sgcode+"','"+supcode+"',sysdate,to_date('"+validdate+"','yyyy-mm-dd'),'"+uploadfile+"',0)";
			dao.saveBySQL(insertSql);
			result.setReturnCode(Constants.SUCCESS_FLAG);
		} catch (Exception e){
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}
	
	public ReturnObject getHSCLSSSPCXSQ(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		int limit = hscBean.getRows();
		int start = (hscBean.getPage() - 1) * hscBean.getRows();
		StringBuffer countSQl = new StringBuffer("select count(1) from YW_HSC_LSSSPCXSQ pp,inf_supinfo sup where pp.sgcode = sup.supsgcode and pp.supcode = sup.supid ");
		StringBuffer rowsSql = new StringBuffer("select pp.uuid,pp.sgcode,pp.supcode,to_char(pp.applydate,'yyyy-mm-dd')applydate,to_char(pp.validdate,'yyyy-mm-dd')validdate,(pp.validdate - sysdate)flag,pp.uploadfile,pp.ppstatus,pp.temp1,pp.temp2,pp.temp3,pp.temp4,pp.temp5,(pp.supcode || '_' ||sup.supname) supname from YW_HSC_LSSSPCXSQ pp,inf_supinfo sup where pp.sgcode = sup.supsgcode and pp.supcode = sup.supid ");	
		StringBuffer wheresql = new StringBuffer(" ");
		if(!StringUtil.isBlank(hscBean.getSgcode())){
			wheresql.append(" and pp.sgcode = '"+hscBean.getSgcode()+"'");
		}
		if(!StringUtil.isBlank(hscBean.getSupcode())){
			wheresql.append(" and pp.supcode = '"+hscBean.getSupcode()+"'");
		}
		if(!StringUtil.isBlank(hscBean.getStartDate())){
			wheresql.append(" and to_char(pp.applydate,'yyyy-mm-dd') >= '"+hscBean.getStartDate()+"'");
		}
		if(!StringUtil.isBlank(hscBean.getEndDate())){
			wheresql.append(" and to_char(pp.applydate,'yyyy-mm-dd') <= '"+hscBean.getEndDate()+"'");
		}
		try {
			//统计总条数
			countSQl.append(wheresql);
			int countNum = Integer.parseInt(dao.executeSqlCount(countSQl.toString()).get(0).toString());
			//分页查询
			rowsSql.append(wheresql);
			List rowsList = dao.executeSql(rowsSql.toString(), start, limit);
			result.setTotal(countNum);
			result.setRows(rowsList);
			result.setReturnCode(Constants.SUCCESS_FLAG);
			return result;
		} catch (Exception e) {
			result.setReturnCode(Constants.ERROR_FLAG);
		}
		return result;
	}

	public ReturnObject updateppStatus(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		String updateSql = "update yw_hsc_lssspcxsq set ppstatus = '1' where uuid = '"+hscBean.getUuid()+"' ";
		try {
			dao.updateSql(updateSql);
			result.setReturnCode("1");
		} catch (Exception e) {
			result.setReturnCode("0");
		}
		return result;
	}
	
	public ReturnObject deleteUUID(ReturnObject result ,Object[] o){
		HscBean hscBean = (HscBean) o[0];
		String updateSql = "delete from yw_hsc_lssspcxsq where uuid = '"+hscBean.getUuid()+"' ";
		try {
			dao.updateSql(updateSql);
			result.setReturnCode("1");
		} catch (Exception e) {
			e.printStackTrace();
			result.setReturnCode("0");
		}
		return result;
	}
}
