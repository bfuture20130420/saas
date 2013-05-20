<%@ page language="java" import="java.util.Date,java.text.*" contentType="text/html; charset=GBK"pageEncoding="GBK"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.basic.dao.UniversalAppDao"%>
<%@page import="java.util.Map"%>
<%@page import="com.bfuture.app.saas.util.Money"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="com.bfuture.app.saas.util.Money" %>
<%@page import="java.text.SimpleDateFormat" %>
<%! 
	public String NulltoBlank( String str ){
		
		return str == null ? "" : str;
	}

	public String NulltoBlank( Object str ){
		
		return str == null ? "" : str.toString();
	}
%>
<%
	final Log log = LogFactory.getLog(getClass());
	request.setCharacterEncoding("GBK");
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}

	
	String vs_supcode =  request.getParameter("supcode");
	String vs_billno = request.getParameter("billno");
	String vs_sgcode = request.getParameter("sgcode");
	//String isShowFY = request.getParameter("isShowFY");

	NumberFormat df = NumberFormat.getInstance();
	df.setMaximumFractionDigits(2);
	df.setMinimumFractionDigits(2);	
%>
 
<html>
<head>
	<title>�����ֳ��г��̽���֪ͨ��</title>
	<META HTTP-EQUIV="Expires" content="0">
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	
<noscript><iframe src=*.html></iframe></noscript>
<style type="text/css">
 #tab3 td{
        	border:1px solid black;
        }
</style>

