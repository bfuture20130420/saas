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
<title>零售商商品促销申请</title>
<script type="text/javascript" language="javascript">
var fileDate = "";
var now = new Date(); 
var validNow = new Date(); 
now.setDate( now.getDate() - 7 );
validNow.setDate( now.getDate() + 30);
$("#spcxsqlss_searchWindow_startDate").val( now.format('yyyy-MM-dd') );
$("#spcxsqlss_searchWindow_endDate").attr("value",new Date().format('yyyy-MM-dd'));
$("#spcxsqlss_uploadWindow_validDate").attr("value",validNow.format('yyyy-MM-dd'));


$(function(){
	$('#spcxsqlssDataGrid').datagrid({	
		width: 897 ,
		nowrap: false,
		striped: true,
		url:'',		
		fitColumns:false,
		remoteSort: true,
		singleSelect: true,				
		loadMsg:'加载数据...',				
		columns:[[				
			{field:'SUPNAME',title:'供应商名称',width:313,align:'left'},
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
					return '<img src="${pageContext.request.contextPath }/themes/icons/download.png" title="查看" width="16" height="16" onclick=downloadFile("'+value+'") />&nbsp;&nbsp;'+
						   '<img src="${pageContext.request.contextPath }/themes/icons/delete.png" title="删除" width="16" height="16" onclick=deleteFile("'+rec.UUID+'") />';
				}
			}
		]],
		toolbar:[{
				id : "spcxsqlssDataGrid_search",
				text:'查询信息',
				iconCls:'icon-search',
				handler:function(){
					$('#spcxsqlss_searchWindow').window('open');
				}
			},
			{
				id : "spcxsqlssDataGrid_download",
				text:'下载模版',
				iconCls:'icon-down',
				handler:function(){
					window.location.href = "downloadfile?filename="+encodeURI(encodeURI('HSC_csjjtzd.xls'));
				}
			},
			{
				id : "spcxsqlssDataGrid_upload",
				text:'上传文件',
				iconCls:'icon-up',
				handler:function(){
					$('#spcxsqlss_uploadWindow').window('open');
				}
			}],
		pagination:true,
		rownumbers:true	
	});
	
	
	var load = new AjaxUpload( "spcxsqlss_uploadWindow_upload", {
		action : "uploadfile_new.jsp",
		autoSubmit : true,
		onChange : function(file, extension) {
			$("#spcxsqlss_uploadWindow_uploadfile").val(file);
			// 附件类型的验证
			if (/^(doc|docx|xls|xlsx|pdf)$/.test(extension)) {
				// 附件大小的验证
				// 这里暂时在服务器端验证
			} else {
				$.messager.alert('没有通过验证', '文件类型不合法，请上传doc,docx,xls,xlsx,pdf格式文件', 'warning');
				return false;
			}
		},
		onComplete : function(file, response) {
			var reply = JSON.parse(response);
			if (reply.err != null ) { // 控制附件的大小
					$.messager.alert('没有通过验证', reply.err , 'warning');
					return false;
			}else{
				fileDate = reply.fileDate;
			}
		}
	});
	
	searchCXSHLSS();
});

function uploadCXSHLSS(){
	var supid = $('#spcxsqlss_uploadWindow_supid').val();
	var validDate = $('#spcxsqlss_uploadWindow_validDate').val();
	var fileName = $('#spcxsqlss_uploadWindow_uploadfile').val();
	if(fileName == ""){
		$.messager.alert('提示', '请选择上传的文件!', 'info');
		return ;
	}
	if(validDate == ""){
		$.messager.alert('提示', '请填写有效时间!', 'info');
		return ;
	}
	if(supid == ""){
		$.messager.alert('提示', '请填写供应商编码!', 'info');
		return ;
	}
	$('#spcxsqlss_uploadWindow').window('close');
	$.post('JsonServlet', 
		{
			data : obj2str( {
				ACTION_TYPE : 'saveHSCLSSSPCXSQ',
				ACTION_CLASS : 'com.bfuture.app.saas.model.HscBean',
				ACTION_MANAGER : 'hscManager',	
				optType : 'add',
				optContent : '提交促销申请表',
				list : [{
					sgcode : '<%=sgcode%>',
					supcode : supid,
					validDate : validDate,
					uploadFile : fileDate+fileName
				}]
			})

		}, 
		function(data){
			if (data.returnCode == '1') {
				searchCXSHLSS();
				$.messager.alert('提示', '提交成功!', 'info');	
			}else {
				$.messager.alert('提示', '提交失败!' + data.returnInfo, 'error');
			}
		}, 
		'json');
}

