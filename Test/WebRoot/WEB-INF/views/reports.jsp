<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="reports" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FinVault — Reports</title>
    <%@ include file="base-styles.jsp" %>
    <style>
        .report-grid-2 { display:grid;grid-template-columns:1fr 1fr;gap:1.4rem;margin-bottom:1.5rem; }
        .report-grid-3 { display:grid;grid-template-columns:1fr 1fr 1fr;gap:1.4rem;margin-bottom:1.5rem; }
        canvas { display:block;max-width:100%; }

        .period-tabs { display:flex;gap:.4rem;background:var(--card);border:1px solid var(--border);border-radius:10px;padding:.3rem;width:fit-content;margin-bottom:1.5rem; }
        .period-tab { padding:.45rem 1.1rem;border-radius:7px;font-size:.84rem;font-weight:500;cursor:pointer;color:var(--muted);background:none;border:none;transition:all .15s; }
        .period-tab.active { background:var(--gold);color:var(--ink);font-weight:700; }

        .export-bar { display:flex;gap:.8rem;margin-bottom:1.5rem;align-items:center; }
        .export-bar span { font-size:.88rem;color:var(--muted); }

        /* Top expenses table */
        .top-table td:last-child { text-align:right;font-weight:600;color:var(--expense); }

        /* Trend numbers */
        .trend-row { display:flex;justify-content:space-between;align-items:center;padding:.6rem 0;border-bottom:1px solid var(--border); }
        .trend-row:last-child { border-bottom:none; }
        .trend-month { font-size:.88rem;font-weight:500; }
        .trend-amounts { display:flex;gap:1.5rem;text-align:right;font-size:.85rem; }
        .trend-inc { color:var(--income); }
        .trend-exp { color:var(--expense); }
        .trend-net { color:var(--gold);font-weight:600; }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div class="main">
    <div class="topbar">
        <h1>Reports & Analytics</h1>
        <div class="topbar-actions">
            <button class="btn-secondary" onclick="window.print()">🖨 Print</button>
            <button class="btn-primary" onclick="exportPDF()">⬇ Export PDF</button>
        </div>
    </div>

    <div class="content">

        <!-- Period selector -->
        <div class="period-tabs fade-up">
            <button class="period-tab active" onclick="setPeriod('3m',this)">3 Months</button>
            <button class="period-tab" onclick="setPeriod('6m',this)">6 Months</button>
            <button class="period-tab" onclick="setPeriod('1y',this)">1 Year</button>
            <button class="period-tab" onclick="setPeriod('all',this)">All Time</button>
        </div>

        <!-- Summary KPIs -->
       <div class="report-grid-3 fade-up delay-1">

    <div class="panel">
        <div class="label">Avg Monthly Income</div>
        <div id="avgIncome" class="value" style="color:var(--income)">₹0</div>
        <div id="incomeChange" class="subtext"></div>
    </div>

    <div class="panel">
        <div class="label">Avg Monthly Spend</div>
        <div id="avgExpense" class="value" style="color:var(--expense)">₹0</div>
        <div id="expenseChange" class="subtext"></div>
    </div>

    <div class="panel">
        <div class="label">Avg Savings Rate</div>
        <div id="savingsRate" class="value" style="color:var(--saving)">0%</div>
        <div id="savingTrend" class="subtext"></div>
    </div>

