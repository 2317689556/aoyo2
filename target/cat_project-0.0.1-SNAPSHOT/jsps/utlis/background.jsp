<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script type="text/javascript" src="/js/google-maps.js"></script>
<link href="/css/fonts.css" rel="stylesheet">
<script>
    var circleArr = [];

    //调用执行
    window.onload = function () {
        $(".vertical-nav").verticalnav({speed: 400, align: "left"});
        //定义画布宽高和生成点的个数
        var WIDTH = window.innerWidth, HEIGHT = window.innerHeight, POINT = 55;

        var canvas = document.getElementById('Mycanvas');
        canvas.width = WIDTH,
            canvas.height = HEIGHT;
        var context = canvas.getContext('2d');
        context.strokeStyle = 'rgba(0,0,0,0.02)',
            context.strokeWidth = 1,
            context.fillStyle = 'rgba(0,0,0,0.05)';
        init();
        getMenu();
        setInterval(function () {
            for (var i = 0; i < POINT; i++) {
                var cir = circleArr[i];
                cir.x += cir.moveX;
                cir.y += cir.moveY;
                if (cir.x > WIDTH) cir.x = 0;
                else if (cir.x < 0) cir.x = WIDTH;
                if (cir.y > HEIGHT) cir.y = 0;
                else if (cir.y < 0) cir.y = HEIGHT;

            }
            draw();
        }, 16);

        function getMenu() {
            $.ajax({
                url: "/user/listMenu",
                type: "post",
                dataType: "json",
                success: function (data) {
                    console.log(data);
                    for (var i = 1; i < data.length; i++) {
                        $("#menu").append("<li><a href=\"#\"><i class=\""+data[i].menuIconPath+"\"></i>"+data[i].menuName+"\n" +
                            "                    <span class=\""+data[i].menuId+"\"></span></a>\n" +
                            "                    <ul id=\""+data[i].menuId+"\">\n" +
                            "                    </ul>\n" +
                            "                </li>")


                        var arr=data[i].childMenus;
                        if(arr!=null && arr.length!=0){
                            $("."+data[i].menuId+"").addClass("submenu-icon");
                            for (var a = 0; a < arr.length; a++) {
                                var id=arr[a].menuParentId;
                                $("#"+id+"").append("<li><a href=\""+arr[a].menuPath+"\">"+arr[a].menuName+"\n" +
                                    "             <span class=\""+arr[a].menuId+"\"></span>       </a><ul id=\""+arr[a].menuId+"\">\n" +
                                    "                    </ul>\n" +
                                    "                </li>");

                                var arr1=arr[a].childMenus;
                                if(arr1!=null && arr1.length!=0){
                                    $("."+arr[a].menuId+"").addClass("submenu-icon");
                                    setMenu(arr1,arr[a].menuId);
                                }
                            }
                        }
                        $(".vertical-nav").verticalnav({speed: 400, align: "left"});

                    }

                }
            });
        };
        function setMenu(data,id){
            for (var i = 0; i < data.length; i++) {
                var arr=data[i];

                $("#"+id+"").append("<li><a href=\""+arr.menuPath+"\">"+arr.menuName+"\n" +
                    "                  <span class=\""+arr.menuId+"\"></span>    </a><ul id=\""+arr.menuId+"\">\n" +
                    "                    </ul>\n" +
                    "                </li>");

                var arr1=arr.childMenus;
                if(arr1!=null && arr1.length!=0){
                    $("."+arr.menuId+"").addClass("submenu-icon");
                    setMenu(arr1,arr.menuId);
                }

            }

        }

        //线条：开始xy坐标，结束xy坐标，线条透明度
        function Line(x, y, _x, _y, o) {
            this.beginX = x,
                this.beginY = y,
                this.closeX = _x,
                this.closeY = _y,
                this.o = o;
        }

        //点：圆心xy坐标，半径，每帧移动xy的距离
        function Circle(x, y, r, moveX, moveY) {
            this.x = x,
                this.y = y,
                this.r = r,
                this.moveX = moveX,
                this.moveY = moveY;
        }

        //生成max和min之间的随机数
        function num(max, _min) {
            var min = arguments[1] || 0;
            return Math.floor(Math.random() * (max - min + 1) + min);
        }

        // 绘制原点
        function drawCricle(cxt, x, y, r, moveX, moveY) {
            var circle = new Circle(x, y, r, moveX, moveY)
            cxt.beginPath()
            cxt.arc(circle.x, circle.y, circle.r, 0, 2 * Math.PI)
            cxt.closePath()
            cxt.fill();
            return circle;
        }

        //绘制线条
        function drawLine(cxt, x, y, _x, _y, o) {
            var line = new Line(x, y, _x, _y, o)
            cxt.beginPath()
            cxt.strokeStyle = 'rgba(0,0,0,' + o + ')'
            cxt.moveTo(line.beginX, line.beginY)
            cxt.lineTo(line.closeX, line.closeY)
            cxt.closePath()
            cxt.stroke();

        }

        //初始化生成原点
        function init() {
            circleArr = [];
            for (var i = 0; i < POINT; i++) {
                circleArr.push(drawCricle(context, num(WIDTH), num(HEIGHT), num(15, 2), num(10, -10) / 40, num(10, -10) / 40));
            }
            draw();
        }

        //每帧绘制
        function draw() {
            context.clearRect(0, 0, canvas.width, canvas.height);
            for (var i = 0; i < POINT; i++) {
                drawCricle(context, circleArr[i].x, circleArr[i].y, circleArr[i].r);
            }
            for (var i = 0; i < POINT; i++) {
                for (var j = 0; j < POINT; j++) {
                    if (i + j < POINT) {
                        var A = Math.abs(circleArr[i + j].x - circleArr[i].x),
                            B = Math.abs(circleArr[i + j].y - circleArr[i].y);
                        var lineLength = Math.sqrt(A * A + B * B);
                        var C = 1 / lineLength * 7 - 0.009;
                        var lineOpacity = C > 0.03 ? 0.03 : C;
                        if (lineOpacity > 0) {
                            drawLine(context, circleArr[i].x, circleArr[i].y, circleArr[i + j].x, circleArr[i + j].y, lineOpacity);
                        }
                    }
                }
            }
        }

    }

