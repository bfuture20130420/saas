<%@ page language="java" import="java.util.Date,java.text.*" contentType="text/html; charset=GBK"pageEncoding="GBK"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.basic.dao.UniversalAppDao"%>
<%@page import="java.util.Map"%>
<%@page import="com.bfuture.app.saas.util.Money"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="com.bfuture.app.saas.util.Money" %>
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

	
	String supcode =  request.getParameter("gys");
	String vs_billno = request.getParameter("billno");
	String vs_sgcode = request.getParameter("sgcode");
	String isShowFY = request.getParameter("isShowFY");

	NumberFormat df = NumberFormat.getInstance();
	df.setMaximumFractionDigits(2);
	df.setMinimumFractionDigits(2);	
%>
 
<html>
<head>
	<title>购得乐超市厂商结算通知单</title>
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
		String vs_sqlKxdet = "";
		int    i=0;
		double totalFYJE = 0;
		List rs_head = null;
		List rs_kxdet = null;
		
  		vs_sqlhead = "select A.JSDH,A.CSBM,SUPNAME,to_char(LRRQ,'yyyy-MM-dd HH24:mi:ss') LRRQ,to_char(HDRQ,'yyyy-MM-dd HH24:mi:ss') HDRQ,"+
					 " GZRQ,DEPT_ID,GDJE,TZJE,JSJE,ZT,LRR,HDR,CJJE,YFJE,A.TEMP1 AS FYJE FROM HYT_JSZX_CSGDZB_GDL A,INF_SUPINFO B WHERE A.SGCODE = B.SUPSGCODE AND A.CSBM = B.SUPID AND A.SGCODE = '" 
					 + vs_sgcode + "' AND A.JSDH = '" + vs_billno + "'" +"AND A.CSBM='"+ supcode+"' ";
				
		AppSpringContext appContext = AppSpringContext.getInstance();
	    UniversalAppDao dao = (UniversalAppDao)appContext.getAppContext().getBean("universalAppDao");
	    log.debug("settledetPrint_GDL.jsp headSql="+vs_sqlhead);    
	    rs_head = dao.executeSql(vs_sqlhead);
	    String chineseMoney = "";
	    
	    if("true".equals(isShowFY)){
	    	vs_sqlKxdet = "SELECT KKMC,KKJE FROM HYT_JSZX_JSDKKB_GDL WHERE SGCODE='"+vs_sgcode+"' AND JSDH='"+vs_billno+"'";
	    	log.debug("settledetPrint_GDL.jsp kxdetSql="+vs_sqlKxdet);   
	    	rs_kxdet = dao.executeSql(vs_sqlKxdet);
	    	if(rs_kxdet != null){
		    	for(Object object : rs_kxdet){
		    		Map map = (Map)object;
		    		totalFYJE += Double.parseDouble(map.get("KKJE").toString());
		    	}
	    	}
	    }

%>
<br/>
<center>
<table id ="tab1" border="0" align="center" cellpadding="0" cellspacing="0">

