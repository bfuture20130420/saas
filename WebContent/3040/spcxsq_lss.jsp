<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>零售商商品促销申请</title>
<script type="text/javascript" language="javascript">

	function searchCXSHLSS(){
		
		
	}
	
</script>
</head>
<body>
<center>
<div id="spcxsqlss_mainPanel" class="easyui-panel" style="width: 800px;height: 600px;">
	
</div>
<div id="spcxsqlss_searchWindow" class="easyui-window" closed="true" style="width: 400px;height: 300px;">
	<table width="100%">
		<tr>
			<td align="right">开始时间:</td>
			<td>
				<input />
			</td>
		</tr>
		<tr>
			<td align="left">结束时间:</td>
			<td>
				<input />
			</td>
		</tr>
		<tr>
			<td align="left">供应商编码:</td>
			<td>
				<input />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a id="tijiao" name="tijiao" class="easyui-linkbutton" iconCls="icon-ok" href="javascript:searchCXSHLSS();">确定</a>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="chongzhi" name="chongzhi" class="easyui-linkbutton" iconCls="icon-reload" href="javascript:searchCXSHLSS();">重置</a>
			</td>
		</tr>
	</table>
</div>
<div>
	<table id="spcxsqlssDataGrid"></table>
</div>
</center>
</body>
</html>