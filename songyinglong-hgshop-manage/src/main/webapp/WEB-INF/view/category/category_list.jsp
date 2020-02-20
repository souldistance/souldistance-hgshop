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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resource/css/bootstrap-treeview.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap-treeview.js"></script>
    <title>分类管理</title>
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

        //点击新增分类按钮
        function preAddCategory(flag) {
            if(flag==1){
                $('#tree').hide();
            }else{
                $('#tree2').hide();
            }
            $.post('/admin/selectBrands',function (obj) {
                if(obj.code==0){
                    var data=obj.data;
                    var str="";
                    for (var i=0;i<data.length;i++){
                        str+='&nbsp;<input type="checkbox" name="brands['+i+'].id" value="'+data[i].id+'" />&nbsp;'+data[i].name;
                        if((i+1)%5==0){
                            str+="<br/>";
                        }
                    }
                    if(flag==1){
                        $('#brands').html(str);
                    }else if(flag==2){
                        $('#brands2').html(str);
                    }
                }else{
                    alert('查询品牌失败!');
                }
            });
            $.post('/admin/selectSpecs',function (obj) {
                if(obj.code==0) {
                    var data = obj.data;
                    var str="";
                    for (var i=0;i<data.length;i++){
                        str+='&nbsp;<input type="checkbox" name="specs['+i+'].id" value="'+data[i].id+'" onclick="toShowSpec('+flag+',this)" />&nbsp;<span onmouseout="hideSpecOption('+flag+')" onmouseover="showSpecOption('+flag+','+data[i].id+')">'+data[i].specName+'</span>';
                        if((i+1)%5==0){
                            str+="<br/>";
                        }
                    }
                    if(flag==1){
                        $('#specs').html(str);
                    }else if(flag==2){
                        $('#specs2').html(str);
                    }
                }else{
                    alert('查询规格参数失败!');
                }
            });
        }

        //修改模态框的数据回显和详情模态框的页面展示
        function getCategoryById(id,flag){
            if(flag==1){
                preAddCategory(2);
            }
            $.post('/admin/getCategoryById',{id:id},function(obj){
                if(obj.code==0){
                    var data=obj.data;
                    var brands=data.brands;
                    var specs=data.specs;
                    if(flag==1){
                        //修改模态框的数据回显
                        $('#id2').val(data.id);
                        $('#name2').val(data.text);
                        $('#parentId2').val(data.parentId);
                        $('#parentName2').val(data.parentName);
                        $('#level2').val(data.level);
                        for (var i in brands){
                            $('#brands2 input[value="'+brands[i].id+'"]').attr('checked','checked');
                        }
                        for(var i in specs){
                            $('#specs2 input[value="'+specs[i].id+'"]').attr('checked','checked');
                        }
                        if(data.level==3){
                            $('#brands2Div').show();
                            $('#specs2Div').show();
                        }else{
                            $('#brands2Div').hide();
                            $('#specs2Div').hide();
                        }
                    }else{
                        //详情模态框的页面展示
                        $('#name3').text(data.text);
                        $('#parentName3').text(data.parentName);
                        $('#level3').text(data.level);
                        var brandsName=[];
                        for (var i in brands){
                            brandsName.push(brands[i].name);
                        }
                        $('#brands3').html(brandsName.toString());
                        var specsName=[];
                        for(var i in specs){
                            specsName.push(specs[i].specName);
                        }
                        $('#specs3').html(specsName.toString());
                    }
                }else{
                    alert(obj.message);
                }
            });
        }

        $(function () {
            //点击选择父分类进行分类全查
            $('#parentName1').on('click',function () {
                $.post('/admin/getAllCategories', {}, function(obj) {
                    if(obj.code==0){
                        var data=obj.data;
                        var options = {
                            levels : 2,
                            data : data,
                            onNodeSelected : function(event, data) {
                                $("#parentId1").val(data.id);
                                $("#parentName1").val(data.text);
                                $("#tree").hide();//选中树节点后隐藏树
                            }
                        };
                        $('#tree').treeview(options);
                        $('#tree').show();
                    }else{
                        alert(obj.message);
                    }
                });
            });
            $("#parentName2").click(function() {
                $.post('/admin/getAllCategories', {}, function(obj) {
                    if(obj.code==0){
                        var data=obj.data;
                        var options = {
                            levels : 2,
                            data : data,
                            onNodeSelected : function(event, data) {
                                $("#parentId2").val(data.id);
                                $("#parentName2").val(data.text);
                                $("#tree2").hide();//选中树节点后隐藏树
                            }
                        };
                        $('#tree2').treeview(options);
                        $('#tree2').show();
                    }else{
                        alert(obj.message);
                    }
                });
            });
        })
        //添加分类功能
        function addCategory() {
            if($("#parentName1").val()==''){
                $("#parentId1").val(0);
            }
            $.post('/admin/categoryAddOrUpdate',$('#addModalForm').serialize(),function(obj){
                if(obj.code==0){
                    $("#insertCategoryModal").modal('hide');
                    window.location.reload();
                }else{
                    alert('添加分类失败');
                }
            });
        }
        //修改分类功能
        function editCategory() {
            if($("#parentName2").val()==''){
                $("#parentId2").val(0);
            }
            $.post('/admin/categoryAddOrUpdate',$('#editModalForm').serialize(),function(obj){
                if(obj.code==0){
                    $("#editCategoryModal").modal('hide');
                    window.location.reload();
                }else{
                    alert('添加分类失败');
                }
            });
        }

        //删除分类
        function deleteCategory(id){
            if(confirm('确定要删除选中的数据吗?')){
                $.post('/admin/categoryDelete',{id:id},function(obj){
                    if(obj.code==0){
                        window.location.reload();
                    }else{
                        alert(obj.code + "@" + obj.message);
                    }
                });
            }
        }

        //当选择3级分类时  可对品牌和规格参进行维护
        function showDiv(thiz,flag) {
            if(flag==1){
                if(thiz.value==3){
                    $('#brandsDiv').show();
                    $('#specsDiv').show();
                }else{
                    $('#brandsDiv').hide();
                    $('#specsDiv').hide();
                }
            }else{
                if(thiz.value==3){
                    $('#brands2Div').show();
                    $('#specs2Div').show();
                }else{
                    $('#brands2Div').hide();
                    $('#specs2Div').hide();
                }
            }
        }

        //鼠标滑过specName时显示spec详情
        function showSpecOption(flag,specId){
            $.post('/admin/getSpecById', {id: specId}, function (obj) {
                if (obj.code == 0) {
                    var data = obj.data;
                    var specOptions = data.specOptions;
                    var specptionNames=[];
                    for (var o in specOptions){
                        specptionNames.push(specOptions[o].optionName);
                    }
                    var str='<div class="form-group">'
                        +'<label for="specName" class="col-sm-3 control-label">规格名称</label>'
                        +'<div class="col-sm-9">'
                        +'<span id="specName">'+data.specName+'</span>'
                        +'</div></div>'
                        +'<div class="form-group">'
                        +'<label for="specptionName" class="col-sm-3 control-label">规格内容</label>'
                        +'<div class="col-sm-9">'
                        +'<span id="specptionName">'+specptionNames.toString()+'</span>'
                        +'</div></div>';
                    if (flag == 1) {
                        $('#specOption').show();
                        $('#specOption').html(str);
                    }else {
                        $('#specOption2').show();
                        $('#specOption2').html(str);
                    }
                }
            });
        }

        //鼠标离开specName时隐藏
        function hideSpecOption(flag) {
            if (flag == 1) {
                $('#specOption').hide();
            }else {
                $('#specOption2').hide();
            }
        }

        //选中spec时显示
        function toShowSpec(flag,thiz) {
            if(thiz.checked){
                showSpecOption(flag,thiz.value);
            }else{
                hideSpecOption(flag);
            }
        }
    </script>
