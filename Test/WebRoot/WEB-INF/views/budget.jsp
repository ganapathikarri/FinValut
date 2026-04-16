<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="currentPage" value="budget" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FinVault — Budget</title>
<%@ include file="base-styles.jsp"%>
<style>
.budget-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
	gap: 1.3rem;
	margin-bottom: 2rem;
}

.budget-card {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	padding: 1.4rem;
	transition: border-color .2s;
	animation: fadeUp .4s ease both;
}

.budget-card:hover {
	border-color: rgba(201, 168, 76, .3);
}

.bc-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 1rem;
}

.bc-left {
	display: flex;
	align-items: center;
	gap: .75rem;
}

.bc-emoji {
	width: 38px;
	height: 38px;
	background: rgba(255, 255, 255, .05);
	border-radius: 10px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 1.1rem;
}

.bc-name {
	font-weight: 600;
	font-size: .95rem;
}

.bc-period {
	font-size: .75rem;
	color: var(--muted);
}

.bc-actions {
	display: flex;
	gap: .3rem;
}

.bc-amounts {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	margin-bottom: .6rem;
}

.bc-spent {
	font-family: 'DM Serif Display', serif;
	font-size: 1.4rem;
}

.bc-limit {
	font-size: .82rem;
	color: var(--muted);
}

.budget-bar {
	height: 8px;
	background: rgba(255, 255, 255, .07);
	border-radius: 6px;
	overflow: hidden;
	margin-bottom: .7rem;
}

.budget-fill {
	height: 100%;
	border-radius: 6px;
	transition: width .8s ease;
}

.fill-ok {
	background: var(--income);
}

.fill-warn {
	background: var(--gold);
}

.fill-danger {
	background: var(--expense);
}

.bc-footer {
	display: flex;
	justify-content: space-between;
	font-size: .78rem;
	color: var(--muted);
}

.bc-remaining {
	
}

.bc-pct {
	font-weight: 600;
}

.pct-ok {
	color: var(--income);
}

.pct-warn {
	color: var(--gold);
}

.pct-danger {
	color: var(--expense);
}

/* Month selector */
.month-bar {
	display: flex;
	align-items: center;
	gap: 1rem;
	margin-bottom: 1.5rem;
}

.month-bar select {
	padding: .6rem 1rem;
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 9px;
	color: var(--cream);
	font-family: 'DM Sans', sans-serif;
	font-size: .88rem;
	outline: none;
}

.month-bar select:focus {
	border-color: var(--gold);
}

/* Overall progress panel */
.overview-panel {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	padding: 1.5rem;
	margin-bottom: 1.8rem;
	display: flex;
	gap: 2.5rem;
	align-items: center;
}

.ov-stat {
	text-align: center;
	flex: 1;
}

.ov-val {
	font-family: 'DM Serif Display', serif;
	font-size: 1.8rem;
	margin-bottom: .2rem;
}

.ov-lbl {
	font-size: .75rem;
	text-transform: uppercase;
	letter-spacing: .08em;
	color: var(--muted);
}

