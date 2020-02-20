<%@ page import="java.net.URLDecoder" %><%--suppress ALL --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>HgShop登录</title>
    <!-- Bootstrap core CSS -->
    <link href="<%=request.getContextPath()%>/resource/css/bootstrap.css" rel="stylesheet">
    <link href="/resource/css/jquery/screen.css" rel="stylesheet" type="text/css">
    <!-- Custom styles for this template -->
    <link href="<%=request.getContextPath()%>/resource/css/signin.css" rel="stylesheet">
    <script type="text/javascript" src="<%=request.getContextPath()%>/resource/jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/resource/jquery/bootstrap.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/resource/jquery/jquery.validate.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/resource/jquery/validate_addMethod.js"></script>
    <script>

        function login() {
            /*$.post('/passport/login', $('#loginForm').serialize(), function (result) {
                if (result.code == 0) {
                    location="/admin/index";
                } else {
                    var str = '<div class="alert alert-warning alert-dismissible" role="alert">'
                        + ' <button type="button" class="close" data-dismiss="alert" aria-label="Close">'
                        + '<span aria-hidden="true">&times;</span>'
                        + '</button><strong> ' +  result.message + '</strong></div>';
                    $("#error").html(str);
                }
            });*/
            $.ajax({
                url:'/passport/login',
                data:$('#loginForm').serialize(),
                type:"post",
                success:function (result) {
                    if (result.code == 0) {
                        location = "/admin/index";
                    } else {
                        var str = '<div class="alert alert-warning alert-dismissible" role="alert">'
                            + ' <button type="button" class="close" data-dismiss="alert" aria-label="Close">'
                            + '<span aria-hidden="true">&times;</span>'
                            + '</button><strong> ' + result.message + '</strong></div>';
                        $("#error").html(str);
                    }
                },error:function () {
                    alert("系统错误!");
                }
            })
        }
    </script>
</head>
<body>
<div class="container">
    <form class="form-signin"   id="loginForm">
        <h2 class="form-signin-heading" style="text-align: center;">HgShop</h2>
        <span>${message}</span>
        <div class="form-group">
            <label for="username">用户名</label>
            <input type="text" id="username" name="username"  class="form-control" placeholder="请输入用户名" required
                   autofocus>
        </div>
        <div class="form-group">
            <label for="password">密码</label>
            <input type="password" id="password"  name="password" class="form-control" placeholder="请输入密码" required>
        </div>
        <div class="checkbox">
            <label>
                <input type="checkbox" value="remember" name="remember"> 记住我
            </label>
        </div>
        <div id="error"></div>
        <button class="btn btn-lg btn-primary btn-block" type="button" onclick="login()">登录</button>
    </form>
</div>
</body>
</html>
