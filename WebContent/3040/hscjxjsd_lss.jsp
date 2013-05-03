<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
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
<title>好收成经销结算单查询</title>
<script type="text/javascript" language="javascript">
$(function(){
	//结算单头
	$('#jxjsdHeadDataGrid').datagrid({
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
			{field:'BILLNO',title:'结算单号',width:150,align:'center',
				formatter:function(value,rec){
					if(value == '合计'){
						return value;
					}else{
						return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="showjxjsdDetailWindow('+value+');">' + value + '</a>';	
					}										
				}	
			},
			{field:'LRDATE',title:'录入日期',width:80,align:'center',sortable:true},
			{field:'HYFTOTAL',title:'含税进货金额',width:80,align:'center',sortable:true},				
			{field:'WYFTOTAL',title:'无税进货金额', width:80,sortable:true,align:'center'},
			{field:'JTAXTOTAL',title:'进项税额',width:80,align:'center',sortable:true},
			{field:'TCTOTAL',title:'折扣金额',width:80,align:'center',sortable:true},
			{field:'YFTOTAL',title:'本次应付金额',width:80,align:'center',sortable:true},
			{field:'TZTOTAL',title:'本次调整金额',width:80,align:'center',sortable:true},
			{field:'SFTOTAL',title:'实际应付金额',width:80,align:'center',sortable:true},
			{field:'SFTOTAL',title:'已开发票金额',width:80,align:'center',sortable:true},
			{field:'SFTOTAL',title:'已付款金额',width:80,align:'center',sortable:true},
			{field:'SUPCODE',title:'供应商编码',width:100,align:'center',sortable:true},	
			{field:'SUPNAME',title:'供应商名称',width:250,align:'left',sortable:true}
		]],
		toolbar:[{
			text:'导出Excel',
			iconCls:'icon-redo',
			handler:function(){
				exportExcel();
			}
		}],
		pagination:true,
		rownumbers:true
	});

	$('#jsdDetailWindow').window({
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		closed: true,
		draggable:false,
		resizable:false,
		shadow:false,
		modal:true
	});
	
	 /* 绑定Tabs */
	 $('#showDetailTab').tabs({   
	      border:false,   
	      onSelect:function(title){   
	         if(title=="业务单据"){
	        	ywdj(); 
	         }else if(title=="单据明细"){
	        	ywmx();
	         }else if(title=="扣款明细"){
	        	kkmx(); 
	         }else if(title=="分税率统计"){
	        	fsltj(); 
	         }
	      }
	 }); 
	
});

function reloadgrid(){
	$('#jxjsdHeadDataGrid').datagrid('options').url = 'JsonServlet';        
	$('#jxjsdHeadDataGrid').datagrid('options').queryParams = {
		data :obj2str(
			{		
				ACTION_TYPE : 'getHSCJXJSDHead',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',		 
				list:[{
					sgcode : '<%=sgcode%>',
					billno : $("#billno").val(),
					startDate : $("#startDate").val(),
					endDate : $("#endDate").val(),
					supcode : $("#supcode").val(),
					djType : '0'
				}]
			}
		)
	};
	$("#jxjsdHeadDataGrid").datagrid('reload'); 
	$("#jxjsdHeadDataGrid").datagrid('resize'); 
}

function showjxjsdDetailWindow(billno){
	
	$('#jsdDetailWindow').window('open');
}

function exportExcel(){
	
}

//业务单据
function ywdj(){
	$('#ywdjTable').datagrid({
		width:970,
		nowrap: false,
		striped: true,
		url:'',		
		fitColumns:false,
		remoteSort: true,
		singleSelect: true,
		showFooter:true,				
		loadMsg:'加载数据...',				
		columns:[[				
			{field:'BILLNO',title:'业务组织',width:150,align:'center'},
			{field:'LRDATE',title:'业务单号',width:150,align:'center',sortable:true},
			{field:'GSXSSL',title:'业务类型',width:80,align:'center',sortable:true},
			{field:'GSXSSL',title:'记账日期',width:80,align:'center',sortable:true},
			{field:'GSHSJJJE',title:'含税金额', width:80,sortable:true,align:'center'},
			{field:'GSHSJJJE',title:'无税金额', width:80,sortable:true,align:'center'},
			{field:'GSXSJE',title:'进项税额',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'采购单号',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'门店验收单号',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'标志',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'发生数量',width:80,align:'center',sortable:true}
		]],
		pagination:true,
		rownumbers:true
	});
}

//业务明细
function ywmx(){
	$('#djmxTable').datagrid({
		width:970,
		nowrap: false,
		striped: true,
		url:'',		
		fitColumns:false,
		remoteSort: true,
		singleSelect: true,
		showFooter:true,				
		loadMsg:'加载数据...',				
		columns:[[				
			{field:'BILLNO',title:'业务组织',width:150,align:'center'},
			{field:'LRDATE',title:'业务类型',width:80,align:'center',sortable:true},
			{field:'GSXSSL',title:'业务单号',width:80,align:'center',sortable:true},				
			{field:'GSHSJJJE',title:'业务单据序号', width:80,sortable:true,align:'center'},
			{field:'GSXSJE',title:'部门编码',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'部门名称',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'商品编码',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'商品名称',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'商品条码',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'单位',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'规格',width:80,align:'center',sortable:true},
			{field:'SUPCODE',title:'含税进价',width:100,align:'center',sortable:true},	
			{field:'SUPNAME',title:'无税进价',width:250,align:'left',sortable:true},
			{field:'GSXSJE',title:'进项税率(%)',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'数量',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'含税进价金额',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'无税进价金额',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'进项税额',width:80,align:'center',sortable:true},
			{field:'GSXSJE',title:'优惠金额',width:80,align:'center',sortable:true},
			{field:'SUPCODE',title:'备注',width:100,align:'center',sortable:true}	

		]],
		pagination:true,
		rownumbers:true
	});
}

