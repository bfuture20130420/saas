<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>	
	<title>结算补差单查询</title>
	
<%
	Object obj = session.getAttribute( "LoginUser" );
	if( obj == null ){
		response.sendRedirect( "login.jsp" );
		return;
	}
	SysScmuser currUser = (SysScmuser)obj;
	String sgcode = currUser.getSgcode();
	String suType = currUser.getSutype() + "";
%>
<style>
	.underLine{
		border:0px;
		border-bottom:#000 1px solid;
		overflow:hidden;
	}
</style>
	<script type="text/javascript">
	var now = new Date(); 
	now.setDate( now.getDate() - 7 );
	$("#sdate").val( now.format('yyyy-MM-dd') );
	$("#edate").attr("value",new Date().format('yyyy-MM-dd'));
		$(function(){
			// 填充订单头列表
			$('#orderSearchSupList').datagrid({
				nowrap: false,
				striped: true,			
				width:1000,	
				sortOrder: 'desc',
				singleSelect : true,
				showFooter:true,
				remoteSort: true,
				fitColumns:false,
				idField: 'BOHBILLNO',
				loadMsg:'加载数据...',
				columns:[[
				          
				          
//单据号		原单据号   门店     补差金额      补差日期    审核日期    供应商编码  供应商名称  备注  
						
						
						
						{field:'SHEET_NO',title:'单据号',width:185,sortable:true,
							formatter:function(value,rec){
								
								return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showOrderDet("'+rec.SHEET_NO +'","'+ rec.SHPNAME +'","'+ rec.APPROVE_DATE +'","'+ rec.SUPCUST_NO +'","'+ rec.SUPNAME +'");>' + value + '</a>';
							}
						},	
						{field:'VOUCHER_NO',title:'原单据号',width:100,sortable:true},

						{field:'SHPNAME',title:'门店',width:180,sortable:true},
						{field:'INOUT_AMOUNT',title:'补差金额',width:100,sortable:true},
						{field:'PAY_DATE',title:'补差日期',width:100,sortable:true},
						{field:'APPROVE_DATE',title:'审核日期',width:100,sortable:true},
						{field:'MEMO',title:'备注',width:200,sortable:true}
						
						<%if("L".equals(suType)){%>
						,{field:'SUPCUST_NO',title:'供应商编号',width:100,sortable:true},
						{field:'SUPNAME',title:'供应商名称',width:250,sortable:true}
						<%}%>
						
						
				]],	
//				toolbar:[{
//					text:'导出Excel',
//					iconCls:'icon-redo',
//					handler:function(){
//						exportExcel();
//					}
//				}],
				pagination:true,
				rownumbers:true
			});
			
			// 填充订单明细列表
			$('#orderDetSupList').datagrid({
				width: 1000,
				nowrap: false,
				striped: true,	
				url:'',			
				sortOrder: 'asc',
				singleSelect : true,
				remoteSort: true,
				fitColumns:false,
				loadMsg:'加载数据...',				
				showFooter:true,
				rownumbers:true,				
				columns:[[	
				          
     //单据号     商品编码    商品条码   商品名称     规格     单位           包装因子      原进货价      现进货价      数量小计    差价金额
					
					{field:'ITEM_ID',title:'商品编码',width:100,align:'left'},
					{field:'ITEM_NAME',title:'商品名称',width:250,align:'left'},
					{field:'ITEM_SUBNO',title:'商品条码',width:100,align:'left'},
					{field:'ITEM_SIZE',title:'商品规格',width:70,align:'left'},

					{field:'UNIT_FACTOR',title:'包装因子',width:50,align:'left'},

					
					
					{field:'UNIT_NO',title:'单位',width:70,align:'left'},
					
					{field:'IN_PRICE',title:'原进货价',width:60,align:'left'}, 
				    
					{field:'VALID_PRICE',title:'现进货价',width:100,align:'left'},
					{field:'TOTAL_QTY',title:'数量小计',width:81,align:'left'},
					{field:'SUB_AMOUNT',title:'差价金额',width:81,align:'left'}	
     
     
     
     
				]]
			});
		});
		
		
		function exportExcel(){
			var searchData = getFormData( 'orderSearchHTSearch' ); 
			if(User.sutype == 'L'){
				searchData['enTitle'] = ['BOHBILLNO','BOHMFID','SHPNAME','BOHDHRQ','BOHJHRQ','SL','JE','BOHSUPID','SUNAME'];
				<%if(sgcode.equals("3039")){%>
			    searchData['cnTitle'] = ['订单编号','门店编号','门店名称','订货日期','送货期限','订货数量','含税进价金额','供应商编号','供应商名称'];
				<%} else {%>
			    searchData['cnTitle'] = ['订单编号','门店编号','门店名称','订货日期','送货日期','订货数量','含税进价金额','供应商编号','供应商名称'];
				<%}%>
			}else{
				searchData['enTitle'] = ['BOHBILLNO','BOHMFID','SHPNAME','BOHDHRQ','BOHJHRQ','SL','JE'];
				<%if(sgcode.equals("3039")){%>
				searchData['cnTitle'] = ['订单编号','门店编号','门店名称','订货期限','送货日期','订货数量','含税进价金额'];
				<%} else {%>
				searchData['cnTitle'] = ['订单编号','门店编号','门店名称','订货日期','送货日期','订货数量','含税进价金额'];
				<%}%>
				
			} 
			searchData['bohsupid'] = $('#bohsupid').val();  		// 供应商编码
			searchData['bohsgcode'] = User.sgcode;  // 实例编码
			searchData['exportExcel'] = true;
			searchData['sheetTitle'] = '订单信息查询';
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'SearchYwBorderhead',
								ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderhead',
								ACTION_MANAGER : 'ywBorderhead',											 
								list:[searchData]
							}
						)						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	location.href = data.returnInfo;	                    	 
	                    }else{ 
	                        $.messager.alert('提示','导出Excel失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		} 

		// 加载订单头列表1111111111111111111111111111111111111111111111111111111111111111111111111111111111111
		function reloadgrid()  { 
        	var searchData = getFormData( 'orderSearchHTSearch' ); 
			searchData['sucode'] = $('#bohsupid').val();  		// 供应商编码
			searchData['sgcode'] = User.sgcode;  // 实例编码
			searchData['flag'] = 'K';  // 调用方法
	        //查询参数直接添加在queryParams中
	        $('#orderSearchSupList').datagrid('options').url = 'JsonServlet';        
			$('#orderSearchSupList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'serchJSBXHead',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
						ACTION_MANAGER : 'settleManagerGdl',		
						optType : 'query',
						optContent : '查询订单',			 
						list:[	searchData	]
					}
				)
			};        
			$("#orderSearchSupListTD").show();			
			$("#orderSearchSupList").datagrid('reload');
			$("#orderSearchSupList").datagrid('resize');   
    	}
    	
    	// 钻去订单明细的方法222222222222222222222222222222222222222222222222222222222222222222222222222222222222
		function showOrderDet( sheet_no,SHPNAME,APPROVE_DATE,SUPCUST_NO,SUPNAME){
			$('#bohbillno_').empty().append(sheet_no); // 订单编号
			$('#bohsupid_').empty().append(SUPCUST_NO);	// 供应商编号
			$('#bohsupid_').append(SUPNAME);				// 供应商名称
			$('#bohdhrq_').empty().append(APPROVE_DATE); // 订货日期
			$('#bohmfid_').empty().append(SHPNAME);				// 收货门店名称
		//	$('#memo_').empty().append(MEMO);				// 收货门店名称	
			
	        //查询参数直接添加在queryParams中
	        $('#orderDetSupList').datagrid('options').url = 'JsonServlet';        
			$('#orderDetSupList').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'serchJSBXDet',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
						ACTION_MANAGER : 'settleManagerGdl',		 
						list:[{
							billno : sheet_no,
							sgcode : User.sgcode
						}]
					}
				)
			};
			
			$( '#orderSearchHTSearch' ).hide();
			$( '#orderDetHT' ).show();			        
			$("#orderDetSupList").datagrid('reload');
			$("#orderDetSupList").datagrid('resize'); 
		}
		
		// 返回订单头页
		function returnFirst(){
			$( '#orderSearchHTSearch' ).show();
			$( '#orderDetHT' ).hide(); 
			reloadgrid();
		}
		
		// 详细页的[打印]按钮事件
		function printOrder(){
			var mfid = $('#bohmfid_hidden').val();
			$.messager.confirm('确认操作', '确认要打印吗?', function(r){
				if (r){
					$.post( 'JsonServlet',				
						{
							data : obj2str({		
									ACTION_TYPE : 'addYwBorderstatus',
									ACTION_CLASS : 'com.bfuture.app.saas.model.YwBorderstatus',
									ACTION_MANAGER : 'ywBorderstatus',
									optType : 'update',
									optContent : '打印订单',	
									list:[{
										bohsgcode : User.sgcode,    			  // 实例编码
										bohbillno : $('#bohbillno_hidden').val(), // 订单编号
										bohshmfid : mfid,   // 门店编号
										bohstatus : ''      					  // 订单状态
									}]
							})
							
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){	                    	 
		                    	
		                    }else{ 
		                        $.messager.alert('提示','打印订单失败!<br>原因：' + data.returnInfo,'error');
		                        return;
		                    } 
		            	},
		            	'json'
					);
				
				
	                var bodsgcode = User.sgcode; 					 // 实例编码
					var bodbillno = $('#bohbillno_hidden').val(); 	 // 订单编号
					var bodshmfid = $('#bohmfid_hidden').val(); 	 // 门店编号
	                //在url中指定打印执行页面
	                var url = "print_order.jsp?bodsgcode=" + bodsgcode + "&bodbillno=" + bodbillno + "&bodshmfid=" + bodshmfid;					
					window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');	
				}
			});
		}		
		// 加载门店下拉框数据
		function loadSupShop( list ){ 
			if( $(list).attr('isLoad') == undefined ){
				$(list).attr('isLoad' , true );
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
	                    	 	$.each( data.rows, function(i, n) { 
						            var html = "<option value='" + n.SHPCODE + "'>" + n.SHPNAME + "</option>";  
						            $(list).append(html);  
						        });						        
	                    	 }	                    	 
	                    	 
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
<table id="orderSearchHTSearch" style="line-height:20px;border:none; font-size:12px;margin:auto;width:1000px;" align="center"> 
	<tr> 
		<td colspan="6" align="left" style="border:none; color:#4574a0;">结算补差单查询</td> 
	</tr>
	<tr>
		<td align="right" width="100">单据编号：</td>
		<td align="left" width="230"><input type="text" name="billno" id="billno" value="" width="110" /> </td>
		<td align="right" width="100">开始日期：</td>
		<td align="left" width="230"><input type="text" name="sdate" id="sdate" value="" size="20"  onClick="WdatePicker({isShowClear:false,readOnly:true,maxDate:'#F{$dp.$D(\'edate\')}'});" /> </td>
		<td align="right" width="100">结束日期：</td>
		<td align="left" width="240"><input type="text" name="edate" id="edate" value="" size="20"  onClick="WdatePicker({isShowClear:false,readOnly:true,minDate:'#F{$dp.$D(\'sdate\')}',maxDate:'%y-%M-%d'});" /> </td>
	</tr> 
	<tr>
		<td align="right" width="100">门店名称：</td>
		<td align="left" width="230">
			<select style="width:155px;" name='bohmfid' id="bohmfid" size='1' onclick="loadSupShop(this);">
            			<option value = ''>所有门店</option>
    				</select>
		</td>
		<td align="right" width="100" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">供应商编码：</td>
		<td align="left" width="230" style="display: <%if("L".equals(suType)){%>block;<%}else{%>none;<%}%>">
			<input type="text" id="bohsupid" name="bohsupid" value="<%if("L".equals(suType)){%><%}else{%><%=currUser.getSupcode()%><%}%>"  size="20" />
		</td>
		<td align="right" width="100">&nbsp;</td>
		<td align="left" width="240">&nbsp;</td>
	</tr>

	<tr> 
		<td colspan="6" style="border:none;"> 
			<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="reloadgrid();"/></a>
		</td> 
	</tr>
	<tr>
		<td id="orderSearchSupListTD" colspan="6" style="border: none; display: none;">
			<table id="orderSearchSupList"></table>
		</td>
	</tr> 
</table>
<!-- 查询条件区域结束  -->
		
	
<!-- 第一个页面 列表页 结束  -->
	
<!-- 第二个页面 详细页 开始 display:none;-->		
<!-- (2)详细区开始 -->
<table id="orderDetHT" width="100" style="line-height:20px;border:none;font-size: 12;display: none" align="center"> 
   <tr><td colspan='6' ><div style=" height: 20px"></div></td></tr>
   <tr><th colspan="6" style="align:center;font-size:24px;">结算补差单明细</th></tr>
         <tr><td colspan='6' ><div style=" height: 20px"></div></td></tr>
   
 <tr>
     <td width="100" align="right">单据编号：</td>
     <td width="230" align="left"><span id="bohbillno_"></span></td>
     <td width="100" align="right">审核日期：</td> 
     <td width="230" align="left"  colspan="3"><span id="bohdhrq_"></span></td>

   </tr>
   <tr>
     <td width="100" align="right">门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：</td>
     <td width="230" align="left"><span id="bohmfid_"></span></td>
     <td width="100" align="right">供&nbsp;应&nbsp;商：</td>
     <td width="570" align="left" colspan="3"><span id="bohsupid_"></span></td>
   </tr>   

   
   
   
   <tr><td colspan="6"><table id="orderDetSupList"></table></td></tr>
   <tr>
      <td colspan="3" style="border:none;">	
		<a href="javascript:void(0);"><img src="images/goback.jpg" border="0" onclick="returnFirst();"/></a>		
      </td>
   </tr>
</table>
        <!-- (2)详细区结束 -->
<!-- (1)标题开始 -->
<span id="detTitle" style="color:008CFF;font-size:20px"></span>
<input type="hidden" id="bohbillno_hidden">
<input type="hidden" id="bohmfid_hidden"><br>
<!-- (1)标题结束 -->
<!-- 第二个页面 详细页 结束 -->
</center>	
</body>
</html>