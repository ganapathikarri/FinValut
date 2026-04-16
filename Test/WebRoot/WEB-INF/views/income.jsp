<%-- ========= income.jsp ========= --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="currentPage" value="income" scope="request" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FinVault — Income</title>
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
	background: var(--income);
	color: #fff;
	font-weight: 700;
}

.source-badge {
	display: inline-block;
	padding: .22rem .6rem;
	border-radius: 5px;
	font-size: .74rem;
	font-weight: 600;
	background: rgba(60, 185, 124, .14);
	color: var(--income);
}
</style>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
</head>
<body>
	<%@ include file="sidebar.jsp"%>
	<div class="main">
		<div class="topbar">
			<h1>Income</h1>
			<div class="topbar-actions">
				<button class="btn-primary" onclick="openModal('addIncomeModal')">+
					Add Income</button>
			</div>
		</div>
		<div class="content">
			<c:if test="${not empty success}">
				<div class="alert alert-success">✓ ${success}</div>
			</c:if>

			<div class="page-tabs fade-up">
				<a href="income" class="page-tab active">📥 Income</a> <a
					href="expenses" class="page-tab">📤 Expenses</a>
			</div>

			<!-- Stats -->
			<div class="stats-row fade-up delay-1">

				<div class="stat-card">
					<div class="stat-label">This Month</div>
					<div class="stat-value" style="color:var(--income)">
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
			<!-- Chart + Table -->
			<div
				style="display:grid;grid-template-columns:1.5fr 1fr;gap:1.4rem;margin-bottom:1.5rem;">
				<div class="panel fade-up delay-2">
					<div class="panel-header">
						<span class="panel-title">Monthly Income Trend</span>
					</div>
					<canvas id="incomeChart" height="200"></canvas>
				</div>
				<div class="panel fade-up delay-3">
					<div class="panel-header">
						<span class="panel-title">By Source</span>
					</div>
					<canvas id="incomeDonut" height="200"></canvas>
				</div>
			</div>

			<!-- Table -->
			<div class="table-wrap fade-up delay-4">
				<div
					style="display:flex;align-items:center;justify-content:space-between;
                padding:1rem 1.4rem;border-bottom:1px solid var(--border);">

					<span
						style="font-family:'DM Serif Display',serif;font-size:1.05rem">
						Income Records </span>

					<button class="btn-secondary"
						onclick="window.location='${pageContext.request.contextPath}/income/export'">
						⬇ Export</button>
				</div>

				<table>
					<thead>
						<tr>
							<th>Source</th>
							<th>Type</th>
							<th>Date</th>
							<th>Note</th>
							<th style="text-align:right">Amount</th>
							<th>Actions</th>
						</tr>
					</thead>

					<tbody>
						<c:choose>
							<c:when test="${not empty incomes}">
								<c:forEach var="inc" items="${incomes}">
									<tr>
										<td><strong>${inc[0]}</strong></td>
										<td><span class="source-badge">${inc[1]}</span></td>
										<td style="color:var(--muted)"><fmt:formatDate
												value="${inc[2]}" pattern="dd MMM yyyy" /></td>
										<td style="color:var(--muted)">${inc[3]}</td>
										<td
											style="text-align:right;color:var(--income);font-weight:700">
											+₹ <fmt:formatNumber value="${inc[4]}" groupingUsed="true"
												maxFractionDigits="0" />
										</td>
										<td>
											<div style="display:flex;gap:.4rem">
												<button class="icon-btn" onclick="editIncome('${inc[5]}')">✏️</button>
												<button class="icon-btn" onclick="deleteIncome('${inc[5]}')">🗑</button>
											</div>
										</td>
									</tr>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="6" style="text-align:center;color:var(--muted)">
										No income records found</td>
								</tr>
							</c:otherwise>

						</c:choose>
					</tbody>
				</table>
			</div>

			<!-- ADD INCOME MODAL -->
			<div class="modal-backdrop" id="addIncomeModal">
				<div class="modal">
					<div class="modal-header">
						<span class="modal-title">Add Income</span>
						<button class="modal-close" onclick="closeModal('addIncomeModal')">×</button>
					</div>
					<form action="${pageContext.request.contextPath}/addIncome"
						method="POST">
						<input type="hidden" name="${_csrf.parameterName}"
							value="${_csrf.token}" />
						<div class="form-row">
							<div class="form-group">
								<label>Source</label> <input type="text" name="source"
									placeholder="e.g. Salary" required>
							</div>
							<div class="form-group">
								<label>Type</label> <select name="type">
									<option value="Salary">Salary</option>
									<option value="Freelance">Freelance</option>
									<option value="Business">Business</option>
									<option value="Investment">Investment</option>
									<option value="Gift">Gift</option>
									<option value="Other">Other</option>
								</select>
							</div>
						</div>
						<div class="form-row">
							<div class="form-group">
								<label>Amount (₹)</label> <input type="number" name="amount"
									placeholder="0" min="1" required>
							</div>
							<div class="form-group">
								<label>Date</label> <input type="date" name="date"
									id="incomeDateInput" required>
							</div>
						</div>
						<div class="form-group">
							<label>Note (optional)</label> <input type="text" name="note"
								placeholder="Any detail...">
						</div>
						<div class="modal-footer">
							<button type="button" class="btn-secondary"
								onclick="closeModal('addIncomeModal')">Cancel</button>
							<button type="submit" class="btn-primary">Save Income</button>
						</div>
					</form>
				</div>
			</div>

			<script>
