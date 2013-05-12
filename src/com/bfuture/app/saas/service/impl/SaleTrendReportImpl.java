package com.bfuture.app.saas.service.impl;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.bfuture.app.basic.Constants;
import com.bfuture.app.basic.model.ReturnObject;
import com.bfuture.app.basic.service.BaseManager;
import com.bfuture.app.basic.service.impl.BaseManagerImpl;
import com.bfuture.app.basic.util.xml.ConversionUtils;
import com.bfuture.app.basic.util.xml.StringUtil;
import com.bfuture.app.saas.model.report.YwGoodssale;

public class SaleTrendReportImpl extends BaseManagerImpl implements BaseManager {
	
	protected final Log log = LogFactory.getLog(SaleTrendReportImpl.class);
	
	@Override
	public ReturnObject ExecOther(String actionType, Object[] o) {
		ReturnObject result = new ReturnObject();
		if ("getSaleTrendReport".equals( actionType )) {
			result = getSaleTrendReport(o);
			return result;
		}else if ("getSaleTrendReport3040".equals( actionType )) {
			result = getSaleTrendReport3040(o);
			return result;
		}
		return result;
	}

	/**
	 *描述：销售趋势分析
	 *备注：公用模块
	 */
	public ReturnObject getSaleTrendReport(Object[] o) {
		ReturnObject result = new ReturnObject();
		log.info("SaleTrendReportImpl.getSaleTrendReport()");
		try{
			YwGoodssale goodsale = (YwGoodssale)o[0];
			String gsTableName="YW_GOODSSALE"+(StringUtil.isBlank(goodsale.getGssgcode())?"":goodsale.getGssgcode());
			StringBuffer chartSql = new StringBuffer( "SELECT to_char(T.GSRQ,'YYYY-MM-DD') GSRQ,case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end SHPCODE,case when T1.SHPNAME is null then '其他' else T1.SHPNAME end SHPNAME,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR,SUM(GSXSJE) GSXSJE, T2.supid INFSUPID,T2.supname INFSUPNAME FROM ").append(gsTableName).append("  T  " );				
			chartSql.append( " LEFT JOIN INF_SHOP T1 ON T.GSMFID=T1.SHPCODE AND T.GSSGCODE = T1.SGCODE left join inf_supinfo T2 on T2.supsgcode = T.gssgcode and T2.supid = T.gssupid WHERE 1 = 1 " );
							
			if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
					chartSql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
				chartSql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
				chartSql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
				chartSql.append( " and T.GSRQ >= to_date('" + goodsale.getStartDate() + "','YYYY-MM-DD')" );
			}
			
			if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
				chartSql.append( " and T.GSRQ <= to_date('" + goodsale.getEndDate() +"','YYYY-MM-DD')" );
			}
			
			chartSql.append( " GROUP BY to_char(T.GSRQ,'YYYY-MM-DD'), case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end, case when T1.SHPNAME is null then '其他' else T1.SHPNAME end, T2.supid, T2.supname" );		
						
			if( !StringUtil.isBlank( goodsale.getSaleObject() ) ){
				chartSql.append( " order by "+goodsale.getSaleObject());
			}				
			
			List lstChartResult = dao.executeSql( chartSql.toString() );	
			
			// 计算合计部分开始
			if( lstChartResult != null && lstChartResult.size() > 0 ){
				List<Object> lstSumResult = new ArrayList<Object>();
				
				double gsxssl = 0,gshsjjje = 0, gsxssr = 0, gsxsje = 0;
				for( Object obj : lstChartResult ){
					Map mapGs = (Map)obj;
					gsxssl += mapGs.get( "GSXSSL" ) != null ? Double.parseDouble( mapGs.get( "GSXSSL" ).toString() ) : 0;
					gshsjjje += mapGs.get( "GSHSJJJE" ) != null ? Double.parseDouble( mapGs.get( "GSHSJJJE" ).toString() ) : 0;
					gsxssr += mapGs.get( "GSXSSR" ) != null ? Double.parseDouble( mapGs.get( "GSXSSR" ).toString() ) : 0;
					gsxsje += mapGs.get( "GSXSJE" ) != null ? Double.parseDouble( mapGs.get( "GSXSJE" ).toString() ) : 0;
				}
				
				Map<String, Object> mapSum = new HashMap<String, Object>();
				mapSum.put( "GSRQ", "合计" );
				mapSum.put( "GSXSSL", gsxssl );
				mapSum.put( "GSHSJJJE", gshsjjje );
				mapSum.put( "GSXSSR", gsxssr );
				mapSum.put( "GSXSJE", gsxsje );
				lstSumResult.add( mapSum );
				
				result.setFooter( lstSumResult );
			}// 计算合计部分结束
			
