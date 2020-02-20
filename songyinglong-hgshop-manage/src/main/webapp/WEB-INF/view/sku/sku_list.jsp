<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="${pageContext.request.contextPath}/resource/css/bootstrap.css" rel="stylesheet">
	<link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/font-awesome.min.css"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/bootstrap-treeview.css"/>
	<link href="${pageContext.request.contextPath}/resource/css/bootstrap.css" rel="stylesheet">
	<script type="text/javascript" src="${pageContext.request.contextPath}/resource/jquery/jquery-3.4.1.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap-treeview.js"></script>
	<title>sku管理</title>
	<style>
		/* 设置模态框不变色  */
		.modal-backdrop {
			opacity: 0.05 !important;
			filter: alpha(opacity=0.05) !important;
		}
		body {
			padding-top: 50px;
		}
	</style>
	<script>
        //自适应高度
        function IFrameResize() {
            //alert(this.document.body.scrollHeight); //弹出当前页面的高度
            var obj = parent.document.getElementById("childFrame"); //取得父页面IFrame对象
            //alert(obj.height); //弹出父页面中IFrame中设置的高度
            obj.height = this.document.body.scrollHeight - 2; //调整父页面中IFrame的高度为此页面的高度
        }

        //分页功能
        function limit(pageNum) {
            if (pageNum == 0) {
                return;
            }
            $('#pageNum').val(pageNum);
            $('#queryForm').submit();
        }

        //全选功能
        function selectAll() {
            $('.ck').each(function () {
                this.checked = !this.checked;
            })
        }
	</script>
