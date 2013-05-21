<%@ page language="java" contentType="text/html; charset=GBK"
    pageEncoding="GBK" %>
<%@page import="com.bfuture.app.saas.util.Money" %>
    
<%@page import="com.bfuture.app.saas.model.SysScmuser"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<%      
		Object obj = session.getAttribute( "LoginUser" );
		if( obj == null ){
			response.sendRedirect( "login.jsp" );
			return;
		}		
		SysScmuser currUser = (SysScmuser)obj;
%>

	<title>厂商结算通知单查询</title>	
	<style type="text/css">   	      
        .proxy{
			border:1px solid #ccc;
			width:200px;
			background:#9FECFF;
			position:'absolute';
			z-Index:99999;
		}
		.over{
			border:1px solid red;			
		}
		.normal{
			border:1px solid #ccc;
		}
        .btn  
        {  
            display: block;  
            margin: 10px auto;  
            width: 80px;  
        }  
        #tab3 td{
        	border:1px solid black;
        }
	</style>
	
	<script>
		//------------------不显示供应商
		$(function(){
			if(User.sutype != 'L'){
				$("#supcode_f").hide();	
			};		
			}
		);
	
		$(function(){
			$('#jxsettle').datagrid({
				width: User.sutype == 'L' ? 867 : 867,
				nowrap: false,
				striped: true,
				collapsible:true,
				url:'',
				sortOrder: 'desc',
				remoteSort: true,
				fitColumns:false,
				idField: 'SHEET_NO',
				loadMsg:'加载数据...',
				showFooter:true,
				columns:[[
				{field:'SHEET_NO',title:'结算单号',width:120,sortable:true,
					formatter:function(value,rec){
						if(value =='合计')
							return value;
						return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showsettleDet("' +value + '");>' + value+ '</a>';
					}
				},
				{field:'SHPNAME',title:'门店',width:90,sortable:true,align:'left'},
				
				{field:'SALEWAY',title:'结算类型',width:90,sortable:true},
				{field:'CONTRACT',title:'合同号',width:90,sortable:true,align:'left'},
				{field:'YMTIME',title:'年月',width:90,sortable:true,align:'left'},
				{field:'OPER_NAME',title:'操作员',width:90,sortable:true,align:'left'},
				{field:'OPER_DATE',title:'操作日期',width:90,sortable:true,align:'left'},
				{field:'APPROVE_NAME',title:'审核人',width:90,sortable:true,align:'left'},
				{field:'APPROVE_DATE',title:'审核日期',width:90,sortable:true,align:'left'},
				{field:'NOTAXAMT',title:'价款',width:80,sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
					}},
				{field:'TAXAMT',title:'税额',width:80,sortable:true,formatter:function(value,rec){
								if( value != null && value != undefined )
									return formatNumber(value,{   
									decimalPlaces: 2,thousandsSeparator :','
									});
							}},
				{field:'AMT',title:'价税合计',width:80,sortable:true,formatter:function(value,rec){
									if( value != null && value != undefined )
										return formatNumber(value,{   
										decimalPlaces: 2,thousandsSeparator :','
										});
							}},
				{field:'INITAMT',title:'期初余款',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
				{field:'NEEDAMT',title:'本期应结',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
				{field:'SETTLEAMT',title:'本期实结',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
				{field:'BALANCEAMT',title:'本期结余',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
				{field:'TOTDEDUCT_AMT',title:'扣款总额',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
					
				<%
				if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
				%>
					{field:'SUPCUST_NO',title:'供应商编码',width:90,sortable:true},
					{field:'SUP_NAME',title:'供应商名称',width:200,sortable:true},
				<%
				}
				%>
				{field:'MEMO',title:'备注',width:90,sortable:true,align:'left'},

				{field:'APPROVE_FLAG',title:'单据状态',width:90,sortable:true,align:'left'},
				{field:'LOOK_STATUS',title:'查看状态',width:90,sortable:true,align:'left'}
				]],
				pagination:true,
				singleSelect:true,
				rownumbers:true
			});	
			$('#jxsettleDet').datagrid({
				width: 800,
				iconCls:'icon-save',
				nowrap: false,
				striped: true,				
				url:'',
				sortOrder: 'asc',
				singleSelect : true,
				remoteSort: true,
				fitColumns:false,
				loadMsg:'加载数据...',
				showFooter:true,
				columns:[[
					{field:'SHEET_NO',title:'结算单号',width:120, rowspan:2,align:'center'},
					{field:'VOUCHER_NO',title:'业务单号',width:120, rowspan:2,align:'center'},
					{field:'ITEM_SUBNO',title:'商品条码',width:200, rowspan:2,align:'center'},
					{field:'ITEM_NAME',title:'商品名称',width:200, rowspan:2,align:'center'},
					{field:'QTY',title:'结算数量',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'PRICE',title:'结算单价',width:80, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'AMT',title:'结算金额',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'NOTAX_AMT',title:'价款',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'TAX_AMT',title:'税额',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'TAX_RATE',title:'税率',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}}
				
				]],	
				pagination:true,			
				rownumbers:true
			});
			var now = new Date();
			now.setDate( now.getDate() - 30 );
			$("#sdate").val(now.format('yyyy-MM-dd'));
			$('#edate').val(Date.parseString(new Date().toString()).format('yyyy-MM-dd'));
			//如果是零售商，就显示供应商输入框
			if(User.sutype == 'L'){
				$("#supcodeDiv").show();
				$("#jxDataExportExcel").width(867);
				$("#div1").attr("style","width:867px;height:150px;margin-left:300px");
			}else{
				$("#supcodeDiv").hide();
			}
			
			//var billflag=$('#billflag').val();
			
			//if(billflag==0){
			//searchsettle();
			
			//}
			//$('#billflag').val('');
		});	
		//返回	
		function returnFirst(){
			$( '#div1' ).show();
			$( '#div2' ).hide(); 
			$("#BZ").html('');//清空备注DIV
			$("#fyCheckbox").attr('checked',false);
		}
		//查看结算单明细
		function showsettleDet(settleno){
			var data;
			var fjsl=0;
			var rows = $('#jxsettle').datagrid( 'getRows' );
			var rowInx = $('#jxsettle').datagrid( 'getRowIndex',settleno);	
			if( rowInx < 0 ){
				$.messager.alert('警告','请先选择一行记录！','warning');
				return;
			}
			data = rows[rowInx];	
			
			clearObject( data );			
			var NOTAXAMT = formatNumber(data.NOTAXAMT,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
			var TAXAMT = formatNumber(data.TAXAMT,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
			var AMT = formatNumber(data.AMT,{   
				decimalPlaces: 2,thousandsSeparator :','
			});
			var INITAMT = formatNumber(data.INITAMT,{   
				decimalPlaces: 2,thousandsSeparator :','
			});
			var NEEDAMT = formatNumber(data.NEEDAMT,{   
				decimalPlaces: 2,thousandsSeparator :','
			});
			var SETTLEAMT = formatNumber(data.SETTLEAMT,{   
				decimalPlaces: 2,thousandsSeparator :','
			});
			var BALANCEAMT = formatNumber(data.BALANCEAMT,{   
				decimalPlaces: 2,thousandsSeparator :','
			});
			var TOTDEDUCT_AMT = formatNumber(data.TOTDEDUCT_AMT,{   
				decimalPlaces: 2,thousandsSeparator :','
			});		
			$('#NOTAXAMT').text(NOTAXAMT );
			$('#TAXAMT').text(TAXAMT );
			$('#AMT').text( AMT );
			$('#INITAMT').text( INITAMT );
			$('#NEEDAMT').text( NEEDAMT );
			$('#SETTLEAMT').text( SETTLEAMT );
			$('#SETTLEAMT_T').text( SETTLEAMT );
			$('#BALANCEAMT').text( BALANCEAMT );
			$('#TOTDEDUCT_AMT').text( TOTDEDUCT_AMT );
			
			
        	//填充数据
        	$('#JSHSGCODE').text( data.JSHSGCODE );
        	$('#SHEET_NO').text( data.SHEET_NO  );
        	$('#SHPNAME').text( data.SHPNAME );
        	$('#CONTRACT').text( data.CONTRACT );
        	$('#YMTIME').text( data.YMTIME );
        	$('#STARTTIME').text( data.STARTTIME );
        	$('#ENDTIME').text( data.ENDTIME );
        	$('#OPER_NAME').text( data.OPER_NAME );
        	$('#OPER_DATE').text( data.OPER_DATE );
        	$('#APPROVE_NAME').text( data.APPROVE_NAME );
        	$('#APPROVE_DATE').text( data.APPROVE_DATE );
        	$('#SUPCUST_NO').text( data.SUPCUST_NO);
        	$('#SUP_NAME').text( data.SUP_NAME );
        	$('#APPROVE_FLAG').text( data.APPROVE_FLAG);
        	$('#LOOK_STATUS').text( data.LOOK_STATUS );
        	
			//填充同意，不同意状态
			$('#alllookstatus').val( data.LOOK_STATUS );
			
	        //大写实付金额
			var MONEY = parseFloat($("#SETTLEAMT").text().replace(",",""));
			var chineseMoney=DoNumberCurrencyToChineseCurrency( MONEY );				        
			$('#cMoney').empty().text( chineseMoney );	
			$("#lMoney").empty().text(SETTLEAMT);
        	//根据审核状态确定是否显示：同意：不同意：按钮
        	var APPROVE_FLAG=data.APPROVE_FLAG;
        	if(APPROVE_FLAG=='已审核'){
        		$("#yesbt").hide();
        		$("#nobt").hide();
        	}

        	
	        //查询参数直接添加在queryParams中
	        $('#jxsettleDet').datagrid('options').url = 'JsonServlet';        
			$('#jxsettleDet').datagrid('options').queryParams = {
				data :obj2str(
					{		
						ACTION_TYPE : 'serchSettledt',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
						ACTION_MANAGER : 'settleManagerGdl',			 
						list:[{sgcode : User.sgcode,billno:data.SHEET_NO,sutype:User.sutype == 'L' ?'L':'S',lookstatus:data.LOOK_STATUS	}]
					}
				)
			};
			$("#jxsettleDet").datagrid('resize');        
			$("#jxsettleDet").datagrid('reload'); 
			
			$( '#div1' ).hide();
			$( '#div2' ).show();
			$(function (){
				showKkfyDetList();
				//$("#fyCheckbox").attr('checked',true);
				
			});
		}
		
		
		function exportExcel(){
			var supcode;
			if(User.sutype == 'L'){
				supcode = getFormData( 'jxsettle_form').supcode;
			}else{
				supcode = User.supcode;
			}
			$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'searchSettlehead',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
								ACTION_MANAGER : 'settleManagerGdl',										 
								list:[{
									exportExcel : true,
									<%
									if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
									%>
										enTitle: ['SHEET_NO','SHPNAME','SALEWAY','CONTRACT','YMTIME','OPER_NAME','OPER_DATE','APPROVE_NAME','APPROVE_DATE','NOTAXAMT','TAXAMT','AMT','INITAMT','NEEDAMT','SETTLEAMT','BALANCEAMT','TOTDEDUCT_AMT','SUPCUST_NO','SUP_NAME','MEMO','APPROVE_FLAG','LOOK_STATUS' ],
										cnTitle: ['结算单号','门店','结算类型','合同号','年月','操作员','操作日期','审核人','审核日期','价款','税额','价税合计','期初余款','本期应结','本期实结','本期结余','扣款总额','供应商编码','供应商名称','备注','单据状态','查看状态'],
									<%
									}else{
									%>
									enTitle: ['SHEET_NO','SHPNAME','SALEWAY','CONTRACT','YMTIME','OPER_NAME','OPER_DATE','APPROVE_NAME','APPROVE_DATE','NOTAXAMT','TAXAMT','AMT','INITAMT','NEEDAMT','SETTLEAMT','BALANCEAMT','TOTDEDUCT_AMT','MEMO','APPROVE_FLAG','LOOK_STATUS' ],
									cnTitle: ['结算单号','门店','结算类型','合同号','年月','操作员','操作日期','审核人','审核日期','价款','税额','价税合计','期初余款','本期应结','本期实结','本期结余','扣款总额','备注','单据状态','查看状态'],
									<%}%>
									sheetTitle: '厂商结算通知单查询',
									sgcode : User.sgcode,
									sdate:getFormData( 'jxsettle_form').sdate,
									edate:getFormData( 'jxsettle_form').edate,
									billno:getFormData( 'jxsettle_form').billno,
									lookstatus:getFormData( 'jxsettle_form').lookstatus,
									billstatus:	getFormData( 'jxsettle_form').billstatus,
									sucode:getFormData( 'jxsettle_form').supcode,
									bohmfid:getFormData('jxsettle_form').bohmfid

								}]
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
		
		
		//查询结算单信息主表-----------------------1111111111
		function searchsettle(){
			var supcode;
			if(User.sutype == 'L'){
				supcode = getFormData( 'jxsettle_form').supcode;
			}else{
				supcode = User.supcode;
			}
			//alert(supcode);
			//得到隐藏域的值
			//var billflag = $('#billflag').val();
			//if(billflag=='0'){
			//$('#sdate').val('');
			//$('#edate').val('');
			//}
			//查询参数直接添加在queryParams中
		    $('#jxsettle').datagrid('options').url = 'JsonServlet';        
			$('#jxsettle').datagrid('options').queryParams = {
				data :obj2str(
					{					
						ACTION_TYPE : 'searchSettlehead',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
						ACTION_MANAGER : 'settleManagerGdl',	
						optType : 'query',
						optContent : '厂商结算通知单查询',	 
						list:[{
							sgcode : User.sgcode,
							sdate:getFormData( 'jxsettle_form').sdate,
							edate:getFormData( 'jxsettle_form').edate,
							billno:getFormData( 'jxsettle_form').billno,
							lookstatus:getFormData( 'jxsettle_form').lookstatus,
							billstatus:	getFormData( 'jxsettle_form').billstatus,
							sucode:supcode,
							bohmfid:getFormData('jxsettle_form').bohmfid,
							sutype:User.sutype == 'L' ?'L':'S'
						}]		 
					}
				)
			}; 
			//alert(getFormData( 'jxsettle_form').supcode);
			$("#jxsettle").datagrid('reload');
			$("#datajxsettle").show();
			$("#jxsettle").datagrid('resize'); 
		}
		//默认显示费用
		
	
		//  显示扣款费用
		function showKkfyDetList(){
			
				//显示费用
				$.post( 'JsonServlet',				
					{
						data :obj2str(
							{		
								ACTION_TYPE : 'searchSettlekxdet',
								ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
								ACTION_MANAGER : 'settleManagerGdl',										 
								list:[{
									sgcode : User.sgcode,
									billno: $("#SHEET_NO").text()
								}]
							}
						)						
					}, 
					function(data){ 
	                    if(data.returnCode == '1' ){
	                    	 if( data.rows != undefined && data.rows.length > 0 ){	
	                    	 	var totalKKJE = 0;
	                    	 	//循环所有扣项明细
	                    	 	$.each( data.rows, function(i, n) {    // 循环原列表中选中的值，依次添加到目标列表中  
	                    	 //		totalKKJE += n.KKJE;
						            var html = (i+1)+"、" + n.CHARGE_NAME + "(￥" + n.FEE_AMT+"元:详情："+n.MEMO + ")<br/>";  
						            $("#BZ").append(html);  
						        });	
						        //  费用金额
						    //   var fyje = formatNumber(totalKKJE,{decimalPlaces: 2,thousandsSeparator :','});
						    //    $("#FYJE").text(fyje);
						        //  扣除项目=扣除项目+费用金额
						   //     var cjje = formatNumber( parseFloat($("#CJJE").text()) + totalKKJE ,{decimalPlaces: 2,thousandsSeparator :','});
						   //     $("#CJJE").text(cjje);
						   //     // 实付金额 = 勾单金额-费用金额
						    //    var sfje = parseFloat($("#SFJE").text().replace(",","")) - totalKKJE;
						   //     var formatsfje = formatNumber( sfje ,{decimalPlaces: 2,thousandsSeparator :','});
						   //     $("#SFJE").text(formatsfje);	
						  //      var chineseMoney=DoNumberCurrencyToChineseCurrency( sfje );				        
						        //大写实付金额
        				//		$('#cMoney').empty().text( chineseMoney );
						        
	                    	 }else{
	                    		 $("#BZ").append("<h3>没有其它信息</h3>");  
	                    	 }
	                    }else{ 
	                        $.messager.alert('提示','查询费用明细失败!<br>原因：' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			
		}
		
		//重置
		function clearsettle(){
			clearForm('jxsettle_form');
		}
		//打印
		function printJxsettle(){
			$.messager.confirm('确认操作', '确认要打印吗?', function(r){
				if (r){
					var djbh = $('#SHEET_NO').text();
					var sgcode = User.sgcode;
					var supcode = $('#SUPCUST_NO').text();
					//var url = "settledetPrint_GDL.jsp?supcode="+supcode+"&billno="+djbh+"&sgcode="+sgcode+"&isShowFY="+$("#fyCheckbox").attr("checked");
					var url = "settlegdl_print.jsp?supcode="+supcode+"&billno="+djbh+"&sgcode="+sgcode;
					window.open(url,'','width='+(screen.width-12)+',height='+(screen.height-80)+', top=0,left=0, toolbar=yes, menubar=yes, scrollbars=yes, resizable=yes,location=no,status=yes');	
				}
			});
		}
		

		//显示门店
		$(function(){
			var subshop=$('#bohmfid');
			loadSupShop(subshop);
		});

		
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
		//同意、、、、不同意
		function yesbt(){
			var st=$('#alllookstatus').val();
			if(st=='确认无误'||st=='有疑问'){
				 $.messager.alert('提示','您已提交过了，请勿重复提交！');   
				
			}else{
				$.post( 'JsonServlet',				
						{
							data :obj2str(
								{		
									ACTION_TYPE : 'uplookstatus',
									ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
									ACTION_MANAGER : 'settleManagerGdl',										 
									list:[{									
										sgcode : User.sgcode,
										billno:$("#SHEET_NO").text(),
										lookstatus:	'确认无误'
									}]
								}
							)						
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){
		                    	 $.messager.alert('提示','提交成功');   
		                    	 $('#alllookstatus').val('确认无误');
		                    }else{ 
		                        $.messager.alert('提示','提交失败');
		                    } 
		            	},
		            	'json'
		            );
				
				
			}
			
		}
		
		function nobt(){
			var st=$('#alllookstatus').val();
			if(st=='确认无误'||st=='有疑问'){
				 $.messager.alert('提示','您已提交过了，请勿重复提交！');   
				
			}else{
				$.post( 'JsonServlet',				
						{
							data :obj2str(
								{		
									ACTION_TYPE : 'uplookstatus',
									ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
									ACTION_MANAGER : 'settleManagerGdl',										 
									list:[{									
										sgcode : User.sgcode,
										billno:$("#SHEET_NO").text(),
										lookstatus:	'有疑问'
									}]
								}
							)						
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){
		                    	 $.messager.alert('提示','提交成功');  
		                    	 $('#alllookstatus').val('有疑问');
		                    }else{ 
		                        $.messager.alert('提示','提交失败');
		                    } 
		            	},
		            	'json'
		            );
			}
		
			
		}
		
		
	</script>
</head>
<body>	
	<div id="div1"   title="厂商结算通知单查询" style="width:800px;height:150px;margin-left: 150px" >
		<table id="jxsettle_form" width="800" style="line-height:25px; text-align:left; border:none; font-size:12px"> 
			<tr> 
				<td colspan="3" align="left" style="border:none; color:#4574a0;">厂商结算通知单查询</td> 
			</tr> 
			<tr> 
				<td width="240" style="border:none;"> 
					起 始 日 期：
					<input type="text" name="sdate" id="sdate" value="" size="20"  onClick="WdatePicker();"  /> 
					
      			</td>
				<td width="240" style="border:none;"> 
					结 束 日 期：
					<input type="text" name="edate" id="edate" value="" size="20"   onClick="WdatePicker();" />
				</td> 
				<td width="250" style="border:none;"> 
					 结 算 单 号：
					<input type="text" name="billno" id="billno" value="" /> 
				</td>
  			</tr> 
			<tr>
				<td  width="250" style="border:none;"  > 
					查 看 状 态：
						<select style="width:140px;height:18px" name='lookstatus' id="lookstatus" size='1'  >
              			<option value = ''>所有状态</option>
              			<option value ='未查看'>未查看</option>
              			<option value ='已查看'>已查看</option>
              			<option value = '确认无误'>确认无误</option>
              			<option value = '有疑问'>有疑问</option>
      				</select>
				</td> 	
				<td  width="250" style="border:none;"  > 
					门&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;店：
					<select style="width:140px;height:18px" name='bohmfid' id="bohmfid" size='1'  >
              			<option value = ''>所有门店</option>
      				</select>
				</td> 	
				<td  width="250" style="border:none;"  > 
					单 据 状 态：
						<select style="width:140px;height:18px" name='billstatus' id="billstatus" size='1'  >
              			<option value = ''>所有状态</option>
              			<option value = '未审核'>未审核</option>
              			<option value = '已审核'>已审核</option>
              			</select>
				</td> 
			</tr>
 
			<tr>
						<td  width="250" style="border:none;" colspan='3' id="supcode_f"> 
					供应商编码&nbsp;：
						<input type="text" name="supcode" id="supcode" value="" width="110" /> 
				</td> 	
			</tr>	
			<tr>
				<td style="border:none;" colspan="3" align="left"> 
	  				<a href="javascript:void(0);"><img src="images/sure.jpg" border="0" onclick="searchsettle();"/></a>
				</td> 			
			</tr>
		</table>
		<div id="datajxsettle" style="display:none;">
			<div id="jxDataExportExcel" align="left" style="color: #336699; width: 800;">
				<a href="javascript:exportExcel();">>>导出Excel表格</a>
			</div>	
			<table id="jxsettle" align="center"></table>
		</div> 
	</div>

	<div id="div2" style="width:800px;display:none;padding: 10px;margin-left: 150px;">
		<table id="tab1" width="100%" height="100%">
			<tr>
				<td>
					<table id="tab2" width="100%" style="line-height: 25px;text-align: left; border: none; font-size: 12px; background-color: #F5F5F5; padding: 10px;">
						<TR>
							<TD width="250px;">
								<h3>购得乐超市</h3>
							</TD>
							<td width="300px;">
								<h2>厂商结算通知单</h2>
							</td>
							<td width="250px;">
								通知单号：<span style="text-decoration:underline;" id="SHEET_NO"></span>
							</td>
						</TR>
						<TR>
							<TD>
								结算开始日期：<span style="text-decoration:underline;" id="STARTTIME"></span>
							</TD>
							<TD>
								结算截止日期：<span style="text-decoration:underline;" id="ENDTIME"></span>
							</TD>
							<TD>
								合同编号：<span style="text-decoration:underline;" id="CONTRACT"></span>
							</TD>
						</TR>
						<TR>
							<TD>
								<strong>抽单金额：<span style="text-decoration:underline;" id="AMT"></span></strong>
							</TD>
							<TD>
								付款月份：<span style="text-decoration:underline;" id="YMTIME"></span>	
							</TD>
							<td valign="top">
								核对标志：<span style="text-decoration:underline;" id="APPROVE_FLAG"></span>
							</td>
						</TR>
						<TR>
							<td>
								<strong>扣除金额：<span style="text-decoration:underline;" id="TOTDEDUCT_AMT"></span></strong>
							</td>
							<td>
								<table>
									<tr>
										<td valign="bottom">
											结<br/>算<br/>金<br/>额
											
										</td>
										<td>
											<table id="tab3" width="170px" style="border:1px solid black;" cellpadding="0" cellspacing="0">
												<tr style="border:1px solid black;">
													<td width="80px;">期初余款：</td>
													<td >
														<span id="INITAMT">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>本期应结：</td>
													<td>
														<span id="NEEDAMT">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>本期实结：</td>
													<td>
														 <span id="SETTLEAMT">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>本期结余：</td>
													<td>
														 <span id="BALANCEAMT">&nbsp;</span>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>	
							</td>
							<td valign="top">
								<table>
									<tr>
										<td valign="bottom">
											单<br/>据<br/>执<br/>行
											
										</td>
										<td>
											<table id="tab3" width="170px" style="border:1px solid black;" cellpadding="0" cellspacing="0">
													<tr style="border:1px solid black;">
													<td style="width:80px;">操作人：</td>
													<td>
														<span id="OPER_NAME">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>操作日期：</td>
													<td>
														<span id="OPER_DATE">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>审核人：</td>
													<td>
														 <span id="APPROVE_NAME">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>审核日期：</td>
													<td>
														 <span id="APPROVE_DATE">&nbsp;</span>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>	
							</td>
						</TR>
							<tr>
							<td colspan="3">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr style="text-decoration:underline;" >
										<td>厂商编码</td>
										<td>厂商名称</td>
										<td>实际结算金额</td>
										<td>价款</td>
										<td>税款</td>
									</tr>
									<tr style="text-decoration:underline;" >
										<td>
											<span id="SUPCUST_NO">&nbsp;</span>
										</td>
										<td>
											<SPAN ID="SUP_NAME">&nbsp;</SPAN>
										</td>
										<td>
											<SPAN ID="SETTLEAMT_T">&nbsp;</SPAN>
										</td>
										<td>
											<SPAN ID="NOTAXAMT">&nbsp;</SPAN>
										</td>
										<td>
											<SPAN ID="TAXAMT">&nbsp;</SPAN>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<TR>
							<TD colspan="3">
								<span style="text-decoration:underline;">
									<strong>本次实付：</strong>
									<span style="font-size: 15px;">
										大写金额：<span id="cMoney"></span>
										(小写)&nbsp;&nbsp;
										<strong><span id="lMoney"></span></strong>
									</span>
								</span>
							</TD>
						</TR>
						
					
						<tr>
							<td colspan="3">
								<table width="100%" style="border:1px solid black;" cellpadding="0" cellspacing="0">	
									<TR>
										<TD WIDTH="10px;" style="border:1px solid black;">
											备注
										</TD>
										<TD>
											<TABLE width="100%" style="border:1px solid black;" cellpadding="0" cellspacing="0">
												<tr height='50px;'>
													<td colspan="3">
														<span id="BZ"></span> 
													</td>
												</tr>
												<tr>
													<td colspan="3">&nbsp;</td>
												</tr>
												<tr>
													<td>
														输入：
														<span id="LRR"></span>&nbsp;&nbsp;
														<span id="LRRQ"></span>
													</td>
													<td>
														核对：
														<span id="HDR"></span>&nbsp;&nbsp;
														<span id="HDRQ"></span>
													</td>
													<td>
														打印：
													</td>
												</tr>
											</TABLE>
										</TD>
									</TR>
								</table>
							</td>
						</tr>
						<TR>
							<TD style="text-decoration:underline;">
								支付方式：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</TD>
							<TD style="text-decoration:underline;">
								开户银行：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</TD>
							<TD style="text-decoration:underline;">
								银行账号：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</TD>
						</TR>
						<tr>
							<TD colspan="3">
								<table id="jxsettleDet" align="center"></table>
							</TD>
						</tr>
						<tr>
							<td>出&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;纳：</td>
							<td>财务经理：</td>
							<td>厂&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;商：</td>
						</tr>
						<tr>
							<td>领导批示：</td>
							<td>结&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;算：</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>	
				<td>
					<table width="100%" border="1" style="line-height:20px; text-align:left; font-size:12px;background-color:#F5F5F5 ">
						<tr align="center">
							<td>
								<!--<input type="checkbox" id="fyCheckbox" onclick="showKkfyDetList(this);" />显示费用&nbsp;&nbsp;&nbsp;&nbsp;  -->
								<%
									if(currUser.getSutype()!='L'){
									%>
									<input type="hidden" id="alllookstatus"/>
									<input type="button" id="yesbt" name="yesbt" value=" 同意 "  onClick="yesbt();" class=bottom>&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="button" id="nobt" name="nobt" value=" 不同意 "  onClick="nobt();" class=bottom>&nbsp;&nbsp;&nbsp;&nbsp;
									<%} %>

							
								<input type="button" name="btprint" value=" 打印 "  onClick="printJxsettle();" class=bottom>&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="button" name="" value=" 返回 " class=bottom onclick="returnFirst();">
							</td>
						</tr>
					</table> 
				</td>
			</tr>
		</table>
	</div>
</body>
</html>