</div>
        <!-- Bar chart + Donut chart -->
        <div class="report-grid-2 fade-up delay-2">
            <div class="panel">
                <div class="panel-header"><span class="panel-title">Income vs Expenses</span></div>
                <canvas id="barChart" height="200"></canvas>
            </div>
            <div class="panel">
                <div class="panel-header"><span class="panel-title">Spending by Category</span></div>
                <canvas id="donutChart" height="200"></canvas>
            </div>
        </div>

        <!-- Line chart + Monthly trend table -->
        <div class="report-grid-2 fade-up delay-3">
            <div class="panel">
                <div class="panel-header"><span class="panel-title">Net Savings Trend</span></div>
                <canvas id="lineChart" height="200"></canvas>
            </div>
            <div class="panel">
                <div class="panel-header"><span class="panel-title">Monthly Breakdown</span></div>
                <div>
                    <c:choose>
                        <c:when test="${not empty monthlyReports}">
                            <c:forEach var="r" items="${monthlyReports}">
                                <div class="trend-row">
                                    <div class="trend-month">${r.month}</div>
                                    <div class="trend-amounts">
                                        <span class="trend-inc">+₹<fmt:formatNumber value="${r.income}" groupingUsed="true" maxFractionDigits="0"/></span>
                                        <span class="trend-exp">-₹<fmt:formatNumber value="${r.expense}" groupingUsed="true" maxFractionDigits="0"/></span>
                                        <span class="trend-net">₹<fmt:formatNumber value="${r.net}" groupingUsed="true" maxFractionDigits="0"/></span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div id="trendRows"></div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Top transactions table -->
        <div class="panel fade-up delay-4">
            <div class="panel-header"><span class="panel-title">Top 10 Expenses This Period</span></div>
            <table class="top-table">
                <thead><tr><th>#</th><th>Description</th><th>Category</th><th>Date</th><th>Amount</th></tr></thead>
                <tbody id="topExpenses">
                    <%-- Populated by JS sample or server JSTL --%>
                    <c:choose>
                        <c:when test="${not empty topExpenses}">
                            <c:forEach var="tx" items="${topExpenses}" varStatus="s">
                                <tr>
                                    <td style="color:var(--muted)">${s.count}</td>
                                    <td>${tx.description}</td>
                                    <td><span class="badge badge-${fn:toLowerCase(tx.categoryClass)}">${tx.category}</span></td>
                                    <td style="color:var(--muted)"><fmt:formatDate value="${tx.date}" pattern="dd MMM"/></td>
                                    <td>-₹<fmt:formatNumber value="${tx.amount}" groupingUsed="true" maxFractionDigits="0"/></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise></c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </div>
</div>

<script>
// ---- Shared Chart defaults ----
Chart.defaults.color = '#6b7280';
Chart.defaults.borderColor = 'rgba(255,255,255,0.07)';
Chart.defaults.font.family = "'DM Sans', sans-serif";

const months6 = ['Nov','Dec','Jan','Feb','Mar','Apr'];
const incomes  = [58000,61000,55000,63000,60000,65000];
const expenses = [35000,40000,37000,41000,36000,38400];
const savings  = incomes.map((v,i) => v - expenses[i]);

// Bar chart
new Chart(document.getElementById('barChart'), {
    type: 'bar',
    data: {
        labels: months6,
        datasets: [
            { label:'Income',   data: incomes,   backgroundColor:'rgba(60,185,124,0.7)', borderRadius:6 },
            { label:'Expenses', data: expenses,  backgroundColor:'rgba(224,82,82,0.7)',  borderRadius:6 },
        ]
    },
    options: {
        responsive:true, plugins:{ legend:{ position:'top' } },
        scales: { x:{ grid:{display:false} }, y:{ grid:{color:'rgba(255,255,255,0.05)'}, ticks:{callback:v=>'₹'+v.toLocaleString('en-IN')} } }
    }
});

// Donut
new Chart(document.getElementById('donutChart'), {
    type: 'doughnut',
    data: {
        labels:['Rent','Groceries','Food','Transport','Health','Utilities','Other'],
        datasets:[{ data:[14000,9200,5600,3200,2400,2000,2000],
            backgroundColor:['#c9a84c','#5b8dee','#e0a552','#b090e0','#3cb97c','#60c0d0','#808080'],
            borderWidth:0, hoverOffset:8
        }]
    },
    options:{ responsive:true, cutout:'65%', plugins:{ legend:{ position:'right' } } }
});

// Line chart
new Chart(document.getElementById('lineChart'), {
    type:'line',
    data:{
        labels: months6,
        datasets:[{
            label:'Net Savings', data: savings,
            borderColor:'#c9a84c', backgroundColor:'rgba(201,168,76,0.1)',
            tension:.4, fill:true, pointBackgroundColor:'#c9a84c', pointRadius:4
        }]
    },
    options:{
        responsive:true, plugins:{ legend:{ display:false } },
        scales:{ x:{grid:{display:false}}, y:{grid:{color:'rgba(255,255,255,0.05)'}, ticks:{callback:v=>'₹'+v.toLocaleString('en-IN')}} }
    }
});

