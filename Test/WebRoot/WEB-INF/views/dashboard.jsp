<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FinVault — Dashboard</title>
<link
	href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:wght@300;400;500;600&display=swap"
	rel="stylesheet">
<style>
*, *::before, *::after {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

:root {
	--ink: #0d1117;
	--slate: #1c2333;
	--card: #1e2a3a;
	--gold: #c9a84c;
	--gold-light: #e8c96a;
	--cream: #f5f0e8;
	--muted: #6b7280;
	--income: #3cb97c;
	--expense: #e05252;
	--saving: #5b8dee;
	--border: rgba(255, 255, 255, 0.07);
}

body {
	font-family: 'DM Sans', sans-serif;
	background: var(--ink);
	color: var(--cream);
	min-height: 100vh;
	display: flex;
}

/* ========= SIDEBAR ========= */
.sidebar {
	width: 240px;
	background: var(--slate);
	border-right: 1px solid var(--border);
	display: flex;
	flex-direction: column;
	padding: 1.5rem 0;
	position: fixed;
	top: 0;
	left: 0;
	height: 100vh;
	z-index: 100;
	overflow-y: auto;
}

.sidebar-logo {
	display: flex;
	align-items: center;
	gap: 0.7rem;
	padding: 0 1.4rem 1.8rem;
	border-bottom: 1px solid var(--border);
	margin-bottom: 1.5rem;
}

.logo-icon {
	width: 36px;
	height: 36px;
	background: linear-gradient(135deg, var(--gold), var(--gold-light));
	border-radius: 9px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1rem;
}

.logo-text {
	font-family: 'DM Serif Display', serif;
	font-size: 1.3rem;
}

.nav-label {
	font-size: 0.68rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.1em;
	color: var(--muted);
	padding: 0 1.4rem;
	margin-bottom: 0.4rem;
	margin-top: 1.2rem;
}

.nav-item {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	padding: 0.7rem 1.4rem;
	text-decoration: none;
	color: var(--muted);
	font-size: 0.9rem;
	font-weight: 500;
	border-radius: 0;
	transition: color 0.2s, background 0.2s;
	cursor: pointer;
	border: none;
	background: none;
	width: 100%;
	text-align: left;
}

.nav-item:hover {
	color: var(--cream);
	background: rgba(255, 255, 255, 0.04);
}

.nav-item.active {
	color: var(--gold);
	background: rgba(201, 168, 76, 0.1);
	border-right: 2px solid var(--gold);
}

.nav-icon {
	font-size: 1.05rem;
	width: 22px;
	text-align: center;
}

.sidebar-footer {
	margin-top: auto;
	padding: 1.2rem 1.4rem;
	border-top: 1px solid var(--border);
}

.user-chip {
	display: flex;
	align-items: center;
	gap: 0.7rem;
}

.avatar {
	width: 34px;
	height: 34px;
	background: linear-gradient(135deg, var(--gold), var(--gold-light));
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
	font-size: 0.85rem;
	color: var(--ink);
	flex-shrink: 0;
}

.user-info .name {
	font-size: 0.88rem;
	font-weight: 600;
}

.user-info .role {
	font-size: 0.75rem;
	color: var(--muted);
}

/* ========= MAIN CONTENT ========= */
.main {
	margin-left: 240px;
	flex: 1;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

/* Top bar */
.topbar {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 1.2rem 2rem;
	border-bottom: 1px solid var(--border);
	background: var(--ink);
	position: sticky;
	top: 0;
	z-index: 50;
}

.topbar h1 {
	font-family: 'DM Serif Display', serif;
	font-size: 1.55rem;
}

.topbar-actions {
	display: flex;
	align-items: center;
	gap: 1rem;
}

.btn-add {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	padding: 0.6rem 1.2rem;
	background: linear-gradient(135deg, var(--gold), var(--gold-light));
	color: var(--ink);
	border: none;
	border-radius: 8px;
	font-family: 'DM Sans', sans-serif;
	font-size: 0.88rem;
	font-weight: 600;
	cursor: pointer;
	text-decoration: none;
	transition: opacity 0.2s;
}

.btn-add:hover {
	opacity: 0.88;
}

.date-badge {
	font-size: 0.82rem;
	color: var(--muted);
	padding: 0.5rem 0.9rem;
	background: var(--slate);
	border-radius: 8px;
}

/* Content area */
.content {
	padding: 2rem;
	flex: 1;
}

/* ---- SUMMARY CARDS ---- */
.summary-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 1.2rem;
	margin-bottom: 2rem;
}

.summary-card {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 14px;
	padding: 1.4rem;
	position: relative;
	overflow: hidden;
	animation: fadeUp 0.4s ease both;
}

.summary-card:nth-child(1) {
	animation-delay: 0.05s;
}

.summary-card:nth-child(2) {
	animation-delay: 0.10s;
}

.summary-card:nth-child(3) {
	animation-delay: 0.15s;
}

.summary-card:nth-child(4) {
	animation-delay: 0.20s;
}

@keyframes fadeUp {from { opacity:0;
	transform: translateY(16px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.summary-card::after {
	content: '';
	position: absolute;
	top: 0;
	right: 0;
	width: 80px;
	height: 80px;
	background: radial-gradient(circle, var(--accent, rgba(201, 168, 76, 0.12))
		0%, transparent 70%);
}

.summary-card.income {
	--accent: rgba(60, 185, 124, 0.14);
}

.summary-card.expense {
	--accent: rgba(224, 82, 82, 0.14);
}

.summary-card.saving {
	--accent: rgba(91, 141, 238, 0.14);
}

.summary-card.balance {
	--accent: rgba(201, 168, 76, 0.14);
}

.card-label {
	font-size: 0.75rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.08em;
	color: var(--muted);
	margin-bottom: 0.6rem;
}

.card-amount {
	font-family: 'DM Serif Display', serif;
	font-size: 1.9rem;
	line-height: 1;
	margin-bottom: 0.5rem;
}

.income  .card-amount {
	color: var(--income);
}

.expense .card-amount {
	color: var(--expense);
}

.saving  .card-amount {
	color: var(--saving);
}

.balance .card-amount {
	color: var(--gold);
}

.card-delta {
	font-size: 0.8rem;
	color: var(--muted);
}

.card-delta .up {
	color: var(--income);
}

.card-delta .down {
	color: var(--expense);
}

.card-icon {
	font-size: 1.6rem;
	margin-bottom: 0.8rem;
}

/* ---- TWO COLUMN SECTION ---- */
.two-col {
	display: grid;
	grid-template-columns: 1.6fr 1fr;
	gap: 1.5rem;
	margin-bottom: 2rem;
}

.panel {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 14px;
	padding: 1.5rem;
	animation: fadeUp 0.4s ease 0.25s both;
}

.panel-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 1.2rem;
}

.panel-title {
	font-family: 'DM Serif Display', serif;
	font-size: 1.1rem;
}

.panel-link {
	font-size: 0.82rem;
	color: var(--gold);
	text-decoration: none;
	font-weight: 500;
}

/* Chart placeholder — replace with Chart.js canvas */
.chart-area {
	height: 180px;
	background: linear-gradient(180deg, rgba(201, 168, 76, 0.05) 0%,
		transparent 100%);
	border-radius: 10px;
	display: flex;
	flex-direction: column;
	justify-content: flex-end;
	padding: 0.5rem;
	gap: 0.4rem;
}

.bar-row {
	display: flex;
	align-items: flex-end;
	gap: 0.5rem;
	height: 100%;
}

.bar-group {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 0.3rem;
	flex: 1;
}

.bars {
	display: flex;
	gap: 3px;
	align-items: flex-end;
	height: 130px;
	width: 100%;
	justify-content: center;
}

.bar {
	border-radius: 4px 4px 0 0;
	width: 10px;
	transition: height 0.6s ease;
}

.bar.income {
	background: var(--income);
}

.bar.expense {
	background: var(--expense);
}

.bar-month {
	font-size: 0.68rem;
	color: var(--muted);
}

.chart-legend {
	display: flex;
	gap: 1.2rem;
	margin-top: 0.8rem;
}

.legend-item {
	display: flex;
	align-items: center;
	gap: 0.4rem;
	font-size: 0.78rem;
	color: var(--muted);
}

.legend-dot {
	width: 8px;
	height: 8px;
	border-radius: 50%;
}

/* Categories */
.category-list {
	display: flex;
	flex-direction: column;
	gap: 0.9rem;
}

.cat-item {
	display: flex;
	align-items: center;
	gap: 0.8rem;
}

.cat-emoji {
	width: 34px;
	height: 34px;
	background: rgba(255, 255, 255, 0.05);
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1rem;
	flex-shrink: 0;
}

.cat-info {
	flex: 1;
}

.cat-name {
	font-size: 0.88rem;
	font-weight: 500;
	margin-bottom: 0.25rem;
	display: flex;
	justify-content: space-between;
}

.cat-name span {
	color: var(--muted);
	font-size: 0.82rem;
	font-weight: 400;
}

.progress-bar {
	height: 5px;
	background: rgba(255, 255, 255, 0.07);
	border-radius: 4px;
	overflow: hidden;
}

.progress-fill {
	height: 100%;
	border-radius: 4px;
	transition: width 0.8s ease;
}

/* ---- TRANSACTIONS TABLE ---- */
.transactions-panel {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 14px;
	overflow: hidden;
	animation: fadeUp 0.4s ease 0.3s both;
}

.transactions-panel .panel-header {
	padding: 1.4rem 1.6rem 0;
}

table {
	width: 100%;
	border-collapse: collapse;
}

thead th {
	font-size: 0.72rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.07em;
	color: var(--muted);
	padding: 0.8rem 1.6rem;
	text-align: left;
	border-bottom: 1px solid var(--border);
}

tbody tr {
	border-bottom: 1px solid var(--border);
	transition: background 0.15s;
}

tbody tr:last-child {
	border-bottom: none;
}

tbody tr:hover {
	background: rgba(255, 255, 255, 0.02);
}

tbody td {
	padding: 0.9rem 1.6rem;
	font-size: 0.88rem;
}

.tx-name {
	font-weight: 500;
}

.tx-category {
	display: inline-block;
	padding: 0.2rem 0.55rem;
	border-radius: 5px;
	font-size: 0.75rem;
	font-weight: 500;
}

.tx-amount {
	font-weight: 600;
	font-family: 'DM Serif Display', serif;
	font-size: 1rem;
}

.tx-amount.credit {
	color: var(--income);
}

.tx-amount.debit {
	color: var(--expense);
}

.tx-date {
	color: var(--muted);
	font-size: 0.82rem;
}

.badge-food {
	background: rgba(224, 165, 82, 0.15);
	color: #e0a552;
}

.badge-shopping {
	background: rgba(91, 141, 238, 0.15);
	color: #7aa4f0;
}

.badge-income {
	background: rgba(60, 185, 124, 0.15);
	color: #3cb97c;
}

.badge-bills {
	background: rgba(224, 82, 82, 0.15);
	color: #e07070;
}

.badge-travel {
	background: rgba(160, 120, 220, 0.15);
	color: #b090e0;
}

.badge-health {
	background: rgba(60, 185, 124, 0.12);
	color: #5dbf90;
}

.cat-emoji {
	font-family: "Segoe UI Emoji", "Noto Color Emoji", sans-serif;
}
/* Responsive */
@media ( max-width : 1100px) {
	.summary-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.two-col {
		grid-template-columns: 1fr;
	}
}

@media ( max-width : 768px) {
	.sidebar {
		transform: translateX(-100%);
	}
	.main {
		margin-left: 0;
	}
	.content {
		padding: 1.2rem;
	}
	.summary-grid {
		grid-template-columns: 1fr 1fr;
	}
}
</style>
</head>
<body>

	<!-- ====== SIDEBAR ====== -->
	<aside class="sidebar">
		<div class="sidebar-logo">
			<div class="logo-icon">💰</div>
			<span class="logo-text">FinVault</span>
		</div>

		<span class="nav-label">Main</span> <a href="dashboard"
			class="nav-item active"> <span class="nav-icon">📊</span>
			Dashboard
		</a> <a href="transactions" class="nav-item"> <span class="nav-icon">↔</span>
			Transactions
		</a> <a href="income" class="nav-item"> <span class="nav-icon">📥</span>
			Income
		</a> <a href="expenses" class="nav-item"> <span class="nav-icon">📤</span>
			Expenses
		</a> <span class="nav-label">Planning</span> <a href="budget"
			class="nav-item"> <span class="nav-icon">🎯</span> Budget
		</a> <a href="goals" class="nav-item"> <span class="nav-icon">🏆</span>
			Goals
		</a> <a href="reports" class="nav-item"> <span class="nav-icon">📈</span>
			Reports
		</a> <span class="nav-label">Account</span> <a href="profile"
			class="nav-item"> <span class="nav-icon">👤</span> Profile
		</a> <a href="settings" class="nav-item"> <span class="nav-icon">⚙</span>
			Settings
		</a>

		<div class="sidebar-footer">
			<div class="user-chip">
				<div class="avatar">
					<!-- First letter of user name -->
					<c:choose>
						<c:when test="${not empty sessionScope.user}">
                            ${fn:substring(sessionScope.user.firstName, 0, 1)}
                        </c:when>
						<c:otherwise>U</c:otherwise>
					</c:choose>
				</div>
				<div class="user-info">
					<div class="name">
						<c:choose>
							<c:when test="${not empty sessionScope.user}">${sessionScope.user.firstName}</c:when>
							<c:otherwise>User</c:otherwise>
						</c:choose>
					</div>
					<div class="role">Personal Plan</div>
				</div>
			</div>
			<form action="${pageContext.request.contextPath}/logout"
				method="POST" style="margin-top:0.8rem;">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
				<button class="nav-item"
					style="color:#e05252; padding:0.5rem 0; font-size:0.85rem;">
					<span class="nav-icon">🚪</span> Sign Out
				</button>
			</form>
		</div>
	</aside>

	<!-- ====== MAIN ====== -->
	<div class="main">

		<!-- Topbar -->
		<div class="topbar">
			<h1>
				Good morning,
				<c:choose>
					<c:when test="${not empty sessionScope.user}">${sessionScope.user.firstName} 👋</c:when>
					<c:otherwise>there 👋</c:otherwise>
				</c:choose>
			</h1>
			<div class="topbar-actions">
				<div class="date-badge" id="todayDate"></div>
				<a href="transactions/add" class="btn-add">+ Add Transaction</a>
			</div>
		</div>

		<!-- Content -->
		<div class="content">

			<!-- ---- SUMMARY CARDS ---- -->
			<div class="summary-grid">

				<div class="summary-card balance">
					<div class="card-icon">💳</div>
					<div class="card-label">Net Balance</div>
					<div class="card-amount">
						₹
						<fmt:formatNumber value="${netBalance}" groupingUsed="true"
							maxFractionDigits="0" />
					</div>
					<div class="card-delta">Updated today</div>
				</div>

				<div class="summary-card income">
					<div class="card-icon">📥</div>
					<div class="card-label">This Month Income</div>
					<div class="card-amount">
						₹
						<fmt:formatNumber value="${monthlyIncome}" groupingUsed="true"
							maxFractionDigits="0" />
					</div>
					<div class="card-delta">
						<span class="up">↑ 8.2%</span> vs last month
					</div>
				</div>

				<div class="summary-card expense">
					<div class="card-icon">📤</div>
					<div class="card-label">This Month Expenses</div>
					<div class="card-amount">
						₹
						<fmt:formatNumber value="${monthlyExpense}" groupingUsed="true"
							maxFractionDigits="0" />
					</div>
					<div class="card-delta">
						<span class="down">↑ 3.1%</span> vs last month
					</div>
				</div>

				<div class="summary-card saving">
					<div class="card-icon">🏦</div>
					<div class="card-label">Savings This Month</div>
					<div class="card-amount">
						₹
						<fmt:formatNumber value="${monthlySaving}" groupingUsed="true"
							maxFractionDigits="0" />
					</div>
					<div class="card-delta">
						<span class="up">40.9%</span> savings rate
					</div>
				</div>

			</div>

			<!-- ---- CHART + CATEGORIES ---- -->
			<div class="two-col">

				<!-- Bar chart -->
				<div class="panel">
					<div class="panel-header">
						<span class="panel-title">Income vs Expenses</span> <a
							href="reports" class="panel-link">View full report →</a>
					</div>

					<div class="chart-area">
						<div class="bar-row" id="barChart">
							<!-- Bars generated by JS below -->
						</div>
					</div>

					<div class="chart-legend">
						<div class="legend-item">
							<div class="legend-dot" style="background:var(--income)"></div>
							Income
						</div>
						<div class="legend-item">
							<div class="legend-dot" style="background:var(--expense)"></div>
							Expenses
						</div>
					</div>
				</div>

				<!-- Category breakdown -->
				<div class="panel">
					<div class="panel-header">
						<span class="panel-title">Top Categories</span> <a href="expenses"
							class="panel-link">All →</a>
					</div>

					<div class="category-list">

						<c:set var="maxAmount" value="${topCategories[0][1]}" />

						<c:forEach var="cat" items="${topCategories}" varStatus="status">

							<div class="cat-item">

								<!-- Emoji -->
								<div class="cat-emoji">
									<c:choose>
										<c:when test="${fn:containsIgnoreCase(cat[0], 'food')}">🍔</c:when>
										<c:when test="${fn:containsIgnoreCase(cat[0], 'rent')}">🏠</c:when>
										<c:when test="${fn:containsIgnoreCase(cat[0], 'health')}">💊</c:when>
										<c:when test="${fn:containsIgnoreCase(cat[0], 'transport')}">🚌</c:when>
										<c:when test="${fn:containsIgnoreCase(cat[0], 'shop')}">🛒</c:when>
										<c:otherwise>💰</c:otherwise>
									</c:choose>
								</div>

								<div class="cat-info">

									<!-- Name + Amount -->
									<div class="cat-name">
										${cat[0]} <span> ₹<fmt:formatNumber value="${cat[1]}"
												groupingUsed="true" />
										</span>
									</div>

									<!-- Progress Bar -->
									<c:set var="percent" value="${(cat[1] * 100) / maxAmount}" />

									<div class="progress-bar">
										<div class="progress-fill"
											style="width:${percent}%; background:${status.index == 0 ? 'var(--gold)' :
                                                                  status.index == 1 ? 'var(--expense)' :
                                                                  status.index == 2 ? 'var(--saving)' :
                                                                  status.index == 3 ? '#a080d0' :
                                                                  'var(--income)'}">
										</div>
									</div>

								</div>
							</div>

						</c:forEach>

					</div>
				</div>

			</div>

			<!-- ---- RECENT TRANSACTIONS ---- -->
			<div class="transactions-panel">
				<div class="panel-header">
					<span class="panel-title">Recent Transactions</span> <a
						href="transactions" class="panel-link">View all →</a>
				</div>

				<table>
					<thead>
						<tr>
							<th>Description</th>
							<th>Category</th>
							<th>Date</th>
							<th>Amount</th>
						</tr>
					</thead>
					<tbody>
						<%-- Loop over model data if available --%>
						<c:choose>
							<c:when test="${not empty recentTransactions}">
								<c:forEach var="tx" items="${recentTransactions}">
									<tr>
										<td class="tx-name">${tx.description}</td>
										<td><span class="tx-category badge-${tx.categoryClass}">${tx.category}</span></td>
										<td class="tx-date"><fmt:formatDate value="${tx.date}"
												pattern="dd MMM yyyy" /></td>
										<td
											class="tx-amount ${tx.type == 'CREDIT' ? 'credit' : 'debit'}">
											${tx.type == 'CREDIT' ? '+' : '-'}₹<fmt:formatNumber
												value="${tx.amount}" groupingUsed="true"
												maxFractionDigits="0" />
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<%-- Static sample rows for design preview --%>
								<tr>
									<td class="tx-name">Salary - April</td>
									<td><span class="tx-category badge-income">Income</span></td>
									<td class="tx-date">01 Apr 2026</td>
									<td class="tx-amount credit">+₹65,000</td>
								</tr>
								<tr>
									<td class="tx-name">Monthly Rent</td>
									<td><span class="tx-category badge-bills">Bills</span></td>
									<td class="tx-date">01 Apr 2026</td>
									<td class="tx-amount debit">-₹14,000</td>
								</tr>
								<tr>
									<td class="tx-name">BigBasket Order</td>
									<td><span class="tx-category badge-shopping">Shopping</span></td>
									<td class="tx-date">02 Apr 2026</td>
									<td class="tx-amount debit">-₹3,240</td>
								</tr>
								<tr>
									<td class="tx-name">Swiggy Dinner</td>
									<td><span class="tx-category badge-food">Food</span></td>
									<td class="tx-date">03 Apr 2026</td>
									<td class="tx-amount debit">-₹680</td>
								</tr>
								<tr>
									<td class="tx-name">Bus Pass Recharge</td>
									<td><span class="tx-category badge-travel">Travel</span></td>
									<td class="tx-date">04 Apr 2026</td>
									<td class="tx-amount debit">-₹500</td>
								</tr>
								<tr>
									<td class="tx-name">Apollo Pharmacy</td>
									<td><span class="tx-category badge-health">Health</span></td>
									<td class="tx-date">05 Apr 2026</td>
									<td class="tx-amount debit">-₹420</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>

		</div>
		<!-- /content -->
	</div>
	<!-- /main -->

	<script>
        // Today's date in topbar
        const d = new Date();
        document.getElementById('todayDate').textContent =
            d.toLocaleDateString('en-IN', { weekday:'short', day:'numeric', month:'long', year:'numeric' });

        // Generate bar chart (sample data — replace with server data via JSTL/JSON)
        const months = ['Oct','Nov','Dec','Jan','Feb','Mar'];
        const incomeData  = [58000, 61000, 55000, 63000, 60000, 65000];
        const expenseData = [35000, 40000, 37000, 41000, 36000, 38400];

        const maxVal = Math.max(...incomeData, ...expenseData);
        const container = document.getElementById('barChart');

        months.forEach((m, i) => {
            const inH  = Math.round((incomeData[i]  / maxVal) * 120);
            const exH  = Math.round((expenseData[i] / maxVal) * 120);

            const group = document.createElement('div');
            group.className = 'bar-group';
            group.innerHTML = `
                <div class="bars">
                    <div class="bar income"  style="height:${inH}px"  title="Income ₹${incomeData[i].toLocaleString('en-IN')}"></div>
                    <div class="bar expense" style="height:${exH}px" title="Expense ₹${expenseData[i].toLocaleString('en-IN')}"></div>
                </div>
                <div class="bar-month">${m}</div>
            `;
            container.appendChild(group);
        });
    </script>

</body>
</html>