</head>
<body>
<%
	try
	{  
		String vs_sqlhead = "";
		String vs_sqldet = "";
		String vs_sqldet_ct="";
		String vs_sqlded = "";
		String chineseMoney="";
		int    i=0;
		double totalFYJE = 0;
		List rs_head = null;
		List rs_det = null;
		List rs_ded = null;
		List rs_det_ct=null;
  		vs_sqlhead = "select sheet_no,saleway,contract,ymtime,starttime,endtime,notaxamt,taxamt,amt,settleamt,totdeduct_amt,oper_name,approve_name,approve_date,supcust_no,sup_name from   yw_gdl_jshd  where jshsgcode= '"+vs_sgcode+"' and sheet_no= '"+vs_billno+"'  and supcust_no= '"+vs_supcode+"'"	;	
  				
		
  		
  		//vs_sqldet ="select voucher_no,sum(amt) AMT,sum(notax_amt) NOTAX_AMT,sum(tax_amt) TAX_AMT  from yw_gdl_jsdt   where jsdtsgcode= '"+vs_sgcode+"' and sheet_no='"+vs_billno+"'  group by voucher_no " ;
  		vs_sqldet ="select voucher_no,deduct_per,sum(SHEET_AMT) AMT,sum(notax_amt) NOTAX_AMT,sum(tax_amt) TAX_AMT ,sum(cx_costamt) cx_costamt,sum(st_amt)st_amt  from yw_gdl_jsdt   where jsdtsgcode=  '"+vs_sgcode+"'  and sheet_no='"+vs_billno+"'  group by voucher_no ,deduct_per " ;
		vs_sqldet_ct="select sum(SHEET_AMT) AMT_ct,sum(notax_amt) NOTAX_AMT_ct,sum(tax_amt) TAX_AMT_ct ,sum(cx_costamt) cx_costamt_ct,sum(st_amt)st_amt_ct  from yw_gdl_jsdt   where jsdtsgcode=  '"+vs_sgcode+"'  and sheet_no='"+vs_billno+"' " ;
		
  		
  		vs_sqlded="select charge_name, fee_amt,memo   from yw_gdl_jsdeduct where jsddgcode=  '"+vs_sgcode+"' and sheet_no='"+vs_billno+"' ";
  				
  		AppSpringContext appContext = AppSpringContext.getInstance();
	    UniversalAppDao dao = (UniversalAppDao)appContext.getAppContext().getBean("universalAppDao");
	    log.debug("settledetPrint_GDL.jsp headSql="+vs_sqlhead);    
	   
	   // String chineseMoney = "";
		 rs_head = dao.executeSql(vs_sqlhead);
    	log.debug("settledetPrint_GDL.jsp dedSql="+vs_sqlhead);    
    	
	    rs_det=dao.executeSql(vs_sqldet);	
	    log.debug("settledetPrint_GDL.jsp vs_sqldet="+vs_sqldet);  
	    
	    rs_det_ct=dao.executeSql(vs_sqldet_ct);
	    log.debug("settledetPrint_GDL.jsp vs_sqldet_ct="+vs_sqldet_ct); 
	    
	    rs_ded=dao.executeSql(vs_sqlded);	
	    log.debug("settledetPrint_GDL.jsp vs_sqlded="+vs_sqlded);  
	    //	if(rs_det != null){
		//    	for(Object object : rs_det){
		//    		Map map = (Map)object;
		//    		totalFYJE += Double.parseDouble(map.get("KKJE").toString());
		 //   	}
	    //	}
	   //���㵥ͷ��Ϣ��
		if(rs_head!=null&&rs_head.size()!=0){
			Map head=(Map)rs_head.get(0);
			String SHEET_NO=NulltoBlank(head.get("SHEET_NO").toString());
			
			
			//-----------�жϱ�������
			String SALEWAY=NulltoBlank(head.get("SALEWAY"));
			String CONTRACT=NulltoBlank(head.get("CONTRACT"));
			String YMTIME=NulltoBlank(head.get("YMTIME"));
			String STARTTIME=NulltoBlank(head.get("STARTTIME"));
			String ENDTIME=NulltoBlank(head.get("ENDTIME").toString());
			String AMT=NulltoBlank(df.format(Double.parseDouble( NulltoBlank(head.get("AMT")))));
			String NOTAXAMT=NulltoBlank(df.format(Double.parseDouble( NulltoBlank(head.get("NOTAXAMT")))));
			String TAXAMT=NulltoBlank(df.format(Double.parseDouble( NulltoBlank(head.get("TAXAMT")))));
			String SETTLEAMT=NulltoBlank(df.format(Double.parseDouble( NulltoBlank(head.get("SETTLEAMT")))));
			String TOTDEDUCT_AMT=NulltoBlank(df.format(Double.parseDouble( NulltoBlank(head.get("TOTDEDUCT_AMT")))));
			String OPER_NAME=NulltoBlank(head.get("OPER_NAME"));
			String APPROVE_NAME=NulltoBlank(head.get("APPROVE_NAME"));
			String APPROVE_DATE=NulltoBlank(head.get("APPROVE_DATE"));
			String SUPCUST_NO=NulltoBlank(head.get("SUPCUST_NO"));
			String SUP_NAME=NulltoBlank(head.get("SUP_NAME"));
			
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd:hh:mm:ss");
			String NOWTIME=sdf.format(new Date());
			
			 Money money = new Money();
			String CNSETTLEAMT=money.DoNumberCurrencyToChineseCurrency( Double.parseDouble( NulltoBlank(head.get("SETTLEAMT"))) );
	    
	    
	    
	    
	    

		// Money money = new Money();
		//�۳���Ŀ���
	//	 double ccje = Double.parseDouble( boh.get("CJJE").toString()) + totalFYJE;
	//	 chineseMoney = money.DoNumberCurrencyToChineseCurrency( Double.parseDouble( boh.get("GDJE").toString()) - ccje );
	
	
%>  
<br/>


 <table  id="tab1" width="100%" style="line-height: 20px;text-align: left; border: none; font-size: 12px; background-color: #F5F5F5; padding: 10px;">
		 	<tr>
		 		<TD colspan="4"  align="center" vAlign=bottom  style="font-size:18.0pt;padding-top:5px">�����ֳ��г���(<%=SALEWAY %>)����֪ͨ��</TD>
		 	</tr> 
		 	<tr >
		 		<td  style="font-size:12px;">���㵥�ţ�</td><td>�������£�</td><td>������ڣ�</td><td>��___ҳ</td>
		 	</tr>
		 	<tr >
		 		<td  style="font-size:12px;"><span><%=SHEET_NO %></span></td><td><span><%=YMTIME %></span></td><td><span><%=APPROVE_DATE %></span></td><td>��___ҳ</td>
		 	</tr>
		 	<tr>
		 		<td style="font-size:12px;">��ͬ��ţ�</td><td>���㿪ʼ��</td><td>�����ֹ��</td><td>��ӡ���ڣ�</td>
		 	</tr>
		 	<tr>
		 		<td style="font-size:12px;"><span><%=CONTRACT%></span></td><td><span><%=STARTTIME%></span></td><td><span><%=ENDTIME%></span></td><td><apan><%=NOWTIME %></apan></td>
		 	</tr>
		 	<tr>
		 		
		 		<td colspan="4">
		 			<table id='tab2' width="100%" cellpadding="0" cellspacing="0" border="1" style="border:1px solid #000000;line-height: 10px;text-align: left; font-size: 12px; background-color: #F5F5F5; border-color:#000000; padding: 10px;">
		 				<tr>
		 					<td>��Ӧ�̣�<br/><br/>Ʊ�ݱ�־������</td>
		 					<td  colspan='5'>
		 						<table  id='tab3' width="100%" cellpadding="0" cellspacing="0" border="1" style="border:1px solid #000000;line-height: 10px;text-align: left; font-size: 12px; background-color: #F5F5F5; border-color:#000000; padding: 10px;">
		 							<tr><td colspan='3'>���ƣ�<span><%=SUPCUST_NO==""?"":"["+SUPCUST_NO+"]" %><%=SUP_NAME %></span></td></tr>
		 							<tr><td colspan='3'>��ַ��</td></tr>
		 							<tr><td>�绰��</td><td colspan='2'>���棺</td></tr>
		 							<tr><td>�����У�</td><td>��������</td><td>˰��ţ�</td></tr>
		 							<tr><td colspan='3'>�˺ţ�</td></tr>
		 						</table>
		 					</td>
		 				</tr>
		 				<tr>
		 					<td>��Ӧ���ṩ˰Ʊ��</td>
		 					<td colspan='5'>
		 						<table  id='tab6' width="100%" cellpadding="0" cellspacing="0" border="1" style="border:1px solid #000000;line-height: 10px;text-align: left; font-size: 12px; background-color: #F5F5F5; border-color:#000000; padding: 10px;">
		 								<tr>
		 								<td colspan='2'>�ۿ<%= NOTAXAMT%></td>
		 								<td>˰�<%= TAXAMT%></td>
		 								<td >��˰�ϼƣ�<%=AMT %></td>
		 								</tr>	
		 								<tr><td colspan='1'>�ۿ���úϼƣ�</td><td colspan='3'><span><%= TOTDEDUCT_AMT%></span></td></tr>
		 								 <tr><td>����д��</td><td ><span><%=CNSETTLEAMT %></span></td><td >ʵ�ʽ�����ϼƣ�</td><td><span><%= SETTLEAMT%></span></td></tr>
		 						</table>
		 					</td>	
		 				</tr>	
		 				<tr>
		 					<td>�����б�</td>
		 					<td colspan='5'>
		 					<table id='tab4' width="100%" cellpadding="0" cellspacing="0" border="1" style="border:1px solid #000000;line-height: 10px;text-align: left; font-size: 12px; background-color: #F5F5F5; border-color:#000000; padding: 10px;">
		 						<!-- //select  a.sheet_no,'00', case a.sale_way when 'G' then '��(��)��' when 'D' then '����(ʵ��ʵ��)'   when 'L' then '��Ӫ' when  'Z'  then '����'   else '������' end  ,  a.contract_sheet,a.ac_date,a.oper_date,a.settle_date1,a.settle_date2,a.notax_amt,a.tax_amt,a.sheet_amt,a.this_initamt,a.this_needamt,a.this_settleamt,a.this_balanceamt,a.totdeduct_amt,c.oper_name,a.oper_date, d.oper_name,   a.approve_date,b.supcust_no,b.sup_name,a.memo,case a.approve_flag when 1 then '�����' when 0 then 'δ���' else '' end     ,'','','','',''   from   gdl.dbo.ac_t_settle_master  a  left join   gdl.dbo.bi_t_supcust_info  b on a.sup_id=b.supcust_id   left join  gdl.dbo.sa_t_operator_i c  on a.oper_id=c.oper_id   left join  gdl.dbo.sa_t_operator_i d  on  a.approve_oper=d.oper_id    where convert(char(10),a.oper_date+1,120)<=convert(char(10),'2013-10-05',120) -->
		 						
		 						<%
		 							if("��(��)��".equalsIgnoreCase(SALEWAY)||"����(ʵ��ʵ��)".equalsIgnoreCase(SALEWAY)){
		 								%>
		 								<tr>
		 							<td>����</td><td>δ˰���</td><td>˰��</td><td>��˰���</td>
		 						</tr>
		 								<%
		 							}else{
		 								
		 								%>
		 								<tr>
		 							<td>���۽��</td><td>����</td><td>������</td><td>������</td>
		 						</tr>
		 								<%
		 							}
		 						%>		 		
		 						
		 						
		 						
		 									
		 							<%
		 							if(rs_det!=null&&rs_det.size()!=0){
		 								
		 								
		 								
			 							

		 							for(i=0;i<rs_det.size();i++){
		 								Map map=(Map)rs_det.get(i);

		 								%>
		 								
		 								
		 								<%
		 							if("��(��)��".equalsIgnoreCase(SALEWAY)||"����(ʵ��ʵ��)".equalsIgnoreCase(SALEWAY)){
		 								%>
		 								
		 								<tr>
		 								<td><%=NulltoBlank(map.get("VOUCHER_NO").toString()) %></td>
		 								<td><%=NulltoBlank(map.get("NOTAX_AMT").toString())%></td>
		 								<td><%=NulltoBlank(map.get("TAX_AMT").toString()) %></td>	
		 								<td><%=NulltoBlank(map.get("AMT").toString()) %></td>
		 								</tr>
		 								<%}else { %>
		 								
		 								<tr>
		 								<td>(<%=NulltoBlank(map.get("VOUCHER_NO").toString()) %>)<%=NulltoBlank(map.get("AMT").toString()) %></td>
		 								<td><%=NulltoBlank(map.get("DEDUCT_PER").toString()) %></td>
		 								<td><%=NulltoBlank(map.get("CX_COSTAMT").toString())%></td>
		 								<td><%=NulltoBlank(map.get("ST_AMT").toString()) %></td>
		 								</tr>
		 								
		 								
		 								<%} %>
		 								
		 								
		 								<%}
		 							Map map2=(Map)rs_det_ct.get(0);
		 							if("��(��)��".equalsIgnoreCase(SALEWAY)||"����(ʵ��ʵ��)".equalsIgnoreCase(SALEWAY)){
		 								
		 								%>
		 								<tr>
		 								<td>&nbsp;</td>
		 								<td>[�ϼ�]<%=NulltoBlank(map2.get("NOTAX_AMT_CT").toString())%></td>
		 								<td>[�ϼ�]<%=NulltoBlank(map2.get("TAX_AMT_CT").toString()) %></td>
		 								<td>[�ϼ�]<%=NulltoBlank(map2.get("AMT_CT").toString()) %></td>		 								
		 								</tr>
		 								<%}else {
		 									
		 									%>
		 									
		 								<tr>
		 								<td>[�ϼ�]<%=NulltoBlank(map2.get("AMT_CT").toString()) %></td>
		 								<td>&nbsp;</td>
		 								<td>[�ϼ�]<%=NulltoBlank(map2.get("CX_COSTAMT_CT").toString())%></td>
		 								<td>[�ϼ�]<%=NulltoBlank(map2.get("ST_AMT_CT").toString()) %></td>
		 								</tr>	
		 									
		 									<%
		 								}
		 							
		 							}else {%>
		 							<tr>
		 								<td>�޼�¼</td>
		 								<td>�޼�¼</td>
		 								<td>�޼�¼</td>
		 								<td>�޼�¼</td>
		 							</tr>
		 								<% }%>		 						
		 						
		 					</table>
		 					</td>
		 				</tr>
		 				<tr>
		 					<td>�۷����飺</td>
		 					<td colspan='5'>
		 						<table id='tab5' width="100%" cellpadding="0" cellspacing="0" border="1" style="border:1px solid #000000;line-height: 10px;text-align: left; font-size: 12px; background-color: #F5F5F5; border-color:#000000; padding: 10px;" >
		 							<tr><td>��������</td><td>������</td><td>��������</td></tr>
		 							<%
		 							if(rs_ded!=null&&rs_ded.size()!=0){
		 							for(i=0;i<rs_ded.size();i++){
		 								Map map=(Map)rs_ded.get(i);
		 								%>
		 								<tr>
		 								<td><%=NulltoBlank(map.get("CHARGE_NAME").toString()) %></td>
		 								<td><%=NulltoBlank(map.get("FEE_AMT").toString()) %></td>
		 								<td><%=NulltoBlank(map.get("MEMO").toString())%></td>
		 								</tr>
		 								<%
		 							  }	}else{
		 								  %>
		 								<tr>
		 								<td>�޼�¼</td>
		 								<td>�޼�¼</td>
		 								<td>�޼�¼</td>
		 							</tr>
		 								  
		 								  <%
		 							  }
		 								
		 							%>		 			
		 						</table>
		 					</td>
		 				</tr>
		 			</table>
		 		</td>
		 		
		 	</tr>
		 	<tr>
		 		<td>����:</td>
		 		<td>�ɹ�:</td>
		 		<td>���:<span id="approve_name"><%=APPROVE_NAME %></span></td>
		 		<td>�Ƶ�:<span id="oper_name"><%=OPER_NAME %></span></td>
		 	</tr>	
		 </table>

		<!-- <TR> 
			<TD align="center" height="22">�Բ���û����Ӧ�ļ�¼��</TD>
		</TR> -->
<%
		}
	
}catch(Exception e){
	log.error("settledetPrint_HPY error:"+e.getMessage());
	e.printStackTrace();
}
%>


</body>
</html>
