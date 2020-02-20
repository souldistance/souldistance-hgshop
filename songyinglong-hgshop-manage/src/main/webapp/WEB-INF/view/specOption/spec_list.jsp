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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/bootstrap-treeview.css"/>
    <link href="${pageContext.request.contextPath}/resource/css/bootstrap.css" rel="stylesheet">
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap-treeview.js"></script>
    <title>规格参数管理</title>
    <style>
        /* 设置模态框不变色  */
        .modal-backdrop {
            opacity: 0.05 !important;
            filter: alpha(opacity=0.05) !important;
        }
        #tree1 ul{
            margin-bottom: 0 !important;
        }
    </style>
    <script>
        //自适应高度
        function IFrameResize() {
            //alert(this.document.body.scrollHeight); //弹出当前页面的高度
            var obj = parent.document.getElementById("nodeFrame"); //取得父页面IFrame对象
            //alert(obj.height); //弹出父页面中IFrame中设置的高度
            obj.height = this.document.body.offsetHeight - 2; //调整父页面中IFrame的高度为此页面的高度
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
            var categoryId='${spec.categoryId}';
            if (categoryId){
                $('#categoryId').val(categoryId);
            }
            $('#queryForm').submit();
        }

        //删除功能
        function deleteSpec(ids){
            if(confirm('确定要删除选中的数据吗?')){
                $.post('/admin/specDelete',{ids:ids},function(obj){
                    if(obj.code==0){
                        window.location.reload();
                    }else{
                        alert('删除规格失败');
                    }
                });
            }
        }

        //批量删除
        function deleteBatchSpec(){
            //批量删除 [user1,user2,user3]  ----> [1,2,3]
           var ids = $('.ck:checked').map(function(){
                return this.value;
            }).get().join(',');
            if(ids!=''){
                if(confirm('确定要删除选中的数据吗?')){
                    $.post('/admin/specDelete',{ids:ids},function(obj){
                        if(obj.code==0){
                            window.location.reload();
                        }else{
                            alert('删除规格失败');
                        }
                    });
                }
            }else{
                alert('请选中要删除的数据');
            }
        }

        var addOptionNum=0; // 【新增规格】时，规格选项递增的索引值
        var editOptionNum=0;//【修改规格】时，规格选项递增的索引值
        //添加规格或修改规格时 删除所属分类或选项内容
        function addOptionDiv(flag) {
            var i=0;
            if(flag==1){
                i=addOptionNum++;
            }else{
                i=editOptionNum++;
            }
            var str='<div class="form-group addDiv" ><label  class="col-sm-3 control-label">规格内容</label>'
                +'<div class="col-sm-7" >'
                +'<input type="hidden" class="form-control"   name="specOptions['+ i +'].id">'
                +'<input type="text" class="form-control" name="specOptions['+ i +'].optionName"  \n'
                +'  placeholder="规格内容">'
                +'</div><div class="col-sm-1" style="padding: 0">'
                +'<button type="button" class="btn btn-danger" onclick="delDiv(this)" >删除</button>'
                +'</div></div>';
            if(flag==1){
                $('#options1').append(str);
            }else{
                $('#options2').append(str);
            }
        }

        //点击 新增规格参数按钮时
        function preAddSpec() {
            $('.addDiv').remove();
            $('#tree1').hide();
            $('#addCText').removeClass('col-md-8');
            $('#addCText').addClass('col-md-12');
        }

        var categoryNum=0; //修改时分类个数
        var addCategoryNum=0;//添加时分类个数
        //添加规格或修改规格时 删除所属分类或选项内容
        function delDiv(thiz) {
            $(thiz).parent().parent().remove();
        }
        //添加规格或修改规格时 添加所属分类
        function addCategoryDiv(flag) {
            var i=0;
            if(flag==1){
                $('#addCTree').html('<div id="tree1" style="display: none; position:absolute; z-index:1010; background-color:white;"></div>');
                i=addCategoryNum++;
            }else{
                i=categoryNum++;
            }
            var str='<div class="form-group addDiv" ><label  class="col-sm-3 control-label">所属分类</label>'
                +'<div class="col-sm-7" >'
                +'<input type="hidden" class="form-control"   name="categories['+ i +'].id">'
                +'<input type="text" class="form-control"     \n'
                +'  placeholder="所属分类" onclick="getCategoryTree(this,'+flag+')">'
                +'<input type="hidden" class="form-control"   name="categories['+ i +'].id">'
                +'</div><div class="col-sm-1" style="padding: 0">'
                +'<button type="button" class="btn btn-danger" onclick="delDiv(this)" >删除</button>'
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
                        levels: 1,
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
                                $('#editCTree').hide();
                                $('#editCText').removeClass("col-md-8");
                                $('#editCText').addClass("col-md-12");
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
                        $('#editCText').removeClass("col-md-12");
                        $('#editCText').addClass("col-md-8");
                        $('#editCTree').addClass("col-md-4");
                        $('#editCTree').show();
                        $('#tree2').treeview(options);
                        $('#tree2').show();
                    }
                }else{
                    alert(obj.message);
                }
            });
        }

        //点击修改或查看时
        function getSpecById(id, flag) {
            $.post('/admin/getSpecById', {id: id}, function (obj) {
                if (obj.code == 0) {
                    var data = obj.data;
                    //var categories=data.categories;
                    var specOptions=data.specOptions;
                    if (flag == 1) {
                        //修改模态框的数据回显
                        $('#id2').val(data.id);
                        $('#specName2').val(data.specName);
                        /*var str1="";
                        for (var i=0;i<categories.length;i++) {
                            str1+='<div class="form-group" ><label  class="col-sm-3 control-label">所属分类</label>'
                                +'<div class="col-sm-7" >'
                                +'<input type="hidden" class="form-control" value="'+categories[i].id+'"  name="categories['+(categoryNum++)+'].id">'
                                +'<input type="text" class="form-control"   \n'
                                +' value="'+categories[i].text+'" placeholder="所属分类" onclick="getCategoryTree(this)">'
                                +'</div><div class="col-sm-1" style="padding: 0">'
                                +'<button type="button" class="btn btn-danger" onclick="delDiv(this)" >删除</button>'
                                +'</div></div>';
                        }
                        $('#category2').html(str1);*/
                        var str2="";
                        for(var i=0;i<specOptions.length;i++){
                            var index=editOptionNum++;
                            str2+='<div class="form-group addDiv" ><label  class="col-sm-3 control-label">规格内容</label>'
                                +'<div class="col-sm-7" >'
                                +'<input type="hidden" class="form-control"  value="'+specOptions[i].id+'"   name="specOptions['+ index +'].id">'
                                +'<input type="text" class="form-control"   \n'
                                +' value="'+specOptions[i].optionName+'" name="specOptions['+ index +'].optionName"   placeholder="规格内容">'
                                +'</div><div class="col-sm-1" style="padding: 0">'
                                +'<button type="button" class="btn btn-danger" onclick="delDiv(this)" >删除</button>'
                                +'</div></div>';
                        }
                        $('#options2').html(str2);
                        //$('#editCTree').html('<div id="tree2" style="display: none; position:absolute; z-index:1010; background-color:white;"></div>');
                    } else {
                        //详情模态框的页面展示
                        $('#specName3').text(data.specName);
                       /* var categoryNames=[];
                        for (var i in categories) {
                            categoryNames.push(categories[i].text);
                        }
                        $('#categoryNames').text(categoryNames.toString());*/
                        var specptionNames=[];
                        for (var o in specOptions){
                            specptionNames.push(specOptions[o].optionName);
                        }
                        $('#specptionNames').text(specptionNames.toString());
                    }
                } else {
                    alert(obj.message);
                }
            });
        }

        //添加规格参数功能
        function addSpec() {
            $.post('/admin/addSpec', $('#addModalForm').serialize(), function (obj) {
                if (obj.code == 0) {
                    $("#insertSpecModal").modal('hide');
                    window.location.reload();
                } else {
                    alert('添加规格失败');
                }
            }, 'json');
        }

        //编辑规格参数功能
        function editSpec() {
            $.post('/admin/editSpec', $('#editModalForm').serialize(), function (obj) {
                if (obj.code == 0) {
                    $("#editSpecModal").modal('hide');
                    window.location.reload();
                } else {
                    alert('编辑规格失败');
                }
            }, 'json');
        }
    </script>
