<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FinVault — Sign In</title>

 
    <link href="https://fonts.googleap
    is.
    com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --ink: #0d1117;
            --slate: #1c2333;
            --gold: #c9a84c;
            --gold-light: #e8c96a;
            --cream: #f5f0e8;
            --muted: #6b7280;
            --error: #e05252;
            --success: #3cb97c;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--ink);
            color: var(--cream);
            min-height: 100vh;
            display: flex;
            overflow: hidden;
        }

        /* Left panel */
        .brand-panel {
            width: 45%;
            background: var(--slate);
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }

        .brand-panel::before {
            content: '';
            position: absolute;
            top: -120px; left: -120px;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(201,168,76,0.15) 0%, transparent 70%);
            pointer-events: none;
        }

        .brand-panel::after {
            content: '';
            position: absolute;
            bottom: -80px; right: -80px;
            width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(201,168,76,0.10) 0%, transparent 70%);
            pointer-events: none;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .logo-icon {
            width: 42px; height: 42px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem;
        }

        .logo-text {
            font-family: 'DM Serif Display', serif;
            font-size: 1.5rem;
            color: var(--cream);
            letter-spacing: 0.02em;
        }

        .brand-hero {
            position: relative; z-index: 1;
        }

        .brand-hero h2 {
            font-family: 'DM Serif Display', serif;
            font-size: 2.8rem;
            line-height: 1.15;
            color: var(--cream);
            margin-bottom: 1.2rem;
        }

        .brand-hero h2 em {
            color: var(--gold);
            font-style: italic;
        }

        .brand-hero p {
            color: var(--muted);
            font-size: 1rem;
            line-height: 1.7;
            max-width: 320px;
        }

        .stats-row {
            display: flex;
            gap: 2rem;
            position: relative; z-index: 1;
        }

        .stat {
            border-left: 2px solid var(--gold);
            padding-left: 1rem;
        }

        .stat-num {
            font-family: 'DM Serif Display', serif;
            font-size: 1.6rem;
            color: var(--gold-light);
        }

        .stat-label {
            font-size: 0.75rem;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        /* Right panel (form) */
        .form-panel {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 4rem;
            background: var(--ink);
        }

        .form-card {
            width: 100%;
            max-width: 400px;
            animation: slideUp 0.5s ease forwards;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .form-header {
            margin-bottom: 2.5rem;
        }

        .form-header h1 {
            font-family: 'DM Serif Display', serif;
            font-size: 2.2rem;
            margin-bottom: 0.4rem;
        }

        .form-header p {
            color: var(--muted);
            font-size: 0.95rem;
        }

        .form-header p a {
            color: var(--gold);
            text-decoration: none;
            font-weight: 500;
        }

        /* Alert message */
        .alert {
            padding: 0.85rem 1rem;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-error {
            background: rgba(224,82,82,0.12);
            border: 1px solid rgba(224,82,82,0.4);
            color: #f08080;
        }

        .alert-success {
            background: rgba(60,185,124,0.12);
            border: 1px solid rgba(60,185,124,0.4);
            color: #6ddba8;
        }

        /* Form group */
        .form-group {
            margin-bottom: 1.4rem;
        }

        .form-group label {
            display: block;
            font-size: 0.8rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--muted);
            margin-bottom: 0.5rem;
        }

        .input-wrap {
            position: relative;
        }

        .input-wrap .icon {
            position: absolute;
            left: 1rem; top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 1rem;
            pointer-events: none;
        }

        .form-group input {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 2.8rem;
            background: var(--slate);
            border: 1.5px solid rgba(255,255,255,0.08);
            border-radius: 10px;
            color: var(--cream);
            font-family: 'DM Sans', sans-serif;
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-group input:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(201,168,76,0.12);
        }

        .form-group input::placeholder { color: rgba(107,114,128,0.8); }

        .form-options {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.8rem;
        }

        .remember-me {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.88rem;
            color: var(--muted);
            cursor: pointer;
        }

        .remember-me input[type="checkbox"] {
            accent-color: var(--gold);
            width: 15px; height: 15px;
        }

        .forgot-link {
            font-size: 0.88rem;
            color: var(--gold);
            text-decoration: none;
            font-weight: 500;
        }

        .btn-primary {
            width: 100%;
            padding: 0.95rem;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: var(--ink);
            border: none;
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.98rem;
            font-weight: 600;
            cursor: pointer;
            letter-spacing: 0.03em;
            transition: opacity 0.2s, transform 0.15s;
        }

        .btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-primary:active { transform: translateY(0); }

        .divider {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin: 1.8rem 0;
        }

        .divider::before, .divider::after {
            content: ''; flex: 1;
            height: 1px;
            background: rgba(255,255,255,0.08);
        }

        .divider span {
            font-size: 0.8rem;
            color: var(--muted);
            white-space: nowrap;
        }

        .register-link {
            text-align: center;
            font-size: 0.9rem;
            color: var(--muted);
        }

        .register-link a {
            color: var(--gold);
            font-weight: 500;
            text-decoration: none;
        }

        @media (max-width: 768px) {
            .brand-panel { display: none; }
            .form-panel { padding: 2rem 1.5rem; }
        }
    </style>
</head>
<body>

    <!-- Left brand panel -->
    <div class="brand-panel">
        <div class="logo">
            <div class="logo-icon">💰</div>
            <span class="logo-text">FinVault</span>
        </div>

        <div class="brand-hero">
            <h2>Take control of your <em>financial future</em></h2>
            <p>Track spending, set goals, and grow your wealth — all in one place built just for you.</p>
        </div>

        <div class="stats-row">
            <div class="stat">
                <div class="stat-num">₹0</div>
                <div class="stat-label">Hidden fees</div>
            </div>
            <div class="stat">
                <div class="stat-num">100%</div>
                <div class="stat-label">Secure & Private</div>
            </div>
            <div class="stat">
                <div class="stat-num">24/7</div>
                <div class="stat-label">Access</div>
            </div>
        </div>
    </div>

    <!-- Right form panel -->
    <div class="form-panel">
        <div class="form-card">

            <div class="form-header">
                <h1>Welcome back</h1>
                <p>Don't have an account? <a href="register">Sign up free</a></p>
            </div>

            <!-- Error / Success messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠ ${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">✓ ${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/submit" method="POST">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrap">
                        <span class="icon">✉</span>
                        <input type="email" id="email" name="email"
                               placeholder="you@example.com"
                               value="${param.email}"
                               required autocomplete="email">
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrap">
                        <span class="icon">🔒</span>
                        <input type="password" id="password" name="password"
                               placeholder="Enter your password"
                               required autocomplete="current-password">
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="rememberMe" value="true"> Remember me
                    </label>
                    <a href="forgot-password" class="forgot-link">Forgot password?</a>
                </div>

                <button type="submit" class="btn-primary">Sign In →</button>
            </form>

            <div class="divider"><span>or</span></div>

            <div class="register-link">
                New to FinVault? <a href="register">Create an account</a>
            </div>

        </div>
    </div>

</body>
</html>