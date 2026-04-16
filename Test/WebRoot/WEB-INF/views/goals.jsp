<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="goals" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FinVault — Goals</title>
    <%@ include file="base-styles.jsp" %>
    <style>
        .goals-grid { display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:1.3rem; }

        .goal-card {
            background:var(--card);border:1px solid var(--border);border-radius:var(--radius);
            padding:1.5rem;animation:fadeUp .4s ease both;transition:border-color .2s,transform .2s;
        }
        .goal-card:hover { border-color:rgba(201,168,76,.35);transform:translateY(-2px); }

        .gc-top { display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:1rem; }
        .gc-icon { width:44px;height:44px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.3rem;flex-shrink:0; }
        .gc-meta { flex:1;padding:0 .8rem; }
        .gc-name { font-weight:600;font-size:1rem;margin-bottom:.2rem; }
        .gc-deadline { font-size:.78rem;color:var(--muted); }
        .gc-actions { display:flex;gap:.3rem; }

        .gc-amounts { margin-bottom:.8rem; }
        .gc-current { font-family:'DM Serif Display',serif;font-size:1.6rem;margin-bottom:.15rem; }
        .gc-target  { font-size:.83rem;color:var(--muted); }

        .goal-bar { height:8px;background:rgba(255,255,255,.07);border-radius:6px;overflow:hidden;margin-bottom:.5rem; }
        .goal-fill { height:100%;border-radius:6px;transition:width 1s ease; }

        .gc-bottom { display:flex;justify-content:space-between;font-size:.78rem; }
        .gc-left-amt { color:var(--muted); }
        .gc-pct { font-weight:700; }

        .gc-contribute {
            width:100%;margin-top:1rem;padding:.6rem;
            background:rgba(255,255,255,.04);border:1px dashed rgba(255,255,255,.12);
            border-radius:8px;color:var(--gold);font-family:'DM Sans',sans-serif;
            font-size:.83rem;cursor:pointer;transition:background .2s;
        }
        .gc-contribute:hover { background:rgba(201,168,76,.1); }

        .completed-badge {
            display:inline-flex;align-items:center;gap:.3rem;
            padding:.25rem .65rem;background:rgba(60,185,124,.15);
            color:var(--income);border-radius:6px;font-size:.75rem;font-weight:600;
        }

        /* Stats top */
        .goal-stats { display:flex;gap:1.2rem;margin-bottom:1.5rem; }
        .gs-card { flex:1;background:var(--card);border:1px solid var(--border);border-radius:12px;padding:1rem 1.2rem; }
        .gs-val { font-family:'DM Serif Display',serif;font-size:1.5rem;margin-bottom:.2rem; }
        .gs-lbl { font-size:.73rem;text-transform:uppercase;letter-spacing:.08em;color:var(--muted); }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div class="main">
    <div class="topbar">
        <h1>Savings Goals</h1>
        <div class="topbar-actions">
            <button class="btn-primary" onclick="openModal('addGoalModal')">+ New Goal</button>
        </div>
    </div>

    <div class="content">
        <c:if test="${not empty success}"><div class="alert alert-success">✓ ${success}</div></c:if>

        <!-- Stats -->
        <div class="goal-stats fade-up">
            <div class="gs-card"><div class="gs-val" style="color:var(--gold)">${goalCount != null ? goalCount : 4}</div><div class="gs-lbl">Active Goals</div></div>
            <div class="gs-card"><div class="gs-val" style="color:var(--income)">₹1,80,000</div><div class="gs-lbl">Total Saved</div></div>
            <div class="gs-card"><div class="gs-val" style="color:var(--saving)">₹5,20,000</div><div class="gs-lbl">Total Target</div></div>
            <div class="gs-card"><div class="gs-val" style="color:var(--income)">2</div><div class="gs-lbl">Completed</div></div>
        </div>

        <!-- Goals grid -->
        <div class="goals-grid" id="goalsGrid">
            <c:choose>
                <c:when test="${not empty goals}">
                    <c:forEach var="g" items="${goals}" varStatus="s">
                        <c:set var="pct" value="${g.saved * 100 / g.target}"/>
                        <div class="goal-card" style="animation-delay:${s.index * 0.06}s">
                            <div class="gc-top">
                                <div class="gc-icon" style="background:${g.colorBg}">${g.emoji}</div>
                                <div class="gc-meta">
                                    <div class="gc-name">${g.name}</div>
                                    <div class="gc-deadline">Target: <fmt:formatDate value="${g.deadline}" pattern="MMM yyyy"/></div>
                                </div>
                                <div class="gc-actions">
                                    <c:if test="${pct >= 100}"><span class="completed-badge">✓ Done</span></c:if>
                                    <button class="icon-btn">✏️</button>
                                    <button class="icon-btn">🗑</button>
                                </div>
                            </div>
                            <div class="gc-amounts">
                                <div class="gc-current" style="color:${g.color}">
                                    ₹<fmt:formatNumber value="${g.saved}" groupingUsed="true" maxFractionDigits="0"/>
                                </div>
                                <div class="gc-target">of ₹<fmt:formatNumber value="${g.target}" groupingUsed="true" maxFractionDigits="0"/> goal</div>
                            </div>
                            <div class="goal-bar">
                                <div class="goal-fill" style="width:${pct > 100 ? 100 : pct}%;background:${g.color}"></div>
                            </div>
                            <div class="gc-bottom">
                                <span class="gc-left-amt">₹<fmt:formatNumber value="${g.target - g.saved}" groupingUsed="true" maxFractionDigits="0"/> to go</span>
                                <span class="gc-pct" style="color:${g.color}"><fmt:formatNumber value="${pct}" maxFractionDigits="0"/>%</span>
                            </div>
                            <button class="gc-contribute" onclick="openContribute(${g.id})">+ Add Money</button>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <%-- JS sample rendering --%>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>

