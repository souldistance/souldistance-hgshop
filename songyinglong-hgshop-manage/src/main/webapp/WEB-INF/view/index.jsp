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
    <script type="text/javascript" src="/resource/jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="/resource/bootstrap/js/bootstrap.min.js"></script>
    <title>Hgshop后台管理系统</title>
    <style>
        .nav li a {
            padding-left: 30px;
        }
        #head {
            width: 30px;
            height: 30px;
            border-radius: 100%;
        }
    </style>
    <script type="text/javascript">
        function left_open() {
            if ($('.leftbar').hasClass('hidden')) {
                $('.leftbar').removeClass('hidden');
                $("#right_content").removeClass('col-md-12');
                $("#right_content").addClass('col-md-10');
            } else {
                $('.leftbar').addClass('hidden');
                $("#right_content").removeClass('col-md-10');
                $("#right_content").addClass('col-md-12');
            }
        }

        $(function () {
            $('.leftbar .nav-link').click(function () {
                $('.leftbar .nav-link').parent().removeClass('active');
                $(this).parent().addClass('active');
            });
        });
    </script>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-2"><a class="navbar-brand" style="color: white" href="#">Hgshop后台</a></div>
            <div class="col-xs-10" style="padding: 0">
                <a href="javascript:void(0)" onclick="left_open()"
                   style="float: left;font-size: 1.5em;margin-top: 10px;color: rgba(255,255,255,.5);"><i
                        class="fa fa-bars"></i></a>
                <!-- Single button -->
                <div class="btn-group" style="float: right">
                    <button type="button" class="btn btn-default dropdown-toggle"
                            style="background-color: #1d2124;border:0px" data-toggle="dropdown" aria-haspopup="true"
                            aria-expanded="false">
                        <img src="/resource/img/111.jpg" id="head"/>
                        <b style="color: white;">${admin.username}</b>
                    </button>
                    <ul class="dropdown-menu" style="position: absolute;left: -50%;margin-top: 10px;">
                        <li><a href="#">个人操作</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/logout">注销</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>
<div class="container-fluid" id="m">
    <div class="row">
        <div class="col-md-2 leftbar" STYLE="padding: 10px;">
            <ul class="nav nav-pills nav-stacked">
                <li class="nav-item active">
                    <a class="nav-link" href="/admin/welcome" target="mainFrame">首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/categories" target="mainFrame">分类管理</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/brands" target="mainFrame">品牌管理</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/specShowCategoryTree" target="mainFrame">规格参数管理</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/spuShowCategoryTree" target="mainFrame">spu管理</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/admin/skuList" target="mainFrame">sku管理</a>
                </li>
            </ul>
        </div>
        <div CLASS="col-md-10" id="right_content" width="100%"  >
            <iframe border=0 marginWidth=0 name="mainFrame"
                    frameSpacing=0 marginHeight=0
                    src="/admin/welcome" frameBorder=0
                    noResize scrolling="no" width=100% height="100%" vspale="0" id="childFrame"></iframe>
        </div>
    </div>
</div>
</body>
</html>