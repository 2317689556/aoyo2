<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div style="float: left; margin: 0 0 0 100px; opacity: 0.8;">
    <div class="content">
        <ul class="vertical-nav dark red" style="text-align: center;">
            <li class="active"><a href="/jsps/index.jsp"><i class="icon-home"></i>首页
                <span class="submenu-icon"></span></a>
            </li>
            <li><a href="#"><i class="icon-cogs"></i>查询
                <span class="submenu-icon"></span></a>
                <c:if test="${USER.gradeId==1||USER.gradeId==2}">
                    <ul>
                        <li><a href="/jsps/inventory.jsp">库存</a>
                        </li>
                        <li><a href="/jsps/purchaseRequest.jsp">出库单</a>
                        </li>
                        <li><a href="/jsps/stockOut.jsp">采购申请/入库单查询</a>
                        </li>
                        <li><a href="/jsps/surgicalDrape.jsp">手术单</a>
                        </li>
                        <li><a href="/jsps/PickingList.jsp">备货单</a>
                        </li>
                        <li><a href="/jsps/abnormal.jsp">异常查询</a>
                        </li>
                    </ul>
                </c:if>
            </li>
                <li><a href="#"><i class="icon-briefcase"></i>填单
                    <span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/libraryOut.jsp">货随发票出库单</a></li>
                        <li><a href="/jsps/PickingListAdd.jsp">备货单</a></li>
                        <li><a href="/jsps/SurgicalOrder.jsp">手术单</a></li>
                        <li><a href="/jsps/ManufacturingConsignment.jsp">委托加工单</a></li>
                    </ul>
                </li>
                <li><a href="#"><i class="icon-user" style="padding-left: 18px;width: 20px;padding-right: 37px;"></i>库管<span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/PurchasingRequisition.jsp">采购申请</a></li>
                        <li><a href="/jsps/ReportedLoss.jsp">退货\报损申请</a></li>
                    </ul>
                </li>
                <li style="text-align: center"><a href="#"><i class="icon-comments-alt"></i>供养设备库<span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/CommissionedProcessing.jsp">零件库</a></li>
                        <li><a href="/jsps/CommissionedProcessing.jsp">委托加工成品库</a></li>
                    </ul>
                </li>
                <li><a href="#"><i class="icon-picture"></i>商品录入信息<span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/CommodityInformation.jsp">商品信息</a></li>
                        <li><a href="/jsps/CommodityInformationAdd.jsp">新增商品录入信息</a></li>
                    </ul>
                </li>
                <li style="text-align: center"><a href="/jsps/finishedProduct.jsp" style="text-align: center"><i class="icon-info" style="padding-left: 25px;width: 20px;padding-right: 30px;"></i>委托加工成品表<span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/TableContents.jsp">内容表</a></li>
                        <li><a href="/jsps/NewTable.jsp">新建表</a></li>
                    </ul>
                </li>
            <li><a href="#"><i class="icon-group"></i>账号管理<span class="submenu-icon"></span></a>
                <ul>
                    <%--权限--%>
                    <c:if test="${USER.gradeId==1}">
                        <li><a href="/jsps/user.jsp">用户管理</a></li>
                    </c:if>
                </ul>
            </li>
            <li><a href="/jsps/venderList.jsp"><i class="icon-question" style="padding-left: 20px;width: 20px;padding-right: 35px;"></i>厂家、代理管理</a>
            </li>
            <%--权限1，2可查看--%>
            <c:if test="${USER.gradeId==2||USER.gradeId==1}">
                <li><a href="/jsps/log.jsp"><i class="icon-bar-chart"></i>统计</a></li>
            </c:if>
        </ul>
    </div>
</div>