.ov-divider {
	width: 1px;
	background: var(--border);
	align-self: stretch;
}
</style>
</head>
<body>
	<%@ include file="sidebar.jsp"%>

	<div class="main">
		<div class="topbar">
			<h1>Budget Planner</h1>
			<div class="topbar-actions">
				<button class="btn-primary" onclick="openModal('addBudgetModal')">+
					New Budget</button>
			</div>
		</div>

		<div class="content">
			<c:if test="${not empty success}">
				<div class="alert alert-success">✓ ${success}</div>
			</c:if>

			<!-- Month picker -->
			<div class="month-bar fade-up">
				<form method="GET">
					<select name="month" onchange="this.form.submit()">
						<option value="4" ${param.month=='4' ?'selected':''}>April
							2026</option>
						<option value="3" ${param.month=='3' ?'selected':''}>March
							2026</option>
						<option value="2" ${param.month=='2' ?'selected':''}>February
							2026</option>
						<option value="1" ${param.month=='1' ?'selected':''}>January
							2026</option>
					</select>
				</form>
			</div>

			<!-- Overview panel -->
			<div class="overview-panel fade-up delay-1">
				<div class="ov-stat">
					<div class="ov-val" style="color:var(--gold)">₹65,000</div>
					<div class="ov-lbl">Total Budget</div>
				</div>
				<div class="ov-divider"></div>
				<div class="ov-stat">
					<div class="ov-val" style="color:var(--expense)">₹38,400</div>
					<div class="ov-lbl">Spent So Far</div>
				</div>
				<div class="ov-divider"></div>
				<div class="ov-stat">
					<div class="ov-val" style="color:var(--income)">₹26,600</div>
					<div class="ov-lbl">Remaining</div>
				</div>
				<div class="ov-divider"></div>
				<div class="ov-stat">
					<div class="ov-val" style="color:var(--saving)">59%</div>
					<div class="ov-lbl">Budget Used</div>
				</div>
			</div>

			<!-- Budget cards -->
			<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
			<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

			<div class="budget-grid">

				<c:choose>

					<c:when test="${not empty budgets}">
						<c:forEach var="b" items="${budgets}" varStatus="s">

							<%-- Safe percentage calculation --%>
							<c:set var="pct"
								value="${b.limit > 0 ? (b.spent * 100 / b.limit) : 0}" />

							<%-- Safe animation delay --%>
							<c:set var="delay" value="${s.index * 0.05}" />

							<div class="budget-card" style="animation-delay:${delay}s;">

								<!-- Header -->
								<div class="bc-header">
									<div class="bc-left">
										<div class="bc-emoji">${b.emoji}</div>
										<div>
											<div class="bc-name">${b.name}</div>
											<div class="bc-period">Monthly</div>
										</div>
									</div>

									<div class="bc-actions">
										<button class="icon-btn edit-btn" data-id="${b.id}">✏️</button>
										<button class="icon-btn delete-btn" data-id="${b.id}">🗑</button>
									</div>
								</div>

								<!-- Amounts -->
								<div class="bc-amounts">
									<div class="bc-spent">
										₹
										<fmt:formatNumber value="${b.spent}" groupingUsed="true"
											maxFractionDigits="0" />
									</div>
									<div class="bc-limit">
										of ₹
										<fmt:formatNumber value="${b.limit}" groupingUsed="true"
											maxFractionDigits="0" />
									</div>
								</div>

								<!-- Progress Bar -->
								<c:set var="pct"
									value="${b.limit > 0 ? (b.spent * 100 / b.limit) : 0}" />
								<c:set var="safePct" value="${pct > 100 ? 100 : pct}" />
								<c:set var="barClass"
									value="${pct >= 90 ? 'fill-danger' : pct >= 70 ? 'fill-warn' : 'fill-ok'}" />

								<div class="budget-bar">
									<div class="budget-fill ${barClass}" style="width:${safePct}%;">
									</div>
								</div>
								<!-- Footer -->
								<div class="bc-footer">
									<span class="bc-remaining"> ₹<fmt:formatNumber
											value="${b.limit - b.spent}" groupingUsed="true"
											maxFractionDigits="0" /> left
									</span> <span
										class="bc-pct 
                            ${pct >= 90 ? 'pct-danger' : pct >= 70 ? 'pct-warn' : 'pct-ok'}">
										<fmt:formatNumber value="${pct}" maxFractionDigits="0" />%
									</span>
								</div>

							</div>

						</c:forEach>
					</c:when>

					<c:otherwise>
						<!-- Clean fallback (no invalid JSTL array) -->
						<div id="sampleCards"></div>
					</c:otherwise>

				</c:choose>

			</div>

			<!-- ADD BUDGET MODAL -->
			<div class="modal-backdrop" id="addBudgetModal">
				<div class="modal">
					<div class="modal-header">
						<span class="modal-title">New Budget Category</span>
						<button class="modal-close" onclick="closeModal('addBudgetModal')">×</button>
					</div>
					<form action="${pageContext.request.contextPath}/budget/add"
						method="POST">
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" />
						<div class="form-row">
							<div class="form-group">
								<label>Category Name</label> <input type="text" name="name"
									placeholder="e.g. Groceries" required>
							</div>
							<div class="form-group">
								<label>Emoji Icon</label> <input type="text" name="emoji"
									placeholder="🛒" maxlength="4">
							</div>
						</div>
						<div class="form-row">
							<div class="form-group">
								<label>Monthly Limit (₹)</label> <input type="number"
									name="limit" placeholder="10000" min="1" required>
							</div>
							<div class="form-group">
								<label>Period</label> <select name="period">
									<option value="MONTHLY">Monthly</option>
									<option value="WEEKLY">Weekly</option>
									<option value="YEARLY">Yearly</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label>Alert at (% of limit)</label> <select name="alertPct">
								<option value="70">70%</option>
								<option value="80" selected>80%</option>
								<option value="90">90%</option>
								<option value="100">100% (over budget)</option>
							</select>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn-secondary"
								onclick="closeModal('addBudgetModal')">Cancel</button>
							<button type="submit" class="btn-primary">Create Budget</button>
						</div>
					</form>
				</div>
			</div>

			<script>