			if( lstChartResult != null && lstChartResult.size() > 0 ){
				
				//按门店重组数据
				Map< String, Map<String,Map>> mapResult = new HashMap< String, Map<String,Map>>();					
				for( Iterator<Map> itMap = lstChartResult.iterator(); itMap.hasNext(); ){
					Map mapGs = itMap.next();
					String mfid = mapGs.get( "SHPCODE" ).toString();
					Map<String,Map> mapMFMap = null;
					if( mapResult.containsKey( mfid ) ){
						mapMFMap = mapResult.get( mfid );
					}
					else{
						mapMFMap = new HashMap<String,Map>();
						mapResult.put( mfid, mapMFMap );
					}
					mapMFMap.put( mapGs.get("GSRQ").toString(), mapGs );
				}
				
				//初始化日期范围
				SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
				Date ed = sdf.parse(goodsale.getEndDate() );
				List<String> lstRq = new ArrayList<String>();
				for( Date sd = sdf.parse(goodsale.getStartDate() ); sd.compareTo( ed ) <= 0;  ){
					lstRq.add( sdf.format(sd) );
					Calendar cal = Calendar.getInstance();
					cal.setTime( sd );
					cal.add( Calendar.DAY_OF_MONTH, 1 );
					sd = cal.getTime();
				}
				
				JSONObject json = new JSONObject();
				
				JSONObject chart = new JSONObject();
				chart.put( "caption", "" );
				chart.put( "xaxisname", "日  期" );
				
				String yaxisname = null;
				if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售数量";
				}
				else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
					yaxisname = "含税进价金额";						
				}
				else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售收入";
				}
				else if( "GSXSJE".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售金额";
				}
				chart.put( "yaxisname", yaxisname );
				chart.put( "showvalues", "0" );
				chart.put( "formatNumberScale", "0" );
				chart.put( "decimals", "2" );
				chart.put( "animation", "1" );
				chart.put( "bgColor", "FFFFFF" );
				chart.put( "legendPosition", "BOTTOM");
				json.put( "chart", chart );
				
				JSONArray categories = new JSONArray();
				JSONArray category = new JSONArray();
				JSONArray dataset = new JSONArray();
				
				for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
					String rq = itRq.next();
					JSONObject joCategory = new JSONObject();
					joCategory.put( "label", rq );
					category.add( joCategory );
				}
				
				JSONObject joCategory = new JSONObject();
				joCategory.put( "category", category );
				categories.add( joCategory );
				json.put( "categories", categories );
				
				for( Iterator<String> itMfid = mapResult.keySet().iterator(); itMfid.hasNext(); ){
					String mfid = itMfid.next();
					Map<String,Map> mapRqgs = mapResult.get( mfid );
					String mfname = mapRqgs.values().iterator().next().get( "SHPNAME" ).toString();
					
					JSONObject joDataset = new JSONObject();
					joDataset.put( "seriesname", mfname );
					JSONArray jaData = new JSONArray();
					
					for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
						String rq = itRq.next();
						JSONObject joData = new JSONObject();
						if( mapRqgs.containsKey( rq ) ){
							Map mapGs = mapRqgs.get( rq );
							if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSSL") != null ? mapGs.get("GSXSSL").toString() : "0" ) );
							}
							else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSHSJJJE") != null ? mapGs.get("GSHSJJJE").toString() : "0" ) );						
							}
							else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSSR") != null ? mapGs.get("GSXSSR").toString() : "0" ) );
							}
							else if( "GSXSJE".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSJE") != null ? mapGs.get("GSXSJE").toString() : "0" ) );
							}

						}
						else{
							joData.put( "value", "0" ); 
						}
						jaData.add( joData );
					}
					
					joDataset.put( "data", jaData );
					dataset.add( joDataset );
				}
				
				json.put( "dataset", dataset );
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setChartData( json );
				result.setRows(lstChartResult); // 列表
			}
		
		}catch( Exception ex ){
			log.error("SaleTrendReportImpl.getSaleTrendReport() error:" + ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		
		return result;
	}
	
	
	/**
	 * 编辑：刘波
	 * 时间：2013-05-11
	 * 描述：3040好收成销售趋势分析
	 * 备注：新增毛利,毛利率
	 */
	public ReturnObject getSaleTrendReport3040(Object[] o){
		ReturnObject result = new ReturnObject();
		log.info("SaleTrendReportImpl.getSaleTrendReport()");
		try{
			YwGoodssale goodsale = (YwGoodssale)o[0];
			String gsTableName="YW_GOODSSALE"+(StringUtil.isBlank(goodsale.getGssgcode())?"":goodsale.getGssgcode());
			StringBuffer rowsSql = new StringBuffer( "SELECT to_char(T.GSRQ,'YYYY-MM-DD') GSRQ,case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end SHPCODE,case when T1.SHPNAME is null then '其他' else T1.SHPNAME end SHPNAME,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR,SUM(GSXSJE) GSXSJE,(SUM(GSXSJE)-SUM(GSHSJJJE))ml,round((SUM(GSXSJE)-SUM(GSHSJJJE))*100/(case when SUM(GSXSJE)=0 then 1 else SUM(GSXSJE) end),2)mll,T2.supid INFSUPID,T2.supname INFSUPNAME FROM ").append(gsTableName).append("  T  " );				
			rowsSql.append( "LEFT JOIN INF_SHOP T1 ON T.GSMFID=T1.SHPCODE AND T.GSSGCODE = T1.SGCODE left join inf_supinfo T2 on T2.supsgcode = T.gssgcode and T2.supid = T.gssupid " );
			
			StringBuffer rowsSql1 = new StringBuffer( "SELECT to_char(T.GSRQ,'YYYY-MM-DD') GSRQ,case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end SHPCODE,case when T1.SHPNAME is null then '其他' else T1.SHPNAME end SHPNAME,SUM(GSXSSL) GSXSSL,SUM(GSHSJJJE) GSHSJJJE,SUM(GSXSSR) GSXSSR,SUM(GSXSJE) GSXSJE,(SUM(GSXSJE)-SUM(GSHSJJJE))ml,round((SUM(GSXSJE)-SUM(GSHSJJJE))*100/(case when SUM(GSXSJE)=0 then 1 else SUM(GSXSJE) end),2)mll FROM ").append(gsTableName).append("  T  " );				
			rowsSql1.append( "LEFT JOIN INF_SHOP T1 ON T.GSMFID=T1.SHPCODE AND T.GSSGCODE = T1.SGCODE left join inf_supinfo T2 on T2.supsgcode = T.gssgcode and T2.supid = T.gssupid " );
			
			StringBuffer whereSql = new StringBuffer(" WHERE 1 = 1 ");
			if( !StringUtil.isBlank( goodsale.getGssupid() ) ){
				whereSql.append( " and T.GSSUPID = '" ).append( goodsale.getGssupid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGsmfid() ) ){
				whereSql.append( " and T.GSMFID = '" ).append( goodsale.getGsmfid() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getGssgcode() ) ){
				whereSql.append( " and T.GSSGCODE = '" ).append( goodsale.getGssgcode() ).append("'");
			}
			
			if( !StringUtil.isBlank( goodsale.getStartDate() ) ){
				whereSql.append( " and T.GSRQ >= to_date('" + goodsale.getStartDate() + "','YYYY-MM-DD')" );
			}
			
			if( !StringUtil.isBlank( goodsale.getEndDate() ) ){
				whereSql.append( " and T.GSRQ <= to_date('" + goodsale.getEndDate() +"','YYYY-MM-DD')" );
			}
			
			rowsSql1.append(whereSql);
			rowsSql1.append( " GROUP BY to_char(T.GSRQ,'YYYY-MM-DD'), case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end, case when T1.SHPNAME is null then '其他' else T1.SHPNAME end " );					
			List lstChartResult1 = dao.executeSql( rowsSql1.toString() );	
			
			rowsSql.append(whereSql);
			rowsSql.append( " GROUP BY to_char(T.GSRQ,'YYYY-MM-DD'), case when T1.SHPCODE is null then 'unknow' else T1.SHPCODE end, case when T1.SHPNAME is null then '其他' else T1.SHPNAME end, T2.supid, T2.supname " );	
			if(!StringUtil.isBlank( goodsale.getSaleObject() ) ){
				rowsSql.append( " order by "+goodsale.getSaleObject());
			}
			List lstChartResult = dao.executeSql( rowsSql.toString() );	
			
			// 计算合计部分开始
			if( lstChartResult != null && lstChartResult.size() > 0 ){
				List<Object> lstSumResult = new ArrayList<Object>();
				
				double gsxssl = 0,gshsjjje = 0, gsxssr = 0, gsxsje = 0,ml = 0,mll = 0.0,kcje = 0 ,zzl = 0.0;
				for( Object obj : lstChartResult ){
					Map mapGs = (Map)obj;
					gsxssl += mapGs.get( "GSXSSL" ) != null ? Double.parseDouble( mapGs.get( "GSXSSL" ).toString() ) : 0;
					gshsjjje += mapGs.get( "GSHSJJJE" ) != null ? Double.parseDouble( mapGs.get( "GSHSJJJE" ).toString() ) : 0;
					gsxssr += mapGs.get( "GSXSSR" ) != null ? Double.parseDouble( mapGs.get( "GSXSSR" ).toString() ) : 0;
					gsxsje += mapGs.get( "GSXSJE" ) != null ? Double.parseDouble( mapGs.get( "GSXSJE" ).toString() ) : 0;
					ml += mapGs.get( "ML" ) != null ? Double.parseDouble( mapGs.get( "ML" ).toString() ) : 0;
				}
				//毛利率
				if(gsxsje == 0){
					gsxsje = 1 ;
				}
				mll = (gsxsje - gshsjjje)*100/gsxsje;
				//周转率
				zzl = gsxsje/kcje;
				DecimalFormat df = new DecimalFormat("#.00");
				Map<String, Object> mapSum = new HashMap<String, Object>();
				mapSum.put( "GSRQ", "合计" );
				mapSum.put( "GSXSSL", gsxssl );
				mapSum.put( "GSHSJJJE", gshsjjje );
				mapSum.put( "GSXSSR", gsxssr );
				mapSum.put( "GSXSJE", gsxsje );
				mapSum.put( "ML", ml );
				mapSum.put( "MLL", df.format(mll)+"%");
				lstSumResult.add( mapSum );
				
				result.setFooter( lstSumResult );
			}// 计算合计部分结束
			
			if( lstChartResult1 != null && lstChartResult1.size() > 0 ){	
				//按门店重组数据
				Map< String, Map<String,Map>> mapResult = new HashMap< String, Map<String,Map>>();					
				for( Iterator<Map> itMap = lstChartResult1.iterator(); itMap.hasNext(); ){
					Map mapGs = itMap.next();
					String mfid = mapGs.get( "SHPCODE" ).toString();
					Map<String,Map> mapMFMap = null;
					if( mapResult.containsKey( mfid ) ){
						mapMFMap = mapResult.get( mfid );
					}
					else{
						mapMFMap = new HashMap<String,Map>();
						mapResult.put( mfid, mapMFMap );
					}
					mapMFMap.put( mapGs.get("GSRQ").toString(), mapGs );
				}
				
				//初始化日期范围
				SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
				Date ed = sdf.parse(goodsale.getEndDate() );
				List<String> lstRq = new ArrayList<String>();
				for( Date sd = sdf.parse(goodsale.getStartDate() ); sd.compareTo( ed ) <= 0;  ){
					lstRq.add( sdf.format(sd) );
					Calendar cal = Calendar.getInstance();
					cal.setTime( sd );
					cal.add( Calendar.DAY_OF_MONTH, 1 );
					sd = cal.getTime();
				}
				
				JSONObject json = new JSONObject();
				
				JSONObject chart = new JSONObject();
				chart.put( "caption", "" );
				chart.put( "xaxisname", "日  期" );
				
				String yaxisname = null;
				if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售数量";
				}
				else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
					yaxisname = "含税进价金额";						
				}
				else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售收入";
				}
				else if( "GSXSJE".equals( goodsale.getSaleObject() ) ){
					yaxisname = "销售金额";
				}
				else if( "ML".equals( goodsale.getSaleObject() ) ){
					yaxisname = "毛利";						
				}
				else if( "MLL".equals( goodsale.getSaleObject() ) ){
					yaxisname = "毛利率(%)";
				}
				chart.put( "yaxisname", yaxisname );
				chart.put( "showvalues", "0" );
				chart.put( "formatNumberScale", "0" );
				chart.put( "decimals", "2" );
				chart.put( "animation", "1" );
				chart.put( "bgColor", "FFFFFF" );
				chart.put( "legendPosition", "BOTTOM");
				json.put( "chart", chart );
				
				JSONArray categories = new JSONArray();
				JSONArray category = new JSONArray();
				JSONArray dataset = new JSONArray();
				
				for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
					String rq = itRq.next();
					JSONObject joCategory = new JSONObject();
					joCategory.put( "label", rq );
					category.add( joCategory );
				}
				
				JSONObject joCategory = new JSONObject();
				joCategory.put( "category", category );
				categories.add( joCategory );
				json.put( "categories", categories );
				
				for( Iterator<String> itMfid = mapResult.keySet().iterator(); itMfid.hasNext(); ){
					String mfid = itMfid.next();
					Map<String,Map> mapRqgs = mapResult.get( mfid );
					String mfname = mapRqgs.values().iterator().next().get( "SHPNAME" ).toString();
					
					JSONObject joDataset = new JSONObject();
					joDataset.put( "seriesname", mfname );
					JSONArray jaData = new JSONArray();
					
					for( Iterator<String> itRq = lstRq.iterator(); itRq.hasNext(); ){
						String rq = itRq.next();
						JSONObject joData = new JSONObject();
						if( mapRqgs.containsKey( rq ) ){
							Map mapGs = mapRqgs.get( rq );
							if( "GSXSSL".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSSL") != null ? mapGs.get("GSXSSL").toString() : "0" ) );
							}
							else if( "GSHSJJJE".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSHSJJJE") != null ? mapGs.get("GSHSJJJE").toString() : "0" ) );						
							}
							else if( "GSXSSR".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSSR") != null ? mapGs.get("GSXSSR").toString() : "0" ) );
							}
							else if( "GSXSJE".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("GSXSJE") != null ? mapGs.get("GSXSJE").toString() : "0" ) );
							}
							else if( "ML".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("ML") != null ? mapGs.get("ML").toString() : "0" ) );						
							}
							else if( "MLL".equals( goodsale.getSaleObject() ) ){
								joData.put( "value", Double.parseDouble( mapGs.get("MLL") != null ? mapGs.get("MLL").toString() : "0" ) );
							}
						}
						else{
							joData.put( "value", "0" ); 
						}
						jaData.add( joData );
					}
					
					joDataset.put( "data", jaData );
					dataset.add( joDataset );
				}
				
				json.put( "dataset", dataset );
				
				result.setReturnCode( Constants.SUCCESS_FLAG );
				result.setChartData( json );
				result.setRows(lstChartResult); // 列表
			}
		
		}catch( Exception ex ){
			log.error("SaleTrendReportImpl.getSaleTrendReport() error:" + ex.getMessage());
			result.setReturnCode( Constants.ERROR_FLAG );
			result.setReturnInfo( ex.getMessage() );
			ex.printStackTrace();
		}
		return result;
	}
}
