<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="currentPage" value="expenses" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FinVault — Expenses</title>
<%@ include file="base-styles.jsp"%>
<style>
.stats-row {
	display: flex;
	gap: 1.2rem;
	margin-bottom: 1.5rem;
}

.stat-card {
	flex: 1;
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 12px;
	padding: 1.1rem 1.3rem;
}

.stat-label {
	font-size: .72rem;
	text-transform: uppercase;
	letter-spacing: .08em;
	color: var(--muted);
	margin-bottom: .35rem;
}

.stat-value {
	font-family: 'DM Serif Display', serif;
	font-size: 1.6rem;
}

.table-wrap {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: var(--radius);
	overflow: hidden;
}

.page-tabs {
	display: flex;
	gap: .4rem;
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 10px;
	padding: .3rem;
	width: fit-content;
	margin-bottom: 1.4rem;
}

.page-tab {
	padding: .45rem 1.1rem;
	border-radius: 7px;
	font-size: .85rem;
	font-weight: 500;
	cursor: pointer;
	color: var(--muted);
	background: none;
	border: none;
	text-decoration: none;
	transition: all .15s;
}

.page-tab.active {
	background: var(--expense);
	color: #fff;
	font-weight: 700;
}

/* Category breakdown mini chart */
.cat-breakdown {
	display: flex;
	flex-direction: column;
	gap: .65rem;
}

.cat-row {
	display: flex;
	align-items: center;
	gap: .8rem;
}

.cat-emoji-sm {
	font-size: 1.05rem;
	width: 24px;
	text-align: center;
}

.cat-bar-wrap {
	flex: 1;
}

.cat-name-row {
	display: flex;
	justify-content: space-between;
	font-size: .82rem;
	margin-bottom: .25rem;
}

.cat-name-row span {
	color: var(--muted);
	font-size: .8rem;
}
</style>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
</head>
<body>
	<%@ include file="sidebar.jsp"%>
	<div class="main">
		<div class="topbar">
			<h1>Expenses</h1>
			<div class="topbar-actions">
				<button class="btn-primary" onclick="openModal('addExpenseModal')">+
					Add Expense</button>
			</div>
		</div>
		<div class="content">
			<c:if test="${not empty success}">
				<div class="alert alert-success">✓ ${success}</div>
			</c:if>

			<div class="page-tabs fade-up">
				<a href="income" class="page-tab">📥 Income</a> <a href="expenses"
					class="page-tab active">📤 Expenses</a>
			</div>

			<!-- Stats -->
			<div class="stats-row fade-up delay-1">

				<div class="stat-card">
					<div class="stat-label">This Month</div>
					<div class="stat-value" style="color:var(--expense)">
						₹
						<fmt:formatNumber value="${thisMonth}" groupingUsed="true" />
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-label">Last Month</div>
					<div class="stat-value" style="color:var(--muted)">
						₹
						<fmt:formatNumber value="${lastMonth}" groupingUsed="true" />
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-label">This Year</div>
					<div class="stat-value" style="color:var(--gold)">
						₹
						<fmt:formatNumber value="${thisYear}" groupingUsed="true" />
					</div>
				</div>

				<div class="stat-card">
					<div class="stat-label">Avg Monthly</div>
					<div class="stat-value" style="color:var(--saving)">
						₹
						<fmt:formatNumber value="${avgMonthly}" groupingUsed="true" />
					</div>
				</div>

			</div>

			<!-- Table -->
			<div class="table-wrap fade-up delay-4">
				<div
					style="display:flex;align-items:center;justify-content:space-between;padding:1rem 1.4rem;border-bottom:1px solid var(--border);">
					<span
						style="font-family:'DM Serif Display',serif;font-size:1.05rem">Expense
						Records</span>
					<button class="btn-secondary"
						onclick="window.location='${pageContext.request.contextPath}/expenses/export'">⬇
						Export</button>
				</div>
				<table>
					<thead>
						<tr>
							<th>Description</th>
							<th>Category</th>
							<th>Date</th>
							<th>Note</th>
							<th style="text-align:right">Amount</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						<c:choose>
							<c:when test="${not empty expenses}">
								<c:forEach var="exp" items="${expenses}">
									<tr>
										<!-- description -->
										<td style="color:var(--expense)"><strong>${exp[0]}</strong></td>

										<!-- category -->
										<td>${exp[1]}</td>

										<!-- date -->
										<td><fmt:formatDate value="${exp[2]}"
												pattern="dd MMM yyyy" /></td>

										<!-- amount -->
										<td>-₹${exp[3]}</td>
										<td
											style="text-align:right;color:var(--expense);font-weight:700">-${exp[4]}</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td><strong>Monthly Rent</strong></td>
									<td><span class="badge badge-bills">Bills</span></td>
									<td style="color:var(--muted)">01 Apr 2026</td>
									<td style="color:var(--muted)">House rent</td>
									<td
										style="text-align:right;color:var(--expense);font-weight:700">-₹14,000</td>
									<td><div style="display:flex;gap:.4rem">
											<button class="icon-btn">✏️</button>
											<button class="icon-btn">🗑</button>
										</div></td>
								</tr>
								<tr>
									<td><strong>BigBasket</strong></td>
									<td><span class="badge badge-shopping">Shopping</span></td>
									<td style="color:var(--muted)">02 Apr 2026</td>
									<td style="color:var(--muted)">Groceries</td>
									<td
										style="text-align:right;color:var(--expense);font-weight:700">-₹3,240</td>
									<td><div style="display:flex;gap:.4rem">
											<button class="icon-btn">✏️</button>
											<button class="icon-btn">🗑</button>
										</div></td>
								</tr>
								<tr>
									<td><strong>Swiggy</strong></td>
									<td><span class="badge badge-food">Food</span></td>
									<td style="color:var(--muted)">03 Apr 2026</td>
									<td style="color:var(--muted)">Dinner</td>
									<td
										style="text-align:right;color:var(--expense);font-weight:700">-₹680</td>
									<td><div style="display:flex;gap:.4rem">
											<button class="icon-btn">✏️</button>
											<button class="icon-btn">🗑</button>
										</div></td>
								</tr>
								<tr>
									<td><strong>Electricity Bill</strong></td>
									<td><span class="badge badge-bills">Bills</span></td>
									<td style="color:var(--muted)">04 Apr 2026</td>
									<td style="color:var(--muted)">APSPDCL</td>
									<td
										style="text-align:right;color:var(--expense);font-weight:700">-₹2,200</td>
									<td><div style="display:flex;gap:.4rem">
											<button class="icon-btn">✏️</button>
											<button class="icon-btn">🗑</button>
										</div></td>
								</tr>
								<tr>
									<td><strong>Apollo Pharmacy</strong></td>
									<td><span class="badge badge-health">Health</span></td>
									<td style="color:var(--muted)">05 Apr 2026</td>
									<td style="color:var(--muted)">Medicines</td>
									<td
										style="text-align:right;color:var(--expense);font-weight:700">-₹420</td>
									<td><div style="display:flex;gap:.4rem">
											<button class="icon-btn">✏️</button>
											<button class="icon-btn">🗑</button>
										</div></td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<!-- ADD EXPENSE MODAL -->
	<div class="modal-backdrop" id="addExpenseModal">
		<div class="modal">
			<div class="modal-header">
				<span class="modal-title">Add Expense</span>
				<button class="modal-close" onclick="closeModal('addExpenseModal')">×</button>
			</div>
			<form action="${pageContext.request.contextPath}/addExpenses"
				method="POST">
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
				<div class="form-group">
					<label>Description</label> <input type="text" name="description"
						placeholder="e.g. Grocery Shopping" required>
				</div>
				<div class="form-row">
					<div class="form-group">
						<label>Category</label> <select name="category" required>
							<option value="Food">Food</option>
							<option value="Shopping">Shopping</option>
							<option value="Bills">Bills & Utilities</option>
							<option value="Travel">Travel</option>
							<option value="Health">Health</option>
							<option value="Entertainment">Entertainment</option>
							<option value="Other">Other</option>
						</select>
					</div>
					<div class="form-group">
						<label>Amount (₹)</label> <input type="number" name="amount"
							placeholder="0.00" step="0.01" min="0" required>
					</div>
				</div>
				<div class="form-group">
					<label>Date</label> <input type="date" name="date"
						id="expDateInput" required>
				</div>
				<div class="form-group">
					<label>Note (optional)</label> <input type="text" name="note"
						placeholder="Any extra detail...">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn-secondary"
						onclick="closeModal('addExpenseModal')">Cancel</button>
					<button type="submit" class="btn-primary">Save Expense</button>
				</div>
			</form>
		</div>
	</div>

	<script>
