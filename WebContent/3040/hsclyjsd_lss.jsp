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
<title>好收成联营结算单查询</title>
<script type="text/javascript" language="javascript">
var ywdjNum = 0;
var ywmxNum = 0;
var kkmxNum = 0;
var fsltjNum = 0;
var now1 = new Date();
now1.setDate( now1.getDate() - 7 );
$("#startDate").val(now1.format('yyyy-MM-dd'));	
var now2 = new Date();
now2.setDate( now2.getDate() - 1 );
$("#endDate").val(now2.format('yyyy-MM-dd'));
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
						var billno = "'" + rec.BILLNO + "'";
						var supid = "'" + rec.SUPCODE + "'";
						var supname = "'" + rec.SUPNAME + "'";
						var contractId = "'" + rec.HTCODE + "'";
						var contractName = "'" + rec.HTNAME + "'";
						var deptcode = "'" + rec.ORGCODE + "'";
						var deptName = "'" + rec.ORGNAME + "'";
						var jzdate = "'" + rec.JZTIME + "'";
						var hyftotal = "'" + rec.HYFTOTAL + "'";
						var wyftotal = "'" + rec.WYFTOTAL + "'";
						var jtaxtotal = "'" + rec.JTAXTOTAL + "'";
						var tctotal = "'" + rec.TCTOTAL + "'";
						var bdtotal = "'" + rec.BDTOTAL + "'";
						var bctotal = "'" + rec.BCTOTAL + "'";
						var yftotal = "'" + rec.YFTOTAL + "'";
						var tztotal = "'" + rec.TZTOTAL + "'";
						var sftotal = "'" + rec.SFTOTAL + "'";
						return '<a href="#" style=" color:#4574a0; font-weight:bold;" onClick="showjxjsdDetailWindow('+billno+','+supid+','+supname+','+contractId+','+contractName+','+deptcode+','+deptName+','+jzdate+','+hyftotal+','+wyftotal+','+jtaxtotal+','+tctotal+','+bdtotal+','+bctotal+','+yftotal+','+tztotal+','+sftotal+');">' + value + '</a>';	
					}										
				}	
			},
			{field:'ORGNAMEALL',title:'组织名称',width:300,align:'left',sortable:true},
			{field:'LRDATE',title:'录入日期',width:100,align:'center',sortable:true,
				formatter:function(value,rec){
					if(value != null && value != ''){
						return new Date(value.time).format('yyyy-MM-dd');
					}
				}
			},
			{field:'HYFTOTAL',title:'含税进货金额',width:100,align:'center',sortable:true},				
			{field:'WYFTOTAL',title:'无税进货金额', width:100,sortable:true,align:'center'},
			{field:'JTAXTOTAL',title:'进项税额',width:100,align:'center',sortable:true},
			{field:'SUPCODE',title:'供应商编码',width:100,align:'center',sortable:true},	
			{field:'SUPNAME',title:'供应商名称',width:250,align:'left',sortable:true}
		]],
		pagination:true,
		rownumbers:true
	});

	$('#jsdDetailWindow').window({
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		closed: true,
		draggable:false,
		resizable:false,
		shadow:false,
		modal:true
	});
	
	$('#btn1').linkbutton({   
	    plain:false  
	});
	$('#btn2').linkbutton({   
	    plain:false  
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
					djType : '2'
				}]
			}
		)
	};
	$("#jxjsdHeadDiv").show();
	$("#jxjsdHeadDataGrid").datagrid('reload'); 
	$("#jxjsdHeadDataGrid").datagrid('resize'); 
}

function showjxjsdDetailWindow(billno,supid,supname,contractId,contractName,deptcode,deptName,jzdate,hyftotal,wyftotal,jtaxtotal,tctotal,bdtotal,bctotal,yftotal,tztotal,sftotal){
	$("#hiddenValue").val(billno);
	$("#hiddenValue1").val(deptcode);
	printJSD();
	/*
	//填充结算单头
	if(jzdate == null || jzdate == "null"){
		jzdate == "";
	}
	$("#supid").empty().append(supid + "-" + supname);
	$("#contractId").empty().append(contractId + "-" + contractName);
	$("#deptcode").empty().append(deptcode + "-" + deptName);
	$("#jzdate").empty().append(jzdate);
	$("#djbillno").empty().append(billno);
	$("#jsdw").empty().append(supid + "-" + supname);
	$("#hsjhje").empty().append(hyftotal);
	$("#wsjhje").empty().append(wyftotal);
	$("#jxse").empty().append(jtaxtotal);
	$("#zkje").empty().append(tctotal);
	$("#zkftje").empty().append(bdtotal);
	$("#zkfyje").empty().append(bctotal);
	$("#bcyfje").empty().append(yftotal);
	$("#bctzje").empty().append(tztotal);
	$("#sjyfje").empty().append(sftotal);
	//填充明细列表
	$('#jsdDetailWindow').window('open');
	
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
	*/
}