<!-- ADD GOAL MODAL -->
<div class="modal-backdrop" id="addGoalModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Create New Goal</span>
            <button class="modal-close" onclick="closeModal('addGoalModal')">×</button>
        </div>
        <form action="${pageContext.request.contextPath}/goals/add" method="POST">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="form-row">
                <div class="form-group">
                    <label>Goal Name</label>
                    <input type="text" name="name" placeholder="e.g. Emergency Fund" required>
                </div>
                <div class="form-group">
                    <label>Emoji</label>
                    <input type="text" name="emoji" placeholder="🏠" maxlength="4">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Target Amount (₹)</label>
                    <input type="number" name="target" placeholder="100000" min="1" required>
                </div>
                <div class="form-group">
                    <label>Already Saved (₹)</label>
                    <input type="number" name="saved" placeholder="0" min="0" value="0">
                </div>
            </div>
            <div class="form-group">
                <label>Target Date</label>
                <input type="date" name="deadline" required>
            </div>
            <div class="form-group">
                <label>Notes (optional)</label>
                <textarea name="notes" placeholder="Why is this goal important..."></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('addGoalModal')">Cancel</button>
                <button type="submit" class="btn-primary">Create Goal</button>
            </div>
        </form>
    </div>
</div>

<!-- CONTRIBUTE MODAL -->
<div class="modal-backdrop" id="contributeModal">
    <div class="modal">
        <div class="modal-header">
            <span class="modal-title">Add Money to Goal</span>
            <button class="modal-close" onclick="closeModal('contributeModal')">×</button>
        </div>
        <form action="${pageContext.request.contextPath}/goals/contribute" method="POST">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <input type="hidden" name="goalId" id="contributeGoalId">
            <div class="form-group">
                <label>Amount to Add (₹)</label>
                <input type="number" name="amount" placeholder="5000" min="1" required>
            </div>
            <div class="form-group">
                <label>Date</label>
                <input type="date" name="date" id="contributeDate" required>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('contributeModal')">Cancel</button>
                <button type="submit" class="btn-primary">Add Funds</button>
            </div>
        </form>
    </div>
</div>

<script>
function openModal(id)  { document.getElementById(id).classList.add('open'); }
function closeModal(id) { document.getElementById(id).classList.remove('open'); }
function openContribute(id) {
    document.getElementById('contributeGoalId').value = id;
    document.getElementById('contributeDate').value = new Date().toISOString().split('T')[0];
    openModal('contributeModal');
}

// Sample goals for design preview
const goals = [
    {emoji:'🏠', name:'House Down Payment', saved:120000, target:300000, color:'#c9a84c', colorBg:'rgba(201,168,76,0.12)'},
    {emoji:'🚗', name:'New Car Fund',        saved:35000,  target:80000,  color:'#5b8dee', colorBg:'rgba(91,141,238,0.12)'},
    {emoji:'🎓', name:'Education Fund',      saved:18000,  target:50000,  color:'#3cb97c', colorBg:'rgba(60,185,124,0.12)'},
    {emoji:'✈️', name:'Europe Trip',         saved:7000,   target:90000,  color:'#b090e0', colorBg:'rgba(160,120,220,0.12)'},
];
const grid = document.getElementById('goalsGrid');
if (!grid.children.length) {
    goals.forEach((g, i) => {
        const pct = Math.round(g.saved / g.target * 100);
        const rem = (g.target - g.saved).toLocaleString('en-IN');
        grid.insertAdjacentHTML('beforeend', `
            <div class="goal-card fade-up" style="animation-delay:${i * 0.06}s">
                <div class="gc-top">
                    <div class="gc-icon" style="background:${g.colorBg}">${g.emoji}</div>
                    <div class="gc-meta">
                        <div class="gc-name">${g.name}</div>
                        <div class="gc-deadline">Target: Dec 2026</div>
                    </div>
                    <div class="gc-actions">
                        <button class="icon-btn">✏️</button>
                        <button class="icon-btn">🗑</button>
                    </div>
                </div>
                <div class="gc-amounts">
                    <div class="gc-current" style="color:${g.color}">₹${g.saved.toLocaleString('en-IN')}</div>
                    <div class="gc-target">of ₹${g.target.toLocaleString('en-IN')} goal</div>
                </div>
                <div class="goal-bar"><div class="goal-fill" style="width:${pct}%;background:${g.color}"></div></div>
                <div class="gc-bottom">
                    <span class="gc-left-amt">₹${rem} to go</span>
                    <span class="gc-pct" style="color:${g.color}">${pct}%</span>
                </div>
                <button class="gc-contribute">+ Add Money</button>
            </div>
        `);
    });
}
</script>
</body>
</html>