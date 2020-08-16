<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>用户主页</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file="/WEB-INF/common.jsp"%>

<link
	href="${path }/resources/css/plugins/bootstrap-table/bootstrap-table.min.css"
	rel="stylesheet">
<link href="${path }/resources/css/animate.css" rel="stylesheet">
<link href="${path }/resources/css/style.css?v=4.1.0" rel="stylesheet">
<script src="${path }/resources/js/echarts.js"></script>
	
</head>
<body class="gray-bg">
	<div class="panel-body">
		<div id="toolbar" class="btn-group">
			<c:forEach items="${operationList}" var="oper">
				<privilege:operation operationId="${oper.operationid }" id="${oper.operationcode }" name="${oper.operationname }" clazz="${oper.iconcls }"  color="#093F4D"></privilege:operation>
			</c:forEach>
        </div>
        <div class="row">
         	<div class="col-lg-2">
				<div class="input-group">
			      <span class="input-group-addon">起止日期 </span>
			      <input name="startTime" id="txt_search_startTime"  class="laydate-icon form-control layer-date">
			      --
			      <input name="endTime"  id="txt_search_endTime" class="laydate-icon form-control layer-date" >
				</div>
			  </div>
        
			  <div class="col-lg-2">
				<div class="input-group">
			      <span class="input-group-addon">学生姓名 </span>
			      <input type="text" name="sname" class="form-control" id="txt_search_sname" >
				</div>
			  </div>
			  <div class="col-lg-2">
				<div class="input-group">
					<span class="input-group-addon">专业</span>
					<select class="form-control" name="txt_search_maid" id = "txt_search_maid">
						<option value="0">---请选择---</option>
						<c:forEach items="${roleList }" var="r">
						 	<option value="${r.maid }">${r.maname }</option>
						</c:forEach>
                	</select>
				</div>
			 </div>
            <button id="btn_search" type="button" class="btn btn-default">
            	<span class="glyphicon glyphicon-search" aria-hidden="true"></span>查询
            </button>
	  	</div>
        
        <table id="table_user"></table>
		
	</div>
	
	<!-- 新增和修改对话框 -->
	<div class="modal fade" id="modal_user_edit" role="dialog" aria-labelledby="modal_user_edit" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<form id="form_user" method="post" action="reserveStudent.htm">
						<input type="hidden" name="sid" id="hidden_txt_userid" value=""/>
						<table style="border-collapse:separate; border-spacing:0px 10px;">
							<tr>
								<td>学生姓名：</td>
								<td><input type="text" id="sname" name="sname"
									class="form-control" aria-required="true" required/></td>
								<td>&nbsp;&nbsp;</td>
								<td>性别：</td>
								<td><input type="radio"  name="sex"
									value="男"/>男
									<input type="radio"  name="sex"
									 value="女"/>女
									</td>
							</tr>
							<tr>
								<td>爱好：</td>
								<td><input type="checkbox" id="hobby" name="hobby"
									 value="篮球"/>篮球
								<input type="checkbox" id="hobby" name="hobby"
										 value="足球"/>足球
								<input type="checkbox" id="hobby" name="hobby"
									value="排球"/>排球</td>
							</tr>
							<tr>
								<td>生日：</td>
								<td><input type="date" id="birthday" name="birthday"/>
								</td>
							</tr>
							<tr>
								<td>专业：</td>
								<td colspan="4">
									<select class="form-control" name="maid" id = "maid" aria-required="true" required>
										<option value="">---请选择---</option>
										<c:forEach items="${roleList }" var="r">
										 	<option value="${r.maid }">${r.maname }</option>
										</c:forEach>
				                	</select>
								</td>
							</tr>
						</table>
						
						<div class="modal-footer">
							<button type="button" class="btn btn-primary"  id="submit_form_user_btn">保存</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						</div>
					</form>

				</div>
				
			</div>

		</div>

	</div>
	
	
	<!-- 导入对话框 -->
	<div class="modal fade" id="modal_student_in" role="dialog" aria-labelledby="modal_user_edit" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<form id="form_in" method="post" action="inStudent.htm" enctype="multipart/form-data">
						<table style="border-collapse:separate; border-spacing:0px 10px;">
							<tr>
								<td>请选择文件：</td>
								<td><input type="file" id="file" name="file"
									class="form-control" aria-required="true" required/></td>
							</tr>
							
						</table>
						
						<div class="modal-footer">
							<button type="button" class="btn btn-primary"  id="submit_form_student_in">上传</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						</div>
					</form>

				</div>
				
			</div>

		</div>

	</div>
	<!-- 添加专业对话框 -->
	<div class="modal fade" id="modal_student_addmajor" role="dialog" aria-labelledby="modal_student_addmajor" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<form id="form_addmajor" method="post" action="addMajor.htm">
						<table style="border-collapse:separate; border-spacing:0px 10px;">
							<tr>
								<td>请填写专业：</td>
								<td><input name="maname"/></td>
							</tr>
							
						</table>
						
						<div class="modal-footer">
							<button type="button" class="btn btn-primary"  id="submit_form_student_addmajor">添加</button>
							<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						</div>
					</form>

				</div>
				
			</div>

		</div>

	</div>
	
	<div class="modal fade" id="modal_student_zz" role="dialog" aria-labelledby="modal_student_zz" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
						<table style="border-collapse:separate; border-spacing:0px 10px;">
							<tr>
								<td> 
								<div id="main1" style="width: 600px;height:400px;"></div>
								</td>
							</tr>
							
						</table>
						
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						</div>

				</div>
				
			</div>

		</div>

	</div>
	
	<div class="modal fade" id="modal_student_bb" role="dialog" aria-labelledby="modal_student_zz" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
						<table style="border-collapse:separate; border-spacing:0px 10px;">
							<tr>
								<td> 
								<div id="main2" style="width: 600px;height:400px;"></div>
								</td>
							</tr>
							
						</table>
						
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
						</div>

				</div>
				
			</div>

		</div>

	</div>
	<!--删除对话框 -->
	<div class="modal fade" id="modal_user_del" role="dialog" aria-labelledby="modal_user_del" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					 <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					 <h4 class="modal-title" id="modal_user_del_head"> 刪除  </h4>
				</div>
				<div class="modal-body">
							删除所选记录？
				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-danger"  id="del_user_btn">刪除</button>
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
			</div>
			</div>
		</div>
	</div>
	
	
	<div class="ui-jqdialog modal-content" id="alertmod_table_user_mod"
		dir="ltr" role="dialog"
		aria-labelledby="alerthd_table_user" aria-hidden="true"
		style="width: 200px; height: auto; z-index: 2222; overflow: hidden;top: 274px; left: 534px; display: none;position: absolute;">
		<div class="ui-jqdialog-titlebar modal-header" id="alerthd_table_user"
			style="cursor: move;">
			<span class="ui-jqdialog-title" style="float: left;">注意</span> <a id ="alertmod_table_user_mod_a"
				class="ui-jqdialog-titlebar-close" style="right: 0.3em;"> <span
				class="glyphicon glyphicon-remove-circle"></span></a>
		</div>
		<div class="ui-jqdialog-content modal-body" id="alertcnt_table_user">
			<div id="select_message"></div>
			<span tabindex="0"> <span tabindex="-1" id="jqg_alrt"></span></span>
		</div>
		<div
			class="jqResize ui-resizable-handle ui-resizable-se glyphicon glyphicon-import"></div>
	</div>
	
	<!-- Peity-->
	<script src="${path }/resources/js/plugins/peity/jquery.peity.min.js"></script>
	
	<!-- Bootstrap table-->
	<script src="${path }/resources/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
	<script src="${path }/resources/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>

	<!-- 自定义js-->
	<script src="${path }/resources/js/content.js?v=1.0.0"></script>
	
	 <!-- jQuery Validation plugin javascript-->
    <script src="${path }/resources/js/plugins/validate/jquery.validate.min.js"></script>
    <script src="${path }/resources/js/plugins/validate/messages_zh.min.js"></script>
   
   	<!-- jQuery form  -->
    <script src="${path }/resources/js/jquery.form.min.js"></script>
    
    <!-- layer javascript -->
    <script src="${path }/resources/js/plugins/layer/layer.min.js"></script>
    <!-- layerDate plugin javascript -->
	<script src="${path }/resources/js/plugins/layer/laydate/laydate.js"></script>
	
	<script type="text/javascript">
	
	// js中自定义时间格式的方法
	Date.prototype.Format = function (fmt) {
		    var o = {  
		        "M+": this.getMonth() + 1, //月份   
		        "d+": this.getDate(), //日   
		        "H+": this.getHours(), //小时   
		        "m+": this.getMinutes(), //分   
		        "s+": this.getSeconds(), //秒   
		        "S": this.getMilliseconds() //毫秒   
		    };  
		    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));  
		    for (var k in o)  
		    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));  
		    return fmt;  
		};
	    // 时间布局插件
	    laydate({
	        elem: '#txt_search_startTime', //目标元素。由于laydate.js封装了一个轻量级的选择器引擎，因此elem还允许你传入class、tag但必须按照这种方式 '#id .class'
	        event: 'focus', //响应事件。如果没有传入event，则按照默认的click
	        format: 'YYYY-MM-DD'// 日期格式
	    });
	    
	    laydate({
	        elem: '#txt_search_endTime',
	        event: 'focus',
	        format: 'YYYY-MM-DD'
	    });
	$(function () {
	    init();
	    $("#btn_search").bind("click",function(){
	    	//先销毁表格  
	        $('#table_user').bootstrapTable('destroy');
	    	init();
	    }); 
	    
	    // 用来将form表单，使用成ajax的方法
	    var validator = $("#form_user").validate({
    		submitHandler: function(form){
   		      $(form).ajaxSubmit({
   		    	dataType:"json", // 将返回来的数据，自动转化成json
   		    	success: function (data) {
   		    		// 将string转化成js能识别的代码
   		    		// eval(data);
   		    		if(data.success && !data.errorMsg ){
   		    			validator.resetForm();
   		    			$('#modal_user_edit').modal('hide');
   		    			// 刷新页面
   		    			$("#btn_search").click();
   		    		}else{
   		    			$("#select_message").text(data.errorMsg);
   		    			$("#alertmod_table_user_mod").show();
   		    		}
                }
   		      });     
   		   }  
	    });
	    $("#submit_form_user_btn").click(function(){
	    	$("#form_user").submit();
	    });
	    
	    var validator2 = $("#form_in").validate({
    		submitHandler: function(form){
   		      $(form).ajaxSubmit({
   		    	dataType:"json", // 将返回来的数据，自动转化成json
   		    	success: function (data) {
   		    		// 将string转化成js能识别的代码
   		    		// eval(data);
   		    		if(data.success && !data.errorMsg ){
   		    			validator2.resetForm();
   		    			$('#modal_student_in').modal('hide');
   		    			// 刷新页面
   		    			$("#btn_search").click();
   		    		}else{
   		    			$("#select_message").text(data.errorMsg);
   		    			$("#alertmod_table_user_mod").show();
   		    		}
                }
   		      });     
   		   }  
	    });
	    $("#submit_form_student_in").click(function(){
	    	$("#form_in").submit();
	    }); 
	    
	    
	    var validator3 = $("#form_addmajor").validate({
    		submitHandler: function(form){
   		      $(form).ajaxSubmit({
   		    	dataType:"json", // 将返回来的数据，自动转化成json
   		    	success: function (data) {
   		    		// 将string转化成js能识别的代码
   		    		// eval(data);
   		    		if(data.success && !data.errorMsg ){
   		    			validator3.resetForm();
   		    			$('#modal_student_addmajor').modal('hide');
   		    			// 刷新页面
   		    			location.reload();
   		    		}else{
   		    			$("#select_message").text(data.errorMsg);
   		    			$("#alertmod_table_user_mod").show();
   		    		}
                }
   		      });     
   		   }  
	    });
	    
	    $("#submit_form_student_addmajor").click(function(){
	    	$("#form_addmajor").submit();
	    });
	});
	
	var init = function () {
		//1.初始化Table
	    var oTable = new TableInit();
	    oTable.Init();
	    //2.初始化Button的点击事件
	    var oButtonInit = new ButtonInit();
	    oButtonInit.Init();
	};
	
	var TableInit = function () {
	    var oTableInit = new Object();
	    //初始化Table
	    oTableInit.Init = function () {
	    	// 自带ajax的表格构建方法
	        $('#table_user').bootstrapTable({
	            url: 'studentList.htm',         //请求后台的URL（*）
	            method: 'post',                      //请求方式（*）
	            contentType : "application/x-www-form-urlencoded", // 请求体的内容格式
	            toolbar: '#toolbar',                //工具按钮用哪个容器
	            striped: true,                      //是否显示行间隔色
	            cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
	            pagination: true,                   //是否显示分页（*）
	            sortable: true,                     //是否启用排序 
	            sortName: "sid",
	            sortOrder: "desc",                   //排序方式
	            queryParams: oTableInit.queryParams,//传递参数（*）
	            sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
	            pageNumber:1,                       //初始化加载第一页，默认第一页
	            pageSize: 10,                       //每页的记录行数（*）
	            pageList: [10, 25, 50, 75, 100],    //可供选择的每页的行数（*）
	            search: false,                       //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
	            strictSearch: true,
	            showColumns: true,                  //是否显示所有的列
	            showRefresh: false,                  //是否显示刷新按钮
	            minimumCountColumns: 2,             //最少允许的列数
	            clickToSelect: true,                //是否启用点击选中行
	           // height: 500,                        //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
	            uniqueId: "sid",                     //每一行的唯一标识，一般为主键列
	            showToggle:true,                    //是否显示详细视图和列表视图的切换按钮
	            cardView: false,                    //是否显示详细视图
	            detailView: false,                   //是否显示父子表
	            columns: [{
	                checkbox: true
	            },
	            {
	                field: 'sid',
	                title: '学生编号',
	                sortable:true
	            },
	            {
	                field: 'sname',
	                title: '学生姓名',
	                sortable:true
	            },{
	                field: 'sex',
	                title: '性别',
	                sortable:true
	            },{
	                field: 'hobby',
	                title: '爱好',
	                sortable:true
	            },  {
	                field: 'birthday',
	                title: '生日',
	                sortable:true,
	                formatter:function(value,row,index){
	                	return new Date(value).Format('yyyy-MM-dd');
	                }
	            },{
	                field: 'maid',
	                title: '专业',
	                sortable:true,
	                formatter:function(value,row,index){
	                	return row.major.maname;
	                }
	            }],
	            onClickRow: function (row) {
	            	$("#alertmod_table_user_mod").hide();
	            }
	        });
	    };

	    //得到查询的参数
	    oTableInit.queryParams = function (params) {
	        var temp = {//这里的键的名字和控制器的变量名必须一致，这边改动，控制器也需要改成一样的
	            limit: params.limit,   //页面大小
	            offset: params.offset,  //页码
	            sname: $("#txt_search_sname").val(),
	            maid: $("#txt_search_maid").val(),
	            startTime:$("#txt_search_startTime").val(),
	           	endTime:$("#txt_search_endTime").val(),
	            search:params.search,
	            order: params.order,
	            ordername: params.sort
	        };
	        return temp;
	    };
	    return oTableInit;
	};
	
	var ButtonInit = function () {
	    var oInit = new Object();
	    var postdata = {};

	    oInit.Init = function () {
	        //初始化页面上面的按钮事件
	    	$("#btn_add").click(function(){
	    		$('#password').attr("readOnly",false).val(getSelection.password);
	    		$("#form_user").resetForm();
	    		document.getElementById("hidden_txt_userid").value='';
	    		$('#modal_user_edit').modal({backdrop: 'static', keyboard: false});
				$('#modal_user_edit').modal('show');
	        });
	        
	    	$("#btn_update").click(function(){
	    		var getSelections = $('#table_user').bootstrapTable('getSelections');
	    		if(getSelections && getSelections.length==1){
	    			// 用来回显的方法
	    			initEditUser(getSelections[0]);
	    			// 显示对话框dialog
	    			$('#modal_user_edit').modal({backdrop: 'static', keyboard: false});
					$('#modal_user_edit').modal('show');
	    		}else{
	    			$("#select_message").text("请选择其中一条数据");
	    			$("#alertmod_table_user_mod").show();
	    		}
	    		
	        });
	    	  //初始化页面上面的按钮事件
	    	$("#btn_zz").click(function(){
	    		
	    		// 请求ajax
	    		$.ajax({
	    		    url:"zzStudent.htm",
	    		    dataType:"json",
	    		    type:"post",
	    		    success:function(res){
	    		    	if(res.success){
	    	    			var list = res.list;
	    	    			var maname = [];
	    	    			var ct = [];
	    	    			for(var i = 0 ; i<list.length;i++){
	    	    				maname[i]=list[i].maname;
	    	    				ct[i] = list[i].ct;
	    	    			}
	    	    			
	    	    			
	    	    			var myChart = echarts.init(document.getElementById('main1'));

	    		            // 指定图表的配置项和数据
	    		            // config option preperties
	    		            var option = {
	    		                title: {
	    		                    text: '学生专业信息统计'
	    		                },
	    		                tooltip: {},
	    		                legend: {
	    		                    data:['人数']
	    		                },
	    		                xAxis: {
	    		                    data: maname
	    		                },
	    		                yAxis: {},
	    		                series: [{
	    		                    name: '人数',
	    		                    type: 'bar',
	    		                    data: ct
	    		                }]
	    		            };

	    		            // 使用刚指定的配置项和数据显示图表。
	    		            myChart.setOption(option);
	    		    		$('#modal_student_zz').modal({backdrop: 'static', keyboard: false});
	    					$('#modal_student_zz').modal('show');
	    	    			
	    	    		}
	    		    }
	    		});
	    		
	    		
	        });
	    	$("#btn_bb").click(function(){
	    		
	    		// 请求ajax
	    		$.ajax({
	    		    url:"zzStudent.htm",
	    		    dataType:"json",
	    		    type:"post",
	    		    success:function(res){
	    		    	if(res.success){
	    	    			var list = res.list;
	    	    			var maname = [];
	    	    			// [{value:188,name:大数据},{},{}]
	    	    			var datas = [];
	    	    			for(var i = 0 ; i<list.length;i++){
	    	    				maname[i]=list[i].maname;
	    	    				// new 创建一个空对象
	    	    				var dd = {};
	    	    				dd.value=list[i].ct;
	    	    				dd.name=list[i].maname;
	    	    				// [{value:188,name:大数据}]
	    	    				datas[i] = dd;
	    	    			}
	    	    			
	    	    			
	    	    			var myChart = echarts.init(document.getElementById('main2'));

	    		            // 指定图表的配置项和数据
	    		           // 指定图表的配置项和数据
					        option = {
							    title : {
							        text: '学生信息统计',
							        x:'center'
							    },
							    tooltip : {
							        trigger: 'item',
							        // a -- name   b -- x轴的data   c -- 产品的value值  d -- echarts算出来的百分比
							        formatter: "{a} <br/>{b} : {c} ({d}%)"
							    },
							    legend: {
							        orient: 'vertical', // 排列的顺序 vertical竖向排列 horizontal横向排列
							        left: 'left',
							        data: maname
							    },
							    series : [
							        {
							            name: '访问来源',
							            type: 'pie',
							            radius : '55%',
							            center: ['50%', '60%'],
							            data:datas,
							            itemStyle: {
							                emphasis: {
							                    shadowBlur: 10,
							                    shadowOffsetX: 0,
							                    shadowColor: 'rgba(0, 0, 0, 0.5)'
							                    // red green blue aph 透明度
							             
							                }
							            }
							        }
							    ]
							};

	    		            // 使用刚指定的配置项和数据显示图表。
	    		            myChart.setOption(option);
	    		            $('#modal_student_bb').modal({backdrop: 'static', keyboard: false});
	    					$('#modal_student_bb').modal('show');	    	    			
	    	    		}
	    		    }
	    		});
	    		
	        });
	    	//初始化页面上面的按钮事件
	    	$("#btn_addmajor").click(function(){
	    		$("#form_addmajor").resetForm();
	    		$('#modal_student_addmajor').modal({backdrop: 'static', keyboard: false});
				$('#modal_student_addmajor').modal('show');
	        });
	    	
	    	// 导出
	    	$("#btn_out").click(function(){
	    		$.ajax({
	    		    url:"outStudent.htm",
	    		    dataType:"json",
	    		    type:"post",
	    		    success:function(res){
	    		    	if(res.success){
	    	    			alert("导出成功！");
	    	    		}
	    		    }
	    		});
	    	});
	    	
	    	// 导入
	    	$("#btn_in").click(function(){
	    		$("#form_in").resetForm();
	    		$('#modal_student_in').modal({backdrop: 'static', keyboard: false});
				$('#modal_student_in').modal('show');
	    	});
	    	
	    	
	    	$("#btn_del").click(function(){
	    		var getSelections = $('#table_user').bootstrapTable('getSelections');
	    		if(getSelections && getSelections.length>0){
	    			$('#modal_user_del').modal({backdrop: 'static', keyboard: false});
	    			$("#modal_user_del").show();
	    		}else{
	    			$("#select_message").text("请选择数据");
	    			$("#alertmod_table_user_mod").show();
	    		}
	        });
	        
	        
	    };

	    return oInit;
	};
	
	$("#alertmod_table_user_mod_a").click(function(){
		$("#alertmod_table_user_mod").hide();
	});
	
	function initEditUser(getSelection){
		// 将form表单清空
		$("#form_user").resetForm();
		
		// id的回显
		$('#hidden_txt_userid').val(getSelection.sid);
		// 姓名 性别 爱好 生日 专业
		$("#sname").val(getSelection.sname);
		// 性别是一个单选框
		// prop = attr 修改某一个标签的属性值
		var sex = getSelection.sex;
		$("input[value='"+sex+"']").prop("checked",true);
		
		// 多选框的回显
		var hobby = getSelection.hobby;
		var hArr = hobby.split(",");
		for(var i = 0 ; i<hArr.length;i++){
			$("input[value='"+hArr[i]+"']").prop("checked",true);
		}
		
		$("#birthday").val(new Date(getSelection.birthday).Format('yyyy-MM-dd'));
		
		$("#maid").val(getSelection.maid);
		
	}
	
	$("#del_user_btn").click(function(){
		// 得到所有的被选中的某一条数据
		var getSelections = $('#table_user').bootstrapTable('getSelections');
		var idArr = new Array();
		var ids;
		getSelections.forEach(function(item){
			idArr.push(item.sid);
		});
		// idArr = [1,2]
		// ids = 1,2
		ids = idArr.join(",");
		$.ajax({
		    url:"deleteStudent.htm",
		    dataType:"json",
		    data:{"ids":ids},
		    type:"post",
		    success:function(res){
		    	if(res.success){
	    			$('#modal_user_del').modal('hide');
	    			$("#btn_search").click();
	    		}else{
	    			$("#select_message").text(res.errorMsg);
	    			$("#alertmod_table_user_mod").show();
	    		}
		    }
		});
	});
	</script>

</body>
</html>