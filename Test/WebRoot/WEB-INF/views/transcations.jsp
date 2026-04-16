<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="transactions" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FinVault — Transactions</title>
    <%@ include file="base-styles.jsp" %>
    <style>
        /* Filter bar */
        .filter-bar { display:flex;align-items:center;gap:.8rem;margin-bottom:1.5rem;flex-wrap:wrap; }
        .filter-bar input, .filter-bar select {
            padding:.6rem 1rem;background:var(--card);border:1px solid var(--border);
            border-radius:9px;color:var(--cream);font-family:'DM Sans',sans-serif;font-size:.87rem;
            outline:none;transition:border-color .2s;
        }
        .filter-bar input { min-width:220px; }
        .filter-bar input:focus,.filter-bar select:focus { border-color:var(--gold); }
        .filter-bar select option { background:var(--slate); }

        /* Summary strip */
        .tx-summary { display:flex;gap:1.2rem;margin-bottom:1.5rem; }
        .tx-sum-card { flex:1;background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem 1.2rem; }
        .tx-sum-label { font-size:.72rem;text-transform:uppercase;letter-spacing:.08em;color:var(--muted);margin-bottom:.3rem; }
        .tx-sum-val { font-family:'DM Serif Display',serif;font-size:1.5rem; }

        /* Table wrapper */
        .table-wrap { background:var(--card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden; }
        .table-toolbar { display:flex;align-items:center;justify-content:space-between;padding:1rem 1.4rem;border-bottom:1px solid var(--border); }
        .tx-count { font-size:.85rem;color:var(--muted); }

        /* Amount colors */
        .credit { color:var(--income);font-weight:600; }
        .debit  { color:var(--expense);font-weight:600; }

        /* Actions col */
        .action-btns { display:flex;gap:.5rem; }
        .icon-btn { background:none;border:none;cursor:pointer;font-size:1rem;padding:.25rem;border-radius:5px;transition:background .15s; }
        .icon-btn:hover { background:rgba(255,255,255,.07); }

        /* Pagination */
        .pagination { display:flex;align-items:center;justify-content:center;gap:.4rem;padding:1rem; }
        .page-btn { width:32px;height:32px;border-radius:7px;border:1px solid var(--border);background:none;color:var(--muted);font-size:.85rem;cursor:pointer;transition:all .15s; }
        .page-btn.active { background:var(--gold);color:var(--ink);border-color:var(--gold);font-weight:600; }
        .page-btn:hover:not(.active) { border-color:var(--gold);color:var(--gold); }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="main">
    <div class="topbar">
        <h1>Transactions</h1>
        <div class="topbar-actions">
            <button class="btn-secondary" onclick="exportCSV()">⬇ Export CSV</button>
            <button class="btn-primary" onclick="openModal('addTxModal')">+ Add Transaction</button>
        </div>
    </div>

    <div class="content">

        <c:if test="${not empty success}"><div class="alert alert-success">✓ ${success}</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-error">⚠ ${error}</div></c:if>

        <!-- Summary strip -->
        <div class="tx-summary fade-up">
            <div class="tx-sum-card">
                <div class="tx-sum-label">Total Income</div>
                <div class="tx-sum-val" style="color:var(--income)">
                    +₹<fmt:formatNumber value="${totalIncome != null ? totalIncome : 130000}" groupingUsed="true" maxFractionDigits="0"/>
                </div>
            </div>
            <div class="tx-sum-card">
                <div class="tx-sum-label">Total Expenses</div>
                <div class="tx-sum-val" style="color:var(--expense)">
                    -₹<fmt:formatNumber value="${totalExpense != null ? totalExpense : 76800}" groupingUsed="true" maxFractionDigits="0"/>
                </div>
            </div>
            <div class="tx-sum-card">
                <div class="tx-sum-label">Net Flow</div>
                <div class="tx-sum-val" style="color:var(--gold)">
                    ₹<fmt:formatNumber value="${netFlow != null ? netFlow : 53200}" groupingUsed="true" maxFractionDigits="0"/>
                </div>
            </div>
            <div class="tx-sum-card">
                <div class="tx-sum-label">This Month</div>
                <div class="tx-sum-val">${txCount != null ? txCount : 34} txns</div>
            </div>
        </div>

        <!-- Filter bar -->
        <form method="GET" action="${pageContext.request.contextPath}/transactions">
            <div class="filter-bar fade-up delay-1">
                <input type="text" name="search" placeholder="🔍  Search description..." value="${param.search}">
                <select name="type">
                    <option value="">All Types</option>
                    <option value="CREDIT" ${param.type=='CREDIT'?'selected':''}>Income</option>
                    <option value="DEBIT"  ${param.type=='DEBIT' ?'selected':''}>Expense</option>
                </select>
                <select name="category">
                    <option value="">All Categories</option>
                    <option value="Food"     ${param.category=='Food'    ?'selected':''}>Food</option>
                    <option value="Shopping" ${param.category=='Shopping'?'selected':''}>Shopping</option>
                    <option value="Bills"    ${param.category=='Bills'   ?'selected':''}>Bills</option>
                    <option value="Travel"   ${param.category=='Travel'  ?'selected':''}>Travel</option>
                    <option value="Health"   ${param.category=='Health'  ?'selected':''}>Health</option>
                    <option value="Salary"   ${param.category=='Salary'  ?'selected':''}>Salary</option>
                </select>
                <input type="date" name="from" value="${param.from}" title="From date">
                <input type="date" name="to"   value="${param.to}"   title="To date">
                <button type="submit" class="btn-primary" style="padding:.6rem 1.1rem;">Filter</button>
                <a href="${pageContext.request.contextPath}/transactions" class="btn-secondary">Reset</a>
            </div>
        </form>

        <!-- Table -->
        <div class="table-wrap fade-up delay-2">
            <div class="table-toolbar">
                <span class="tx-count">Showing <strong>${not empty transactions ? transactions.size() : 6}</strong> transactions</span>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty transactions}">
                            <c:forEach var="tx" items="${transactions}" varStatus="s">
                                <tr>
                                    <td style="color:var(--muted);font-size:.8rem">${s.count}</td>
                                    <td><strong>${tx.description}</strong><br><small style="color:var(--muted)">${tx.note}</small></td>
                                    <td><span class="badge badge-${fn:toLowerCase(tx.categoryClass)}">${tx.category}</span></td>
                                    <td><span class="badge ${tx.type=='CREDIT'?'badge-income':'badge-expense'}">${tx.type=='CREDIT'?'Income':'Expense'}</span></td>
                                    <td style="color:var(--muted)"><fmt:formatDate value="${tx.date}" pattern="dd MMM yyyy"/></td>
                                    <td class="${tx.type=='CREDIT'?'credit':'debit'}">
                                        ${tx.type=='CREDIT'?'+':'-'}₹<fmt:formatNumber value="${tx.amount}" groupingUsed="true" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <button class="icon-btn" title="Edit" onclick="editTx(${tx.id})">✏️</button>
                                            <button class="icon-btn" title="Delete" onclick="deleteTx(${tx.id})">🗑</button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <%-- Sample rows --%>
                            <tr><td style="color:var(--muted)">1</td><td><strong>April Salary</strong></td><td><span class="badge badge-income">Salary</span></td><td><span class="badge badge-income">Income</span></td><td style="color:var(--muted)">01 Apr 2026</td><td class="credit">+₹65,000</td><td><div class="action-btns"><button class="icon-btn">✏️</button><button class="icon-btn">🗑</button></div></td></tr>
                            <tr><td style="color:var(--muted)">2</td><td><strong>Monthly Rent</strong></td><td><span class="badge badge-bills">Bills</span></td><td><span class="badge badge-expense">Expense</span></td><td style="color:var(--muted)">01 Apr 2026</td><td class="debit">-₹14,000</td><td><div class="action-btns"><button class="icon-btn">✏️</button><button class="icon-btn">🗑</button></div></td></tr>
                            <tr><td style="color:var(--muted)">3</td><td><strong>BigBasket Order</strong></td><td><span class="badge badge-shopping">Shopping</span></td><td><span class="badge badge-expense">Expense</span></td><td style="color:var(--muted)">02 Apr 2026</td><td class="debit">-₹3,240</td><td><div class="action-btns"><button class="icon-btn">✏️</button><button class="icon-btn">🗑</button></div></td></tr>
                            <tr><td style="color:var(--muted)">4</td><td><strong>Swiggy Dinner</strong></td><td><span class="badge badge-food">Food</span></td><td><span class="badge badge-expense">Expense</span></td><td style="color:var(--muted)">03 Apr 2026</td><td class="debit">-₹680</td><td><div class="action-btns"><button class="icon-btn">✏️</button><button class="icon-btn">🗑</button></div></td></tr>
                            <tr><td style="color:var(--muted)">5</td><td><strong>Bus Pass</strong></td><td><span class="badge badge-travel">Travel</span></td><td><span class="badge badge-expense">Expense</span></td><td style="color:var(--muted)">04 Apr 2026</td><td class="debit">-₹500</td><td><div class="action-btns"><button class="icon-btn">✏️</button><button class="icon-btn">🗑</button></div></td></tr>
                            <tr><td style="color:var(--muted)">6</td><td><strong>Apollo Pharmacy</strong></td><td><span class="badge badge-health">Health</span></td><td><span class="badge badge-expense">Expense</span></td><td style="color:var(--muted)">05 Apr 2026</td><td class="debit">-₹420</td><td><div class="action-btns"><button class="icon-btn">✏️</button><button class="icon-btn">🗑</button></div></td></tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
            <div class="pagination">
                <button class="page-btn">‹</button>
                <button class="page-btn active">1</button>
                <button class="page-btn">2</button>
                <button class="page-btn">3</button>
                <button class="page-btn">›</button>
            </div>
        </div>

    </div>
