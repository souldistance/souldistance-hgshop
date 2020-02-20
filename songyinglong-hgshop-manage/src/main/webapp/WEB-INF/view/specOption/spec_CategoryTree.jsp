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
    <title>规格参数管理</title>
    <script>
        var h = parent.document.getElementById("childFrame"); //取得父页面IFrame对象
        //自适应高度
        function IFrameResize() {
            //alert(this.document.body.scrollHeight); //弹出当前页面的高度
            //alert(obj.height); //弹出父页面中IFrame中设置的高度
            h.height = this.document.body.offsetHeight - 28;//调整父页面中IFrame的高度为此页面的高度
        }
        $(function() {
            $.post('/admin/getAllCategories1', {}, function(obj) {
                var data=obj.data;
                $('#tree').treeview({
                    levels:1,
                    data : data,
                    onNodeSelected : function(event, node) {
                        $('#nodeFrame').prop('src', '/admin/specList?categoryId=' + node.id );
                        h.height =$('.treeview').outerHeight()+45>660?$('.treeview').outerHeight()+45:660;
                    },
                    onNodeCollapsed: function (event, node) {
                         h.height =$('.treeview').outerHeight()-45>660?$('.treeview').outerHeight()-node.nodes.length*45:660;
                    },
                    onNodeExpanded:function (event, node) {
                        h.height =$('.treeview').outerHeight()+(node.nodes.length+1)*45>660?$('.treeview').outerHeight()+(node.nodes.length+1)*45:660;
                    }
                });
            });
        });
    </script>
</head>
<body onload="IFrameResize()" >
<div class="container-fluid">
    <div class="row">
        <!-- 左边部分 -->
        <div class="col-md-2">
            <div id="tree"></div>
        </div>
        <div CLASS="col-md-10" id="right_content" width="100%"  >
            <iframe border=0 marginWidth=0 name="mainFrame"
                    frameSpacing=0 marginHeight=0
                    src="/admin/specList" frameBorder=0
                    noResize scrolling="no" width=100%  vspale="0"  id="nodeFrame"></iframe>
        </div>
    </div>
</div>
</body>
</html>