<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FinVault — Create Account</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
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
            align-items: center;
            justify-content: center;
            padding: 2rem 1rem;
        }

        /* Background decoration */
        body::before {
            content: '';
            position: fixed;
            top: -200px; right: -200px;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(201,168,76,0.07) 0%, transparent 65%);
            pointer-events: none;
        }

        body::after {
            content: '';
            position: fixed;
            bottom: -200px; left: -200px;
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(201,168,76,0.05) 0%, transparent 65%);
            pointer-events: none;
        }

        .page-wrap {
            width: 100%;
            max-width: 560px;
            animation: fadeUp 0.5s ease forwards;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Top logo bar */
        .top-bar {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo {
            display: inline-flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }

        .logo-icon {
            width: 40px; height: 40px;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
        }

        .logo-text {
            font-family: 'DM Serif Display', serif;
            font-size: 1.5rem;
            color: var(--cream);
        }

        /* Card */
        .card {
            background: var(--slate);
            border: 1px solid rgba(255,255,255,0.07);
            border-radius: 18px;
            padding: 2.5rem;
        }

        .card-header {
            margin-bottom: 2rem;
        }

        .card-header h1 {
            font-family: 'DM Serif Display', serif;
            font-size: 2rem;
            margin-bottom: 0.35rem;
        }

        .card-header p {
            color: var(--muted);
            font-size: 0.93rem;
        }

        .card-header p a {
            color: var(--gold);
            text-decoration: none;
            font-weight: 500;
        }

        /* Alert */
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

        /* Two-col grid */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        /* Form group */
        .form-group {
            margin-bottom: 1.3rem;
        }

        .form-group label {
            display: block;
            font-size: 0.78rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--muted);
            margin-bottom: 0.45rem;
        }

        .input-wrap { position: relative; }

        .input-wrap .icon {
            position: absolute;
            left: 1rem; top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 0.95rem;
            pointer-events: none;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.82rem 1rem 0.82rem 2.7rem;
            background: rgba(255,255,255,0.04);
            border: 1.5px solid rgba(255,255,255,0.09);
            border-radius: 10px;
            color: var(--cream);
            font-family: 'DM Sans', sans-serif;
            font-size: 0.93rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            appearance: none;
        }

        .form-group select {
            padding-left: 2.7rem;
            cursor: pointer;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 3px rgba(201,168,76,0.12);
        }

        .form-group input::placeholder { color: rgba(107,114,128,0.7); }

        /* Password strength bar */
        .strength-wrap {
            margin-top: 0.5rem;
        }

        .strength-bar {
            height: 4px;
            border-radius: 4px;
            background: rgba(255,255,255,0.08);
            overflow: hidden;
        }

        .strength-fill {
            height: 100%;
            border-radius: 4px;
            width: 0%;
            transition: width 0.3s, background 0.3s;
        }

        .strength-label {
            font-size: 0.75rem;
            color: var(--muted);
            margin-top: 0.3rem;
        }

        /* Terms */
        .terms-wrap {
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            margin-bottom: 1.8rem;
            padding: 1rem;
            background: rgba(255,255,255,0.03);
            border-radius: 10px;
            border: 1px solid rgba(255,255,255,0.06);
        }

        .terms-wrap input[type="checkbox"] {
            accent-color: var(--gold);
            width: 16px; height: 16px;
            flex-shrink: 0;
            margin-top: 2px;
        }

        .terms-wrap label {
            font-size: 0.86rem;
            color: var(--muted);
            line-height: 1.5;
            cursor: pointer;
        }

        .terms-wrap label a {
            color: var(--gold);
            text-decoration: none;
        }

        /* Submit button */
        .btn-primary {
            width: 100%;
            padding: 0.95rem;
            background: linear-gradient(135deg, var(--gold), var(--gold-light));
            color: var(--ink);
            border: none;
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: 0.98rem;
            font-weight: 700;
            cursor: pointer;
            letter-spacing: 0.03em;
            transition: opacity 0.2s, transform 0.15s;
        }

        .btn-primary:hover { opacity: 0.9; transform: translateY(-1px); }
        .btn-primary:active { transform: translateY(0); }

        /* Already have account */
        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: var(--muted);
        }

        .login-link a {
            color: var(--gold);
            font-weight: 500;
            text-decoration: none;
        }

        /* Field error hints */
        .field-error {
            font-size: 0.78rem;
            color: #f08080;
            margin-top: 0.3rem;
        }

        @media (max-width: 520px) {
            .form-row { grid-template-columns: 1fr; }
            .card { padding: 1.8rem 1.4rem; }
        }
    </style>