<% 
if( rs_head != null && rs_head.size() > 0 )
{   
		 Map boh = (Map)rs_head.get( 0 ); 
		 i++;
		 Money money = new Money();
		//扣除项目金额
		 double ccje = Double.parseDouble( boh.get("CJJE").toString()) + totalFYJE;
		 chineseMoney = money.DoNumberCurrencyToChineseCurrency( Double.parseDouble( boh.get("GDJE").toString()) - ccje );
%>  
<TR style="font-size:30px;">
	<TD>
		<table id="tab2" width="100%" style="line-height: 20px;text-align: left; border: none; font-size: 12px; background-color: #F5F5F5; padding: 10px;">
			<TR>
				<TD width="250px;">
					<h3>购得乐超市</h3>
				</TD>
				<td width="300px;">
					<h2>厂商结算通知单</h2>
				</td>
				<td width="250px;">
					通知单号：<span style="text-decoration:underline;" id="JSDH">
						<%=NulltoBlank( boh.get("JSDH"))%>
					</span>
				</td>
			</TR>
			<TR>
				<TD>
					<strong>抽单金额：<span style="text-decoration:underline;" id="GDJE">
						<%=NulltoBlank(df.format(Double.parseDouble( boh.get("GDJE").toString())))%>
					</span></strong>
				</TD>
				<TD>&nbsp;</TD>
				<TD>
					付款月份：<span style="text-decoration:underline;" id="GZRQ">
						<%=NulltoBlank( boh.get("GZRQ"))%>
					</span>	
				</TD>
			</TR>
			<TR>
				<td>
					<strong>扣除项目：<span style="text-decoration:underline;" id="CJJE">
						<%=NulltoBlank(df.format( ccje ))%>
					</span></strong>
				</td>
				<td>
					<table>
						<tr>
							<td valign="bottom">
								其<br/>
								中
							</td>
							<td>
								<table id="tab3" width="150px" style="border:1px solid black;" cellpadding="0" cellspacing="0">
									<tr style="border:1px solid black;">
										<td width="90px;">调整金额：</td>
										<td width="60px;">
											<span id="CJJE2">
												<%=NulltoBlank(df.format(Double.parseDouble( boh.get("CJJE").toString())))%>
											</span>
										</td>
									</tr>
									<tr style="border:1px solid black;">
										<td>预付金额：</td>
										<td>
											<span id="YFJE">
												<%=NulltoBlank(df.format(Double.parseDouble(boh.get("YFJE").toString())))%>
											</span>
										</td>
									</tr>
									<tr style="border:1px solid black;">
										<td>费用金额：</td>
										<td>
											<span id="FYJE">
												<%=NulltoBlank(df.format(totalFYJE))%>
											</span>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
				<td valign="top">
					核对标志：<span style="text-decoration:underline;">核对</span>
				</td>
			</TR>
			<TR>
				<TD colspan="3">
					<span style="text-decoration:underline;">
						<strong>本次实付：</strong>
						<span style="font-size: 22px;">
							大写金额：<span id="cMoney"><%=chineseMoney %></span>
							(小写)&nbsp;&nbsp;
							<strong><span id="GDJE2">
								<%=NulltoBlank(df.format(  Double.parseDouble( boh.get("GDJE").toString()) - ccje ))%>
							</span></strong>
						</span>
					</span>
				</TD>
			</TR>
			<tr>
				<td colspan="3">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr style="text-decoration:underline;" >
							<td>序号</td>
							<td>厂商编码</td>
							<td>厂商名称</td>
							<td>部门</td>
							<td>结算金额</td>
							<td>调整金额</td>
						</tr>
						<tr style="text-decoration:underline;" >
							<td>1</td>
							<td>
								<span id="CSBM">
									<%=NulltoBlank( boh.get("CSBM"))%>
								</span>
							</td>
							<td>
								<SPAN ID="SUPNAME">
									<%=NulltoBlank( boh.get("SUPNAME"))%>
								</SPAN>
							</td>
							<td>
								<SPAN ID="DEPT_ID">
									<%=NulltoBlank( boh.get("DEPT_ID"))%>
								</SPAN>
							</td>
							<td>
								<SPAN ID="GDJE3">
									<%=NulltoBlank(df.format(Double.parseDouble( boh.get("GDJE").toString())))%>
								</SPAN>
							</td>
							<td>
								<SPAN ID="TZJE">
									<%=NulltoBlank(df.format(Double.parseDouble( boh.get("TZJE").toString())))%>
								</SPAN>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<table width="100%" style="border:1px solid black;" cellpadding="0" cellspacing="0">	
						<TR>
							<TD WIDTH="10px;" style="border:1px solid black;">
								备注
							</TD>
							<TD>
								<TABLE width="100%" style="border:1px solid black;" cellpadding="0" cellspacing="0">
									<tr height='50px;'>
										<td colspan="3">
											<span id="BZ">
												<% if(rs_kxdet != null){
													for(int k=0;k<rs_kxdet.size();k++){
											    		Map map = (Map)rs_kxdet.get(k);
											    	%>
											    	<%=k+1 %>、<%=NulltoBlank(map.get("KKMC")) %>(<%=df.format( Double.parseDouble(map.get("KKJE").toString()) )%>)<br/>
											    <%		
											    	}
												} %>
											</span> 
										</td>
									</tr>
									<tr>
										<td colspan="3">&nbsp;</td>
									</tr>
									<tr>
										<td>
											输入：
											<span id="LRR">
												<%=NulltoBlank( boh.get("LRR"))%>
											</span>&nbsp;&nbsp;
											<span id="LRRQ">
												<%=NulltoBlank( boh.get("LRRQ"))%>
											</span>
										</td>
										<td>
											核对：
											<span id="HDR">
												<%=NulltoBlank( boh.get("HDR"))%>
											</span>&nbsp;&nbsp;
											<span id="HDRQ">
												<%=NulltoBlank( boh.get("HDRQ"))%>
											</span>
										</td>
										<td>
											打印：
										</td>
									</tr>
								</TABLE>
							</TD>
						</TR>
					</table>
				</td>
			</tr>
			<tr>
				<td>出&nbsp;&nbsp;&nbsp;&nbsp;纳：</td>
				<td>财务经理：</td>
				<td>厂商：</td>
			</tr>
			<tr>
				<td>领导批示：</td>
				<td>结&nbsp;&nbsp;&nbsp;&nbsp;算：</td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</TD>
</TR>		
<%
	} 
	rs_head = null;
	if (i == 0)
	{
%> 
		<TR> 
			<TD align="center" height="22">对不起，没有相应的记录！</TD>
		</TR>
<%
	}
}catch(Exception e){
	log.error("settledetPrint_HPY error:"+e.getMessage());
}
%>

</table>
</center>
</body>
</html>