</head>
<body onload="IFrameResize()">
<div class="container">
    <div class="row">
        <form id="queryForm" action="/admin/categories" method="post">
            <input type="hidden" name="pageNum" id="pageNum">
            <div class="form-group">
                <label for="name">分类名称</label>
                <input type="text" class="form-control" id="name" name="name" placeholder="分类名称"
                       value="${category.name}">
            </div>
            <button type="submit" class="btn btn-success">搜索</button>
        </form>
    </div>
    <div class="row navbar-right">
        <button type="button" class="btn btn-primary btn-md" onclick="preAddCategory(1)" data-toggle="modal" data-target="#insertCategoryModal">
            新增分类
        </button>
    </div>
    <div class="row">
        <table class="table table-striped">
            <thead>
            <tr>
                <th>编号</th>
                <th>分类名称</th>
                <th>父分类名称</th>
                <th>分类级别</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pg.list}" var="category" varStatus="i">
                <tr>
                    <td>${(pg.pageNum-1)*pg.pageSize+i.count}</td>
                    <td>${category.name}</td>
                    <td>${category.parentName}</td>
                    <td>${category.level==1?'一级':(category.level==2?'二级':'三级')}</td>
                    <td>
                        <button on class="btn btn-danger" onclick="deleteCategory(${category.id})">删除</button>
                        <button type="button" class="btn btn-primary btn-md" data-toggle="modal"
                                data-target="#editCategoryModal" onclick="getCategoryById(${category.id},1);">修改
                        </button>
                        <button type="button" class="btn btn-info btn-md" data-toggle="modal"
                                data-target="#checkCategoryModal" onclick="getCategoryById(${category.id},2);">查看
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <%-- 新增 模态框 --%>
        <div class="modal fade" id="insertCategoryModal"
             tabindex="-1" role="dialog"
             aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable"
                 role="document">
                <div class="modal-content">
                    <!-- 模态框头部 -->
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">新增分类</h4>
                    </div>
                    <!-- 模态框主体 -->
                    <div class="modal-body">
                        <form class="form-horizontal" id="addModalForm" action="javascript:void(0);">
                            <div class="form-group">
                                <label for="name1" class="col-sm-3 control-label">分类名称</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="name1" name="name" required placeholder="分类名称">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="parentName1" class="col-sm-3 control-label">父分类名称</label>
                                <div class="col-sm-9">
                                    <input type="hidden" class="form-control" id="parentId1" name="parentId">
                                    <input type="text" class="form-control" id="parentName1" name="parentName"
                                           placeholder="选择父分类">
                                    <div id="tree" style="display: none; position:absolute; z-index:1010; background-color:white;"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="level1" class="col-sm-3 control-label">分类级别</label>
                                <div class="col-sm-9">
                                    <select class="form-control" id="level1" name="level" onchange="showDiv(this,1)">
                                        <option value="">请选择分类级别</option>
                                        <option value="1">一级</option>
                                        <option value="2">二级</option>
                                        <option value="3">三级</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="brandsDiv"  style="display: none;" >
                                <label for="brands" class="col-sm-3 control-label">可选品牌</label>
                                <div class="col-sm-9" id="brands">
                                </div>
                            </div>
                            <div class="form-group" id="specsDiv" style="display: none;" >
                                <label for="specs" class="col-sm-3 control-label">可选规格参数</label>
                                <div class="col-sm-9" id="specs">
                                </div>
                            </div>
                            <div class="alert alert-success" id="specOption" role="alert" style="display: none;"  >
                            </div>
                        </form>
                    </div>
                    <!-- 模态框底部 -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary"
                                data-dismiss="modal">关闭
                        </button>
                        <button type="button" class="btn btn-primary" onclick="addCategory()">添加</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- 编辑 模态框 --%>
        <div class="modal fade" id="editCategoryModal"
             tabindex="-1" role="dialog"
             aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable"
                 role="document">
                <div class="modal-content">
                    <!-- 模态框头部 -->
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">编辑分类</h4>
                    </div>
                    <!-- 模态框主体 -->
                    <div class="modal-body">
                        <form class="form-horizontal" id="editModalForm" action="javascript:void(0);">
                            <div class="form-group">
                                <input type="hidden" id="id2" name="id">
                                <label for="name2" class="col-sm-3 control-label">分类名称</label>
                                <div class="col-sm-9">
                                    <input type="text" class="form-control" id="name2" name="name" placeholder="分类名称">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="parentName2" class="col-sm-3 control-label">父分类名称</label>
                                <div class="col-sm-9">
                                    <input type="hidden" class="form-control" id="parentId2" name="parentId">
                                    <input type="text" class="form-control" id="parentName2" name="parentName"
                                           placeholder="选择父分类">
                                    <div id="tree2" style="display: none; position:absolute; z-index:1010; background-color:white;"></div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="level2" class="col-sm-3 control-label">分类级别</label>
                                <div class="col-sm-9">
                                    <select class="form-control" id="level2" name="level" onchange="showDiv(this,2)">
                                        <option value="">请选择分类级别</option>
                                        <option value="1">一级</option>
                                        <option value="2">二级</option>
                                        <option value="3">三级</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="brands2Div" style="display: none;" >
                                <label for="brands" class="col-sm-3 control-label">可选品牌</label>
                                <div class="col-sm-9" id="brands2">
                                </div>
                            </div>
                            <div class="form-group" id="specs2Div" style="display: none;" >
                                <label for="specs" class="col-sm-3 control-label">可选规格参数</label>
                                <div class="col-sm-9" id="specs2">
                                </div>
                            </div>
                            <div class="alert alert-success" id="specOption2" role="alert" style="display: none;"  >
                            </div>
                        </form>
                    </div>
                    <!-- 模态框底部 -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary"
                                data-dismiss="modal">关闭
                        </button>
                        <button type="button" class="btn btn-primary" onclick="editCategory()">编辑</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- 查看 模态框 --%>
        <div class="modal fade" id="checkCategoryModal"
             tabindex="-1" role="dialog"
             aria-labelledby="exampleModalScrollableTitle" aria-hidden="true">
            <div class="modal-dialog modal-dialog-scrollable"
                 role="document">
                <div class="modal-content">
                    <!-- 模态框头部 -->
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">编辑分类</h4>
                    </div>
                    <!-- 模态框主体 -->
                    <div class="modal-body">
                        <form class="form-horizontal" id="checkModalForm" action="javascript:void(0);">
                            <div class="form-group">
                                <label for="name" class="col-sm-3 control-label">分类名称</label>
                                <div class="col-sm-9">
                                    <span id="name3"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="parentName3" class="col-sm-3 control-label">父分类名称</label>
                                <div class="col-sm-9">
                                    <span id="parentName3"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="level3" class="col-sm-3 control-label">分类级别</label>
                                <div class="col-sm-9">
                                    <span id="level3"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="brands" class="col-sm-3 control-label">可选品牌</label>
                                <div class="col-sm-9" >
                                    <span id="brands3"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="specs" class="col-sm-3 control-label">可选规格参数</label>
                                <div class="col-sm-9" >
                                    <span id="specs3"></span>
                                </div>
                            </div>
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
    <jsp:include page="/WEB-INF/view/common/pages.jsp"></jsp:include>
</div>
</body>

</html>

