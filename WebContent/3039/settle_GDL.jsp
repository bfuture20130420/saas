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

	<title>���̽���֪ͨ����ѯ</title>	
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
		//------------------����ʾ��Ӧ��
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
				loadMsg:'��������...',
				showFooter:true,
				columns:[[
				{field:'SHEET_NO',title:'���㵥��',width:120,sortable:true,
					formatter:function(value,rec){
						if(value =='�ϼ�')
							return value;
						return '<a href=javascript:void(0) style="color:#4574a0; font-weight:bold;" onclick=showsettleDet("' +value + '");>' + value+ '</a>';
					}
				},
				{field:'SHPNAME',title:'�ŵ�',width:90,sortable:true,align:'left'},
				
				{field:'SALEWAY',title:'��������',width:90,sortable:true},
				{field:'CONTRACT',title:'��ͬ��',width:90,sortable:true,align:'left'},
				{field:'YMTIME',title:'����',width:90,sortable:true,align:'left'},
				{field:'OPER_NAME',title:'����Ա',width:90,sortable:true,align:'left'},
				{field:'OPER_DATE',title:'��������',width:90,sortable:true,align:'left'},
				{field:'APPROVE_NAME',title:'�����',width:90,sortable:true,align:'left'},
				{field:'APPROVE_DATE',title:'�������',width:90,sortable:true,align:'left'},
				{field:'NOTAXAMT',title:'�ۿ�',width:80,sortable:true,formatter:function(value,rec){
						if( value != null && value != undefined )
							return formatNumber(value,{   
							decimalPlaces: 2,thousandsSeparator :','
							});
					}},
				{field:'TAXAMT',title:'˰��',width:80,sortable:true,formatter:function(value,rec){
								if( value != null && value != undefined )
									return formatNumber(value,{   
									decimalPlaces: 2,thousandsSeparator :','
									});
							}},
				{field:'AMT',title:'��˰�ϼ�',width:80,sortable:true,formatter:function(value,rec){
									if( value != null && value != undefined )
										return formatNumber(value,{   
										decimalPlaces: 2,thousandsSeparator :','
										});
							}},
				{field:'INITAMT',title:'�ڳ����',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
				{field:'NEEDAMT',title:'����Ӧ��',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
				{field:'SETTLEAMT',title:'����ʵ��',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
				{field:'BALANCEAMT',title:'���ڽ���',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
				{field:'TOTDEDUCT_AMT',title:'�ۿ��ܶ�',width:80,sortable:true,formatter:function(value,rec){
										if( value != null && value != undefined )
											return formatNumber(value,{   
											decimalPlaces: 2,thousandsSeparator :','
											});
									}},
					
				<%
				if("L".equalsIgnoreCase( currUser.getSutype().toString()) ){
				%>
					{field:'SUPCUST_NO',title:'��Ӧ�̱���',width:90,sortable:true},
					{field:'SUP_NAME',title:'��Ӧ������',width:200,sortable:true},
				<%
				}
				%>
				{field:'MEMO',title:'��ע',width:90,sortable:true,align:'left'},

				{field:'APPROVE_FLAG',title:'����״̬',width:90,sortable:true,align:'left'},
				{field:'LOOK_STATUS',title:'�鿴״̬',width:90,sortable:true,align:'left'}
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
				loadMsg:'��������...',
				showFooter:true,
				columns:[[
					{field:'SHEET_NO',title:'���㵥��',width:120, rowspan:2,align:'center'},
					{field:'VOUCHER_NO',title:'ҵ�񵥺�',width:120, rowspan:2,align:'center'},
					{field:'ITEM_SUBNO',title:'��Ʒ����',width:200, rowspan:2,align:'center'},
					{field:'ITEM_NAME',title:'��Ʒ����',width:200, rowspan:2,align:'center'},
					{field:'QTY',title:'��������',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'PRICE',title:'���㵥��',width:80, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'AMT',title:'������',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'NOTAX_AMT',title:'�ۿ�',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'TAX_AMT',title:'˰��',width:100, rowspan:2,align:'center',formatter:function(value,rec){
							if( value != null && value != undefined )
								return formatNumber(value,{   
								decimalPlaces: 2,thousandsSeparator :','
								});
						}},
					{field:'TAX_RATE',title:'˰��',width:100, rowspan:2,align:'center',formatter:function(value,rec){
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
			//����������̣�����ʾ��Ӧ�������
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
		//����	
		function returnFirst(){
			$( '#div1' ).show();
			$( '#div2' ).hide(); 
			$("#BZ").html('');//��ձ�עDIV
			$("#fyCheckbox").attr('checked',false);
		}
		//�鿴���㵥��ϸ
		function showsettleDet(settleno){
			var data;
			var fjsl=0;
			var rows = $('#jxsettle').datagrid( 'getRows' );
			var rowInx = $('#jxsettle').datagrid( 'getRowIndex',settleno);	
			if( rowInx < 0 ){
				$.messager.alert('����','����ѡ��һ�м�¼��','warning');
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
			
			
        	//�������
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
        	
			//���ͬ�⣬��ͬ��״̬
			$('#alllookstatus').val( data.LOOK_STATUS );
			
	        //��дʵ�����
			var MONEY = parseFloat($("#SETTLEAMT").text().replace(",",""));
			var chineseMoney=DoNumberCurrencyToChineseCurrency( MONEY );				        
			$('#cMoney').empty().text( chineseMoney );	
			$("#lMoney").empty().text(SETTLEAMT);
        	//�������״̬ȷ���Ƿ���ʾ��ͬ�⣺��ͬ�⣺��ť
        	var APPROVE_FLAG=data.APPROVE_FLAG;
        	if(APPROVE_FLAG=='�����'){
        		$("#yesbt").hide();
        		$("#nobt").hide();
        	}

        	
	        //��ѯ����ֱ�������queryParams��
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
										cnTitle: ['���㵥��','�ŵ�','��������','��ͬ��','����','����Ա','��������','�����','�������','�ۿ�','˰��','��˰�ϼ�','�ڳ����','����Ӧ��','����ʵ��','���ڽ���','�ۿ��ܶ�','��Ӧ�̱���','��Ӧ������','��ע','����״̬','�鿴״̬'],
									<%
									}else{
									%>
									enTitle: ['SHEET_NO','SHPNAME','SALEWAY','CONTRACT','YMTIME','OPER_NAME','OPER_DATE','APPROVE_NAME','APPROVE_DATE','NOTAXAMT','TAXAMT','AMT','INITAMT','NEEDAMT','SETTLEAMT','BALANCEAMT','TOTDEDUCT_AMT','MEMO','APPROVE_FLAG','LOOK_STATUS' ],
									cnTitle: ['���㵥��','�ŵ�','��������','��ͬ��','����','����Ա','��������','�����','�������','�ۿ�','˰��','��˰�ϼ�','�ڳ����','����Ӧ��','����ʵ��','���ڽ���','�ۿ��ܶ�','��ע','����״̬','�鿴״̬'],
									<%}%>
									sheetTitle: '���̽���֪ͨ����ѯ',
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
	                        $.messager.alert('��ʾ','����Excelʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
		}
		
		
		//��ѯ���㵥��Ϣ����-----------------------1111111111
		function searchsettle(){
			var supcode;
			if(User.sutype == 'L'){
				supcode = getFormData( 'jxsettle_form').supcode;
			}else{
				supcode = User.supcode;
			}
			//alert(supcode);
			//�õ��������ֵ
			//var billflag = $('#billflag').val();
			//if(billflag=='0'){
			//$('#sdate').val('');
			//$('#edate').val('');
			//}
			//��ѯ����ֱ�������queryParams��
		    $('#jxsettle').datagrid('options').url = 'JsonServlet';        
			$('#jxsettle').datagrid('options').queryParams = {
				data :obj2str(
					{					
						ACTION_TYPE : 'searchSettlehead',
						ACTION_CLASS : 'com.bfuture.app.saas.model.report.BillHead',
						ACTION_MANAGER : 'settleManagerGdl',	
						optType : 'query',
						optContent : '���̽���֪ͨ����ѯ',	 
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
		//Ĭ����ʾ����
		
	
		//  ��ʾ�ۿ����
		function showKkfyDetList(){
			
				//��ʾ����
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
	                    	 	//ѭ�����п�����ϸ
	                    	 	$.each( data.rows, function(i, n) {    // ѭ��ԭ�б���ѡ�е�ֵ��������ӵ�Ŀ���б���  
	                    	 //		totalKKJE += n.KKJE;
						            var html = (i+1)+"��" + n.CHARGE_NAME + "(��" + n.FEE_AMT+"Ԫ:���飺"+n.MEMO + ")<br/>";  
						            $("#BZ").append(html);  
						        });	
						        //  ���ý��
						    //   var fyje = formatNumber(totalKKJE,{decimalPlaces: 2,thousandsSeparator :','});
						    //    $("#FYJE").text(fyje);
						        //  �۳���Ŀ=�۳���Ŀ+���ý��
						   //     var cjje = formatNumber( parseFloat($("#CJJE").text()) + totalKKJE ,{decimalPlaces: 2,thousandsSeparator :','});
						   //     $("#CJJE").text(cjje);
						   //     // ʵ����� = �������-���ý��
						    //    var sfje = parseFloat($("#SFJE").text().replace(",","")) - totalKKJE;
						   //     var formatsfje = formatNumber( sfje ,{decimalPlaces: 2,thousandsSeparator :','});
						   //     $("#SFJE").text(formatsfje);	
						  //      var chineseMoney=DoNumberCurrencyToChineseCurrency( sfje );				        
						        //��дʵ�����
        				//		$('#cMoney').empty().text( chineseMoney );
						        
	                    	 }else{
	                    		 $("#BZ").append("<h3>û��������Ϣ</h3>");  
	                    	 }
	                    }else{ 
	                        $.messager.alert('��ʾ','��ѯ������ϸʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );
			
		}
		
		//����
		function clearsettle(){
			clearForm('jxsettle_form');
		}
		//��ӡ
		function printJxsettle(){
			$.messager.confirm('ȷ�ϲ���', 'ȷ��Ҫ��ӡ��?', function(r){
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
		

		//��ʾ�ŵ�
		$(function(){
			var subshop=$('#bohmfid');
			loadSupShop(subshop);
		});

		
		// �����ŵ�����������
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
	                        $.messager.alert('��ʾ','��ȡ�ŵ���Ϣʧ��!<br>ԭ��' + data.returnInfo,'error');
	                    } 
	            	},
	            	'json'
	            );				
			}
		}	
		//ͬ�⡢��������ͬ��
		function yesbt(){
			var st=$('#alllookstatus').val();
			if(st=='ȷ������'||st=='������'){
				 $.messager.alert('��ʾ','�����ύ���ˣ������ظ��ύ��');   
				
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
										lookstatus:	'ȷ������'
									}]
								}
							)						
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){
		                    	 $.messager.alert('��ʾ','�ύ�ɹ�');   
		                    	 $('#alllookstatus').val('ȷ������');
		                    }else{ 
		                        $.messager.alert('��ʾ','�ύʧ��');
		                    } 
		            	},
		            	'json'
		            );
				
				
			}
			
		}
		
		function nobt(){
			var st=$('#alllookstatus').val();
			if(st=='ȷ������'||st=='������'){
				 $.messager.alert('��ʾ','�����ύ���ˣ������ظ��ύ��');   
				
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
										lookstatus:	'������'
									}]
								}
							)						
						}, 
						function(data){ 
		                    if(data.returnCode == '1' ){
		                    	 $.messager.alert('��ʾ','�ύ�ɹ�');  
		                    	 $('#alllookstatus').val('������');
		                    }else{ 
		                        $.messager.alert('��ʾ','�ύʧ��');
		                    } 
		            	},
		            	'json'
		            );
			}
		
			
		}
		
		
	</script>