</head>
<body onload="IFrameResize()">
    <div class="container-fluid">
        <div class="row">
            <form action="/admin/specList" id="queryForm"  method="post">
                <div class="form-group">
                    <input type="hidden" name="pageNum" id="pageNum">
                    <input type="hidden" name="categoryId" id="categoryId">
                    <label for="specName">规格名称</label>
                    <input type="text" class="form-control" id="specName" name="specName" placeholder="规格名称" value="${spec.specName}">
                </div>
                <button class="btn btn-success" type="submit">搜索</button>
            </form>
        </div>

        <div class="row" style="float: right;">
            <button class="btn btn-danger" onclick="deleteBatchSpec()">批量删除</button>
            <button type="button" class="btn btn-primary btn-md"  data-toggle="modal" data-target="#insertSpecModal" >
                新增规格
            </button>
        </div>

        <div class="row">
            <table class="table table-striped">
                <thead>
                <tr>
                    <th><input type="checkbox" onclick="selectAll()">全选</th>
                    <th>编号</th>
                    <th>规格名称</th>
                    <th>规格选项</th>
                    <%--<th>所属分类</th>--%>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${pg.list}" var="s" varStatus="index">
                    <tr>
                        <td><input type="checkbox" class="ck" value="${s.id}"/></td>
                        <td>${(pg.pageNum-1)*pageSize+index.count }</td>
                        <td>${s.specName }</td>
                        <td>
                            <c:forEach items="${s.specOptions}" var="o" varStatus="i">
                                ${o.optionName}
                                <c:if test="${i.count!=s.specOptions.size()}">,</c:if>
                                <c:if test="${i.count%3==0}"><br/></c:if>
                            </c:forEach>
                        </td>
                        <%--<td>${s.categoryNames}</td>--%>
                        <td>
                            <button class="btn btn-danger" onclick="deleteSpec(${s.id})">删除</button>
                            <button type="button" class="btn btn-primary btn-md" data-toggle="modal" data-target="#editSpecModal" onclick="getSpecById(${s.id},1)">
                                修改
                            </button>
                            <button type="button" class="btn btn-primary btn-md" data-toggle="modal" data-target="#checkSpecModal" onclick="getSpecById(${s.id},2)">
                                查看
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <jsp:include page="/WEB-INF/view/common/pages.jsp"/>
            <%-- 新增 模态框 --%>
            <div class="modal fade" id="insertSpecModal"
                 tabindex="-1" role="dialog"
                 aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
                <div class="modal-dialog modal-dialog-scrollable"
                     role="document">
                    <div class="modal-content">
                        <!-- 模态框头部 -->
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">新增规格参数</h4>
                        </div>
                        <!-- 模态框主体 -->
                        <div class="modal-body">
                            <form class="form-horizontal" id="addModalForm" action="javascript:void(0);">
                                <div class="form-group">
                                    <label for="specName1" class="col-sm-3 control-label">规格名称</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="specName1" name="specName" placeholder="规格名称">
                                    </div>
                                </div>
                                <%--<button type="button" class="btn btn-primary" onclick="addCategoryDiv(1)">增加所属分类</button><br>
                                <div class="row">
                                    <div  id="addCText" class="col-md-12">
                                        <div id="category1"></div>
                                    </div>
                                    <div  id="addCTree"></div>
                                </div>--%>
                                <button type="button" class="btn btn-primary" onclick="addOptionDiv(1)">增加选项内容</button>
                                <div class="row" id="options1"></div>
                            </form>
                        </div>
                        <!-- 模态框底部 -->
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                    data-dismiss="modal">关闭
                            </button>
                            <button type="button" class="btn btn-primary" onclick="addSpec()">添加</button>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 修改 模态框 --%>
            <div class="modal fade" id="editSpecModal"
                 tabindex="-1" role="dialog"
                 aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
                <div class="modal-dialog modal-dialog-scrollable"
                     role="document">
                    <div class="modal-content">
                        <!-- 模态框头部 -->
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">修改规格参数</h4>
                        </div>
                        <!-- 模态框主体 -->
                        <div class="modal-body">
                            <form class="form-horizontal" id="editModalForm" action="javascript:void(0);">
                                <div class="form-group">
                                    <input type="hidden" id="id2" name="id">
                                    <label for="specName2" class="col-sm-3 control-label">规格名称</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="specName2" name="specName" placeholder="规格名称">
                                    </div>
                                </div>
                                <%--<button type="button" class="btn btn-primary" onclick="addCategoryDiv(2)">增加所属分类</button><br>
                                <div class="row">
                                    <div  id="editCText" class="col-md-12">
                                        <div id="category2"></div>
                                    </div>
                                    <div  id="editCTree"></div>
                                </div>--%>
                                <button type="button" class="btn btn-primary" onclick="addOptionDiv(2)">增加选项内容</button>
                                <div class="row" id="options2"></div>
                            </form>
                        </div>
                        <!-- 模态框底部 -->
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary"
                                    data-dismiss="modal">关闭
                            </button>
                            <button type="button" class="btn btn-primary" onclick="editSpec()">编辑</button>
                        </div>
                    </div>
                </div>
            </div>

            <%-- 查看 模态框 --%>
            <div class="modal fade" id="checkSpecModal"
                 tabindex="-1" role="dialog"
                 aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
                <div class="modal-dialog modal-dialog-scrollable"
                     role="document">
                    <div class="modal-content">
                        <!-- 模态框头部 -->
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                    aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">查看规格参数</h4>
                        </div>
                        <!-- 模态框主体 -->
                        <div class="modal-body">
                            <form class="form-horizontal"  action="javascript:void(0);">
                            <div class="form-group">
                                <label for="specName3" class="col-sm-3 control-label">规格名称</label>
                                <div class="col-sm-9">
                                    <span id="specName3"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="specptionNames" class="col-sm-3 control-label">规格内容</label>
                                <div class="col-sm-9">
                                    <span id="specptionNames"></span>
                                </div>
                            </div>
                            <%--<div class="form-group">
                                <label for="categoryNames" class="col-sm-3 control-label">所属分类</label>
                                <div class="col-sm-9">
                                    <span id="categoryNames"></span>
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
        </div>
    </div>
</body>
</html>