function searchCXSHLSS(){
	var startDate = $('#spcxsqlss_searchWindow_startDate').val();
	var endDate = $('#spcxsqlss_searchWindow_endDate').val();
	var supcode = $('#spcxsqlss_searchWindow_supid').val();
	$('#spcxsqlssDataGrid').datagrid('options').url = 'JsonServlet';        
	$('#spcxsqlssDataGrid').datagrid('options').queryParams = {
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
	$("#spcxsqlssDataGrid").datagrid('reload');  
	$("#spcxsqlssDataGrid").datagrid('resize'); 
	goBackSearchCXSHLSS();
}

function downloadFile(filename){
	filename = encodeURI(encodeURI(filename));
	window.location = "${pageContext.request.contextPath}/DownloadServlet?downloadFileName="+filename;
}

function deleteFile(uuid){
	if(uuid != "" && uuid != null || uuid != null){
		$.messager.confirm('确认信息','删除数据后不可恢复，确认要删除吗？',function(r){
			if(r){
				$.post( 'JsonServlet',				
				{
					data :obj2str(
						{		
							ACTION_TYPE : 'deleteUUID',
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
				    	searchCXSHLSS();
				    	$.messager.alert('提示','删除成功','error');                   	 
				    }else{ 
				        $.messager.alert('提示','找不到相关记录','error');
				    } 
			   	},
			   	'json'
			    );
			}
		});
	}
}

function goBackSearchCXSHLSS(){
	$('#spcxsqlss_searchWindow').window('close');
}

function goBackUploadCXSHLSS(){
	$('#spcxsqlss_uploadWindow').window('close');
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
<div id="spcxsqlss_mainPanel" class="easyui-panel" title="零售商商品促销申请列表" style="width: 900px;height: 400px;">
	<table id="spcxsqlssDataGrid"></table>
</div>
<div id="spcxsqlss_searchWindow" title="查询窗口" class="easyui-window" closed="true" collapsible="false" minimizable="false" maximizable="false" closable="false" modal="true" style="width: 280px;height: 160px;">
	<table width="100%" style="font-size: 12px;border-top: 5px;">
		<tr>
			<td align="right">开始时间：</td>
			<td>
				<input id="spcxsqlss_searchWindow_startDate" onClick="WdatePicker({isShowClear:false,readOnly:true});"/>
			</td>
		</tr>
		<tr>
			<td align="right">结束时间：</td>
			<td>
				<input id="spcxsqlss_searchWindow_endDate" onClick="WdatePicker({isShowClear:false,readOnly:true});"/>
			</td>
		</tr>
		<tr>
			<td align="right">供应商编码：</td>
			<td>
				<input id="spcxsqlss_searchWindow_supid" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a id="tijiao" name="tijiao" class="easyui-linkbutton" iconCls="icon-ok" href="javascript:searchCXSHLSS();">确定</a>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="chongzhi" name="chongzhi" class="easyui-linkbutton" iconCls="icon-back" href="javascript:goBackSearchCXSHLSS();">返回</a>
			</td>
		</tr>
	</table>
</div>
<div id="spcxsqlss_uploadWindow" title="文件上传窗口" class="easyui-window" closed="true" collapsible="false" minimizable="false" maximizable="false" closable="false" modal="true" style="width: 280px;height: 160px;">
	<table width="100%" style="font-size: 12px;border-top: 5px;">
		<tr>
			<td align="right">上传文件：</td>
		    <td>
		    	<input type="text" id="spcxsqlss_uploadWindow_uploadfile" name="ppfile" size="12"/>
		        <input type="button" value="浏览" style="margin-left:5px;" id="spcxsqlss_uploadWindow_upload" />
		    </td>
		</tr>
		<tr>
			<td align="right">有效日期：</td>
			<td>
				<input id="spcxsqlss_uploadWindow_validDate" onClick="WdatePicker({isShowClear:false,readOnly:true});"/>
			</td>
		</tr>
		<tr>
			<td align="right">供应商编码：</td>
			<td>
				<input id="spcxsqlss_uploadWindow_supid" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<a id="tijiao" name="tijiao" class="easyui-linkbutton" iconCls="icon-ok" href="javascript:uploadCXSHLSS();">确定</a>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="chongzhi" name="chongzhi" class="easyui-linkbutton" iconCls="icon-back" href="javascript:goBackUploadCXSHLSS();">返回</a>
			</td>
		</tr>
	</table>
</div>
</center>
</body>
</html>