</script>
<style>
    html,body {
        width: 100%;
        margin: 0;
        padding: 0;
        overflow-x: hidden;
        overflow-y: auto;
        text-rendering: optimizeLegibility;
        -webkit-font-smoothing: antialiased;
        -moz-osx-font-smoothing: grayscale;
        -webkit-tap-highlight-color: transparent;
        font-family: "Avenir Next ST","Microsoft YaHei","PingFang SC",sans-serif
    }

    .icon-bar-chart {
        width: 50px;
    }

    .bggjgjjgjywrturuwehegqeq410000 {
        clear: both
    }

    .bggjgjjgjywrturuwehegqeq410001:after {
        display: block;
        visibility: hidden;
        content: ".";
        clear: both;
        text-indent: -9999px;
        height: 0;
    }

    .bggjgjjgjywrturuwehegqeq410002 {
        margin-right: 0 !important
    }

    #sdgagdgd10000 {
        width: 660px;
        padding: 40px;
        background: #FFF;
        margin: 20px auto;
        -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.27), 0 0 40px rgba(0, 0, 0, 0.06) inset;
        -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.27), 0 0 40px rgba(0, 0, 0, 0.06) inset;
        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.27), 0 0 40px rgba(0, 0, 0, 0.06) inset;
    }

    .bggjgjjgjywrturuwehegqeq410003 {
        background: none !important;
        width: 740px !important;
        padding: 0px !important;
    }

    .vertical-nav {
        width: 200px;
        margin: 0;
        padding: 0;
        float: left;
        font-family: Segoe UI, Arial;
        position: relative;
        list-style: none;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
        background: #fff;
    }

    #sdgagdgd10001 {
        margin: 0 0 40px;
        font-size: 14px;
        color: #999;
    }

    .bggjgjjgjywrturuwehegqeq410004 {
        display: block;
        margin: 0 auto
    }

    .bggjgjjgjywrturuwehegqeq410005 {
        float: right;
        margin: 10px 0 10px 10px
    }

    .bggjgjjgjywrturuwehegqeq410006 {
        float: left;
        margin: 10px 10px 10px 0
    }

    .bggjgjjgjywrturuwehegqeq410007 {
        float: left
    }

    .bggjgjjgjywrturuwehegqeq410008 {
        float: right
    }

    .bggjgjjgjywrturuwehegqeq410009 {
        text-align: center
    }

    .bggjgjjgjywrturuwehegqeq410010 {
        text-align: right
    }

    .bggjgjjgjywrturuwehegqeq410011 {
        text-align: left
    }

    .vertical-nav li {
        display: block;
        width: 100%;
        padding: 0;
        float: left;
        font-size: 14px;
        position: relative;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        -webkit-box-sizing: border-box;
    }

    .bggjgjjgjywrturuwehegqeq410012 {
        border: 1px solid #ddd;
        text-align: center;
        background-color: #f3f3f3;
        padding-top: 4px;
        margin: 10px;
        -moz-border-radius: 3px;
        -khtml-border-radius: 3px;
        -webkit-border-radius: 3px;
        border-radius: 3px;
    }

    .bggjgjjgjywrturuwehegqeq410012 img {
        margin: 0;
        padding: 0;
        border: 0 none;
    }

    .vertical-nav li a {
        width: 100%;
        display: block;
        padding: 8px 19px 8px 19px;
        color: #888;
        text-decoration: none;
        box-sizing: border-box;
        -moz-box-sizing: border-box;
        -webkit-box-sizing: border-box;
        -o-transition: all .3s ease-in-out;
        -webkit-transition: all .3s ease-in-out;
        -moz-transition: all .3s ease-in-out;
        transition: all .3s ease-in-out;
    }

    .bggjgjjgjywrturuwehegqeq410012 p.bggjgjjgjywrturuwehegqeq410013 {
        font-size: 11px;
        line-height: 17px;
        padding: 0 4px 5px;
        margin: 0;
    }

    .bggjgjjgjywrturuwehegqeq410014 {
        margin: 0 !important;
        max-height: 1em;
    }

    .vertical-nav li:hover > a > i, .vertical-nav > li.active a > i {
        background: #95a5a6;
        color: #fff;
    }

    blockquote.bggjgjjgjywrturuwehegqeq410015 {
        margin-right: 20px;
        text-align: right;
        margin-left: 0;
        width: 33%;
        float: left;
    }

    blockquote.bggjgjjgjywrturuwehegqeq410016 {
        margin-left: 20px;
        text-align: left;
        margin-right: 0;
        width: 33%;
        float: right;
    }

    .bggjgjjgjywrturuwehegqeq410017 a {
        float: left;
        display: block;
        color: #666;
        margin-left: 5px;
        margin-bottom: 5px;
        padding: 3px 7px;
        line-height: 1em;
        background: #EEE;
        -webkit-border-radius: 5px;
        -moz-border-radius: 5px;
        border-radius: 5px;
    }

    .vertical-nav ul, .vertical-nav ul li ul {
        list-style: none;
        margin: 0;
        padding: 0;
        display: none;
        position: absolute;
        z-index: 999;
        width: 100%;
        background: #fff;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
    }

    .vertical-nav ul {
        top: 0;
        left: 100%;
    }

    .bggjgjjgjywrturuwehegqeq410018 {
        float: left;
    }

    #sdgagdgd10002 {
        width: 100%;
    }

    #sdgagdgd10002 caption {
        text-align: right;
        color: #333;
        font-size: 12px;
        margin-top: 10px;
        margin-bottom: 15px;
    }

    .vertical-nav ul li ul {
        top: 1px;
    }

    .vertical-nav ul li {
        clear: both;
        width: 100%;
    }

    .vertical-nav ul li a {
        padding: 10px 20px;
        text-decoration: none;
        display: inline-block;
        border: 0 none;
        float: left;
        clear: both;
    }

    #sdgagdgd10002 thead {
        font-size: 10px;
    }

    #sdgagdgd10002 thead th {
        padding-bottom: 10px;
    }

    #sdgagdgd10002 tbody {
        color: #aaa;
    }

    #sdgagdgd10002 tbody td {
        background: #f5f5f5;
        border: 1px solid #fff;
        text-align: center;
        padding: 8px;
    }

    #sdgagdgd10002 tbody td:hover {
        background: #fff;
    }

    #sdgagdgd10002 tbody .bggjgjjgjywrturuwehegqeq410019 {
        background: none;
    }

    #sdgagdgd10002 tfoot #sdgagdgd10003 {
        font-size: 10px;
        text-transform: uppercase;
        text-align: right;
    }

    #sdgagdgd10002 tfoot #sdgagdgd10004 {
        font-size: 10px;
        text-transform: uppercase;
        padding-top: 10px;
    }

    .vertical-nav .submenu-icon {
        font-family: 'FontAwesome';
        font-size: 10px;
        float: right;
        margin-right: -10px;
        line-height: 24px;
    }

    .vertical-nav > li > a > .submenu-icon:before {
        content: "\f0c9";
    }

    .vertical-nav > li ul a .submenu-icon:before {
        content: "\f0c9";
        float: right;
        line-height: 23px;
    }

    #sdgagdgd10005 {
        width: 740px;
        margin: 0 auto;
        position: relative;
        text-shadow: 1px 1px 1px #FFF;
    }

    #sdgagdgd10006 {
        float: left;
    }

    #sdgagdgd10006 h2, #sdgagdgd10006 h1 {
        margin: 0;
        line-height: 1em;
        font-size: 20px;
        font-weight: normal;
        font-style: normal;
    }

    #sdgagdgd10006 h2 a, #sdgagdgd10006 h1 a {
        color: #7B7B7B;
        text-decoration: none;
    }

    #sdgagdgd10006 h2 a:hover, #sdgagdgd10006 h1 a:hover {
        color: #000
    }

    #sdgagdgd10007 {
        position: absolute;
        height: 48px;
        top: 4px;
        right: -15px;
        font-family: 'Droid Sans', arial, serif;
    }

    .bggjgjjgjywrturuwehegqeq410020, .bggjgjjgjywrturuwehegqeq410020 * {
        margin: 0;
        padding: 0;
        list-style: none;
    }

    .bggjgjjgjywrturuwehegqeq410020 {
        line-height: 1.0
    }

    .bggjgjjgjywrturuwehegqeq410020 ul {
        position: absolute;
        top: -999em;
        width: 10em;
    }

    .bggjgjjgjywrturuwehegqeq410020 ul li {
        width: 100%
    }

    .bggjgjjgjywrturuwehegqeq410020 li:hover {
        visibility: inherit;
    }

    .vertical-nav > li i {
        line-height: 24px !important;
        margin: -16px 14px 0 -20px;
        font-size: 25px;
        float: left;
        border-right: solid 1px #dedede;
        padding-right: 10px;
        padding: 14px 40px 12px 15px;
        width: 28px;
        text-align: center;
        -o-transition: background .3s ease-in-out;
        -webkit-transition: background .3s ease-in-out;
        -moz-transition: background .3s ease-in-out;
        transition: background .3s ease-in-out;
    }

    .bggjgjjgjywrturuwehegqeq410020 li {
        float: left;
        position: relative;
    }

    .bggjgjjgjywrturuwehegqeq410020 a {
        display: block;
        position: relative;
    }

    .bggjgjjgjywrturuwehegqeq410020 li:hover ul, .bggjgjjgjywrturuwehegqeq410020 li.bggjgjjgjywrturuwehegqeq410021 ul {
        left: 0;
        top: 3em;
        z-index: 99;
        background: #FFF;
        padding: 10px 0;
        border: 1px solid #DDD;
        border-top: none;
    }

    ul.bggjgjjgjywrturuwehegqeq410020 li:hover li ul, ul.bggjgjjgjywrturuwehegqeq410020 li.bggjgjjgjywrturuwehegqeq410021 li ul {
        top: -999em
    }

    ul.bggjgjjgjywrturuwehegqeq410020 li li:hover ul, ul.bggjgjjgjywrturuwehegqeq410020 li li.bggjgjjgjywrturuwehegqeq410021 ul {
        left: 10em;
        top: 0;
    }

    .vertical-nav > li.showhide {
        display: none;
        width: 100%;
        height: 50px;
        cursor: pointer;
        color: #888;
        border-bottom: solid 1px rgba(0, 0, 0, 0.1);
        background: #fff;
    }

    .vertical-nav > li.showhide span.title {
        margin: 16px 0 0 25px;
        float: left;
    }

    ul.bggjgjjgjywrturuwehegqeq410020 li li:hover li ul, ul.bggjgjjgjywrturuwehegqeq410020 li li.bggjgjjgjywrturuwehegqeq410021 li ul {
        top: -999em
    }

    ul.bggjgjjgjywrturuwehegqeq410020 li li li:hover ul, ul.bggjgjjgjywrturuwehegqeq410020 li li li.bggjgjjgjywrturuwehegqeq410021 ul {
        left: 10em;
        top: 0;
    }

    .bggjgjjgjywrturuwehegqeq410020 {
        float: left;
        margin-bottom: 1em;
    }

    .bggjgjjgjywrturuwehegqeq410020 a {
        color: #666;
        padding: 0 15px;
        text-decoration: none;
    }

    .bggjgjjgjywrturuwehegqeq410020 a:focus, .bggjgjjgjywrturuwehegqeq410020 a:hover, .bggjgjjgjywrturuwehegqeq410020 a:active {
        color: #000;
    }

    .vertical-nav > li.showhide span.icon {
        margin: 17px 20px;
        float: right;
    }

    .vertical-nav > li.showhide .icon em {
        margin-bottom: 3px;
        display: block;
        width: 20px;
        height: 2px;
        background: #ccc;
    }

    .bggjgjjgjywrturuwehegqeq410022 a {
        color: #000;
    }

    .bggjgjjgjywrturuwehegqeq410020 ul a:focus, .bggjgjjgjywrturuwehegqeq410020 ul a:hover, .bggjgjjgjywrturuwehegqeq410020 ul a:active {
        color: #000 !important;
    }

    li.bggjgjjgjywrturuwehegqeq410021 {
        color: #000
    }

    .bggjgjjgjywrturuwehegqeq410020 li li {
        text-transform: none;
    }

    .bggjgjjgjywrturuwehegqeq410020 li li li {
        background: #FFF
    }

    .bggjgjjgjywrturuwehegqeq410020 ul a {
        color: #999;
        padding: 1em 1.2em
    }

    .bggjgjjgjywrturuwehegqeq410022 ul a {
        color: #000 !important;
    }

    .vertical-nav.dark, .vertical-nav.dark ul, .vertical-nav.dark ul li ul {
        background: #222 !important;
    }

    .vertical-nav.dark > li.showhide {
        background: #222;
        color: #fff !important;
    }

    .vertical-nav.dark > li.showhide .icon em {
        background: #fff;
    }

    .bggjgjjgjywrturuwehegqeq410020 a.bggjgjjgjywrturuwehegqeq410023 {
        padding-right: 2.25em;
        min-width: 1px;
    }

    .bggjgjjgjywrturuwehegqeq410024 {
        position: absolute;
        display: block;
        right: .75em;
        width: 9px;
        height: 5px;
        text-indent: -999em;
        overflow: hidden;
        background: url('${pct}static/images/arrows-down.png');
    }

    a > .bggjgjjgjywrturuwehegqeq410024 {
        top: .4em;
        background-position: 0 -100px;
    }

    a:focus > .bggjgjjgjywrturuwehegqeq410024, a:hover > .bggjgjjgjywrturuwehegqeq410024, a:active > .bggjgjjgjywrturuwehegqeq410024, li:hover > a > .bggjgjjgjywrturuwehegqeq410024, li.bggjgjjgjywrturuwehegqeq410021 > a > .bggjgjjgjywrturuwehegqeq410024 {
        background-position: -9px 0px;
    }

    .red li:hover > a > i, .red li.active > a > i {
        background: #e74c3c;
        color: #fff !important;
    }

    .red li:hover > a {
        color: #e74c3c;
    }

    .bggjgjjgjywrturuwehegqeq410020 ul .bggjgjjgjywrturuwehegqeq410024 {
        top: 1em;
        width: 5px;
        height: 9px;
        background: url('${pct}static/images/arrows-side.png');
    }

    .bggjgjjgjywrturuwehegqeq410020 ul a > .bggjgjjgjywrturuwehegqeq410024 {
        background-position: 0 0
    }

    .bggjgjjgjywrturuwehegqeq410020 ul a:focus > .bggjgjjgjywrturuwehegqeq410024, .bggjgjjgjywrturuwehegqeq410020 ul a:hover > .bggjgjjgjywrturuwehegqeq410024, .bggjgjjgjywrturuwehegqeq410020 ul a:active > .bggjgjjgjywrturuwehegqeq410024, .bggjgjjgjywrturuwehegqeq410020 ul li:hover > a > .bggjgjjgjywrturuwehegqeq410024, .bggjgjjgjywrturuwehegqeq410020 ul li.bggjgjjgjywrturuwehegqeq410021 > a > .bggjgjjgjywrturuwehegqeq410024 {
        background-position: -5px 0;
    }

    #sdgagdgd10008 {
        margin-bottom: 40px;
    }

    .bggjgjjgjywrturuwehegqeq410025 {
        float: left;
        width: 290px;
        margin-right: 25px;
        text-align: center;
    }

    .bggjgjjgjywrturuwehegqeq410025 h2 {
        font-size: 16px;
        font-weight: bold;
        margin-bottom: 20px;
    }

    #sdgagdgd10009 h2 {
        font-size: 14px;
        font-style: normal;
        margin-bottom: 20px;
    }

    #sdgagdgd10010 {
    }

    #portfolio-group {
        margin: 40px 0px;
    }

    #sdgagdgd10011 {
        list-style: none;
    }

    #sdgagdgd10011 a {
        font-size: 10px;
        font-weight: bold;
        float: left;
        padding: 5px 10px;
        margin-right: 5px;
        margin-bottom: 5px;
        cursor: pointer;
        color: #969696;
        background: -moz-linear-gradient(top, #f2f2f2 0%, #dbdbdb);
        background: -webkit-gradient(linear, left top, left bottom, from(#f2f2f2), to(#dbdbdb));
        border-radius: 5px;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        border: 1px solid #CCC;
        text-shadow: 1px 1px 1px #FFF;
    }

    @media (max-width: 768px) {
        .vertical-nav, .vertical-nav li {
            width: 100%;
        }

        .vertical-nav > li > a {
            padding-top: 15px;
            padding-bottom: 15px;
            padding-left: 25px;
        }

        .vertical-nav a {
            width: 100%;
        }

        .vertical-nav ul, .vertical-nav ul li ul {
            width: 100%;
            left: 0;
            border-left: none;
            position: static;
        }

        .vertical-nav ul li {
            background: #e9e9e9;
        }

        .vertical-nav.dark ul li {
            background: #333;
        }

        .vertical-nav ul li a {
            padding-top: 10px;
            padding-bottom: 10px;
        }

        .vertical-nav > li i {
            margin: -16px 14px 0 -25px;
        }

        .vertical-nav > li > ul > li > a {
            padding-left: 40px !important;
        }

        .vertical-nav > li > ul > li > ul > li > a {
            padding-left: 60px !important;
        }

        .vertical-nav > li > ul > li > ul > li > ul > li > a {
            padding-left: 80px !important;
        }

        .vertical-nav .submenu-icon {
            margin-right: 5px;
        }

        .vertical-nav ul .submenu-icon {
            display: none;
        }
    }

    #sdgagdgd10011 a:hover {
        background: #EEE;
        color: #666;
    }

    #sdgagdgd10011 a span {
        display: block;
        border-top: 1px solid #FFF;
        -webkit-border-radius: 3px;
        -moz-border-radius: 3px;
        border-radius: 3px;
    }

    .bggjgjjgjywrturuwehegqeq410026 {
        position: relative;
        float: left;
        width: 150px;
        margin-right: 20px;
        margin-bottom: 20px;
        cursor: pointer;
    }

    .bggjgjjgjywrturuwehegqeq410026 img {
    }

    .overlay {
        background: url(${pct}static/images/overlay-bg.png) repeat;
        width: 150px;
        height: 120px;
        position: absolute;
        display: none;
        left: 0;
        top: 0;
    }

    .bggjgjjgjywrturuwehegqeq410027 p {
        margin-top: 45px;
        margin-left: 40px;
    }

    .bggjgjjgjywrturuwehegqeq410028, .bggjgjjgjywrturuwehegqeq410029 {
        -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=60)";
        filter: alpha(opacity=60);
        -moz-opacity: 0.60;
        -khtml-opacity: 0.60;
        opacity: 0.60;
    }

    .bggjgjjgjywrturuwehegqeq410028:hover, .bggjgjjgjywrturuwehegqeq410029:hover {
        -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=80)";
        filter: alpha(opacity=80);
        -moz-opacity: 0.80;
        -khtml-opacity: 0.80;
        opacity: 0.80;
    }

    .bggjgjjgjywrturuwehegqeq410028 {
        display: block;
        float: left;
        margin-right: 10px;
        text-indent: -99999px;
        width: 32px;
        height: 32px;
        background: url(${pct}static/images/overlay-image.png);
    }

    .bggjgjjgjywrturuwehegqeq410029 {
        display: block;
        float: left;
        text-indent: -99999px;
        width: 32px;
        height: 32px;
        background: url(${pct}static/images/overlay-link.png);
    }

    #sdgagdgd10012 {
        float: left;
        width: 200px;
    }

    #sdgagdgd10013 {
        float: right;
        width: 400px;
    }

    #sdgagdgd10014 {
        padding: 25px 0;
    }

    #sdgagdgd10015 a, #sdgagdgd10016 a {
        display: block;
        float: left;
        height: 30px;
        width: 30px;
        margin-right: 5px;
        background: url(${pct}static/images/bx-arrows.png) no-repeat
    }

    #sdgagdgd10016 a {
        background-position: -30px 0;
    }

    #sdgagdgd10015 a:hover {
        background-position: 0px -30px;
    }

    #sdgagdgd10016 a:hover {
        background-position: -30px;
    }

    #sdgagdgd10017 {
        position: relative;
        width: 660px;
        height: 350px;
    }

    .bggjgjjgjywrturuwehegqeq410030 {
        position: relative
    }

    .bggjgjjgjywrturuwehegqeq410030 img {
        position: absolute;
        top: 0px;
        left: 0px;
        z-index: 6;
    }

    .bggjgjjgjywrturuwehegqeq410030 a.bggjgjjgjywrturuwehegqeq410031 {
        position: absolute;
        top: 0px;
        left: 0px;
        width: 100%;
        height: 100%;
        border: 0;
        padding: 0;
        margin: 0;
        z-index: 6;
        display: none;
    }

    .bggjgjjgjywrturuwehegqeq410032 {
        display: block;
        position: absolute;
        z-index: 5;
        height: 100%;
    }

    .bggjgjjgjywrturuwehegqeq410033 {
        display: block;
        position: absolute;
        z-index: 5;
    }

    .bggjgjjgjywrturuwehegqeq410034 {
        position: absolute;
        left: 0px;
        bottom: 0px;
        background: #000;
        color: #fff;
        opacity: 0.8;
        width: 100%;
        z-index: 8;
    }

    .bggjgjjgjywrturuwehegqeq410034 p {
        padding: 5px;
        margin: 0;
    }

    .bggjgjjgjywrturuwehegqeq410034 a {
        display: inline !important;
    }

    .bggjgjjgjywrturuwehegqeq410035 {
        display: none;
    }

    .bggjgjjgjywrturuwehegqeq410036 a {
        position: absolute;
        top: 45%;
        z-index: 9;
        cursor: pointer;
    }

    .bggjgjjgjywrturuwehegqeq410037 {
        left: 0px
    }

    .bggjgjjgjywrturuwehegqeq410038 {
        right: 0px
    }

    .bggjgjjgjywrturuwehegqeq410039 a {
        position: relative;
        z-index: 9;
        cursor: pointer;
    }

    .bggjgjjgjywrturuwehegqeq410039 a.bggjgjjgjywrturuwehegqeq410040 {
        font-weight: bold
    }

    .bggjgjjgjywrturuwehegqeq410036 a {
        display: block;
        width: 20px;
        height: 40px;
        background: url(${pct}/static/images/slider-arrows.png) no-repeat;
        text-indent: -9999px;
        border: 0;
        -webkit-transition: hover 0.2s ease-in-out;
        -moz-transition: hover 0.2s ease-in-out;
        -o-transition: hover 0.2s ease-in-out;
        -ms-transition: hover 0.2s ease-in-out;
        transition: hover 0.2s ease-in-out;
    }

    .bggjgjjgjywrturuwehegqeq410036 a:hover {
        background: url(${pct}static/images/slider-arrows-hover.png) no-repeat;
    }

    a.bggjgjjgjywrturuwehegqeq410038 {
        background-position: -20px 0 !important;
        right: -20px;
    }

    a.bggjgjjgjywrturuwehegqeq410037 {
        left: -20px
    }

    #sdgagdgd10018 {
    }

    .post-entry {
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 1px solid #EEE;
    }

    .bggjgjjgjywrturuwehegqeq410041 {
        margin-bottom: 20px;
    }

    .bggjgjjgjywrturuwehegqeq410042 {
        float: left;
        height: 150px;
        width: 150px;
    }

    .bggjgjjgjywrturuwehegqeq410043 {
        float: right;
        width: 480px;
    }

    #sdgagdgd10018 ul, ol {
        margin-left: 50px;
        margin-bottom: 10px;
    }

    .bggjgjjgjywrturuwehegqeq410044, .bggjgjjgjywrturuwehegqeq410045 {
        background: #F9F9F9;
        font-size: 11px;
        color: #999;
        padding: 5px;
        margin: 8px 0px;
        text-shadow: 1px 1px 1px #FFF;
        letter-spacing: 1px;
    }

    .bggjgjjgjywrturuwehegqeq410044 a, .bggjgjjgjywrturuwehegqeq410045 a, .bggjgjjgjywrturuwehegqeq410044 span, .bggjgjjgjywrturuwehegqeq410045 span {
        color: #000;
    }

    .bggjgjjgjywrturuwehegqeq410045 {
        margin-bottom: 20px !important;
    }

    .bggjgjjgjywrturuwehegqeq410046 {
        margin-right: 10px;
        margin-top: 30px;
        font-size: 12px;
    }

    .bggjgjjgjywrturuwehegqeq410046 a {
        margin-left: 5px;
    }

    #sdgagdgd10018 h1 {
        margin-bottom: 0px
    }

    .bggjgjjgjywrturuwehegqeq410047 h2 {
        line-height: 1.2em;
        margin: 0 !important;
        font-size: 21px;
    }

    .bggjgjjgjywrturuwehegqeq410047 h2 a {
        text-decoration: none;
    }

    .bggjgjjgjywrturuwehegqeq410048 {
        margin-bottom: 20px !important;
    }

    #sdgagdgd10019 {
        font-size: 14px;
        padding: 20px 0px;
        margin-bottom: 40px;
        border-bottom: 1px dotted #CCC;
    }

    #sdgagdgd10019 p {
        margin: 0;
        padding: 0;
    }

    #sdgagdgd10020 {
        margin-bottom: 20px;
    }

    #sdgagdgd10021 {
        float: left;
        width: 50%;
    }

    #sdgagdgd10022 {
        float: right;
        width: 50%;
        text-align: right;
    }

    #sdgagdgd10021 a {
        float: left;
    }

    #sdgagdgd10022 a {
        float: right !important;
    }

    #sdgagdgd10023 {
        background: #F9F9F9;
        margin: 30px 0px;
        padding: 20px;
        border-top: 1px solid #EEE;
        border-bottom: 1px solid #EEE;
    }

    #sdgagdgd10024 {
        float: left;
        width: 70px;
    }

    #sdgagdgd10024 img {
        padding: 3px;
        border: 1px solid #CCC;
    }

    #sdgagdgd10025 {
        float: right;
        width: 540px;
    }

    #sdgagdgd10023 h4 {
        margin-top: 0px;
        margin-bottom: 5px;
    }

    #sdgagdgd10026 {
        margin: 20px 0;
        padding-bottom: 20px;
        border-bottom: 1px solid #EEE;
        color: #999;
    }

    .bggjgjjgjywrturuwehegqeq410049 {
        margin-bottom: 20px
    }

    .bggjgjjgjywrturuwehegqeq410050 {
        float: left;
        width: 60px;
        margin-right: 20px;
    }

    .bggjgjjgjywrturuwehegqeq410050 img {
        padding: 3px;
        border: 1px solid #EEE;
    }

    .bggjgjjgjywrturuwehegqeq410051 {
        float: right;
        width: 580px;
    }

    #sdgagdgd10026 h3 {
        margin: 0 0 20px
    }

    #sdgagdgd10026 h4 {
        font-size: 12px;
        font-style: normal;
        margin-top: 0px;
        margin-bottom: 5px;
    }

    #sdgagdgd10026 h4 a:hover {
        text-decoration: none;
    }

    #sdgagdgd10027 {
    }

    #commentsbox {
        margin-top: 30px
    }

    #sdgagdgd10028 ol, #sdgagdgd10028 ul {
        list-style: none;
        margin-left: 0 !important;
    }

    #sdgagdgd10028 li {
        margin-bottom: 30px
    }

    .bggjgjjgjywrturuwehegqeq410052 {
        list-style: none;
        margin: 30px 0 0;
        text-indent: 0;
    }

    .bggjgjjgjywrturuwehegqeq410052 li.bggjgjjgjywrturuwehegqeq410053 {
        margin: 0 0 0px 50px
    }

    .bggjgjjgjywrturuwehegqeq410052 li.bggjgjjgjywrturuwehegqeq410054 {
        margin: 0 0 0px 50px
    }

    .bggjgjjgjywrturuwehegqeq410052 li.bggjgjjgjywrturuwehegqeq410055 {
        margin: 0 0 0px 50px
    }

    .bggjgjjgjywrturuwehegqeq410052 li.bggjgjjgjywrturuwehegqeq410056 {
        margin: 0 0 0px 50px
    }

    .bggjgjjgjywrturuwehegqeq410057 {
        background: #FFF;
        position: relative;
        padding: 20px;
        border-bottom: 1px dashed #E3E3E3;
    }

    #sdgagdgd10028 .bggjgjjgjywrturuwehegqeq410058 {
        float: left;
        margin-right: 30px;
    }

    .bggjgjjgjywrturuwehegqeq410059 {
        font-size: 12px;
        color: #000;
        line-height: 1em;
        margin-bottom: 5px;
    }

    .bggjgjjgjywrturuwehegqeq410060 {
        display: none
    }

    .bggjgjjgjywrturuwehegqeq410061 a {
        margin-bottom: 10px;
        font-size: 10px;
        font-style: italic;
        color: #666;
    }

    .bggjgjjgjywrturuwehegqeq410062 {
        font-size: 10px;
        position: absolute;
        bottom: -10px;
        right: 0;
        border: 1px solid #E3E3E3;
        padding: 0 8px;
        background: #EEE;
        color: #666;
        -webkit-border-radius: 50px;
        -moz-border-radius: 50px;
        border-radius: 50px;
    }

    .bggjgjjgjywrturuwehegqeq410063 a {
        color: #F00;
        line-height: 20px;
        height: 20px;
    }

    .bggjgjjgjywrturuwehegqeq410063 a:hover {
        text-decoration: underline;
    }

    #sdgagdgd10029 {
        margin: 40px 0 15px
    }

    #sdgagdgd10030 {
        margin: 0 0 10px;
        padding: 0;
        clear: both;
    }

    #sdgagdgd10031 label {
        display: block;
        font-size: 11px;
    }

    #sdgagdgd10031 input {
        margin-bottom: 10px;
        width: 40%;
    }

    #sdgagdgd10031 textarea {
        margin-top: 10px;
        display: block;
        width: 70%;
    }

    #sdgagdgd10031 input#sdgagdgd10032, #sdgagdgd10031 input#sdgagdgd10033, #sdgagdgd10031 input#sdgagdgd10034, #sdgagdgd10031 textarea {
        background: #FFF;
        position: relative;
        padding: 5px;
        border: 1px solid #E3E3E3;
        -webkit-border-radius: 5px;
        -moz-border-radius: 5px;
        border-radius: 5px;
        -webkit-border-radius: 5px;
        -moz-border-radius: 5px;
        border-radius: 5px;
        -webkit-transition: all 0.2s ease-in-out;
        -moz-transition: all 0.2s ease-in-out;
        -o-transition: all 0.2s ease-in-out;
        -ms-transition: all 0.2s ease-in-out;
        transition: all 0.2s ease-in-out;
    }

    #sdgagdgd10031 input#sdgagdgd10032:focus, #sdgagdgd10031 input#sdgagdgd10033:focus, #sdgagdgd10031 input#sdgagdgd10034:focus, #sdgagdgd10031 textarea:focus {
        -moz-box-shadow: 3px 3px 0px #EEE;
        -webkit-box-shadow: 3px 3px 0px #EEE;
        box-shadow: 3px 3px 0px #EEE;
    }

    #sdgagdgd10035 {
        cursor: pointer;
        font-size: 12px;
        color: #969696;
        padding: 5px 0px;
        width: 100px !important;
        background: -moz-linear-gradient(top, #f2f2f2 0%, #dbdbdb);
        background: -webkit-gradient(linear, left top, left bottom, from(#f2f2f2), to(#dbdbdb));
        border-radius: 5px;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        border: 1px solid #CCC;
    }

    #sdgagdgd10035:hover {
        background: #EEE !important
    }

    .bggjgjjgjywrturuwehegqeq410064 {
        position: absolute;
        left: 0;
        bottom: 0;
        color: #EEE;
    }

    body {
        margin: 0;
        padding: 0;
        background: #dedede url(${pct}/statuc/img/back.png) repeat;
    }

    .content {
        margin: 30px 50px 0 50px;
    }

    .panel {
        position: relative;
        top: 0;
        width: auto;
        margin: 40px 0;
    }

    .panel a {
        display: inline-block;
        width: 20px;
        margin: 0;
        height: 20px;
        outline: none;
        border-radius: 2px;
    }

    .panel a:nth-child(1) {
        background: #95a5a6;
    }

    .panel a:nth-child(2) {
        background: #3498db;
    }

    .panel a:nth-child(3) {
        background: #075395;
    }

    .panel a:nth-child(4) {
        background: #2ecc71;
    }

    .panel a:nth-child(5) {
        background: #299a0b;
    }

    .panel a:nth-child(6) {
        background: #e74c3c;
    }

    .panel a:nth-child(7) {
        background: #a90329;
    }

    .panel a:nth-child(8) {
        background: #9b59b6;
    }

    .panel a:nth-child(9) {
        background: #ff5db1;
    }

    .panel a:nth-child(10) {
        background: #f39c12;
    }

    .panel a:nth-child(11) {
        background: #ca4a00;
    }

    .panel a:nth-child(12) {
        background: #ffcf41;
    }

    .vertical-nav {
        margin: 20px 0 0 0;
    }

    body {
        text-align: center;
        background: #F7FAFC;
        overflow: hidden;
        background: #fff;
    }
</style>

<%--背景--%>
<canvas id="Mycanvas" style="position: absolute; top: 0; left:0; z-index: -1;"></canvas>