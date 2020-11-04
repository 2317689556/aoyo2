<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div style="float: left; margin: 0 0 0 100px; opacity: 0.8;">
    <div class="content">
        <ul class="vertical-nav dark red" style="text-align: center;">
            <li class="active"><a href="/jsps/index.jsp"><i class="icon-home"></i>首页
                <span class="submenu-icon"></span></a>
            </li>
            <li><a href="#"><i class="icon-cogs"></i>空
                <span class="submenu-icon"></span></a>
                <c:if test="${USER.gradeId==1||USER.gradeId==2}">
                    <ul>
                        <li><a href="/jsps/inventory.jsp">空</a>
                        </li>
                        <li><a href="/jsps/purchaseRequest.jsp">空</a>
                        </li>
                        <li><a href="/jsps/stockOut.jsp">空</a>
                        </li>
                        <li><a href="/jsps/surgicalDrape.jsp">空</a>
                        </li>
                        <li><a href="/jsps/PickingList.jsp">空</a>
                        </li>
                        <li><a href="/jsps/abnormal.jsp">空</a>
                        </li>
                    </ul>
                </c:if>
            </li>
                <li><a href="#"><i class="icon-briefcase"></i>空
                    <span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/libraryOut.jsp">空</a></li>
                        <li><a href="/jsps/PickingListAdd.jsp">空</a></li>
                        <li><a href="/jsps/SurgicalOrder.jsp">空</a></li>
                        <li><a href="/jsps/ManufacturingConsignment.jsp">空</a></li>
                    </ul>
                </li>
                <li><a href="#"><i class="icon-user" style="padding-left: 18px;width: 20px;padding-right: 37px;"></i>空<span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/PurchasingRequisition.jsp">空</a></li>
                        <li><a href="/jsps/ReportedLoss.jsp">空</a></li>
                    </ul>
                </li>
                <li style="text-align: center"><a href="#"><i class="icon-comments-alt"></i>空<span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/CommissionedProcessing.jsp">空</a></li>
                        <li><a href="/jsps/CommissionedProcessing.jsp">空</a></li>
                    </ul>
                </li>
                <li><a href="#"><i class="icon-picture"></i>空<span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/CommodityInformation.jsp">空</a></li>
                        <li><a href="/jsps/CommodityInformationAdd.jsp">空</a></li>
                    </ul>
                </li>
                <li style="text-align: center"><a href="/jsps/finishedProduct.jsp" style="text-align: center"><i class="icon-info" style="padding-left: 25px;width: 20px;padding-right: 30px;"></i>空<span class="submenu-icon"></span></a>
                    <ul>
                        <li><a href="/jsps/TableContents.jsp">空</a></li>
                        <li><a href="/jsps/NewTable.jsp">空</a></li>
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
            <li><a href="/jsps/venderList.jsp"><i class="icon-question" style="padding-left: 20px;width: 20px;padding-right: 35px;"></i>空</a>
            </li>
            <%--权限1，2可查看--%>
            <c:if test="${USER.gradeId==2||USER.gradeId==1}">
                <li><a href="/jsps/log.jsp"><i class="icon-bar-chart"></i>统计</a></li>
            </c:if>
        </ul>
    </div>
</div>