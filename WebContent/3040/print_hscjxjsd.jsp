<%@page import="javax.servlet.jsp.tagext.TryCatchFinally"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="com.bfuture.app.basic.AppSpringContext"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<%@page import="com.bfuture.app.saas.service.HscManager"%>
<%@page import="com.bfuture.app.saas.model.HscBean" %>
<%@page import="com.bfuture.app.basic.model.ReturnObject"%>
<% 
Map mapJsdHead = null;
List listYwdjRow = null;
List ListYwdjSum = null;
Map mapYwdjSum = null;
List listfsltjRow = null;
Map mapfsltjRow = null;
List listkkmxRow = null;
Map mapkkmxRow = null;
String billno = request.getParameter("billno");
String orgcode = (String)request.getParameter("orgcode");
try{
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	SysScmuser scmuser = (SysScmuser)obj;
	String sgcode = scmuser.getSgcode();
	AppSpringContext appContext = AppSpringContext.getInstance();
	HscManager ybdetManager = (HscManager)appContext.getAppContext().getBean("hscManager");
	HscBean hscBean = new HscBean();
	hscBean.setSgcode(sgcode);
	hscBean.setBillno(billno);
	hscBean.setOrgcode(orgcode);
	//得到结算单头信息
	ReturnObject hscBeanHeadList = ybdetManager.ExecOther("getHSCJXJSDHead", new Object[]{hscBean});
	List listHeadRow = hscBeanHeadList.getRows();
	mapJsdHead = (Map)(listHeadRow.get(0));
	
	//得到结算单明细信息
	ReturnObject hscBeanYwdjList = ybdetManager.ExecOther("getywdj", new Object[]{hscBean});
	listYwdjRow = hscBeanYwdjList.getRows();
	ListYwdjSum = hscBeanYwdjList.getFooter();
	mapYwdjSum = (Map)ListYwdjSum.get(0);
	
	ReturnObject hscBeanFsltjList = ybdetManager.ExecOther("getfsltj", new Object[]{hscBean});
	listfsltjRow = hscBeanFsltjList.getRows();
	mapfsltjRow = (Map)(hscBeanFsltjList.getFooter().get(0));
	
	ReturnObject hscBeanKkmxList = ybdetManager.ExecOther("getkkmx", new Object[]{hscBean});
	listkkmxRow = hscBeanKkmxList.getRows();
	mapkkmxRow = (Map)(hscBeanKkmxList.getFooter().get(0));
	
}catch(Exception e){
	
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>经销打印页面</title>
<style type="text/css">
<!--
.STYLE1 {font-size: 24px}
.lineBorder {
	border: 2px solid #000000;
}
-->
</style>
<script type="text/javascript" language="javascript">
function showslmx(){
	var billno = "<%=billno%>";
	var orgcode = "<%=orgcode%>";
    //在url中指定打印执行页面
    var url = "hscjxslmx.jsp?billno="+billno+"&orgcode="+orgcode;					
	window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');	
}

</script>
</head>
<body>
	<center>
		<table style="width: 800px;height: 600px;font-size: 12px;" border="0">
		   <tr><td colspan="2"><div align="center"><font class="5 STYLE1"><b>好收成超市应付结算单经销明细表</b></font></div></td></tr>
			<tr>
				<td width="73" align="right">单&nbsp;&nbsp;&nbsp;&nbsp;据&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
				<td width="717" align="left"><%=mapJsdHead.get("BILLNO")%></td>
			</tr>
			<tr>
				<td align="right">结&nbsp;算&nbsp;&nbsp;部&nbsp;门：</td>
				<td align="left"><%=mapJsdHead.get("ORGNAME")%></td>
			</tr>
			<tr>
				<td align="right">合&nbsp;同&nbsp;&nbsp;编&nbsp;码：</td>
				<td align="left"><%=mapJsdHead.get("HTCODE")%></td>
			</tr>
			<tr>
				<td align="right">合&nbsp;同&nbsp;&nbsp;名&nbsp;称：</td>
				<td align="left"><%=mapJsdHead.get("HTNAME")%></td>
			</tr>
			<tr>
				<td align="right">供应商编码：</td>
				<td align="left"><%=mapJsdHead.get("SUPCODE")%></td>
			</tr>
			<tr>
				<td align="right">供应商名称：</td>
				<td align="left"><%=mapJsdHead.get("SUPNAME")%></td>
			</tr>
			<tr>
				<td colspan="2" align="left">
					<%if(listYwdjRow.size()>0){%>
						<table style="width: 100%;font-size: 12px;border-collapse: collapse;" border="0">
						<tr>
							<th  class="lineBorder">业务组织名称</th>
							<th  class="lineBorder">业务单据号</th>
							<th  class="lineBorder">备注</th>
							<th  class="lineBorder">含税进价金额</th>
						</tr>
						<%for(int i = 0 ; i < listYwdjRow.size();i++){
							Map mapYwdj = (Map)listYwdjRow.get(i);
							if(mapYwdj != null){%>
							<tr>
								<td  class="lineBorder"><%=mapYwdj.get("YWORGNAME")%></td>
								<td  class="lineBorder"><%=mapYwdj.get("YWBILLNO")%></td>
								<td  class="lineBorder"><%=mapYwdj.get("REMARK")%></td>
								<td  class="lineBorder"><%=mapYwdj.get("HJTOTAL")%></td>
							</tr>
							<%}
						}%>
						<tr>
							<td  class="lineBorder">合计：</td>
							<td  class="lineBorder">&nbsp;</td>
							<td  class="lineBorder">&nbsp;</td>
							<td  class="lineBorder"><%=mapYwdjSum.get("HJTOTAL")%></td>
						</tr>
					</table>
					<%}else{%>
						系统中没有找到您的记录
					<%}%>
				</td>
			</tr>
			<tr><td colspan="2" align="right"><a href="javascript:showslmx();">税率明细</a></td></tr>
			<tr><td colspan="2" align="left"><b>税率信息</b></td></tr>
			<%if(listfsltjRow.size()>0){%>
				<tr>
				<td colspan="2" align="left">
					<table style="width: 100%;font-size: 12px;border-collapse: collapse;"  border="0">
						<tr>
							<th   class="lineBorder">序号</th>
							<th  class="lineBorder">含税进价金额</th>
							<th  class="lineBorder">进项税率(%)</th>
							<th  class="lineBorder">无税进价金额</th>
							<th  class="lineBorder">进项税额</th>
						</tr>
						<%for(int i = 0 ; i < listfsltjRow.size();i++){
							Map mapfsltj = (Map)listfsltjRow.get(i);
							if(mapfsltj != null){%>
							<tr>
								<td  class="lineBorder"><%=i+1%></td>
								<td  class="lineBorder"><%=mapfsltj.get("HJTOTAL")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("JTAXRATE")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("WJTOTAL")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("JTAXTOTAL")%></td>
							</tr>
							<%}
						}%>
						<tr>
							<td  class="lineBorder">合计：</td>
							<td  class="lineBorder"><%=mapfsltjRow.get("HJTOTAL") %></td>
							<td  class="lineBorder">&nbsp;</td>
							<td  class="lineBorder"><%=mapfsltjRow.get("WJTOTAL") %></td>
							<td  class="lineBorder"><%=mapfsltjRow.get("JTAXTOTAL") %></td>
						</tr>
					</table>
				</td>
			</tr>
			<%}else{%>
				<tr>
					<td colspan="2" align="left">系统中没有找到您的记录</td>
				</tr>
			<%}%>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2" align="left"><b>&nbsp;&nbsp;开票信息</b></td></tr>
			<tr>
				<td colspan="2">
					<table style="width: 100%;font-size: 12px;">
						<tr>
							<td width="8%" align="right">公司名称：</td>
							<td width="92%" align="left">天津市好收成商贸有限公司</td>
						</tr>
						<tr>
							<td align="right">税&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
							<td align="left">120104718254376</td>
						</tr>
						<tr>
							<td align="right">地&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
							<td align="left">天津市南开区红磡标志大厦G01号</td>
						</tr>
						<tr>
							<td align="right">电&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
							<td align="left">022-87410433</td>
						</tr>
						<tr>
							<td align="right">开&nbsp;&nbsp;户&nbsp;&nbsp;行：</td>
							<td align="left">建行新兴路分理处</td>
						</tr>
						<tr>
							<td align="right">帐&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
							<td align="left">1200161800050000431</td>
						</tr>
						<tr>
							<td align="right">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
							<td align="left">供应商确认无误后加盖财务章并打印</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2"><hr /></td>
			</tr>
		</table>
		<table style="width:800px;font-size: 12px;" border="0">
			<tr>
				<td width="8%" align="right">合&nbsp;同&nbsp;&nbsp;编&nbsp;码：</td>
				<td width="92%" align="left"><%=mapJsdHead.get("HTCODE")%></td>
			</tr>
			<tr>
				<td align="right">合&nbsp;同&nbsp;&nbsp;名&nbsp;称：</td>
				<td align="left"><%=mapJsdHead.get("HTNAME")%></td>
			</tr>
			<tr>
				<td align="right">供应商编码：</td>
				<td align="left"><%=mapJsdHead.get("SUPCODE")%></td>
			</tr>
			<tr>
				<td align="right">供应商名称：</td>
				<td align="left"><%=mapJsdHead.get("SUPNAME")%></td>
			</tr>
			<tr>
				<td colspan="2">
					<%if(listkkmxRow.size()>0){%>
						<table style="width: 100%;font-size: 12px;border-collapse: collapse;">
							<tr>
								<th class="lineBorder" style="width: 50%">扣款项目</th>
								<th class="lineBorder" style="width: 50%">扣款金额</th>
							</tr>
							<%for(int i = 0 ; i < listkkmxRow.size();i++){
								Map mapkkmx = (Map)listkkmxRow.get(i);
								if(mapkkmx != null){%>
								<tr>
									<td  class="lineBorder"><%=mapkkmx.get("KXNAME")%></td>
									<td  class="lineBorder"><%=mapkkmx.get("RATEBASE")%></td>
								</tr>
								<%}
							}%>
							<tr>
								<td  class="lineBorder">合计：</td>
								<td  class="lineBorder"><%=mapkkmxRow.get("RATEBASE") %></td>
							</tr>
						</table>
					<%}else{%>
						系统中没有查询到您的记录
					<%}%>
				</td>
			</tr>
		</table>
	</center>
</body>
</html>