function openModal(id)  { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
document.getElementById('expDateInput').value = new Date().toISOString().split('T')[0];

Chart.defaults.color='#6b7280';Chart.defaults.borderColor='rgba(255,255,255,0.07)';Chart.defaults.font.family="'DM Sans',sans-serif";
const mo=['Nov','Dec','Jan','Feb','Mar','Apr'];
const exp=[35000,40000,37000,41000,36000,38400];
new Chart(document.getElementById('expChart'),{type:'bar',data:{labels:mo,datasets:[{label:'Expenses',data:exp,backgroundColor:'rgba(224,82,82,0.7)',borderRadius:6}]},options:{responsive:true,plugins:{legend:{display:false}},scales:{x:{grid:{display:false}},y:{grid:{color:'rgba(255,255,255,0.05)'},ticks:{callback:v=>'₹'+v.toLocaleString('en-IN')}}}}});

// Category breakdown
const cats=[
    {e:'🏠',name:'Rent',      amt:14000,color:'#c9a84c'},
    {e:'🛒',name:'Groceries', amt:9200, color:'#5b8dee'},
    {e:'🍔',name:'Food',      amt:5600, color:'#e0a552'},
    {e:'📱',name:'Utilities', amt:2000, color:'#60c0d0'},
    {e:'💊',name:'Health',    amt:2400, color:'#3cb97c'},
    {e:'🚌',name:'Travel',    amt:3200, color:'#b090e0'},
];
const maxAmt=Math.max(...cats.map(c=>c.amt));
const cbd=document.getElementById('catBreakdown');
cats.forEach(c=>{
    const pct=Math.round(c.amt/maxAmt*100);
    cbd.insertAdjacentHTML('beforeend',`
        <div class="cat-row">
            <div class="cat-emoji-sm">${c.e}</div>
            <div class="cat-bar-wrap">
                <div class="cat-name-row">${c.name}<span>₹${c.amt.toLocaleString('en-IN')}</span></div>
                <div class="progress-bar"><div class="progress-fill" style="width:${pct}%;background:${c.color}"></div></div>
            </div>
        </div>`);
});
</script>
</body>
</html>