</div>

<!-- ADD TRANSACTION MODAL -->
<div class="modal-backdrop" id="addTxModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Add Transaction</span>
            <button class="modal-close" onclick="closeModal('addTxModal')">×</button>
        </div>
        <form action="${pageContext.request.contextPath}/transactions/add" method="POST">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="form-row">
                <div class="form-group">
                    <label>Type</label>
                    <select name="type" required>
                        <option value="DEBIT">Expense</option>
                        <option value="CREDIT">Income</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Amount (₹)</label>
                    <input type="number" name="amount" placeholder="0.00" step="0.01" min="0" required>
                </div>
            </div>
            <div class="form-group">
                <label>Description</label>
                <input type="text" name="description" placeholder="e.g. Grocery Shopping" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Category</label>
                    <select name="category" required>
                        <option value="Food">Food</option>
                        <option value="Shopping">Shopping</option>
                        <option value="Bills">Bills & Utilities</option>
                        <option value="Travel">Travel</option>
                        <option value="Health">Health</option>
                        <option value="Salary">Salary</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Date</label>
                    <input type="date" name="date" required>
                </div>
            </div>
            <div class="form-group">
                <label>Note (optional)</label>
                <input type="text" name="note" placeholder="Any extra detail...">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('addTxModal')">Cancel</button>
                <button type="submit" class="btn-primary">Save Transaction</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id)  { document.getElementById(id).classList.add('open'); }
    function closeModal(id) { document.getElementById(id).classList.remove('open'); }
    function deleteTx(id) { if(confirm('Delete this transaction?')) window.location = '${pageContext.request.contextPath}/transactions/delete/' + id; }
    function editTx(id)   { window.location = '${pageContext.request.contextPath}/transactions/edit/' + id; }
    function exportCSV()  { window.location = '${pageContext.request.contextPath}/transactions/export'; }
    // Set today's date in modal
    document.querySelector('[name="date"]').value = new Date().toISOString().split('T')[0];
</script>
</body>
</html>
