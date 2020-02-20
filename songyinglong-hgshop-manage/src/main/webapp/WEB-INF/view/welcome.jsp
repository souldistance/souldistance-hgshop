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
    <script type="text/javascript" src="<%=request.getContextPath()%>/resource/jquery/jquery-3.4.1.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/resource/jquery/jquery.validate.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath()%>/resource/jquery/bootstrap.js"></script>
    <link href="<%=request.getContextPath()%>/resource/css/bootstrap.css" rel="stylesheet" type="text/css">
    <script type="text/javascript">
        //自适应高度
        function IFrameResize() {
            //alert(this.document.body.scrollHeight); //弹出当前页面的高度
            var obj = parent.document.getElementById("childFrame"); //取得父页面IFrame对象
            //alert(obj.height); //弹出父页面中IFrame中设置的高度
            obj.height = this.document.body.scrollHeight-2; //调整父页面中IFrame的高度为此页面的高度
        }
    </script>
    <title>Insert title here</title>
</head>
<body onload="IFrameResize()">
    <div align="center" class="container">
        <img alt="后台首页"
             src="/resource/img/f603918fa0ec08fa3139e00153ee3d6d55fbda5f.jpg"
             class="img-circle" style="margin-top: 160px">
    </div>
</body>
</html>