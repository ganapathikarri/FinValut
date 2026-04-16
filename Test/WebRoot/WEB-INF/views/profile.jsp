<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="currentPage" value="profile" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FinVault — Profile</title>
    <%@ include file="base-styles.jsp" %>
    <style>
        .profile-layout { display:grid;grid-template-columns:300px 1fr;gap:1.5rem; }

        /* Avatar card */
        .avatar-card {
            background:var(--card);border:1px solid var(--border);border-radius:var(--radius);
            padding:2rem;text-align:center;animation:fadeUp .4s ease both;
        }
        .avatar-big {
            width:88px;height:88px;margin:0 auto 1rem;
            background:linear-gradient(135deg,var(--gold),var(--gold-light));
            border-radius:50%;display:flex;align-items:center;justify-content:center;
            font-family:'DM Serif Display',serif;font-size:2.2rem;color:var(--ink);
        }
        .profile-name { font-family:'DM Serif Display',serif;font-size:1.5rem;margin-bottom:.2rem; }
        .profile-email { font-size:.85rem;color:var(--muted);margin-bottom:1.2rem; }
        .profile-badge { display:inline-block;padding:.3rem .8rem;background:rgba(201,168,76,.12);color:var(--gold);border-radius:6px;font-size:.78rem;font-weight:600;margin-bottom:1.5rem; }
        .profile-stats { display:flex;justify-content:space-around;padding-top:1rem;border-top:1px solid var(--border); }
        .ps-item { text-align:center; }
        .ps-num { font-family:'DM Serif Display',serif;font-size:1.3rem;color:var(--gold); }
        .ps-lbl { font-size:.72rem;color:var(--muted);text-transform:uppercase;letter-spacing:.06em; }

        /* Tabs */
        .tab-bar { display:flex;gap:0;border-bottom:1px solid var(--border);margin-bottom:1.5rem; }
        .tab-btn { padding:.7rem 1.3rem;background:none;border:none;border-bottom:2px solid transparent;color:var(--muted);font-family:'DM Sans',sans-serif;font-size:.9rem;font-weight:500;cursor:pointer;transition:all .15s;margin-bottom:-1px; }
        .tab-btn.active { color:var(--gold);border-bottom-color:var(--gold); }
        .tab-btn:hover:not(.active) { color:var(--cream); }

        .tab-pane { display:none; }
        .tab-pane.active { display:block; }

        /* Change password section */
        .section-title { font-family:'DM Serif Display',serif;font-size:1.1rem;margin-bottom:1.2rem;padding-bottom:.6rem;border-bottom:1px solid var(--border); }
        .danger-zone { margin-top:2rem;padding:1.2rem;border:1px solid rgba(224,82,82,.3);border-radius:12px;background:rgba(224,82,82,.05); }
        .danger-zone .section-title { color:#f08080;border-bottom-color:rgba(224,82,82,.2); }
    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div class="main">
    <div class="topbar">
        <h1>My Profile</h1>
        <div class="topbar-actions">
            <button class="btn-secondary">⬇ Export My Data</button>
        </div>
    </div>

    <div class="content">
        <c:if test="${not empty success}"><div class="alert alert-success">✓ ${success}</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-error">⚠ ${error}</div></c:if>

        <div class="profile-layout">

            <!-- Left: Avatar card -->
            <div>
                <div class="avatar-card">
                    <div class="avatar-big">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">${fn:substring(sessionScope.user.firstName,0,1)}</c:when>
                            <c:otherwise>U</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="profile-name">
                        <c:out value="${not empty sessionScope.user ? sessionScope.user.firstName.concat(' ').concat(sessionScope.user.lastName) : 'Ravi Kumar'}"/>
                    </div>
                    <div class="profile-email">
                        <c:out value="${not empty sessionScope.user ? sessionScope.user.email : 'ravi@example.com'}"/>
                    </div>
                    <div class="profile-badge">Personal Plan</div>
                    <div style="font-size:.82rem;color:var(--muted);margin-bottom:1.5rem">
                        Member since <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="MMM yyyy" var="memberSince"/>
                        <c:out value="${not empty memberSince ? memberSince : 'Jan 2026'}"/>
                    </div>
                    <div class="profile-stats">
                        <div class="ps-item"><div class="ps-num">${txCount != null ? txCount : 142}</div><div class="ps-lbl">Txns</div></div>
                        <div class="ps-item"><div class="ps-num">${goalCount != null ? goalCount : 4}</div><div class="ps-lbl">Goals</div></div>
                        <div class="ps-item"><div class="ps-num">${budgetCount != null ? budgetCount : 8}</div><div class="ps-lbl">Budgets</div></div>
                    </div>
                </div>
            </div>

            <!-- Right: Tabs -->
            <div class="panel fade-up delay-1">
                <div class="tab-bar">
                    <button class="tab-btn active" onclick="showTab('personal',this)">Personal Info</button>
                    <button class="tab-btn" onclick="showTab('financial',this)">Financial Settings</button>
                    <button class="tab-btn" onclick="showTab('security',this)">Security</button>
                </div>

                <!-- Personal Info Tab -->
                <div class="tab-pane active" id="tab-personal">
                    <div class="section-title">Personal Information</div>
                    <form action="${pageContext.request.contextPath}/profile/update" method="POST">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="form-row">
                            <div class="form-group">
                                <label>First Name</label>
                                <input type="text" name="firstName" value="${sessionScope.user.firstName}" placeholder="Ravi" required>
                            </div>
                            <div class="form-group">
                                <label>Last Name</label>
                                <input type="text" name="lastName" value="${sessionScope.user.lastName}" placeholder="Kumar" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" value="${sessionScope.user.email}" placeholder="ravi@example.com" required>
                        </div>
                        <div class="form-group">
                            <label>Mobile Number</label>
                            <input type="tel" name="phone" value="${sessionScope.user.phone}" placeholder="+91 9XXXXXXXXX">
                        </div>
                        <div class="form-group">
                            <label>Date of Birth</label>
                            <input type="date" name="dob" value="${sessionScope.user.dob}">
                        </div>
                        <div class="form-group">
                            <label>Bio (optional)</label>
                            <textarea name="bio" placeholder="A short note about yourself...">${sessionScope.user.bio}</textarea>
                        </div>
                        <button type="submit" class="btn-primary">Save Changes</button>
                    </form>
                </div>

                <!-- Financial Settings Tab -->
                <div class="tab-pane" id="tab-financial">
                    <div class="section-title">Financial Preferences</div>
                    <form action="${pageContext.request.contextPath}/profile/financial" method="POST">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Currency</label>
                                <select name="currency">
                                    <option value="INR" ${sessionScope.user.currency=='INR'?'selected':''}>₹ Indian Rupee (INR)</option>
                                    <option value="USD" ${sessionScope.user.currency=='USD'?'selected':''}>$ US Dollar (USD)</option>
                                    <option value="EUR" ${sessionScope.user.currency=='EUR'?'selected':''}>€ Euro (EUR)</option>
                                    <option value="GBP" ${sessionScope.user.currency=='GBP'?'selected':''}>£ British Pound (GBP)</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Month Start Day</label>
                                <select name="monthStartDay">
                                    <option value="1" ${sessionScope.user.monthStartDay=='1'?'selected':''}>1st of month</option>
                                    <option value="15" ${sessionScope.user.monthStartDay=='15'?'selected':''}>15th of month</option>
                                    <option value="25" ${sessionScope.user.monthStartDay=='25'?'selected':''}>25th of month</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Monthly Income (₹)</label>
                                <input type="number" name="monthlyIncome" value="${sessionScope.user.monthlyIncome}" placeholder="65000">
                            </div>
                            <div class="form-group">
                                <label>Savings Goal (%)</label>
                                <input type="number" name="savingsGoalPct" value="${sessionScope.user.savingsGoalPct}" placeholder="30" min="1" max="100">
                            </div>
                        </div>
                        <button type="submit" class="btn-primary">Save Preferences</button>
                    </form>
                </div>

                <!-- Security Tab -->
                <div class="tab-pane" id="tab-security">
                    <div class="section-title">Change Password</div>
                    <form action="${pageContext.request.contextPath}/profile/change-password" method="POST" id="pwForm">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="form-group">
                            <label>Current Password</label>
                            <input type="password" name="currentPassword" placeholder="Enter current password" required>
                        </div>
                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" name="newPassword" id="newPw" placeholder="Min. 8 characters" required>
                        </div>
                        <div class="form-group">
                            <label>Confirm New Password</label>
                            <input type="password" name="confirmPassword" id="confPw" placeholder="Repeat new password" required>
                        </div>
                        <div class="alert alert-error" id="pwErr" style="display:none;">Passwords do not match.</div>
                        <button type="submit" class="btn-primary">Update Password</button>
                    </form>

                    <div class="danger-zone">
                        <div class="section-title">Danger Zone</div>
                        <p style="font-size:.88rem;color:var(--muted);margin-bottom:1rem">Permanently delete your account and all associated data. This action cannot be undone.</p>
                        <button class="btn-danger" onclick="if(confirm('Are you absolutely sure? This cannot be undone.')) window.location='${pageContext.request.contextPath}/profile/delete'">
                            🗑 Delete My Account
                        </button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script>
function showTab(id, btn) {
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + id).classList.add('active');
    btn.classList.add('active');
}
document.getElementById('pwForm').addEventListener('submit', function(e) {
    const err = document.getElementById('pwErr');
    if(document.getElementById('newPw').value !== document.getElementById('confPw').value) {
        e.preventDefault();
        err.style.display = 'flex';
    } else { err.style.display = 'none'; }
});
</script>
</body>
</html>