</head>
<body onload="IFrameResize()">

		<div class="container">
					<div class="row">
						<!-- 加入了列 填充整行 -->
						<form class="col-sm-12" id="queryForm" action="/admin/skuList" method="post">
							<input type="hidden" id="pageNum" name="pageNum">
							<div class="form-group">
								<label>商品标题</label> 
								<input type="text" name="title" class="form-control" placeholder="请输入商品名称" value="${sku.title}">
							</div>

							<div class="form-group">
								<label>商品卖点</label> 
								<input type="text" name="sellPoint" class="form-control" placeholder="请输入卖点" value="${sku.sellPoint}">
							</div>
							<button class="btn btn-success" type="submit">搜索</button>
						</form>
					</div>

					<!-- 外边距(下方) 10像素的大小 -->
					<div class="row" style="margin-bottom: 10px;">
						<!-- 右端对齐 -->
						<div class="col-sm-12" align="right">
							<input type="button" class="btn btn-danger"
								onclick="deleteBatchSku()" value="批量删除" />
							<button class="btn btn-primary btn-sm" onclick="preAddSku()"
								data-toggle="modal" data-target="#myModal">添加sku</button>
						</div>
					</div>

					<div class="row">
						<table class="table table-striped">
							<thead>
								<tr>
									<th scope="col"><input type="checkbox" onclick="selectAll()" />全选</th>
									<th scope="col">序号</th>
									<th scope="col">商品图片</th>
									<th scope="col">商品标题</th>
									<th scope="col">商品价格</th>
									<th scope="col">商品状态</th>
									<th scope="col">商品库存</th>
									<th scope="col">操作</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${pg.list}" var="sku" varStatus="index">
									<tr>
										<td scope="row">
											<input type="checkbox" class="ck" value="${sku.id}"/>
										</td>
										<td>${(pg.pageNum-1)*pg.pageSize+index.count}</td>
										<td class="col-sm-2">
											<img class="img-responsive" src="/pic/${sku.image}"/>
										</td>
										<td class="col-sm-2">${sku.title}</td>
										<td>${sku.price}</td>
										<td>${sku.status==0 ? '上架' : '下架' }</td>
										<td>${sku.stockCount}</td>
										<td>
											<a href="javascript:void(0)" onclick="deleteSku(${sku.id})" class="btn btn-info">删除</a>
											<button class="btn btn-info btn-sm" data-toggle="modal"
												data-target="#myModal2"
												onclick="getSkuById(${sku.id})">修改</button>
											<button class="btn btn-primary btn-sm" data-toggle="modal"
												data-target="#myModal3"
												onclick="viewById(${sku.id})">详情</button></td>
									</tr>
									</c:forEach>
							</tbody>
						</table>
						<jsp:include page="/WEB-INF/view/common/pages.jsp"/>
					</div>
				</div>


	<!-- ////////////////添加模态框 //////////////////////////////-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">

		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<!-- 关闭的x效果 -->
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>

					<!-- 模态框的标题 -->
					<h4 class="modal-title">添加sku</h4>
				</div>
				<div class="modal-body">
					<form id="modalForm" enctype="multipart/form-data" action="javascript:void(0)">
						<div class="form-group row">
							<label for="title"
								class="col-sm-3 col-form-label col-form-label-sm">商品标题</label>
							<div class="col-sm-9">
								<input type="text" class="form-control form-control-sm"
									id="title" name="title" placeholder="请输入商品标题">
							</div>
						</div>

						<div class="form-group row">
							<label for="price" class="col-sm-3 col-form-label">商品价格</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="price"
									name="price" placeholder="请输入商品价格">
							</div>
						</div>
						
						<div class="form-group row">
							<label for="costPrice" class="col-sm-3 col-form-label">成本价格</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="costPrice"
									name="costPrice" placeholder="请输入成本价格">
							</div>
						</div>

						<div class="form-group row">
							<label for="marketPrice" class="col-sm-3 col-form-label">市场价格</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="marketPrice"
									name="marketPrice" placeholder="请输入市场价格">
							</div>
						</div>

						<div class="form-group row">
							<label for="categoryName" class="col-sm-3 col-form-label">所属分类</label>
							<!-- 左边部分 -->
							<div class="col-sm-9">
								<input type="hidden" class="form-control" id="categoryId" name="categoryId">
								<input type="text" class="form-control" id="categoryName"  placeholder="选择商品分类">
								<div id="tree" style="display: none; position:absolute; z-index:1010; background-color:white; "></div>
							</div>
						</div>

						<div class="form-group row">
							<label for="spuId" class="col-sm-3 col-form-label">所属商品</label>
							<div class="col-sm-9">
								<select class="form-control" id="spuId" name="spuId">
									<option value="">请选择商品</option>
								</select>
							</div>
						</div>

	                     <div class="form-group row">
							<label for="stockCount" class="col-sm-3 col-form-label">商品库存</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="stockCount"
									name="stockCount" placeholder="请输入商品库存">
							</div>
						</div>
						
						  <div class="form-group row">
							<label for="sellPoint" class="col-sm-3 col-form-label">商品卖点</label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="sellPoint"
									name="sellPoint" placeholder="请输入商品卖点">
							</div>
						</div>

						  <div class="form-group row">
							<label for="barcode" class="col-sm-3 col-form-label">商品条形码</label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="barcode"
									name="barcode" placeholder="请输入商品条形码">
							</div>
						</div>

						<div class="form-group row">
							<label for="image11" class="col-sm-3 col-form-label">商品图标</label>
							<div class="col-sm-9">
								<input type="file" class="form-control" id="image11"  onchange="show(this)"
									name="file" />
								<img alt="商品图标" id="image12" style="display:none;width: 50%;height: 50%" >
							</div>
						</div>
						
                        <div class="form-group row">
                            <label for="specOption" class="col-sm-3 col-form-label">规格参数</label>
                            <div class="col-sm-9" id="specOption">
                                <h4>请先选择所属分类!</h4>
                            </div>
                        </div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="addSku()">添加</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!-- ///////////////////添加模态框结束//////////////////////////// -->
	
		
	
	<!-- ////////////////修改模态框 //////////////////////////////-->
	<div class="modal fade" id="myModal2" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">

		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<!-- 关闭的x效果 -->
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>

					<!-- 模态框的标题 -->
					<h4 class="modal-title">编辑sku</h4>
				</div>
				<div class="modal-body">
					<form id="modalForm2" enctype="multipart/form-data" action="javascript:void(0)">
						<input type="hidden" name="id" id="id2"/>
						<input type="hidden" name="image" id="image20"/>
						<div class="form-group row">
							<label for="title2"
								class="col-sm-3 col-form-label col-form-label-sm">商品标题</label>
							<div class="col-sm-9">
								<input type="text" class="form-control form-control-sm"
									id="title2" name="title" placeholder="请输入商品标题">
							</div>
						</div>

						<div class="form-group row">
							<label for="price2" class="col-sm-3 col-form-label">商品价格</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="price2"
									name="price" placeholder="请输入商品价格">
							</div>
						</div>
						
						<div class="form-group row">
							<label for="costPrice2" class="col-sm-3 col-form-label">成本价格</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="costPrice2"
									name="costPrice" placeholder="请输入成本价格">
							</div>
						</div>
						
						<div class="form-group row">
							<label for="marketPrice2" class="col-sm-3 col-form-label">市场价格</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="marketPrice2"
									name="marketPrice" placeholder="请输入市场价格">
							</div>
						</div>

						<div class="form-group row">
							<label for="categoryName2" class="col-sm-3 col-form-label">所属分类</label>
							<!-- 左边部分 -->
							<div class="col-sm-9">
								<input type="hidden" class="form-control" id="categoryId2" name="categoryId">
								<input type="text" class="form-control" id="categoryName2" placeholder="选择商品分类">
								<div id="tree2" style="display: none; position:absolute; z-index:1010; background-color:white; "></div>
							</div>
						</div>

						<div class="form-group row">
							<label for="spuId2" class="col-sm-3 col-form-label">所属商品</label>
							<div class="col-sm-9">
								<select class="form-control" id="spuId2" name="spuId">
									<option value="">请选择商品</option>
								</select>
							</div>
						</div>

	                     <div class="form-group row">
							<label for="stockCount2" class="col-sm-3 col-form-label">商品库存</label>
							<div class="col-sm-9">
								<input type="number" class="form-control" id="stockCount2"
									name="stockCount" placeholder="请输入商品库存">
							</div>
						</div>
						
						  <div class="form-group row">
							<label for="sellPoint2" class="col-sm-3 col-form-label">商品卖点</label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="sellPoint2"
									name="sellPoint" placeholder="请输入商品卖点">
							</div>
						</div>
						
						  <div class="form-group row">
							<label for="barcode2" class="col-sm-3 col-form-label">商品条形码</label>
							<div class="col-sm-9">
								<input type="text" class="form-control" id="barcode2"
									name="barcode" placeholder="请输入商品条形码">
							</div>
						</div>
						
						<div class="form-group row">
							<label for="image21" class="col-sm-3 col-form-label">商品图标</label>
							<div class="col-sm-9">
								<input type="file" class="form-control" id="image21" onchange="show(this,2)"
									name="file" />
								<img alt="商品图标" id="image22" style="width: 50%;height: 50%" >
							</div>
						</div>

                        <div class="form-group row">
                            <label for="specOption2" class="col-sm-3 col-form-label">规格参数</label>
                            <div class="col-sm-9" id="specOption2">
                                <h4>请先选择所属分类!</h4>
                            </div>
                        </div>
						
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="addSku(1)">编辑</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!-- ///////////////////修改模态框结束//////////////////////////// -->


	<!-- ////////////////查看模态框 //////////////////////////////-->
	<div class="modal fade" id="myModal3" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">

		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<!-- 关闭的x效果 -->
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>

					<!-- 模态框的标题 -->
					<h4 class="modal-title">查看sku</h4>
				</div>
				<div class="modal-body">
					<form id="modalForm3" enctype="multipart/form-data" action="javascript:void(0)">
						<div class="form-group row">
							<label for="title3"
								class="col-sm-3 col-form-label col-form-label-sm">商品标题</label>
							<div class="col-sm-9">
								<span id="title3"></span>
							</div>
						</div>

						<div class="form-group row">
							<label for="price3" class="col-sm-3 col-form-label">商品价格</label>
							<div class="col-sm-9">
								<span id="price3"></span>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="costPrice3" class="col-sm-3 col-form-label">成本价格</label>
							<div class="col-sm-9">
								<span id="costPrice3"></span>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="marketPrice3" class="col-sm-3 col-form-label">市场价格</label>
							<div class="col-sm-9">
								<span id="marketPrice3"></span>
							</div>
						</div>

						<div class="form-group row">
							<label for="spuId3" class="col-sm-3 col-form-label">所属商品</label>
							<div class="col-sm-9">
								<span id="spuId3"></span>
							</div>
						</div>

	                     <div class="form-group row">
							<label for="stockCount3" class="col-sm-3 col-form-label">商品库存</label>
							<div class="col-sm-9">
								<span id="stockCount3"></span>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="sellPoint3" class="col-sm-3 col-form-label">商品卖点</label>
							<div class="col-sm-9">
								<span id="sellPoint3"></span>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="barcode3" class="col-sm-3 col-form-label">商品条形码</label>
							<div class="col-sm-9">
								<span id="barcode3"></span>
							</div>
						</div>

						<div class="form-group row">
							<label for="image32" class="col-sm-3 col-form-label">商品图标</label>
							<div class="col-sm-9">
								<img alt="商品图标" id="image32" style="width: 50%;height: 50%">
							</div>
						</div>

						<div class="form-group row">
							<label for="specOption3" class="col-sm-3 col-form-label">规格参数</label>
							<div class="col-sm-9" id="specOption3">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal -->
	</div>
	<!-- ///////////////////查看模态框结束//////////////////////////// -->
	

	<script type="text/javascript">
    //在线预览图片
    function show(obj,flag){
        var obj1;
        if(!flag){
            obj1=$("#image12");
        }else{
            obj1=$("#image22");
        }
        var rd = new FileReader();//创建文件读取对象
        var files = obj.files[0];//获取file组件中的文件
        rd.readAsDataURL(files);//文件读取装换为base64类型
        rd.onloadend = function(e) {
            //加载完毕之后获取结果赋值给img
            obj1.prop('src', this.result);
            obj1.show();
        }
    }
	function preAddSku(flag){
		var obj,obj1;
		if(!flag){
			//新增模态框
			obj=$("#spuId");	
            $('#tree').hide();
            $('#categoryName').val('');
            $('#specOption').html('<h4>请先选择所属分类!</h4>');
		}else{
			//修改模态框
			obj=$("#spuId2");
            $('#tree2').hide();
            $('#categoryName').val('');
		}
		obj.html('<option value="">请选择商品</option>');
   		//追加商品
 		$.post("/admin/selectSpuAll", {},function(result) {
 		    if(result.code==0){
 		        var data=result.data;
                //遍历数据
                for(var i in data){
                    obj.append("<option value='"+data[i].id+"'>"+data[i].goodsName+"</option>");
                }
			}else{
				alert("查询spu失败！");
			}
		},"json");
   }

   //添加或修改功能
	function addSku(flag){
		var obj,obj1;
		if(!flag){
			//添加
			obj=$('#modalForm')[0];
			obj1=$('#myModal');
			$('#specOption select').each(function () {
				if(!this.value){
                    $(this).prev().val('');
				}
            })
		}else{
			//修改
			obj=$('#modalForm2')[0];
			obj1=$('#myModal2');
            $('#specOption2 select').each(function () {
                if(!this.value){
                    $(this).prev().val('');
                }
            })
		}
		var formData = new FormData(obj);
		$.ajax({
            type:'post',
            data:formData,
            url:'/admin/skuAdd',
			processData : false, // 告诉jQuery不要去处理发送的数据
			contentType : false, // 告诉jQuery不要去设置Content-Type请求头
			dataType:'json',
			success:function(result){
               	if(result.code==0){
	               	//关闭模态框
	               	obj1.modal('hide')
            		window.location.reload();
               	}else{
               		alert("sku操作失败");
               	}
 			}
		});
	}
	
	//修改回显
	function getSkuById(id){
    		preAddSku(1);
			$.post('/admin/getSkuById',{id:id},function(obj){
                if(obj.code==0){
                    var sku=obj.data;
                    //规格参数选项索引清零
                    var categoryId=sku.spu.categoryId;
                    //选择树结点后 根据查询该category下的规格参数和spu
                    $.post("/admin/getCategoryById2", {id:categoryId},function(obj) {
                        if (obj.code == 0) {
                            $('#categoryName2').val(obj.data.text);
                            var spus = obj.data.spus;
                            var specs = obj.data.specs;
                            //遍历数据
                            $('#spuId2').html("<option value=''>--请选择--</option>");
                            for (var i in spus) {
                                $('#spuId2').append("<option value='" + spus[i].id + "'>" + spus[i].goodsName + "</option>");
                            }
                            $('#spuId2').val(sku.spuId);
                            var options = '';
                            //1.规格参数div展示
                            for(var i in specs){
                                //颜色
                                var spec = specs[i];
                                //["黑色","白色"]
                                options += '<div class="form-group row"><label class="col-sm-2 col-form-label">'
                                    +spec.specName+'</label><div class="col-sm-10 col-form-label" >'
                                    +'<input type="hidden" name="specs['+i+'].id" value="'+spec.id+'" >'
                                    +'<select id="spec_'+spec.id+'"   class="form-control" name="specOptions['+ i +'].id">'
                                    +'<option value="">请选择' +spec.specName +'</option>';
                                var specOptions=spec.specOptions;
                                for (var j in specOptions){
                                    options += '<option value="'+specOptions[j].id+'">'+specOptions[j].optionName+'</option>';
                                }
                                options +='</select></div></div>';
                            }
                            $('#specOption2').html(options);
                            var specs2=sku.specs;
                            for (var i in specs2){
                                var specOptions=specs2[i].specOptions;
                                $('#spec_'+specs2[i].id).val(specOptions[0].id);
                            }
                        } else {
                            alert("查询规格参数及spu失败!");
                        }
                    });
                    //2.sku信息展示
                    $('#id2').val(sku.id);
                    $('#image20').val(sku.image);
                    $('#image22').prop('src','/pic/' + sku.image);
                    $('#title2').val(sku.title);
                    $('#sellPoint2').val(sku.sellPoint);
                    $('#price2').val(sku.price);
                    $('#costPrice2').val(sku.costPrice);
                    $('#marketPrice2').val(sku.marketPrice);
                    $('#stockCount2').val(sku.stockCount);
                    $('#barcode2').val(sku.barcode);
                    $('#status2').val(sku.status);
				}else{
			        alert('回显数据失败!');
				}
    		},'json');
    	}

    	//查看详情
		function viewById(id) {
            $.post('/admin/getSkuById',{id:id},function(obj){
                if(obj.code==0){
                    var sku=obj.data;
                    //sku中有hg_sku全部信息及hg_sku_spec列表
                    //当前skuId对应的规格参数及规格参数列表
                    //[{"颜色":["黑色","白色"]},{"尺码":["S","M","L"]}]
                    var specs = sku.specs;
                    var options='';
                    //1.规格参数div展示
                    for(var i in specs){
                        //颜色
                        var spec = specs[i];
                        //["黑色","白色"]
                        var optionArr = spec.specOptions;
                        options += '<div class="form-group row"><label class="col-sm-3 col-form-label">'+spec.specName+'</label>';
                        var optionName=[];
                        for(var j in optionArr){
                            //黑色
                            optionName.push(optionArr[j].optionName);

                        }
                        options += '<span class="col-sm-9">'+optionName.toString()+'</span>';
                        options += ' </div> ';
                    }
                    $('#specOption3').html(options);
                    //2.sku信息展示
                    $('#image32').prop('src','/pic/' + sku.image);
                    $('#title3').html(sku.title);
                    $('#sellPoint3').html(sku.sellPoint);
                    $('#price3').html(sku.price);
                    $('#costPrice3').html(sku.costPrice);
                    $('#marketPrice3').html(sku.marketPrice);
                    $('#spuId3 ').html(sku.spu.goodsName);
                    $('#stockCount3').html(sku.stockCount);
                    $('#barcode3').html(sku.barcode);
                    $('#status3').html(sku.status);
                }else{
                    alert('回显数据失败!');
                }
            },'json');
        }
		//根据id删除
    	function deleteSku(ids){
    		if(ids!=''){
    			if(confirm('确定要删除选中的数据吗?')){
    				$.post('/admin/skuDelete',{ids:ids},function(obj){
    	    			if(obj.code==0){
    	    				location='/admin/skuList';
    	    			}else{
    	    				alert('删除sku失败');
    	    			}
    	    		},'json');
    			}
    		}else{
    			alert('请选中要删除的数据');
    		}
    	}

    	//批量删除
		function deleteBatchSku() {
			var ids = $('.ck:checked').map(function(){
                return this.value;
            }).get().join(',');
            if(ids!=''){
                if(confirm('确定要删除选中的数据吗?')){
                    $.post('/admin/skuDelete',{ids:ids},function(obj){
                        if(obj.code==0){
                            location='/admin/skuList';
                        }else{
                            alert('删除sku失败');
                        }
                    },'json');
                }
            }else{
                alert('请选中要删除的数据');
            }
        }

    $(function(){
        $("#categoryName").click(function() {
            $.post('/admin/getAllCategories1', {}, function(obj) {
                if(obj.code==0){
                    var data=obj.data;
                    var options = {
                        levels : 2,
                        data : data,
                        onNodeSelected : function(event, data) {
                            $("#categoryId").val(data.id);
                            $("#categoryName").val(data.text);
                            $("#tree").hide();//选中树节点后隐藏树
                            $("#spuId").html("<option value=''>--该分类下无商品,请重新选择分类或先向该分类添加规格参数！--</option>");
                            $('#specOption').html('该分类下无规格参数,请重新选择分类或先向该分类添加商品数据!');
                            var id=data.id;
                            alert(id);
                            //规格参数选项索引清零
                            //选择树结点后 查询该category 下的规格参数和spu
                            $.post("/admin/getCategoryById2", {id:id},function(obj) {
                                if(obj.code==0){
                                    var spus=obj.data.spus;
                                    var specs=obj.data.specs;
                                    //遍历数据
                                    $('#spuId').html("<option value=''>--请选择--</option>");
                                    for(var i in spus){
                                        $('#spuId').append("<option value='"+spus[i].id+"'>"+spus[i].goodsName+"</option>");
                                    }
                                    var options='';
                                    //1.规格参数div展示
                                    for(var i in specs){
                                        //颜色
                                        var spec = specs[i];
                                        //["黑色","白色"]
                                        options += '<div class="form-group row"><label class="col-sm-2 col-form-label">'
                                            +spec.specName+'</label><div class="col-sm-10 col-form-label" >'
											+'<input type="hidden" name="specs['+i+'].id" value="'+spec.id+'" >'
                                            +'<select  class="form-control"  name="specOptions['+ i +'].id">'
                                            +'<option value="">请选择' +spec.specName +'</option>';
                                        var specOptions=spec.specOptions;
                                        for (var j in specOptions){
                                            options += '<option value="'+specOptions[j].id+'">'+specOptions[j].optionName+'</option>';
                                        }
                                        options +='</select></div></div>';
                                    }
                                    $('#specOption').html(options);
                                }else{
                                    alert("查询规格参数及spu失败!");
                                }
                            },"json");
                        }
                    };
                    $('#tree').treeview(options);
                    $('#tree').show();
                }else{
                    alert('分类查询失败!');
                }
            });
        });
        $("#categoryName2").click(function() {
            $.post('/admin/getAllCategories1', {}, function(obj) {
                if(obj.code==0) {
                    var data = obj.data;
                    var options = {
                        levels: 2,
                        data: data,
                        onNodeSelected: function (event, data) {
                            $("#categoryId2").val(data.id);
                            $("#categoryName2").val(data.text);
                            $("#tree2").hide();//选中树节点后隐藏树
                            $("#spuId2").html("<option value=''>--该分类下无商品,请重新选择分类或先向该分类添加规格参数!--</option>");
                            $('#specOption2').html('该分类下无规格参数,请重新选择分类或先向该分类添加商品数据!');
                            var id=data.id;
                            //选择树结点后 查询该category 下的规格参数和spu
                            $.post("/admin/getCategoryById2", {id:id},function(obj) {
                                if(obj.code==0){
                                    var spus=obj.data.spus;
                                    var specs=obj.data.specs;
                                    //遍历数据
                                    $('#spuId2').html("<option value=''>--请选择--</option>");
                                    for(var i in spus){
                                        $('#spuId2').append("<option value='"+spus[i].id+"'>"+spus[i].goodsName+"</option>");
                                    }
                                    var options='';
                                    //1.规格参数div展示
                                    for(var i in specs){
                                        //颜色
                                        var spec = specs[i];
                                        //["黑色","白色"]
                                        options += '<div class="form-group row"><label class="col-sm-2 col-form-label">'
                                            +spec.specName+'</label><div class="col-sm-10 col-form-label" >'
											+'<input type="hidden" name="specs['+i+'].id" value="'+spec.id+'" >'
                                            +'<select  class="form-control"  name="specOptions['+ i +'].id">'
                                            +'<option value="">请选择' +spec.specName +'</option>';
                                        var specOptions=spec.specOptions;
                                        for (var j in specOptions){
                                            options += '<option value="'+specOptions[j].id+'">'+specOptions[j].optionName+'</option>';
                                        }
                                        options +='</select></div></div>';
                                    }
                                    $('#specOption2').html(options);
                                }else{
                                    alert("查询规格参数及spu失败!");
                                }
                            },"json");
                        }
                    };
                    $('#tree2').treeview(options);
                    $('#tree2').show();
                }else{
                    alert('分类查询失败!');
                }
            });
        });
    });

	</script>
</body>
</html>