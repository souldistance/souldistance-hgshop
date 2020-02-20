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
    <link href="/resource/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resource/css/font-awesome.min.css"/>
    <link href="<%=request.getContextPath()%>/resource/css/dashboard.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/bootstrap-treeview.css"/>
    <link href="${pageContext.request.contextPath}/resource/css/bootstrap.css" rel="stylesheet">
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap-treeview.js"></script>
    <title>品牌管理</title>
    <style>
        /* 设置模态框不变色  */
        .modal-backdrop {
            opacity: 0.05 !important;
            filter: alpha(opacity=0.05) !important;
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

        //全选功能
        function selectAll() {
            $('.ck').each(function () {
                this.checked = !this.checked;
            })
        }

        //分页功能
        function limit(pageNum) {
            if (pageNum == 0) {
                return;
            }
            $('#pageNum').val(pageNum);
            $('#queryForm').submit();
            //$('#content-wrapper').load('/admin/brands?' + $('form').serialize());
        }

        //批量删除
        function deleteBatch() {
            var ids = $('.ck:checked').map(function () {
                return this.value;
            }).get().join();
            if (ids == '') {
                alert('请选择要删除的品牌!');
            } else {
                $.post("/admin/deleteBrands", {ids: ids}, function (obj) {
                    if (obj.code == 0) {
                        alert('删除成功!');
                        location = '/admin/brands';
                        // $('#content-wrapper').load('/admin/brands');
                    } else {
                        alert(obj.message);
                    }
                });
            }
        }

        //单删功能
        function deleteBrand(id) {
            $.post("/admin/deleteBrands", {ids: id}, function (obj) {
                if (obj.code == 0) {
                    window.location.reload();
                    // $('#content-wrapper').load('/admin/brands');
                } else {
                    alert(obj.message);
                }
            });
        }

        //添加品牌功能
        function addBrand() {
            $.post('/admin/brandAdd', $('#addModalForm').serialize(), function (obj) {
                if (obj.code == 0) {
                    $("#insertBrandModal").modal('hide');
                    window.location.reload();
                } else {
                    alert('添加品牌失败');
                }
            }, 'json');
        }

        //编辑功能
        function editBrand() {
            $.post('/admin/editBrand', $('#editBrandForm').serialize(), function (obj) {
                if (obj.code == 0) {
                    $("#editBrandModal").modal('hide');
                    window.location.reload();
                } else {
                    alert('编辑品牌失败');
                }
            }, 'json');
        }

        //点击 新增品牌按钮时
        function preAddBrand() {
            $('.add-category').remove();
            $('#tree1').hide();
            $('#addCText').removeClass('col-md-8');
            $('#addCText').addClass('col-md-12');
        }
        var categoryNum=0; //修改时分类个数
        var addCategoryNum=0;//添加时分类个数
        //查看品牌
        function checkBrand(id, flag) {
            /*$('.add-category').remove();
            $('#cText').removeClass('col-md-8');
            $('#cText').addClass('col-md-12');*/
            $.post('/admin/getBrandById', {id: id}, function (obj) {
                if (obj.code == 0) {
                    var data = obj.data;
                    //var categories=data.categories;
                    if (flag == 1) {
                        //修改模态框的数据回显
                        $('#id2').val(data.id);
                        $('#name2').val(data.name);
                        $('#firstChar2').val(data.firstChar);
                        /*var str="";
                        for (var i=0;i<categories.length;i++) {
                            str+='<div class="form-group" ><label  class="col-sm-3 control-label">所属分类</label>'
                                +'<div class="col-sm-7" >'
                                +'<input type="hidden" class="form-control" value="'+categories[i].id+'"  name="categories['+(categoryNum++)+'].id">'
                                +'<input type="text" class="form-control"   \n'
                                +' value="'+categories[i].text+'" placeholder="所属分类" onclick="getCategoryTree(this)">'
                                +'</div><div class="col-sm-1" style="padding: 0">'
                                +'<button type="button" class="btn btn-danger" onclick="delCategory(this)" >删除</button>'
                                +'</div></div>';
                        }
                        $('#category2').html(str);
                        $('#cTree').html('<div id="tree2" style="display: none; position:absolute; z-index:1010; background-color:white;"></div>');*/
                    } else {
                        //详情模态框的页面展示
                        $('#name3').text(data.name);
                        $('#firstChar3').text(data.firstChar);
                        /*var categoriesName=[];
                        for (var i in categories) {
                            categoriesName.push(categories[i].text);
                        }
                        $('#categoryId').text(categoriesName.toString());*/
                    }
                } else {
                    alert(obj.message);
                }
            });
        }
        //添加品牌或修改品牌时 删除所属分类
        function delCategory(thiz) {
            $(thiz).parent().parent().remove();
        }
        //添加品牌或修改品牌时 添加所属分类
        function addCategoryDiv(flag) {
            var i=0;
            if(flag==1){
                $('#addCTree').html('<div id="tree1" style="display: none; position:absolute; z-index:1010; background-color:white;"></div>');
                i=addCategoryNum++;
            }else{
                i=categoryNum++;
            }
            var str='<div class="form-group add-category" ><label  class="col-sm-3 control-label">所属分类</label>'
                +'<div class="col-sm-7" >'
                +'<input type="hidden" class="form-control"   name="categories['+ i +'].id">'
                +'<input type="text" class="form-control"   \n'
                +'  placeholder="所属分类" onclick="getCategoryTree(this,'+flag+')">'
                +'</div><div class="col-sm-1" style="padding: 0">'
                +'<button type="button" class="btn btn-danger" onclick="delCategory(this)" >删除</button>'
                +'</div></div>';
            if(flag==1){
                $('#category1').append(str);
            }else{
                $('#category2').append(str);
            }
        }
        //修改时 点击分类框可选择分类
        function getCategoryTree(thiz,flag) {
            $.post('/admin/getAllCategories', {}, function(obj) {
                if(obj.code==0){
                    let data = obj.data;
                    let options = {
                        levels: 2,
                        data: data,
                        onNodeSelected: function (event, data) {
                            $(thiz).prev().val(data.id);
                            $(thiz).val(data.text);
                            if(flag==1){
                                $('#tree1').hide();//选中树节点后隐藏树
                                $('#addCTree').hide();
                                $('#addCText').removeClass("col-md-8");
                                $('#addCText').addClass("col-md-12");
                            }else{
                                $('#tree2').hide();//选中树节点后隐藏树
                                $('#cTree').hide();
                                $('#cText').removeClass("col-md-8");
                                $('#cText').addClass("col-md-12");
                            }
                        }
                    };
                    if(flag==1){
                        $('#addCText').removeClass("col-md-12");
                        $('#addCText').addClass("col-md-8");
                        $('#addCTree').addClass("col-md-4");
                        $('#addCTree').show();
                        $('#tree1').treeview(options);
                        $('#tree1').show();
                    }else{
                        $('#cText').removeClass("col-md-12");
                        $('#cText').addClass("col-md-8");
                        $('#cTree').addClass("col-md-4");
                        $('#cTree').show();
                        $('#tree2').treeview(options);
                        $('#tree2').show();
                    }
                }else{
                    alert(obj.message);
                }
            });
        }
    </script>
</head>
<body onload="IFrameResize()">
<div class="container">
    <div class="row">
        <form id="queryForm" action="/admin/brands" method="post">
            <input type="hidden" name="pageNum" id="pageNum">
            <div class="form-group">
                <label for="name">品牌名称</label>
                <input type="text" class="form-control" id="name" name="name" placeholder="品牌名称"
                       value="${brand.name }">
            </div>
            <div class="form-group">
                <label for="firstChar">品牌首字母</label>
                <input type="text" class="form-control" id="firstChar" name="firstChar" placeholder="品牌首字母"
                       value="${brand.firstChar }">
            </div>
            <button class="btn btn-success" type="submit">搜索</button>
        </form>
    </div>

    <div class="row" style="float: right;">
        <button class="btn btn-danger" onclick="deleteBatch()">批量删除</button>
        <button type="button" class="btn btn-primary btn-md" data-toggle="modal" data-target="#insertBrandModal">
            新增品牌
        </button>
    </div>
    <div class="row">
        <table class="table table-striped">
            <thead>
            <tr>
                <th><input type="checkbox" onclick="selectAll()">全选</th>
                <th>编号</th>
                <th>品牌名称</th>
                <th>首字母</th>
                <%--<th>所属分类</th>--%>
                <th>状态</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pg.list}" var="brand" varStatus="i">
                <tr>
                    <td><input type="checkbox" class="ck" value="${brand.id}"/></td>
                    <td>${(pg.pageNum-1)*pg.pageSize+i.count}</td>
                    <td>${brand.name}</td>
                    <td>${brand.firstChar}</td>
                    <%--<td>
                        <c:forEach items="${brand.categories}" var="c" varStatus="i">
                            ${c.name}
                            <c:if test="${i.count!=brand.categories.size()}">,</c:if>
                        </c:forEach>
                    </td>--%>
                    <td>${brand.deletedFlag==true ? '正常' : '删除'}</td>
                    <td>
                        <button class="btn btn-danger"
                                onclick="deleteBrand(${brand.id})">${brand.deletedFlag==true ? '删除' : '恢复'}</button>
                        <button type="button" class="btn btn-primary btn-md" data-toggle="modal"
                                data-target="#editBrandModal" onclick="checkBrand(${brand.id},1);">
                            修改
                        </button>
                        <button type="button" class="btn btn-info btn-md" data-toggle="modal"
                                data-target="#checkBrandModal" onclick="checkBrand(${brand.id},2);">
                            查看
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <%-- 新增 模态框 --%>
        <div class="modal fade" id="insertBrandModal"
             tabindex="-1" role="dialog"
             aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable"
                 role="document">
                <div class="modal-content">
                    <!-- 模态框头部 -->
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">新增品牌</h4>
                    </div>
                    <!-- 模态框主体 -->
                    <div class="modal-body">
                        <form class="form-horizontal" id="addModalForm" action="javascript:void(0);">
                            <div class="form-group">
                                <label for="name1" class="col-sm-3 control-label">品牌名称</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="name1" name="name" placeholder="品牌名称">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="firstChar1" class="col-sm-3 control-label">品牌首字母</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="firstChar1" name="firstChar"
                                           placeholder="品牌首字母">
                                </div>
                            </div>
                            <%--<button type="button" class="btn btn-primary" onclick="addCategoryDiv(1)">增加所属分类</button><br>
                            <div class="row">
                                <div  id="addCText" class="col-md-12">
                                    <div id="category1"></div>
                                </div>
                                <div  id="addCTree"></div>
                            </div>--%>
                        </form>
                    </div>
                    <!-- 模态框底部 -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary"
                                data-dismiss="modal">关闭
                        </button>
                        <button type="button" class="btn btn-primary" onclick="addBrand()">添加</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- 查看 模态框 --%>
        <div class="modal fade" id="checkBrandModal"
             tabindex="-1" role="dialog"
             aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable"
                 role="document">
                <div class="modal-content">
                    <!-- 模态框头部 -->
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">查看品牌</h4>
                    </div>
                    <!-- 模态框主体 -->
                    <div class="modal-body">
                        <form class="form-horizontal" action="javascript:void(0);">
                            <div class="form-group">
                                <label for="name3" class="col-sm-3 control-label">品牌名称</label>
                                <div class="col-sm-9">
                                    <span id="name3"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="firstChar3" class="col-sm-3 control-label">品牌首字母</label>
                                <div class="col-sm-9">
                                    <span id="firstChar3"></span>
                                </div>
                            </div>
                            <%--<div class="form-group">
                                <label for="categoryId" class="col-sm-3 control-label">所属分类</label>
                                <div class="col-sm-9">
                                    <span id="categoryId"></span>
                                </div>
                            </div>--%>
                        </form>
                    </div>
                    <!-- 模态框底部 -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary"
                                data-dismiss="modal">关闭
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <%-- 修改 模态框 --%>
        <div class="modal fade" id="editBrandModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">编辑品牌</h4>
                    </div>
                    <div class="modal-body">
                        <form class="form-horizontal" id="editBrandForm" action="javascript:void(0);">
                            <input type="hidden" id="id2" name="id">
                            <div class="form-group">
                                <label for="name2" class="col-sm-3 control-label">品牌名称</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="name2" name="name" placeholder="品牌名称">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="firstChar2" class="col-sm-3 control-label">品牌首字母</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="firstChar2" name="firstChar"
                                           placeholder="品牌首字母">
                                </div>
                            </div>
                            <%--<button type="button" class="btn btn-primary" onclick="addCategoryDiv(2)">增加所属分类</button><br>
                            <div class="row">
                                <div  id="cText" class="col-md-12">
                                    <div id="category2"></div>
                                </div>
                                <div  id="cTree"></div>
                            </div>--%>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        <button type="button" class="btn btn-primary" onclick="editBrand()">编辑</button>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="/WEB-INF/view/common/pages.jsp"/>
    </div>
</div>
</body>
</html>