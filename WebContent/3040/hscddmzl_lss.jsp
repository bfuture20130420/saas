<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bfuture.app.saas.model.SysScmuser"%>
<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sgcode = currUser.getSgcode();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>好收成订单满足率查询</title>
<script type="text/javascript" language="javascript">
var now1 = new Date();
now1.setDate( now1.getDate() - 7 );
$("#startDate").val(now1.format('yyyy-MM-dd'));	
var now2 = new Date();
now2.setDate( now2.getDate() - 1 );
$("#endDate").val(now2.format('yyyy-MM-dd'));

//加载门店
var obj = document.getElementById("orgcode");
loadAllShop(obj);

//获取所有门店信息
function loadAllShop( list ){
	if( $(list).attr('isLoad') == undefined ){
		$.post( 'JsonServlet',				
			{
				data : obj2str({		
						ACTION_TYPE : 'datagrid',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.Shop',
						ACTION_MANAGER : 'shopManager',	
						list:[{									
							sgcode : User.sgcode
						}]
				})
				
			}, 
			function(data){ 
                   if(data.returnCode == '1' ){
                   	 if( data.rows != undefined && data.rows.length > 0 ){	                    	 	
                   	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
				            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
				            $(list).append(html);  
				        });						        
                   	 }	                    	 
                   	 $(list).attr('isLoad' , true );
                   }else{ 
                       $.messager.alert('提示','获取门店信息失败!<br>原因：' + data.returnInfo,'error');
                   } 
           	},
           	'json'
           );				
	}
}

$(function(){
	//结算单头
	$('#hscddmzlDataGrid').datagrid({
		width:990,
		nowrap: false,
		striped: true,
		url:'',		
		fitColumns:false,
		remoteSort: true,
		singleSelect: true,
		showFooter:true,				
		loadMsg:'加载数据...',
		columns:[[				
			{field:'ORGNAMEALL',title:'组织名称',width:165,align:'left'},
			{field:'DDZS',title:'订单张数',width:60,align:'center',sortable:true},
			{field:'DHSL',title:'订货数量',width:80,align:'center',sortable:true},
			{field:'SJSL',title:'实到数量',width:80,align:'center',sortable:true},
			{field:'LXDDS',title:'履行订单数',width:70,align:'center',sortable:true},				
			{field:'WQLXDDS',title:'完全履行订单数', width:90,sortable:true,align:'center'},
			{field:'ZSDHDDS',title:'准时到货订单数',width:90,align:'center',sortable:true},
			{field:'DDZXL',title:'订单执行率(%)',width:85,align:'center',sortable:true},
			{field:'DDMZL',title:'订单满足率(%)',width:85,align:'center',sortable:true},
			{field:'DDZSL',title:'订单准时率(%)',width:85,align:'center',sortable:true},
			{field:'ZZTS',title:'周转天数',width:60,align:'center',sortable:true},
			{field:'SUPNAMEALL',title:'供应商名称',width:300,align:'left',sortable:true}
		]],
		pagination:true,
		rownumbers:true
	});
});

function reloadgrid(){
	$('#hscddmzlDataGrid').datagrid('options').url = 'JsonServlet';        
	$('#hscddmzlDataGrid').datagrid('options').queryParams = {
		data :obj2str(
			{		
				ACTION_TYPE : 'getHSCDDMZL',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',		 
				list:[{
					sgcode : '<%=sgcode%>',
					startDate : $("#startDate").val(),
					endDate : $("#endDate").val(),
					orgcode : $("#orgcode").val(),
					supcode : $("#supcode").val()
				}]
			}
		)
	};
	$("#hscddmzlDiv").show();
	$("#hscddmzlDataGrid").datagrid('reload'); 
	$("#hscddmzlDataGrid").datagrid('resize'); 
}
</script>
</head>
<body>
	<center>
		<form id="queryForm">
			<table style="width:1000px;font-size: 12px;">
				<tr><td colspan="8" align="left" style="color: #4574a0;">好收成订单满足率查询</td></tr>
				<tr>
					<td align="right">门店名称：</td>
					<td align="left">
						<select style="width: 155px;" name='orgcode' id="orgcode" size='1'>
							<option value=''>所有门店</option>
						</select>
					</td>
					<td align="right">开始日期：</td>
					<td align="left">
						<input type="text" id="startDate" name="startDate" type="text" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20"></input>
					</td>
					<td align="right">结束日期：</td>
					<td align="left">
						<input type="text" id="endDate" name="endDate" type="text" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});"></input>
					</td>
					<td align="right">供应商编码：</td>
					<td align="left">
						<input type="text" id="supcode" name="supcode" size="20"/>
					</td>
				</tr>
				<tr>
					<td colspan="8" align="left">
						<img src="images/sure.jpg" border="0" onclick="reloadgrid()"/>
					</td>
				</tr>
			</table>
		</form>
		<div id="hscddmzlDiv" style="display: none;width: 1000px;">
			<table id="hscddmzlDataGrid"></table>
		</div>
	</center>
</body>
</html>