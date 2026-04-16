<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="currentPage" value="settings" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FinVault — Settings</title>
    <%@ include file="base-styles.jsp" %>
    <style>
        .settings-layout { display:grid;grid-template-columns:220px 1fr;gap:1.5rem; }

        /* Settings sidebar nav */
        .settings-nav { background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:.5rem 0;height:fit-content; }
        .s-nav-item { display:flex;align-items:center;gap:.7rem;padding:.72rem 1.2rem;font-size:.9rem;color:var(--muted);cursor:pointer;background:none;border:none;width:100%;text-align:left;transition:all .15s; }
        .s-nav-item:hover { color:var(--cream);background:rgba(255,255,255,.04); }
        .s-nav-item.active { color:var(--gold);background:rgba(201,168,76,.08);border-right:2px solid var(--gold); }
        .s-nav-icon { font-size:1rem;width:20px;text-align:center; }

        /* Section panes */
        .settings-pane { display:none; }
        .settings-pane.active { display:block; }

        /* Toggle switch */
        .setting-row { display:flex;align-items:center;justify-content:space-between;padding:1rem 0;border-bottom:1px solid var(--border); }
        .setting-row:last-child { border-bottom:none; }
        .setting-info .s-title { font-size:.93rem;font-weight:500;margin-bottom:.2rem; }
        .setting-info .s-desc  { font-size:.8rem;color:var(--muted); }

        .toggle { position:relative;width:44px;height:24px;flex-shrink:0; }
        .toggle input { opacity:0;width:0;height:0; }
        .toggle-slider { position:absolute;inset:0;background:rgba(255,255,255,.12);border-radius:24px;cursor:pointer;transition:background .2s; }
        .toggle-slider::before { content:'';position:absolute;width:18px;height:18px;left:3px;top:3px;background:white;border-radius:50%;transition:transform .2s; }
        .toggle input:checked + .toggle-slider { background:var(--gold); }
        .toggle input:checked + .toggle-slider::before { transform:translateX(20px); }

        .settings-section-title { font-family:'DM Serif Display',serif;font-size:1.15rem;margin-bottom:1.2rem;padding-bottom:.6rem;border-bottom:1px solid var(--border); }

        /* Category management */
        .category-chip { display:inline-flex;align-items:center;gap:.5rem;padding:.35rem .75rem;background:rgba(255,255,255,.06);border:1px solid var(--border);border-radius:8px;font-size:.82rem;margin:.3rem; }
        .chip-del { background:none;border:none;color:var(--muted);cursor:pointer;font-size:.9rem;padding:0;line-height:1; }
        .chip-del:hover { color:var(--expense); }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div class="main">
    <div class="topbar">
        <h1>Settings</h1>
    </div>

    <div class="content">
        <c:if test="${not empty success}"><div class="alert alert-success">✓ ${success}</div></c:if>

        <div class="settings-layout fade-up">

            <!-- Settings nav -->
            <div class="settings-nav">
                <button class="s-nav-item active" onclick="showPane('notifications',this)"><span class="s-nav-icon">🔔</span> Notifications</button>
                <button class="s-nav-item" onclick="showPane('appearance',this)"><span class="s-nav-icon">🎨</span> Appearance</button>
                <button class="s-nav-item" onclick="showPane('categories',this)"><span class="s-nav-icon">🏷</span> Categories</button>
                <button class="s-nav-item" onclick="showPane('privacy',this)"><span class="s-nav-icon">🔒</span> Privacy</button>
                <button class="s-nav-item" onclick="showPane('data',this)"><span class="s-nav-icon">💾</span> Data & Backup</button>
            </div>

            <!-- Panes -->
            <div class="panel fade-up delay-1">

                <!-- NOTIFICATIONS -->
                <div class="settings-pane active" id="pane-notifications">
                    <div class="settings-section-title">Notification Settings</div>
                    <form action="${pageContext.request.contextPath}/settings/notifications" method="POST">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="s-title">Budget Alerts</div>
                                <div class="s-desc">Notify when spending exceeds budget threshold</div>
                            </div>
                            <label class="toggle"><input type="checkbox" name="budgetAlert" ${settings.budgetAlert ? 'checked' : 'checked'}><span class="toggle-slider"></span></label>
                        </div>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="s-title">Goal Milestones</div>
                                <div class="s-desc">Notify when you reach 25%, 50%, 75%, 100% of a goal</div>
                            </div>
                            <label class="toggle"><input type="checkbox" name="goalMilestone" ${settings.goalMilestone ? 'checked' : 'checked'}><span class="toggle-slider"></span></label>
                        </div>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="s-title">Monthly Summary Email</div>
                                <div class="s-desc">Receive a summary of your month every 1st</div>
                            </div>
                            <label class="toggle"><input type="checkbox" name="monthlySummary" ${settings.monthlySummary ? 'checked' : ''}><span class="toggle-slider"></span></label>
                        </div>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="s-title">Large Transaction Alert</div>
                                <div class="s-desc">Alert for any single transaction above ₹5,000</div>
                            </div>
                            <label class="toggle"><input type="checkbox" name="largeTxAlert" ${settings.largeTxAlert ? 'checked' : 'checked'}><span class="toggle-slider"></span></label>
                        </div>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="s-title">Weekly Digest</div>
                                <div class="s-desc">Get a weekly spending summary every Sunday</div>
                            </div>
                            <label class="toggle"><input type="checkbox" name="weeklyDigest"><span class="toggle-slider"></span></label>
                        </div>
                        <div style="margin-top:1.5rem">
                            <button type="submit" class="btn-primary">Save Notification Prefs</button>
                        </div>
                    </form>
                </div>

                <!-- APPEARANCE -->
                <div class="settings-pane" id="pane-appearance">
                    <div class="settings-section-title">Appearance</div>
                    <form action="${pageContext.request.contextPath}/settings/appearance" method="POST">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="form-group">
                            <label>Theme</label>
                            <select name="theme">
                                <option value="dark" selected>Dark (Default)</option>
                                <option value="light">Light</option>
                                <option value="system">Follow System</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Date Format</label>
                            <select name="dateFormat">
                                <option value="DD MMM YYYY" selected>05 Apr 2026</option>
                                <option value="DD/MM/YYYY">05/04/2026</option>
                                <option value="MM/DD/YYYY">04/05/2026</option>
                                <option value="YYYY-MM-DD">2026-04-05</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Number Format</label>
                            <select name="numberFormat">
                                <option value="IN">₹1,23,456 (Indian)</option>
                                <option value="INTL">₹123,456 (International)</option>
                            </select>
                        </div>
                        <button type="submit" class="btn-primary">Save Appearance</button>
                    </form>
                </div>

                <!-- CATEGORIES -->
                <div class="settings-pane" id="pane-categories">
                    <div class="settings-section-title">Manage Categories</div>
                    <p style="font-size:.88rem;color:var(--muted);margin-bottom:1rem">Add custom categories for your transactions.</p>
                    <div id="categoryChips">
                        <c:choose>
                            <c:when test="${not empty categories}">
                                <c:forEach var="cat" items="${categories}">
                                    <span class="category-chip">${cat.emoji} ${cat.name}
                                        <button class="chip-del" onclick="deleteCategory(${cat.id})">✕</button>
                                    </span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span class="category-chip">🍔 Food <button class="chip-del" onclick="this.parentElement.remove()">✕</button></span>
                                <span class="category-chip">🛒 Shopping <button class="chip-del" onclick="this.parentElement.remove()">✕</button></span>
                                <span class="category-chip">🚌 Travel <button class="chip-del" onclick="this.parentElement.remove()">✕</button></span>
                                <span class="category-chip">💊 Health <button class="chip-del" onclick="this.parentElement.remove()">✕</button></span>
                                <span class="category-chip">📱 Utilities <button class="chip-del" onclick="this.parentElement.remove()">✕</button></span>
                                <span class="category-chip">🎮 Entertainment <button class="chip-del" onclick="this.parentElement.remove()">✕</button></span>
                                <span class="category-chip">👗 Clothing <button class="chip-del" onclick="this.parentElement.remove()">✕</button></span>
                                <span class="category-chip">🏠 Rent <button class="chip-del" onclick="this.parentElement.remove()">✕</button></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <form action="${pageContext.request.contextPath}/settings/categories/add" method="POST" style="margin-top:1.3rem;display:flex;gap:.8rem;align-items:flex-end;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="form-group" style="margin:0;width:80px;">
                            <label>Emoji</label>
                            <input type="text" name="emoji" placeholder="🏷" maxlength="4" style="text-align:center">
                        </div>
                        <div class="form-group" style="margin:0;flex:1">
                            <label>Category Name</label>
                            <input type="text" name="name" placeholder="e.g. Pet Care" required>
                        </div>
                        <button type="submit" class="btn-primary" style="margin-bottom:0">+ Add</button>
                    </form>
                </div>

                <!-- PRIVACY -->
                <div class="settings-pane" id="pane-privacy">
                    <div class="settings-section-title">Privacy Settings</div>
                    <form action="${pageContext.request.contextPath}/settings/privacy" method="POST">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="s-title">Session Timeout</div>
                                <div class="s-desc">Auto-logout after inactivity</div>
                            </div>
                            <select name="sessionTimeout" style="background:var(--slate);border:1px solid var(--border);color:var(--cream);border-radius:8px;padding:.5rem .8rem;font-family:'DM Sans',sans-serif;outline:none;">
                                <option value="30">30 minutes</option>
                                <option value="60" selected>1 hour</option>
                                <option value="120">2 hours</option>
                                <option value="0">Never</option>
                            </select>
                        </div>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="s-title">Two-Factor Authentication</div>
                                <div class="s-desc">Add an extra layer of security at login</div>
                            </div>
                            <label class="toggle"><input type="checkbox" name="twoFactor"><span class="toggle-slider"></span></label>
                        </div>
                        <div class="setting-row">
                            <div class="setting-info">
                                <div class="s-title">Hide Amounts on Dashboard</div>
                                <div class="s-desc">Blur monetary values for screen privacy</div>
                            </div>
                            <label class="toggle"><input type="checkbox" name="hideAmounts"><span class="toggle-slider"></span></label>
                        </div>
                        <div style="margin-top:1.5rem">
                            <button type="submit" class="btn-primary">Save Privacy Settings</button>
                        </div>
                    </form>
                </div>

                <!-- DATA & BACKUP -->
                <div class="settings-pane" id="pane-data">
                    <div class="settings-section-title">Data & Backup</div>
                    <div class="setting-row">
                        <div class="setting-info">
                            <div class="s-title">Export All Transactions</div>
                            <div class="s-desc">Download a CSV of all your transaction history</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/transactions/export" class="btn-secondary">⬇ CSV</a>
                    </div>
                    <div class="setting-row">
                        <div class="setting-info">
                            <div class="s-title">Export Full Report</div>
                            <div class="s-desc">Download PDF report with charts and analysis</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/reports/export" class="btn-secondary">⬇ PDF</a>
                    </div>
                    <div class="setting-row">
                        <div class="setting-info">
                            <div class="s-title">Import Transactions</div>
                            <div class="s-desc">Upload a CSV file to bulk-import transactions</div>
                        </div>
                        <form action="${pageContext.request.contextPath}/transactions/import" method="POST" enctype="multipart/form-data" style="display:flex;align-items:center;gap:.6rem">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="file" name="csvFile" accept=".csv" style="display:none" id="csvInput" onchange="this.form.submit()">
                            <button type="button" class="btn-secondary" onclick="document.getElementById('csvInput').click()">⬆ Upload CSV</button>
                        </form>
                    </div>
                </div>

            </div><!-- /panel -->
        </div><!-- /settings-layout -->
    </div>
</div>

<script>
function showPane(id, btn) {
    document.querySelectorAll('.settings-pane').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.s-nav-item').forEach(b => b.classList.remove('active'));
    document.getElementById('pane-' + id).classList.add('active');
    btn.classList.add('active');
}
function deleteCategory(id) {
    if(confirm('Delete this category?')) window.location = '${pageContext.request.contextPath}/settings/categories/delete/' + id;
}
</script>
</body>
</html>