function exportExcel(){
	
}

//业务单据
function ywdj(){
	if(ywdjNum == 0){
		var params = {
			data :obj2str({		
				ACTION_TYPE : 'getywdj',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',
				list:[{
					billno : $("#hiddenValue").val()
				}]	 
			})
		}; 
		$('#ywdjTable').datagrid({
			width:980,
			nowrap: false,
			striped: true,
			url:'JsonServlet',	
			queryParams : params,
			fitColumns:false,
			remoteSort: true,
			singleSelect: true,
			showFooter:true,				
			loadMsg:'加载数据...',				
			columns:[[				
				{field:'YWORGNAME',title:'业务组织',width:200,align:'left',sortable:true},
				{field:'YWBILLNO',title:'业务单号',width:150,align:'center',sortable:true},
				{field:'REMARK',title:'业务类型',width:150,align:'center',sortable:true},
				{field:'JZDATE',title:'记账日期',width:83,align:'center',sortable:true,
					formatter:function(value,rec){
						if(value != null && value != ''){
							return new Date(value.time).format('yyyy-mm-dd');
						}
					}
				},
				{field:'HJTOTAL',title:'含税金额', width:90,sortable:true,align:'center'},
				{field:'WJTOTAL',title:'无税金额', width:90,sortable:true,align:'center'},
				{field:'JTAXTOTAL',title:'进项税额',width:90,align:'center',sortable:true},
				{field:'FSCOUNT',title:'发生数量',width:90,align:'center',sortable:true}
			]],
			pagination:true,
			rownumbers:true
		});	
		//标记已经加载过了
		ywdjNum = 1 ;
	}			
}

//业务明细
function ywmx(){
	if(ywmxNum==0){
		var params = {
			data :obj2str({		
				ACTION_TYPE : 'getywmx',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',
				list:[{
					billno : $("#hiddenValue").val()
				}]	 
			})
		};
		$('#djmxTable').datagrid({
			width:980,
			nowrap: false,
			striped: true,
			url:'JsonServlet',	
			queryParams : params,		
			fitColumns:false,
			remoteSort: true,
			singleSelect: true,
			showFooter:true,				
			loadMsg:'加载数据...',				
			columns:[[				
				{field:'YWORGNAME',title:'业务组织',width:200,align:'left'},
				{field:'REMARK',title:'业务类型',width:150,align:'left',sortable:true},
				{field:'YWBILLNO',title:'业务单号',width:150,align:'center',sortable:true},				
				{field:'PLUCODE',title:'商品编码',width:80,align:'center',sortable:true},
				{field:'BARCODE',title:'商品条码',width:150,align:'center',sortable:true},
				{field:'PLUNAME',title:'商品名称',width:250,align:'center',sortable:true},				
				{field:'UNIT',title:'单位',width:80,align:'center',sortable:true},
				{field:'SPEC',title:'规格',width:80,align:'center',sortable:true},
				{field:'HJPRICE',title:'含税进价',width:100,align:'center',sortable:true},	
				{field:'WJPRICE',title:'无税进价',width:80,align:'left',sortable:true},
				{field:'JTAXRATE',title:'进项税率(%)',width:80,align:'center',sortable:true},
				{field:'FSCOUNT',title:'数量',width:80,align:'center',sortable:true},
				{field:'HJTOTAL',title:'含税进价金额',width:80,align:'center',sortable:true},
				{field:'WJTOTAL',title:'无税进价金额',width:80,align:'center',sortable:true},
				{field:'JTAXTOTAL',title:'进项税额',width:80,align:'center',sortable:true},
				{field:'YHTOTAL',title:'优惠金额',width:80,align:'center',sortable:true}
			]],
			pagination:true,
			rownumbers:true
		});
		ywmxNum = 1;
	}
}