//扣款明细
function kkmx(){
	$('#kkmxTable').datagrid({
		width:970,
		nowrap: false,
		striped: true,
		url:'',		
		fitColumns:false,
		remoteSort: true,
		singleSelect: true,
		showFooter:true,				
		loadMsg:'加载数据...',				
		columns:[[				
			{field:'BILLNO',title:'业务组织',width:90,align:'center'},
			{field:'LRDATE',title:'扣款项编码',width:90,align:'center',sortable:true},
			{field:'GSXSSL',title:'扣款',width:90,align:'center',sortable:true},				
			{field:'GSHSJJJE',title:'条款号', width:90,sortable:true,align:'center'},
			{field:'GSXSJE',title:'分配类型',width:90,align:'center',sortable:true},
			{field:'GSXSJE',title:'扣款比例(%)',width:90,align:'center',sortable:true},
			{field:'GSXSJE',title:'比例基数',width:60,align:'center',sortable:true},
			{field:'GSXSJE',title:'扣款金额',width:90,align:'center',sortable:true},
			{field:'GSXSJE',title:'支付类型',width:90,align:'center',sortable:true},
			{field:'GSXSJE',title:'服药开发票',width:90,align:'center',sortable:true},
			{field:'GSXSJE',title:'备注',width:90,align:'center',sortable:true}
		]],
		pagination:true,
		rownumbers:true
	});
}

//分税率统计
function fsltj(){
	$('#fsltjTable').datagrid({
		width:970,
		nowrap: false,
		striped: true,
		url:'',		
		fitColumns:false,
		remoteSort: true,
		singleSelect: true,
		showFooter:true,				
		loadMsg:'加载数据...',				
		columns:[[				
			{field:'GSXSJE',title:'税率',width:240,align:'center',sortable:true},
			{field:'GSXSJE',title:'含税金额',width:240,align:'center',sortable:true},
			{field:'SUPCODE',title:'无税金额',width:240,align:'center',sortable:true},	
			{field:'SUPNAME',title:'税额',width:240,align:'center',sortable:true}
		]],
		pagination:true,
		rownumbers:true
	});
}


</script>
</head>
<body>
	<center>
		<!-- 查询区域 -->
		<form id="queryForm">
			<table style="width:1000px;font-size: 12px;">
				<tr><td colspan="8" align="left" style="color: #4574a0;">好收成经销结算单查询</td></tr>
				<tr>
					<td align="right">结算单号：</td>
					<td align="left">
						<input type="text" id="billno" name="billno" size="20"/>
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
		<table id="jxjsdHeadDataGrid"></table>
		
		<div id="jsdDetailWindow" class="easyui-window" title="结算单明细" style="width: 1010px;height: 600px;top: 125px;">
			<table height="158" style="width: 990px;font-size: 12px;">
				<tr>
					<td colspan="6" height="5px">&nbsp;</td>
				</tr>
				<tr>
					<td width="99" height="24" align="right">供应商编码：</td>
					<td width="259" align="left"></td>
					<td width="102" align="right">合同编码：</td>
					<td width="270" align="left"></td>
					<td width="87" align="right"></td>
					<td width="135" align="left"></td>
				</tr>
				<tr>
					<td height="24" align="right">组织：</td>
					<td align="left"></td>
					<td align="right">结算截止日期：</td>
					<td align="left"></td>
					<td align="right"></td>
					<td align="left"></td>
				</tr>
				<tr>
					<td height="24" align="right">单据号：</td>
					<td align="left"></td>
					<td align="right">结算单位：</td>
					<td align="left"></td>
					<td align="right">结算方式编码：</td>
					<td align="left"></td>
				</tr>
				<tr>
					<td height="24" align="right">含税进货金额：</td>
					<td align="left"></td>
					<td align="right">无税进货金额：</td>
					<td align="left"></td>
					<td align="right">进项税额：</td>
					<td align="left"></td>
				</tr>
				<tr>
					<td height="24" align="right">折扣金额：</td>
					<td align="left"></td>
					<td align="right">折扣分摊金额：</td>
					<td align="left"></td>
					<td align="right">折扣费用金额：</td>
					<td align="left"></td>
				</tr>
				<tr>
					<td align="right">本次应付金额：</td>
					<td align="left"></td>
					<td align="right">本次调整金额：</td>
					<td align="left"></td>
					<td align="right">实际应付金额：</td>
					<td align="left"></td>
				</tr>
				<tr>
					<td colspan="6" >&nbsp;&nbsp;&nbsp;&nbsp;本次应付金额 = 含税进货金额 - 扣款费用金额</td>
				</tr>
				<tr>
					<td colspan="6" height="5px">&nbsp;</td>
				</tr>
		  	</table>
		  	<div id="showDetailPanl" style="width:980;">
				<div id="showDetailTab" class="easyui-tabs" style="width:970px;height:320px;border: 1px">
					<div title="业务单据">
						<table id="ywdjTable"></table>
					</div>
					<div title="单据明细">
						<table id="djmxTable"></table>
					</div>
					<div title="扣款明细">
						<table id="kkmxTable"></table>
					</div>
					<div title="分税率统计">
						<table id="fsltjTable"></table>
					</div>
				</div>
			</div>
			
				<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="saveUserRole();">确定</a> 
			    <a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="cancelUserRole();">取消</a>
				<a href="#" class="easyui-linkbutton" iconCls="icon-print">打印</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="#" class="easyui-linkbutton" iconCls="icon-back">返回</a>
		</div>
	</center>
</body>
</html>