</head>
<body>

    <div class="page-wrap">

        <div class="top-bar">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <div class="logo-icon">💰</div>
                <span class="logo-text">FinVault</span>
            </a>
        </div>

        <div class="card">
            <div class="card-header">
                <h1>Create your account</h1>
                <p>Already have one? <a href="login">Sign in instead</a></p>
            </div>

            <!-- Server-side validation errors -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠ ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/registerSubmittion" method="POST" id="registerForm" novalidate>
                

                <!-- Name row -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">User Name</label>
                        <div class="input-wrap">
                            <span class="icon">👤</span>
                            <input type="text" id="firstName" name="firstName"
                                   placeholder="Ravi"
                                   value="${param.username}"
                                   required>
                        </div>
                    </div>
                 
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrap">
                        <span class="icon">✉</span>
                        <input type="email" id="email" name="email"
                               placeholder="ravi@example.com"
                               value="${param.email}"
                               required autocomplete="email">
                    </div>
                </div>

                <!-- Phone -->
                <div class="form-group">
                    <label for="phone">Mobile Number</label>
                    <div class="input-wrap">
                        <span class="icon">📱</span>
                        <input type="tel" id="phone" name="phone"
                               placeholder="+91 9XXXXXXXXX"
                               value="${param.phone}"
                               pattern="[0-9+\s\-]{10,14}">
                    </div>
                </div>

                <!-- Currency & Income row -->
                <div class="form-row">
                    <div class="form-group">
                        <label for="currency">Currency</label>
                        <div class="input-wrap">
                            <span class="icon">💱</span>
                            <select id="currency" name="currency">
                                <option value="INR" ${param.currency == 'INR' ? 'selected' : ''}>₹ INR</option>
                                <option value="USD" ${param.currency == 'USD' ? 'selected' : ''}>$ USD</option>
                                <option value="EUR" ${param.currency == 'EUR' ? 'selected' : ''}>€ EUR</option>
                                <option value="GBP" ${param.currency == 'GBP' ? 'selected' : ''}>£ GBP</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="monthlyIncome">Monthly Income</label>
                        <div class="input-wrap">
                            <span class="icon">💼</span>
                            <input type="number" id="monthlyIncome" name="monthlyIncome"
                                   placeholder="50000"
                                   value="${param.monthlyIncome}"
                                   min="0">
                        </div>
                    </div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-wrap">
                        <span class="icon">🔒</span>
                        <input type="password" id="password" name="password"
                               placeholder="Min. 8 characters"
                               required autocomplete="new-password"
                               oninput="checkStrength(this.value)">
                    </div>
                    <div class="strength-wrap">
                        <div class="strength-bar">
                            <div class="strength-fill" id="strengthFill"></div>
                        </div>
                        <div class="strength-label" id="strengthLabel">Enter a password</div>
                    </div>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <div class="input-wrap">
                        <span class="icon">🔑</span>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Re-enter password"
                               required autocomplete="new-password">
                    </div>
                    <div class="field-error" id="pwMatchErr" style="display:none;">Passwords do not match.</div>
                </div>

                <!-- Terms -->
                <div class="terms-wrap">
                    <input type="checkbox" id="terms" name="agreeTerms" value="true" required>
                    <label for="terms">
                        I agree to the <a href="terms" target="_blank">Terms of Service</a> and
                        <a href="privacy" target="_blank">Privacy Policy</a>. I understand that my data
                        is kept secure and never shared.
                    </label>
                </div>

                <button type="submit" class="btn-primary">Create My Account →</button>
            </form>

            <div class="login-link">
                Already registered? <a href="login">Sign in here</a>
            </div>

        </div>
    </div>

    <script>
        function checkStrength(val) {
            const fill  = document.getElementById('strengthFill');
            const label = document.getElementById('strengthLabel');
            let score = 0;
            if (val.length >= 8)  score++;
            if (/[A-Z]/.test(val))     score++;
            if (/[0-9]/.test(val))     score++;
            if (/[^A-Za-z0-9]/.test(val)) score++;

            const levels = [
                { pct: '0%',   color: 'transparent', text: 'Enter a password' },
                { pct: '25%',  color: '#e05252',      text: 'Weak' },
                { pct: '50%',  color: '#e0a552',      text: 'Fair' },
                { pct: '75%',  color: '#e0d052',      text: 'Good' },
                { pct: '100%', color: '#3cb97c',       text: 'Strong ✓' },
            ];
            const l = levels[score];
            fill.style.width = l.pct;
            fill.style.background = l.color;
            label.textContent = l.text;
            label.style.color = l.color === 'transparent' ? '#6b7280' : l.color;
        }

        // Client-side password match check
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const p1 = document.getElementById('password').value;
            const p2 = document.getElementById('confirmPassword').value;
            const err = document.getElementById('pwMatchErr');
            if (p1 !== p2) {
                e.preventDefault();
                err.style.display = 'block';
                document.getElementById('confirmPassword').focus();
            } else {
                err.style.display = 'none';
            }
        });
    </script>

</body>
</html>