//扣款明细
function kkmx(){
	if(kkmxNum == 0){
		var params = {
			data :obj2str({		
				ACTION_TYPE : 'getkkmx',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',
				list:[{
					billno : $("#hiddenValue").val(),
					orgcode : $("#hiddenValue1").val()
				}]	 
			})
		};
		$('#kkmxTable').datagrid({
			width:980,
			nowrap: false,
			striped: true,
			url:'JsonServlet',	
			queryParams : params,		
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
		kkmxNum = 1;
	}
}

//分税率统计
function fsltj(){
	if(fsltjNum == 0 ){
		var params = {
			data :obj2str({		
				ACTION_TYPE : 'getfsltj',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',
				list:[{
					billno : $("#hiddenValue").val()
				}]	 
			})
		};
		$('#fsltjTable').datagrid({
			width:980,
			nowrap: false,
			striped: true,
			url:'JsonServlet',	
			queryParams : params,	
			fitColumns:false,
			remoteSort: true,
			singleSelect: true,
			showFooter:true,				
			loadMsg:'加载数据...',				
			columns:[[				
				{field:'JTAXRATE',title:'税率',width:248,align:'center',sortable:true},
				{field:'HJTOTAL',title:'含税金额',width:240,align:'center',sortable:true},
				{field:'WJTOTAL',title:'无税金额',width:230,align:'center',sortable:true},	
				{field:'JTAXTOTAL',title:'税额',width:230,align:'center',sortable:true}
			]],
			pagination:true,
			rownumbers:true
		});
		fsltjNum = 1;
	}
}

function printJSD(){
	var billno = $('#hiddenValue').val();
    //在url中指定打印执行页面
    var url = "3040/print_hsclyjsd.jsp?billno=" + billno;					
	window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');	
}

function goBack(){
	ywdjNum = 0;
	ywmxNum = 0;
	kkmxNum = 0;
	fsltjNum = 0;
	$('#jsdDetailWindow').window('close');
}


</script>
</head>
<body>
	<center>
		<input type="hidden" id="hiddenValue" value=""></input>
		<input type="hidden" id="hiddenValue1" value=""></input>
		<!-- 查询区域 -->
		<form id="queryForm">
			<table style="width:1000px;font-size: 12px;">
				<tr><td colspan="8" align="left" style="color: #4574a0;">好收成联营结算单查询</td></tr>
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
		<div id="jxjsdHeadDiv" style="display: none;width: 1000px;">
			<table id="jxjsdHeadDataGrid"></table>
		</div>
		
		
		<div id="jsdDetailWindow" class="easyui-window" title="结算单明细" style="width: 1010px;height: 600px;top: 125px;">
			<table height="158" style="width: 990px;font-size: 12px;">
				<tr>
					<td width="99" height="24" align="right">供应商编码：</td>
					<td width="259" align="left" id="supid"></td>
					<td width="102" align="right">合同编码：</td>
					<td width="270" align="left" id="contractId"></td>
					<td width="87" align="right"></td>
					<td width="135" align="left"></td>
				</tr>
				<tr>
					<td height="24" align="right">组织：</td>
					<td align="left" id="deptcode"></td>
					<td align="right">结算截止日期：</td>
					<td align="left" id="jzdate"></td>
					<td align="right"></td>
					<td align="left"></td>
				</tr>
				<tr>
					<td height="24" align="right">单据号：</td>
					<td align="left" id="djbillno"></td>
					<td align="right">结算单位：</td>
					<td align="left" id="jsdw"></td>
					<td align="right">结算方式编码：</td>
					<td align="left">0-经销结算</td>
				</tr>
				<tr>
					<td height="24" align="right">含税进货金额：</td>
					<td align="left" id="hsjhje"></td>
					<td align="right">无税进货金额：</td>
					<td align="left" id="wsjhje"></td>
					<td align="right">进项税额：</td>
					<td align="left" id="jxse"></td>
				</tr>
				<tr>
					<td height="24" align="right">折扣金额：</td>
					<td align="left" id="zkje"></td>
					<td align="right">折扣分摊金额：</td>
					<td align="left" id="zkftje"></td>
					<td align="right">折扣费用金额：</td>
					<td align="left" id="zkfyje"></td>
				</tr>
				<tr>
					<td align="right">本次应付金额：</td>
					<td align="left" id="bcyfje"></td>
					<td align="right">本次调整金额：</td>
					<td align="left" id="bctzje"></td>
					<td align="right">实际应付金额：</td>
					<td align="left" id="sjyfje"></td>
				</tr>
				<tr>
					<td colspan="6" >&nbsp;&nbsp;&nbsp;&nbsp;本次应付金额 = 含税进货金额 - 扣款费用金额</td>
				</tr>
		  	</table>
		  	<div id="showDetailPanl" style="width:980;">
				<div id="showDetailTab" class="easyui-tabs" style="width:980px;height:360px;border: 0px">
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
			<div>
				<a href="javascript:printJSD();" id="btn1" iconCls="icon-print">打印</a>  
				<a href="javascript:goBack();" id="btn2" iconCls="icon-back">返回</a> 
			</div>
		</div>
	</center>
</body>
</html>