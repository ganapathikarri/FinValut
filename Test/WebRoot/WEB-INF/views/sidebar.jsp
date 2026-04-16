<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-icon">💰</div>
        <span class="logo-text">FinVault</span>
    </div>

    <span class="nav-label">Main</span>
    <a href="${pageContext.request.contextPath}/dashboard"     class="nav-item ${currentPage == 'dashboard'    ? 'active' : ''}"><span class="nav-icon">📊</span> Dashboard</a>
    <a href="${pageContext.request.contextPath}/transactions"  class="nav-item ${currentPage == 'transactions' ? 'active' : ''}"><span class="nav-icon">↔</span> Transactions</a>
    <a href="${pageContext.request.contextPath}/income"        class="nav-item ${currentPage == 'income'       ? 'active' : ''}"><span class="nav-icon">📥</span> Income</a>
    <a href="${pageContext.request.contextPath}/expenses"      class="nav-item ${currentPage == 'expenses'     ? 'active' : ''}"><span class="nav-icon">📤</span> Expenses</a>

    <span class="nav-label">Planning</span>
    <a href="${pageContext.request.contextPath}/budget"        class="nav-item ${currentPage == 'budget'       ? 'active' : ''}"><span class="nav-icon">🎯</span> Budget</a>
    <a href="${pageContext.request.contextPath}/goals"         class="nav-item ${currentPage == 'goals'        ? 'active' : ''}"><span class="nav-icon">🏆</span> Goals</a>
    <a href="${pageContext.request.contextPath}/reports"       class="nav-item ${currentPage == 'reports'      ? 'active' : ''}"><span class="nav-icon">📈</span> Reports</a>

    <span class="nav-label">Account</span>
    <a href="${pageContext.request.contextPath}/profile"       class="nav-item ${currentPage == 'profile'      ? 'active' : ''}"><span class="nav-icon">👤</span> Profile</a>
    <a href="${pageContext.request.contextPath}/settings"      class="nav-item ${currentPage == 'settings'     ? 'active' : ''}"><span class="nav-icon">⚙</span> Settings</a>

    <div class="sidebar-footer">
        <div class="user-chip">
            <div class="avatar">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">${fn:substring(sessionScope.user.firstName,0,1)}</c:when>
                    <c:otherwise>U</c:otherwise>
                </c:choose>
            </div>
            <div class="user-info">
                <div class="name"><c:out value="${not empty sessionScope.user ? sessionScope.user.firstName : 'User'}"/></div>
                <div class="role">Personal Plan</div>
            </div>
        </div>
        <form action="${pageContext.request.contextPath}/logout" method="POST" style="margin-top:0.8rem;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <button class="nav-item" style="color:#e05252;padding:0.5rem 0;font-size:0.85rem;">
                <span class="nav-icon">🚪</span> Sign Out
            </button>
        </form>
    </div>
</aside>