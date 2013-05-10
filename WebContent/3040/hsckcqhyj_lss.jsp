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
<title>好收成库存缺货预警查询</title>
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

$(function(){
	//结算单头
	$('#hsckcqhyjDataGrid').datagrid({
		width:1000,
		nowrap: false,
		striped: true,
		url:'',		
		fitColumns:false,
		remoteSort: true,
		singleSelect: true,
		showFooter:true,				
		loadMsg:'加载数据...',
		columns:[[				
			{field:'ORGNAMEALL',title:'组织名称',width:150,align:'left'},
			{field:'CATNAMEALL',title:'类别名称',width:150,align:'left',sortable:true},
			{field:'PPNAMEALL',title:'品牌名称',width:150,align:'left',sortable:true},
			{field:'ZSGDID',title:'商品编码',width:80,align:'center',sortable:true},
			{field:'ZSBARCODE',title:'商品条码',width:120,align:'center',sortable:true},				
			{field:'GDNAME',title:'商品名称', width:250,sortable:true,align:'left'},
			{field:'GDSPEC',title:'商品规格',width:80,align:'center',sortable:true},
			{field:'GDUNIT',title:'商品单位',width:80,align:'center',sortable:true},
			{field:'KCSL',title:'库存数量',width:80,align:'center',sortable:true},
			{field:'KCJE',title:'库存金额',width:80,align:'center',sortable:true},
			{field:'XSSL',title:'销售数量',width:80,align:'center',sortable:true},
			{field:'XSJE',title:'销售金额',width:80,align:'center',sortable:true},
			{field:'RJXL',title:'日均销量',width:80,align:'center',sortable:true},
			{field:'KXTS',title:'可销天数',width:100,align:'center',sortable:true},	
			{field:'ZJJHRQ',title:'最近进货日期',width:80,align:'left',sortable:true},
			{field:'ZJXSRQ',title:'最近销售日期',width:80,align:'center',sortable:true},
			{field:'ZZL',title:'周转率',width:80,align:'center',sortable:true},
			{field:'ZZTS',title:'周转天数',width:80,align:'center',sortable:true}
		]],
		pagination:true,
		rownumbers:true
	});
});

function reloadgrid(){
	$('#hsckcqhyjDataGrid').datagrid('options').url = 'JsonServlet';        
	$('#hsckcqhyjDataGrid').datagrid('options').queryParams = {
		data :obj2str(
			{		
				ACTION_TYPE : 'getHSCKCYJ',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',		 
				list:[{
					sgcode : '<%=sgcode%>',
					orgcode : $("#orgcode").val(),
					catid : $("#catid").val(),
					ppid : $("#ppid").val(),
					yjDays : $("#yjDays").val(),
					startDate : $("#startDate").val(),
					endDate : $("#endDate").val()
				}]
			}
		)
	};
	$("#hsckcqhyjDiv").show();
	$("#hsckcqhyjDataGrid").datagrid('reload'); 
	$("#hsckcqhyjDataGrid").datagrid('resize'); 
}

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

</script>
</head>
<body>
	<center>
		<!-- 查询区域 -->
		<form id="queryForm">
			<table style="width:1000px;font-size: 12px;">
				<tr><td colspan="6" align="left" style="color: #4574a0;">商品库存缺货预警查询</td></tr>
				<tr>
					<td align="right">门店名称：</td>
					<td align="left">
						<select style="width: 155px;" name='orgcode' id="orgcode" size='1'>
							<option value=''>所有门店</option>
						</select>
					</td>
					<td align="right">品类编码：</td>
					<td align="left">
						<input type="text" id="catid" name="catid" size="20"/>
					</td>
					<td align="right">品牌编码：</td>
					<td align="left">
						<input type="text" id="ppid" name="ppid" size="20"/>
					</td>
				</tr>
				<tr>
					<td align="right">开始日期：</td>
					<td align="left">
						<input type="text" id="startDate" name="startDate" type="text" onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'endDate\')}'});"size="20"></input>
					</td>
					<td align="right">结束日期：</td>
					<td align="left">
						<input type="text" id="endDate" name="endDate" type="text" onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'startDate\')}',maxDate:'%y-%M-%d'});"></input>
					</td>
					<td align="right">预警天数：</td>
					<td align="left">
						<input type="text" id="yjDays" name="yjDays" size="20"/>
					</td>
				</tr>
				<tr>
					<td colspan="6" align="left">
						<img src="images/sure.jpg" border="0" onclick="reloadgrid()"/>
					</td>
				</tr>
			</table>
		</form>
		<div id="hsckcqhyjDiv" style="display: none;width: 800px;">
			<table id="hsckcqhyjDataGrid"></table>
		</div>
	</center>
</body>
</html>