function openModal(id)  { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
document.getElementById('incomeDateInput').value = new Date().toISOString().split('T')[0];

Chart.defaults.color='#6b7280';Chart.defaults.borderColor='rgba(255,255,255,0.07)';Chart.defaults.font.family="'DM Sans',sans-serif";

  
    const mo = [
        <c:forEach var="m" items="${months}" varStatus="status">
            "${m}"<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const inc = [
        <c:forEach var="v" items="${values}" varStatus="status">
            ${v}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    new Chart(document.getElementById('incomeChart'), {
        type: 'line',
        data: {
            labels: mo,
            datasets: [{
                label: 'Income',
                data: inc,
                borderColor: '#3cb97c',
                backgroundColor: 'rgba(60,185,124,0.1)',
                tension: .4,
                fill: true,
                pointBackgroundColor: '#3cb97c',
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                x: { grid: { display: false } },
                y: {
                    grid: { color: 'rgba(255,255,255,0.05)' },
                    ticks: {
                        callback: v => '₹' + v.toLocaleString('en-IN')
                    }
                }
            }
        }
    });
    const labels = [
    	<c:forEach var="c" items="${categories}" varStatus="s">
    	"${c}"<c:if test="${!s.last}">,</c:if>
    	</c:forEach>
    	];

    	const data = [
    	<c:forEach var="a" items="${categoryAmounts}" varStatus="s">
    	${a}<c:if test="${!s.last}">,</c:if>
    	</c:forEach>
    	];

    	new Chart(document.getElementById('incomeDonut'), {
    	    type: 'doughnut',
    	    data: {
    	        labels: labels,
    	        datasets: [{
    	            data: data,
    	            backgroundColor: ['#3cb97c','#c9a84c','#5b8dee','#808080','#ff6384'],
    	            borderWidth: 0,
    	            hoverOffset: 8
    	        }]
    	    },
    	    options: {
    	        responsive: true,
    	        cutout: '65%',
    	        plugins: {
    	            legend: { position: 'bottom' }
    	        }
    	    }
    	});   
    	function deleteIncome(id) {
    	    if (!confirm("Are you sure you want to delete?")) return;

    	    fetch('deleteExpense?id=' + id, {
    	        method: 'DELETE'
    	    })
    	    .then(() => {
    	        alert("Deleted successfully");
    	        location.reload(); // simple way
    	    })
    	    .catch(err => console.error(err));
    	}
    new Chart(document.getElementById('incomeChart'),{type:'line',data:{labels:mo,datasets:[{label:'Income',data:inc,borderColor:'#3cb97c',backgroundColor:'rgba(60,185,124,0.1)',tension:.4,fill:true,pointBackgroundColor:'#3cb97c',pointRadius:4}]},options:{responsive:true,plugins:{legend:{display:false}},scales:{x:{grid:{display:false}},y:{grid:{color:'rgba(255,255,255,0.05)'},ticks:{callback:v=>'₹'+v.toLocaleString('en-IN')}}}}});
    new Chart(document.getElementById('incomeDonut'),{type:'doughnut',data:{labels:['Salary','Freelance','Investments','Other'],datasets:[{data:[65000,18000,2400,1000],backgroundColor:['#3cb97c','#c9a84c','#5b8dee','#808080'],borderWidth:0,hoverOffset:8}]},options:{responsive:true,cutout:'65%',plugins:{legend:{position:'bottom'}}}});
    
</script>
</body>
</html>