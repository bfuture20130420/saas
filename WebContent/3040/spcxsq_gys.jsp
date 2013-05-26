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
	String supcode = currUser.getSupcode();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>零售商商品促销申请(供应商查询页面)</title>
<script type="text/javascript" language="javascript">
var now = new Date();  
now.setDate( now.getDate() - 7 );
$("#spcxsqgys_searchWindow_startDate").val( now.format('yyyy-MM-dd') );
$("#spcxsqgys_searchWindow_endDate").attr("value",new Date().format('yyyy-MM-dd'));

$(function(){
	$('#spcxsqgysDataGrid').datagrid({	
		width: 897 ,
		nowrap: false,
		striped: true,
		url:'',		
		fitColumns:false,
		remoteSort: true,
		singleSelect: true,				
		loadMsg:'加载数据...',				
		columns:[[				
			{field:'SQZZ',title:'申请组织',width:313,align:'left',
				formatter:function(value,rec){
					return '天津好收成商贸有限公司';
				}
			},
			{field:'APPLYDATE',title:'申请日期',width:120,align:'center'},
			{field:'VALIDDATE',title:'有效日期',width:120,align:'center'},
			{field:'PPSTATUS',title:'是否查看',width:120,align:'center',
				formatter:function(value,rec){
					if(value == "0"){
						return "否";
					}else{
						return "是";
					}
				}
			},	
			{field:'FLAG',title:'是否过期',width:120,align:'center',
				formatter:function(value,rec){
					if(value > 0){
						return "否";
					}else{
						return "是";
					}
				}
			},	
			{field:'UPLOADFILE',title:'相关操作', width:70,align:'center',
				formatter:function(value,rec){
					return '<img src="${pageContext.request.contextPath }/themes/icons/download.png" title="查看" width="16" height="16" onclick=downloadFile("'+value+'","'+rec.UUID+'","'+rec.PPSTATUS+'") />';
				}
			}
		]],
		toolbar:[{
				id : "spcxsqgysDataGrid_search",
				text:'查询信息',
				iconCls:'icon-search',
				handler:function(){
					$('#spcxsqgys_searchWindow').window('open');
				}
			}],
		pagination:true,
		rownumbers:true	
	});
	searchCXSHGYS();
});

function searchCXSHGYS(){
	var supcode = '<%=supcode%>';
	var startDate = $('#spcxsqgys_searchWindow_startDate').val();
	var endDate = $('#spcxsqgys_searchWindow_endDate').val();
	$('#spcxsqgysDataGrid').datagrid('options').url = 'JsonServlet';        
	$('#spcxsqgysDataGrid').datagrid('options').queryParams = {
		data :obj2str(
			{		
				ACTION_TYPE : 'getHSCLSSSPCXSQ',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',		 
				list:[{
					sgcode : '<%=sgcode%>',
					supcode : supcode,
					startDate : startDate,
					endDate : endDate
				}]
			}
		)
	};	
	$("#spcxsqgysDataGrid").datagrid('reload');  
	$("#spcxsqgysDataGrid").datagrid('resize'); 
	goBackSearchCXSHGYS();
}

function downloadFile(filename,uuid,ppstatus){
	if(ppstatus == "0"){
		//更新状态
		$.post( 'JsonServlet',				
		{
			data :obj2str(
				{		
					ACTION_TYPE : 'updateppStatus',
					ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
					ACTION_MANAGER : 'hscManager',												 
					list:[{
						uuid : uuid
					}]
				}
			)						
		}, 
		function(data){ 
		    if(data.returnCode == '1' ){
		    	filename = encodeURI(encodeURI(filename));
		 	    window.location = "${pageContext.request.contextPath}/DownloadServlet?downloadFileName="+filename;                    	 
		    }else{ 
		        $.messager.alert('提示','找不到相关记录','error');
		    } 
	   	},
	   	'json'
	    );
	}else{
		filename = encodeURI(encodeURI(filename));
 	    window.location = "${pageContext.request.contextPath}/DownloadServlet?downloadFileName="+filename; 
	}
	
}

function goBackSearchCXSHGYS(){
	$('#spcxsqgys_searchWindow').window('close');
}

function clearForm(obj){
	$(':input',obj)   
	 .not(':button, :submit, :reset, :hidden')   
	 .val('')   
	 .removeAttr('checked')   
	 .removeAttr('selected');
}
	
</script>
</head>
<body>
<center>
<div id="spcxsqgys_mainPanel" class="easyui-panel" title="零售商商品促销申请列表" style="width: 900px;height: 400px;">
	<table id="spcxsqgysDataGrid"></table>
</div>
<div id="spcxsqgys_searchWindow" title="查询窗口" class="easyui-window" closed="true" collapsible="false" minimizable="false" maximizable="false" closable="false" modal="true" style="width: 280px;height: 160px;">
	<table width="100%" style="font-size: 12px;border-top: 5px;">
		<tr>
			<td align="right">开始时间：</td>
			<td>
				<input id="spcxsqgys_searchWindow_startDate" onClick="WdatePicker({isShowClear:false,readOnly:true});"/>
			</td>
		</tr>
		<tr>
			<td align="right">结束时间：</td>
			<td>
				<input id="spcxsqgys_searchWindow_endDate" onClick="WdatePicker({isShowClear:false,readOnly:true});"/>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a id="tijiao" name="tijiao" class="easyui-linkbutton" iconCls="icon-ok" href="javascript:searchCXSHGYS();">确定</a>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="chongzhi" name="chongzhi" class="easyui-linkbutton" iconCls="icon-back" href="javascript:goBackSearchCXSHGYS();">返回</a>
			</td>
		</tr>
	</table>
</div>
</center>
</body>
</html>