// Monthly trend rows (sample)
const trendData = [
    {month:'April 2026',  inc:65000, exp:38400},
    {month:'March 2026',  inc:60000, exp:36000},
    {month:'February 2026',inc:63000,exp:41000},
    {month:'January 2026', inc:55000,exp:37000},
    {month:'December 2025',inc:61000,exp:40000},
    {month:'November 2025',inc:58000,exp:35000},
];
const trendEl = document.getElementById('trendRows');
if(trendEl) trendData.forEach(r => {
    const net = r.inc - r.exp;
    trendEl.insertAdjacentHTML('beforeend',`
        <div class="trend-row">
            <div class="trend-month">${r.month}</div>
            <div class="trend-amounts">
                <span class="trend-inc">+₹${r.inc.toLocaleString('en-IN')}</span>
                <span class="trend-exp">-₹${r.exp.toLocaleString('en-IN')}</span>
                <span class="trend-net">₹${net.toLocaleString('en-IN')}</span>
            </div>
        </div>`);
});

// Top expenses sample
const topEx = [
    {desc:'Monthly Rent',  cat:'Bills',    date:'01 Apr', amt:14000, cls:'bills'},
    {desc:'BigBasket',     cat:'Shopping', date:'02 Apr', amt:3240,  cls:'shopping'},
    {desc:'Electricity',   cat:'Bills',    date:'03 Apr', amt:2200,  cls:'bills'},
    {desc:'Gym Membership',cat:'Health',   date:'04 Apr', amt:1500,  cls:'health'},
    {desc:'Ola Cabs',      cat:'Travel',   date:'05 Apr', amt:1200,  cls:'travel'},
];
const tbody = document.getElementById('topExpenses');
if(tbody && !tbody.children.length) topEx.forEach((t,i) => {
    tbody.insertAdjacentHTML('beforeend',`
        <tr>
            <td style="color:var(--muted)">${i+1}</td>
            <td>${t.desc}</td>
            <td><span class="badge badge-${t.cls}">${t.cat}</span></td>
            <td style="color:var(--muted)">${t.date}</td>
            <td>-₹${t.amt.toLocaleString('en-IN')}</td>
        </tr>`);
});

function setPeriod(p, btn) {
    document.querySelectorAll('.period-tab').forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
    // In real app: reload charts via AJAX with period param
}
function loadKPIs() {

    fetch('${pageContext.request.contextPath}/api/reports')
    .then(res => {
        if (!res.ok) throw new Error("API error");
        return res.json();
    })
    .then(data => {

        console.log("DATA:", data); 
        document.getElementById("avgIncome").innerText =
            "₹" + (data.avgIncome || 0).toLocaleString("en-IN");

        document.getElementById("avgExpense").innerText =
            "₹" + (data.avgExpense || 0).toLocaleString("en-IN");

        document.getElementById("savingsRate").innerText =
            (data.savingsRate || 0).toFixed(1) + "%";
    })
    .catch(err => console.error(err));
}

window.onload = loadKPIs;

function loadBarChart() {

    fetch('${pageContext.request.contextPath}/api/reports')
    .then(res => res.json())
    .then(data => {

        console.log("Chart Data:", data); // debug

        const months   = data.months;        // ['Jan','Feb',...]
        const incomes  = data.incomeList;    // [50000,60000...]
        const expenses = data.expenseList;   // [30000,40000...]

        renderBarChart(months, incomes, expenses);
    });
}
function renderBarChart(months, incomes, expenses) {

    new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
            labels: months,
            datasets: [
                {
                    label: 'Income',
                    data: incomes,
                    backgroundColor: 'rgba(60,185,124,0.7)',
                    borderRadius: 6
                },
                {
                    label: 'Expenses',
                    data: expenses,
                    backgroundColor: 'rgba(224,82,82,0.7)',
                    borderRadius: 6
                }
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { position: 'top' }
            },
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
}

window.onload = loadBarChart();
function exportPDF() { window.location = '${pageContext.request.contextPath}/reports/export'; }
</script>
</body>
</html>