</head>
<body>	
	<div id="div1"   title="���̽���֪ͨ����ѯ" style="width:800px;height:150px;margin-left: 150px" >
		<table id="jxsettle_form" width="800" style="line-height:25px; text-align:left; border:none; font-size:12px"> 
			<tr> 
				<td colspan="3" align="left" style="border:none; color:#4574a0;">���̽���֪ͨ����ѯ</td> 
			</tr> 
			<tr> 
				<td width="240" style="border:none;"> 
					�� ʼ �� �ڣ�
					<input type="text" name="sdate" id="sdate" value="" size="20"  onClick="WdatePicker();"  /> 
					
      			</td>
				<td width="240" style="border:none;"> 
					�� �� �� �ڣ�
					<input type="text" name="edate" id="edate" value="" size="20"   onClick="WdatePicker();" />
				</td> 
				<td width="250" style="border:none;"> 
					 �� �� �� �ţ�
					<input type="text" name="billno" id="billno" value="" /> 
				</td>
  			</tr> 
			<tr>
				<td  width="250" style="border:none;"  > 
					�� �� ״ ̬��
						<select style="width:140px;height:18px" name='lookstatus' id="lookstatus" size='1'  >
              			<option value = ''>����״̬</option>
              			<option value ='δ�鿴'>δ�鿴</option>
              			<option value ='�Ѳ鿴'>�Ѳ鿴</option>
              			<option value = 'ȷ������'>ȷ������</option>
              			<option value = '������'>������</option>
      				</select>
				</td> 	
				<td  width="250" style="border:none;"  > 
					��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�꣺
					<select style="width:140px;height:18px" name='bohmfid' id="bohmfid" size='1'  >
              			<option value = ''>�����ŵ�</option>
      				</select>
				</td> 	
				<td  width="250" style="border:none;"  > 
					�� �� ״ ̬��
						<select style="width:140px;height:18px" name='billstatus' id="billstatus" size='1'  >
              			<option value = ''>����״̬</option>
              			<option value = 'δ���'>δ���</option>
              			<option value = '�����'>�����</option>
              			</select>
				</td> 
			</tr>
 
			<tr>
						<td  width="250" style="border:none;" colspan='3' id="supcode_f"> 
					��Ӧ�̱���&nbsp;��
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
				<a href="javascript:exportExcel();">>>����Excel���</a>
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
								<h3>�����ֳ���</h3>
							</TD>
							<td width="300px;">
								<h2>���̽���֪ͨ��</h2>
							</td>
							<td width="250px;">
								֪ͨ���ţ�<span style="text-decoration:underline;" id="SHEET_NO"></span>
							</td>
						</TR>
						<TR>
							<TD>
								���㿪ʼ���ڣ�<span style="text-decoration:underline;" id="STARTTIME"></span>
							</TD>
							<TD>
								�����ֹ���ڣ�<span style="text-decoration:underline;" id="ENDTIME"></span>
							</TD>
							<TD>
								��ͬ��ţ�<span style="text-decoration:underline;" id="CONTRACT"></span>
							</TD>
						</TR>
						<TR>
							<TD>
								<strong>�鵥��<span style="text-decoration:underline;" id="AMT"></span></strong>
							</TD>
							<TD>
								�����·ݣ�<span style="text-decoration:underline;" id="YMTIME"></span>	
							</TD>
							<td valign="top">
								�˶Ա�־��<span style="text-decoration:underline;" id="APPROVE_FLAG"></span>
							</td>
						</TR>
						<TR>
							<td>
								<strong>�۳���<span style="text-decoration:underline;" id="TOTDEDUCT_AMT"></span></strong>
							</td>
							<td>
								<table>
									<tr>
										<td valign="bottom">
											��<br/>��<br/>��<br/>��
											
										</td>
										<td>
											<table id="tab3" width="170px" style="border:1px solid black;" cellpadding="0" cellspacing="0">
												<tr style="border:1px solid black;">
													<td width="80px;">�ڳ���</td>
													<td >
														<span id="INITAMT">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>����Ӧ�᣺</td>
													<td>
														<span id="NEEDAMT">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>����ʵ�᣺</td>
													<td>
														 <span id="SETTLEAMT">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>���ڽ��ࣺ</td>
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
											��<br/>��<br/>ִ<br/>��
											
										</td>
										<td>
											<table id="tab3" width="170px" style="border:1px solid black;" cellpadding="0" cellspacing="0">
													<tr style="border:1px solid black;">
													<td style="width:80px;">�����ˣ�</td>
													<td>
														<span id="OPER_NAME">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>�������ڣ�</td>
													<td>
														<span id="OPER_DATE">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>����ˣ�</td>
													<td>
														 <span id="APPROVE_NAME">&nbsp;</span>
													</td>
												</tr>
												<tr style="border:1px solid black;">
													<td>������ڣ�</td>
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
										<td>���̱���</td>
										<td>��������</td>
										<td>ʵ�ʽ�����</td>
										<td>�ۿ�</td>
										<td>˰��</td>
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
									<strong>����ʵ����</strong>
									<span style="font-size: 15px;">
										��д��<span id="cMoney"></span>
										(Сд)&nbsp;&nbsp;
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
											��ע
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
														���룺
														<span id="LRR"></span>&nbsp;&nbsp;
														<span id="LRRQ"></span>
													</td>
													<td>
														�˶ԣ�
														<span id="HDR"></span>&nbsp;&nbsp;
														<span id="HDRQ"></span>
													</td>
													<td>
														��ӡ��
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
								֧����ʽ��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</TD>
							<TD style="text-decoration:underline;">
								�������У�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</TD>
							<TD style="text-decoration:underline;">
								�����˺ţ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</TD>
						</TR>
						<tr>
							<TD colspan="3">
								<table id="jxsettleDet" align="center"></table>
							</TD>
						</tr>
						<tr>
							<td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�ɣ�</td>
							<td>������</td>
							<td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̣�</td>
						</tr>
						<tr>
							<td>�쵼��ʾ��</td>
							<td>��&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�㣺</td>
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
								<!--<input type="checkbox" id="fyCheckbox" onclick="showKkfyDetList(this);" />��ʾ����&nbsp;&nbsp;&nbsp;&nbsp;  -->
								<%
									if(currUser.getSutype()!='L'){
									%>
									<input type="hidden" id="alllookstatus"/>
									<input type="button" id="yesbt" name="yesbt" value=" ͬ�� "  onClick="yesbt();" class=bottom>&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="button" id="nobt" name="nobt" value=" ��ͬ�� "  onClick="nobt();" class=bottom>&nbsp;&nbsp;&nbsp;&nbsp;
									<%} %>

							
								<input type="button" name="btprint" value=" ��ӡ "  onClick="printJxsettle();" class=bottom>&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="button" name="" value=" ���� " class=bottom onclick="returnFirst();">
							</td>
						</tr>
					</table> 
				</td>
			</tr>
		</table>
	</div>
</body>
</html>