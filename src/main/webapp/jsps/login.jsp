<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    pageContext.setAttribute("pct", request.getContextPath());
%>
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

        });

    </script>

</head>
<body>
<dl class="admin_login" style="width: 400px;">
    <dt>
        <strong style="color: #5bc0de">奥友后台管理系统</strong>
        <em>Abstruse Friend </em>
    </dt>
    <dd class="user_icon">
        <input type="text" placeholder="账号" id="user" class="login_txtbx" style="height: 35px"/>
    </dd>
    <dd class="pwd_icon">
        <input type="password" placeholder="密码" id="password" class="login_txtbx" style="height: 35px"/>
    </dd>
    <dd style="margin :0px 10px 10px 10px ;float:right;"></dd>
    <dd style="margin :0px 10px 10px 20px ;float:right;">
        <img id="authImg" src="${pct}/user/autoImage"  style="width:100px; height: 36px;"/>
    </dd>
    <dd class="val_icon">
        <input type="text" id="codestext" placeholder="验证码" maxlength="4" class="login_txtbx" style="float:left;width:200px;height: 36px;">

    </dd>
    <span class="help-block" style="color:red;">&nbsp;</span>
    <dd style="float:left;">
        <input type="button" value="立即登陆" class="submit_btn" style="width:300px;"/>
    </dd>

</dl>


</body>

<script>
    //校验码的验证
    $(function () {
        /* $(document).keydown(function(event){
             if(event.keyCode==13){
                 sendForm();
             }
         });*/

        $(".submit_btn").click(function(){
            console.log(bl());
            bl();

            b2();

        });

        function b2(){

            if(bl()!=false){
                $.ajax({
                    url: "/user/login",
                    type: "post",
                    data:{userName:$("#user").val(),userPwd:$("#password").val()},
                    dataType: "json",
                    success: function (data) {
                        if(data){
                            location.href="http://localhost:8080/jsps/index.jsp";
                        }else {
                            setError(user,"该用户不存在");
                            return false;
                        }
                    }
                })
            }


        }

        $("#user").blur(function () {
            var user=$(this);
            if(user.val()!=''){
                $.ajax({
                    url: "/user/login",
                    type: "post",
                    data:{userName:$("#user").val(),userPwd:$("#password").val()},
                    dataType: "json",
                    success: function (data) {
                        if(data){

                        }else {
                            setError(user,"该用户不存在");
                            return false;
                        }
                    }
                })
            }else{
                setError(user,"用户名不能为空");
                return false;
            }

        });

        $("#mobile").blur(function () {
            console.log("-------1-------");
            var phone=$(this).val();
            if(!(/^1[34578]\d{9}$/.test(phone))){
                setError($(this),"手机号码有误，请重填!");
            }else{
                if(!isExistMobile(phone)){
                    setError($(this),"该手机号码不存在！");
                }else{
                    setOk($(this));
                }
            }
        });
        $("#password").blur(function () {
            var password=$(this).val();
            if(!(/^\S{6,20}$/.test(password)) && password!=''){
                setError($(this),"(密码错误！)密码由6-20位字母，数字和符号组合，区分大小写!");
                return false;
            }else{
                setOk($(this));
            }
        });
        //刷新校验码
        $("#authImg").click(function () {
            $(this).attr("src","/user/autoImage?date=" + new Date());
        });
        var q=0;
        //校验码的验证
        $("#codestext").blur(function () {
            var _that=$(this);
            var _this=this;
            if(($(this).val())!=''){
                $.ajax({
                    type:"post",
                    url:"/user/checkCodestext",
                    data:{
                        "codestext":$(this).val()
                    },
                    dataType:"json",
                    error:function(error){
                        setError(_that,"校验码不正确!");
                        return false;
                        q=1;
                    },success:function(data){
                        if(data){
                            setOk(_that);
                            q=0;
                        }else{
                            setError(_that,"校验码不正确!");
                            q=1;
                            return false;
                        }
                    }
                });
            }

        });

        /*验证成功，调用此方法*/
        function setOk(obj){
            var _pdiv=obj.parents().parents(".form-group");
            if(_pdiv.hasClass("has-error")){
                _pdiv.removeClass("has-error");
            }
            _pdiv.addClass("has-success");
            obj.parents().nextAll("span.help-block").html("&nbsp;");
        }

        /*验证失败，调动此方法*/
        function setError(obj,str){
            var _pdiv=obj.parents().parents(".form-group");
            if(_pdiv.hasClass("has-success")){
                _pdiv.removeClass("has-success");
            }
            _pdiv.addClass("has-error");
            obj.parents().nextAll("span.help-block").html(str);
        }

        function bl() {
            var user=$("#user");
            var password=$("#password").val();
            var i=0;
                if(user.val()!=''){
                    $.ajax({
                        url: "/user/login",
                        type: "post",
                        data:{userName:$("#user").val(),userPwd:$("#password").val()},
                        dataType: "json",
                        success: function (data) {
                            if(data){
                            }else {
                                setError(user,"该用户不存在");
                                return false;
                            }
                        }
                    })
                }else{
                    setError(user,"用户名不能为空");
                    return false;
                }

            if(!(/^\S{6,20}$/.test(password))){
                setError($("#password"),"(密码错误！)密码由6-20位字母，数字和符号组合，区分大小写!");
                return false;
            }else if(password==''){
                setError($("#password"),"密码不能为空");
                return false;
            } else{
                setOk($("#password"));
            }

            var _that=$("#codestext");
                if((_that.val())!=''){
                    $.ajax({
                        type:"post",
                        url:"/user/checkCodestext",
                        data:{
                            "codestext":_that.val()
                        },
                        dataType:"json",
                        error:function(error){
                            q=1;
                            setError(_that,"校验码不正确!");
                            return false;
                        },success:function(data){
                            if(data){
                                setOk(_that);
                                q=0;

                            }else{
                                q=1;
                                setError(_that,"校验码不正确!");
                                return false;
                            }

                        }


                    });
                    if(q==1){
                        return false;
                    }
            }else{
                setError(_that,"校验码不能为空!");
                return false;
            }






        }
    });

</script>
</html>
