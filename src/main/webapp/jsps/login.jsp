<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>奥友后台管理系统---登录</title>
    <script src="/js/jquery.js"></script>
    <script src="/js/jquery-3.4.1.min.js"></script>
    <script src="/bootstrap/table/bootstrap-table.js"></script>
    <script src="/bootstrap/js/bootstrap-tab.js"></script>
    <script src="/bootstrap/js/bootstrap.js"></script>
    <script src="/bootstrap/js/bootstrap.min.js"></script>
    <script src="/bootstrap/js/bootstrap-table-zh-CN.min.js"></script>

    <script src="/js/verificationNumbers.js" tppabs="/js/verificationNumbers.js"></script>
    <script src="/js/Particleground.js" tppabs="/js/Particleground.js"></script>

    <link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/bootstrap/css/bootstrap-tab.css">
    <link rel="stylesheet" href="/bootstrap/table/bootstrap-table.css">
    <link rel="stylesheet" type="text/css" href="/css/style.css" tppabs="/css/style.css" />
    <style>
        body{height:100%;background:#16a085;overflow:hidden;}
        canvas{z-index:-1;position:absolute;}
    </style>

    <script>
        $(document).ready(function() {
            //粒子背景特效
            $('body').particleground({
                dotColor: '#5cbdaa',
                lineColor: '#5cbdaa'
            });
            //验证码
            createCode();
            //测试提交，对接程序删除即可
            $(".submit_btn").click(function(){
                location.href="javascrpt:;"/*tpa=http://***index.html*/;
            });
        });
    </script>

</head>
<body>
<dl class="admin_login">
    <dt>
        <strong style="color: #5bc0de">奥友后台管理系统</strong>
        <em>Abstruse Friend </em>
    </dt>
    <dd class="user_icon">
        <input type="text" placeholder="账号" class="login_txtbx" style="height: 35px"/>
    </dd>
    <dd class="pwd_icon">
        <input type="password" placeholder="密码" class="login_txtbx" style="height: 35px"/>
    </dd>
    <dd class="val_icon">
        <div class="checkcode"  style="height: 36px">
            <input type="text" id="J_codetext" placeholder="验证码" maxlength="4" class="login_txtbx"style="height: 36px">
            <canvas class="J_codeimg" id="myCanvas" onclick="createCode()">对不起，您的浏览器不支持canvas，请下载最新版浏览器!</canvas>
        </div>
    <dd class="yan_icon">
        <input type="button" value="验证码核验" class="ver_btn" onClick="validate();">
    </dd>
    </dd>
    <dd>
        <input type="button" value="立即登陆" class="submit_btn"/>
    </dd>
    <dd>
    </dd>
</dl>


</body>
</html>
