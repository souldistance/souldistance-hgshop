<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>商城搜索页</title>
		<jsp:include page="common.jsp"></jsp:include>
		<script>
			function changePic(id,skuId,image){
				$("#sku" + id + " img").prop('src', image);
				
				$("#sku" + id).prop('href', 'page?id='+skuId);
			}
			function limit(pageNum) {
				if(pageNum==0){
				    return;
				}
				$('#pageNum').val(pageNum);
				$('#categoryId').val('${spuVO.categoryId}');
				$('#brandId').val('${spuVO.brandId}');
				$('#optionId').val('${spuVO.optionId}');
				$('#serchForm').submit();
            }
		</script>
	</head>

	<body>
	<div class="container-fluid">
	<jsp:include page="/WEB-INF/view/header2.jsp"></jsp:include>
	
	<div class="container-fluid filter" style="margin:5px 15px">
			<div class="row">
				<div class="flag">
				<div class="col-md-1 brand_list_header">
					品牌：
				</div>
				<c:forEach items="${map.brandList}" var="brand">
					<div class="col-md-2 brand_list"><a href="list?brandId=${brand.id}&keyword=${keyword}&categoryId=${spuVO.categoryId}">${brand.name}</a></div>
				</c:forEach>
				</div>
			</div>
			<div class="row">
				<div class="col-md-1 category_list_header">
					分类：
				</div>
				<c:forEach items="${map.categoryList}" var="category">
				<div class="col-md-2 category_list"><a href="list?categoryId=${category.id}&keyword=${keyword}">${category.name}</a></div>
				</c:forEach>
			</div>
			<c:forEach items="${map.specList}" var="spec">
			<div class="row">
				<div class="col-md-1 spec_list">
					${spec.specName}：
				</div>
				<c:forEach items="${spec.specOptions}" var="specOption">
				<div class="col-md-2 spec_option_list"><a href="list?optionId=${specOption.id}&keyword=${keyword}&categoryId=${spuVO.categoryId}">${specOption.optionName}</a></div>
				</c:forEach>
			</div>
			</c:forEach>
		</div>
		
		
		<div class="container-fluid">
				<div class="col-md-2" style="text-align:center;padding:2px;">
					<img src="img/404-bg.jpg" class="img-responsive" style="margin-bottom:2px"/>
					<img src="img/blog/blog_img1.jpg" class="img-responsive" style="margin-bottom:2px"/>
					<img src="img/blog/blog_img2.jpg" class="img-responsive" style="margin-bottom:2px"/>
					<img src="img/blog/blog_img3.jpg" class="img-responsive" style="margin-bottom:2px"/>
					<img src="img/blog/blog_img4.jpg" class="img-responsive" style="margin-bottom:2px"/>
					<img src="img/blog/blog_img5.jpg" class="img-responsive" style="margin-bottom:2px"/>
					<img src="img/blog/blog_img6.jpg" class="img-responsive" style="margin-bottom:2px"/>
				</div>
				<div class="col-md-10">
					<c:forEach items="${map.pageInfo.list}" var="spu">
					<div class="col-md-3" style="text-align:center;padding:2px;">
						<a href="page?id=${spu.skuList[0].id}" id="sku${spu.id}">
							<img src="pic/${spu.skuList[0].image}" class="img-responsive">
						</a>
						<div style="text-align:left;">
						<c:forEach items="${spu.skuList}" var="sku">
							<a href='page?id=${sku.id}' onmouseover="changePic(${spu.id},${sku.id},'pic/${sku.image }')"><img src="pic/${sku.image}" style="width:40px;height:40px"></a>
						</c:forEach>
						</div>
						<p><font color="#E4393C" style="font-size:16px">${spu.skuList[0].price }</font></p>
						<p><a href="page?id=${spu.skuList[0].id}" style='color:#666'>${spu.skuList[0].title }</a></p>
					</div>
					</c:forEach>
				</div>
			</div>
		<!--<div class="col-md-10">
			<div class="col-md-2" style="height:250px;text-align:center">
				<a href="product_info.html"> 
					<img src="products/1/c_0004.jpg" width="170" height="170" style="display: inline-block;">
				</a>
				<p>
					<a href="product_info.html" style='color: green'>联想手机</a>
				</p>
				<p>
					<font color="#FF0000">商城价：&yen;2500</font>
				</p>
			</div>
		</div>-->

	<!--分页 -->
	<div style="width: 380px; margin: 0 auto; margin-top: 50px;">
		<nav aria-label="Page navigation example">
			<ul class="pagination">
				<li class="page-item"><a class="page-link" href="#"
										 aria-label="Previous" onclick="limit(${map.pageInfo.prePage })"> <span
						aria-hidden="true">&laquo;</span>
				</a></li>
				<c:forEach items="${map.pageInfo.navigatepageNums }" var="n" varStatus="i">
					<li class="page-item ${n==map.pageInfo.pageNum?"active":"" }"><a class="page-link" href="#"
																					 onclick="limit(${n })">${n }</a></li>
				</c:forEach>
				<li class="page-item"><a class="page-link" href="#"
										 aria-label="Next" onclick="limit(${map.pageInfo.nextPage })"> <span
						aria-hidden="true">&raquo;</span>
				</a></li>
			</ul>
		</nav>
	</div>
	<!-- 分页结束 -->

	<!--商品浏览记录-->
	<div style="width: 1210px; margin: 0 auto; padding: 0 9px; border: 1px solid #ddd; border-top: 2px solid #999; height: 246px;">

		<h4 style="width: 50%; float: left; font: 14px/30px 微软雅黑">浏览记录</h4>
		<div style="width: 50%; float: right; text-align: right;">
			<a href="">more</a>
		</div>
		<div style="clear: both;"></div>

		<div style="overflow: hidden;">

			<ul style="list-style: none;">
				<li
					style="width: 150px; height: 216; float: left; margin: 0 8px 0 0; padding: 0 18px 15px; text-align: center;"><img
					src="products/1/cs10001.jpg" width="130px" height="130px" /></li>
			</ul>

		</div>
	</div>
			
	<jsp:include page="/WEB-INF/view/footer.jsp"></jsp:include>
	</div>	
	</body>

</html>