function openModal(id)  { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
function editBudget(id)   { window.location = '${pageContext.request.contextPath}/budget/edit/' + id; }
function deleteBudget(id) { if(confirm('Delete this budget?')) window.location = '${pageContext.request.contextPath}/budget/delete/' + id; }

// Render sample cards if no server data
const samples = [
    {emoji:'🏠',name:'Rent',         spent:14000,limit:14000},
    {emoji:'🛒',name:'Groceries',    spent:9200, limit:12000},
    {emoji:'🍔',name:'Food & Dining',spent:5600, limit:8000},
    {emoji:'🚌',name:'Transport',    spent:3200, limit:5000},
    {emoji:'💊',name:'Health',       spent:2400, limit:4000},
    {emoji:'📱',name:'Utilities',    spent:2000, limit:3000},
    {emoji:'🎮',name:'Entertainment',spent:1800, limit:3000},
    {emoji:'👗',name:'Clothing',     spent:200,  limit:2000},
];
const container = document.getElementById('sampleCards');
if (container) {
    samples.forEach((b, i) => {
        const pct = Math.round(b.spent / b.limit * 100);
        const cls = pct >= 90 ? 'fill-danger' : pct >= 70 ? 'fill-warn' : 'fill-ok';
        const pcls= pct >= 90 ? 'pct-danger'  : pct >= 70 ? 'pct-warn'  : 'pct-ok';
        const rem = b.limit - b.spent;
        container.insertAdjacentHTML('beforeend', `
            <div class="budget-card" style="animation-delay:${i*0.05}s">
                <div class="bc-header">
                    <div class="bc-left">
                        <div class="bc-emoji">${b.emoji}</div>
                        <div><div class="bc-name">${b.name}</div><div class="bc-period">Monthly</div></div>
                    </div>
                    <div class="bc-actions">
                        <button class="icon-btn">✏️</button>
                        <button class="icon-btn">🗑</button>
                    </div>
                </div>
                <div class="bc-amounts">
                    <div class="bc-spent">₹${b.spent.toLocaleString('en-IN')}</div>
                    <div class="bc-limit">of ₹${b.limit.toLocaleString('en-IN')}</div>
                </div>
                <div class="budget-bar"><div class="budget-fill ${cls}" style="width:${Math.min(pct,100)}%"></div></div>
                <div class="bc-footer">
                    <span>₹${rem.toLocaleString('en-IN')} left</span>
                    <span class="bc-pct ${pcls}">${pct}%</span>
                </div>
            </div>
        `);
    });
    // Move sample cards out of inner div into grid
    const grid = document.querySelector('.budget-grid');
    while(container.firstChild) grid.appendChild(container.firstChild);
    container.remove();
}
</script>
</body>
</html>
