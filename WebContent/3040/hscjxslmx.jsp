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

List listfsltjRow = null;
Map mapfsltjRow = null;
try{
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	SysScmuser scmuser = (SysScmuser)obj;
	String sgcode = scmuser.getSgcode();
	String billno = request.getParameter("billno");
	String orgcode = (String)request.getParameter("orgcode");
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
	ReturnObject hscBeanFsltjList = ybdetManager.ExecOther("getfsltjsum", new Object[]{hscBean});
	listfsltjRow = hscBeanFsltjList.getRows();
	mapfsltjRow = (Map)(hscBeanFsltjList.getFooter().get(0));
}catch(Exception e){
	
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>税率明细</title>
<style type="text/css">
<!--
.STYLE1 {font-size: 24px}
.lineBorder {
	border: 2px solid #000000;
}
-->
</style>
<script type="text/javascript" language="javascript">
function printJSD(){
	var billno = $('#hiddenValue').val();
    //在url中指定打印执行页面
    var url = "3040/print_hscjxjsd.jsp?billno=" + billno;					
	window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');	
}

</script>
</head>
<body>
	<center>
		<table style="width: 800px;font-size: 12px;" border="0">
		   <tr><td colspan="2"><div align="center"><font class="5 STYLE1"><b>好收成超市应付结算单税额明细表</b></font></div></td></tr>
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
				<td colspan="2">
					<table style="width: 100%;font-size: 12px;border-collapse: collapse;" border="0">
						<tr>
							<th  class="lineBorder">业务组织名称</th>
							<th  class="lineBorder">业务单据号</th>
							<th  class="lineBorder">业务类型</th>
							<th  class="lineBorder">17%税额</th>
							<th  class="lineBorder">13%税额</th>
							<th  class="lineBorder">未税金额</th>
							<th  class="lineBorder">含税金额</th>
						</tr>
						<%for(int i = 0 ; i < listfsltjRow.size();i++){
							Map mapfsltj = (Map)listfsltjRow.get(i);
							if(mapfsltj != null){%>
							<tr>
								<td  class="lineBorder"><%=mapfsltj.get("YWORGNAME")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("YWBILLNO")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("REMARK")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("TAX2")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("TAX1")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("WJTOTAL")%></td>
								<td  class="lineBorder"><%=mapfsltj.get("HJTOTAL")%></td>
							</tr>
							<%}
						}%>
						<tr>
							<td  class="lineBorder">合计：</td>
							<td  class="lineBorder">&nbsp;</td>
							<td  class="lineBorder">&nbsp;</td>
							<td  class="lineBorder"><%=mapfsltjRow.get("TAX2")%></td>
							<td  class="lineBorder"><%=mapfsltjRow.get("TAX1")%></td>
							<td  class="lineBorder"><%=mapfsltjRow.get("WJTOTAL")%></td>
							<td  class="lineBorder"><%=mapfsltjRow.get("HJTOTAL")%></td>
						</tr>
					</table>
				</td>
			</tr>
			</table>	
	</center>
</body>
</html>