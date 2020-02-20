<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- 登录 注册 购物车... -->
<div class="container-fluid">
	<div class="col-md-4">
		
	</div>
	<div class="col-md-5">
		
	</div>
	<div class="col-md-3" style="padding-top:20px">
		<ol class="list-inline">
			<li id="loginbar"><a href="toLogin">登录</a></li>
			<li id="registerbar"><a href="toRegister">注册</a></li>
			<li><a href="/cartList2">购物车</a></li>
			<li><a href="/order/myorder">我的订单</a></li>
		</ol>
	</div>
</div>

<div class="container">
		<div class="row">
			<div class="col-md-3">
				<a href="/">
					<img alt="Shopholic" src="img/logo.png">
				</a>
			</div>
			<div class="col-md-6">
				<form action="/list2" method="post" id="serchForm">
					<div>
						<input type="hidden" name="pageNum" id="pageNum">
						<input type="hidden" name="categoryId" id="categoryId">
						<input type="hidden" name="brandId" id="brandId">
						<input type="hidden" name="optionId" id="optionId">
						<input id="search" name="keyword" type="text" width="100%" class="form-control" placeholder="Search" value="${keyword}" >
						<!--<div id="showDiv" style="display:none; position:absolute;z-index:1000;background:#fff; width:179px;border:1px solid #ccc;">
						</div>-->
						<button class="search-btn" type="submit"></button>
					</div>
				</form>
			</div>
		</div>
	</div>

<!-- 导航条 -->
<div class="container-fluid"  style="margin-top:30px">
				
	<nav class="navbar" style="margin-bottom:0">
		<div class="container-fluid">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="col-md-3">
				<div class="sidebar-menu-dropdown">
					<a class="btn-sidebar-menu-dropdown"> 分类 <i
						class="fa fa-bars" style="float:right"></i></a>
					<div id="cat" class="cat-dropdown">
						<div class="sidebar-contant">
											<div id="menu" class="navbar-collapse collapse">
												<ul class="nav navbar-nav ">
													<c:forEach items="${navCategories}" var="category">
												<li class="level">
													<a href="/list2?categoryId=${category.id }" class="page-scroll"> <i class="fa fa-desktop"></i>${category.name }</a>
													<c:if test="${!empty category.childs}">
														<div class="megamenu mobile-sub-menu"
															style="width: 630px;">
															<div class="megamenu-inner-top">
																<ul class="sub-menu-level1">
																	<c:forEach items="${category.childs}" var="secondCategory">
																		<li class="level2">
																			<a href="/list2?categoryId=${secondCategory.id }">
																				<span>${secondCategory.name }</span>
																					</a>
																			<ul class="sub-menu-level2 ">
																				<c:forEach items="${secondCategory.childs}" var="threeCategory">
																					<li class="level3"><a href="/list2?categoryId=${threeCategory.id }"><span>■</span>${threeCategory.name }</a></li>
																				</c:forEach>
																			</ul>
																		</li>
																	</c:forEach>
																</ul>
															</div>
														</div>	
													</c:if>
											</c:forEach>
													
												</ul>
											</div>
										</div>
					</div>
				</div>
				<!--<a class="navbar-brand" href="#">首页</a>-->
			</div>

			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
<%--
					<li class="active"><a href="product_list.html">手机数码<span class="sr-only">(current)</span></a></li>
--%>
					<c:forEach items="${navCategories}" var="category">
						<li><a href="/list2?categoryId=${category.id }">${category.name }</a></li>
					</c:forEach>
				</ul>
			</div>
		</div>
	</nav>
</div>
<!-- 完成异步搜索 -->
<script type="text/javascript">

    function overFn(obj){
        $(obj).css("background","#DBEAF9");
    }
    function outFn(obj){
        $(obj).css("background","#fff");
    }

    function clickFn(obj){
        $("#search").val($(obj).html());
        $("#showDiv").css("display","none");
    }


    function searchWord(obj){
        //1、获得输入框的输入的内容
        var word = $(obj).val();
        //2、根据输入框的内容去数据库中模糊查询---List<Product>
        var content = "";
        $.post(
            "searchWord",
            {"word":word},
            function(data){
                //3、将返回的商品的名称 现在showDiv中
                //[{"pid":"1","pname":"小米 4c 官方版","market_price":8999.0,"shop_price":8999.0,"pimage":"products/1/c_0033.jpg","pdate":"2016-08-14","is_hot":1,"pdesc":"小米 4c 标准版 全网通 白色 移动联通电信4G手机 双卡双待 官方好好","pflag":0,"cid":"1"}]

                if(data.length>0){
                    for(var i=0;i<data.length;i++){
                        content+="<div style='padding:5px;cursor:pointer' onclick='clickFn(this)' onmouseover='overFn(this)' onmouseout='outFn(this)'>"+data[i]+"</div>";
                    }
                    $("#showDiv").html(content);
                    $("#showDiv").css("display","block");
                }

            },
            "json"
        );

    }
</script>