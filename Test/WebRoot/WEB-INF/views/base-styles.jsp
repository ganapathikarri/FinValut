<%-- Save as WEB-INF/views/includes/base-styles.jsp and include in every page --%>
<link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display:ital@0;1&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
/* ===== FINVAULT BASE STYLES ===== */
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

:root {
    --ink:        #0d1117;
    --slate:      #1c2333;
    --card:       #1e2a3a;
    --card2:      #162030;
    --gold:       #c9a84c;
    --gold-light: #e8c96a;
    --cream:      #f5f0e8;
    --muted:      #6b7280;
    --income:     #3cb97c;
    --expense:    #e05252;
    --saving:     #5b8dee;
    --border:     rgba(255,255,255,0.07);
    --radius:     14px;
}

body {
    font-family: 'DM Sans', sans-serif;
    background: var(--ink);
    color: var(--cream);
    min-height: 100vh;
    display: flex;
}

/* SIDEBAR */
.sidebar {
    width: 240px;
    background: var(--slate);
    border-right: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    padding: 1.5rem 0;
    position: fixed;
    top: 0; left: 0;
    height: 100vh;
    z-index: 100;
    overflow-y: auto;
}
.sidebar-logo { display:flex; align-items:center; gap:.7rem; padding:0 1.4rem 1.8rem; border-bottom:1px solid var(--border); margin-bottom:1.5rem; }
.logo-icon { width:36px;height:36px;background:linear-gradient(135deg,var(--gold),var(--gold-light));border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:1rem; }
.logo-text { font-family:'DM Serif Display',serif;font-size:1.3rem; }
.nav-label { font-size:.68rem;font-weight:600;text-transform:uppercase;letter-spacing:.1em;color:var(--muted);padding:0 1.4rem;margin-bottom:.4rem;margin-top:1.2rem;display:block; }
.nav-item { display:flex;align-items:center;gap:.75rem;padding:.7rem 1.4rem;text-decoration:none;color:var(--muted);font-size:.9rem;font-weight:500;transition:color .2s,background .2s;cursor:pointer;border:none;background:none;width:100%;text-align:left; }
.nav-item:hover { color:var(--cream);background:rgba(255,255,255,.04); }
.nav-item.active { color:var(--gold);background:rgba(201,168,76,.1);border-right:2px solid var(--gold); }
.nav-icon { font-size:1.05rem;width:22px;text-align:center; }
.sidebar-footer { margin-top:auto;padding:1.2rem 1.4rem;border-top:1px solid var(--border); }
.user-chip { display:flex;align-items:center;gap:.7rem; }
.avatar { width:34px;height:34px;background:linear-gradient(135deg,var(--gold),var(--gold-light));border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:.85rem;color:var(--ink);flex-shrink:0; }
.user-info .name { font-size:.88rem;font-weight:600; }
.user-info .role { font-size:.75rem;color:var(--muted); }

/* MAIN */
.main { margin-left:240px;flex:1;min-height:100vh;display:flex;flex-direction:column; }
.topbar { display:flex;align-items:center;justify-content:space-between;padding:1.2rem 2rem;border-bottom:1px solid var(--border);background:var(--ink);position:sticky;top:0;z-index:50; }
.topbar h1 { font-family:'DM Serif Display',serif;font-size:1.55rem; }
.topbar-actions { display:flex;align-items:center;gap:1rem; }
.content { padding:2rem;flex:1; }

/* BUTTONS */
.btn-primary { display:inline-flex;align-items:center;gap:.5rem;padding:.7rem 1.3rem;background:linear-gradient(135deg,var(--gold),var(--gold-light));color:var(--ink);border:none;border-radius:9px;font-family:'DM Sans',sans-serif;font-size:.88rem;font-weight:700;cursor:pointer;text-decoration:none;transition:opacity .2s,transform .15s; }
.btn-primary:hover { opacity:.88;transform:translateY(-1px); }
.btn-secondary { display:inline-flex;align-items:center;gap:.5rem;padding:.65rem 1.2rem;background:rgba(255,255,255,.06);color:var(--cream);border:1px solid var(--border);border-radius:9px;font-family:'DM Sans',sans-serif;font-size:.88rem;font-weight:500;cursor:pointer;text-decoration:none;transition:background .2s; }
.btn-secondary:hover { background:rgba(255,255,255,.1); }
.btn-danger { display:inline-flex;align-items:center;gap:.5rem;padding:.65rem 1.2rem;background:rgba(224,82,82,.12);color:#f08080;border:1px solid rgba(224,82,82,.3);border-radius:9px;font-family:'DM Sans',sans-serif;font-size:.88rem;font-weight:500;cursor:pointer;transition:background .2s; }
.btn-danger:hover { background:rgba(224,82,82,.22); }

/* CARDS / PANELS */
.panel { background:var(--card);border:1px solid var(--border);border-radius:var(--radius);padding:1.5rem; }
.panel-header { display:flex;align-items:center;justify-content:space-between;margin-bottom:1.2rem; }
.panel-title { font-family:'DM Serif Display',serif;font-size:1.1rem; }
.panel-link { font-size:.82rem;color:var(--gold);text-decoration:none;font-weight:500; }

/* FORM ELEMENTS */
.form-group { margin-bottom:1.3rem; }
.form-group label { display:block;font-size:.78rem;font-weight:600;text-transform:uppercase;letter-spacing:.08em;color:var(--muted);margin-bottom:.45rem; }
.form-group input,.form-group select,.form-group textarea {
    width:100%;padding:.82rem 1rem;background:rgba(255,255,255,.04);border:1.5px solid rgba(255,255,255,.09);
    border-radius:10px;color:var(--cream);font-family:'DM Sans',sans-serif;font-size:.93rem;outline:none;
    transition:border-color .2s,box-shadow .2s;
}
.form-group textarea { resize:vertical;min-height:90px; }
.form-group input:focus,.form-group select:focus,.form-group textarea:focus { border-color:var(--gold);box-shadow:0 0 0 3px rgba(201,168,76,.12); }
.form-group input::placeholder,.form-group textarea::placeholder { color:rgba(107,114,128,.7); }
.form-row { display:grid;grid-template-columns:1fr 1fr;gap:1rem; }
.form-row-3 { display:grid;grid-template-columns:1fr 1fr 1fr;gap:1rem; }

/* TABLE */
table { width:100%;border-collapse:collapse; }
thead th { font-size:.72rem;font-weight:600;text-transform:uppercase;letter-spacing:.07em;color:var(--muted);padding:.8rem 1.2rem;text-align:left;border-bottom:1px solid var(--border); }
tbody tr { border-bottom:1px solid var(--border);transition:background .15s; }
tbody tr:last-child { border-bottom:none; }
tbody tr:hover { background:rgba(255,255,255,.02); }
tbody td { padding:.85rem 1.2rem;font-size:.88rem;vertical-align:middle; }

/* BADGES */
.badge { display:inline-block;padding:.2rem .6rem;border-radius:5px;font-size:.74rem;font-weight:600; }
.badge-income   { background:rgba(60,185,124,.15);color:#3cb97c; }
.badge-expense  { background:rgba(224,82,82,.15);color:#e07070; }
.badge-food     { background:rgba(224,165,82,.15);color:#e0a552; }
.badge-shopping { background:rgba(91,141,238,.15);color:#7aa4f0; }
.badge-bills    { background:rgba(224,82,82,.15);color:#e07070; }
.badge-travel   { background:rgba(160,120,220,.15);color:#b090e0; }
.badge-health   { background:rgba(60,185,124,.12);color:#5dbf90; }
.badge-saving   { background:rgba(91,141,238,.15);color:#5b8dee; }

/* ALERTS */
.alert { padding:.85rem 1rem;border-radius:8px;font-size:.9rem;margin-bottom:1.5rem;display:flex;align-items:center;gap:.5rem; }
.alert-error   { background:rgba(224,82,82,.12);border:1px solid rgba(224,82,82,.4);color:#f08080; }
.alert-success { background:rgba(60,185,124,.12);border:1px solid rgba(60,185,124,.4);color:#6ddba8; }

/* ANIMATIONS */
@keyframes fadeUp { from{opacity:0;transform:translateY(16px)} to{opacity:1;transform:translateY(0)} }
.fade-up { animation:fadeUp .4s ease both; }
.delay-1 { animation-delay:.05s; }
.delay-2 { animation-delay:.10s; }
.delay-3 { animation-delay:.15s; }
.delay-4 { animation-delay:.20s; }
.delay-5 { animation-delay:.25s; }

/* MODAL */
.modal-backdrop { display:none;position:fixed;inset:0;background:rgba(0,0,0,.65);z-index:200;align-items:center;justify-content:center; }
.modal-backdrop.open { display:flex; }
.modal { background:var(--slate);border:1px solid var(--border);border-radius:18px;padding:2rem;width:100%;max-width:480px;animation:fadeUp .3s ease; }
.modal-header { display:flex;align-items:center;justify-content:space-between;margin-bottom:1.5rem; }
.modal-title { font-family:'DM Serif Display',serif;font-size:1.3rem; }
.modal-close { background:none;border:none;color:var(--muted);font-size:1.4rem;cursor:pointer;line-height:1; }
.modal-close:hover { color:var(--cream); }
.modal-footer { display:flex;justify-content:flex-end;gap:.8rem;margin-top:1.5rem; }

/* PROGRESS */
.progress-bar { height:6px;background:rgba(255,255,255,.07);border-radius:4px;overflow:hidden; }
.progress-fill { height:100%;border-radius:4px;transition:width .8s ease; }

/* RESPONSIVE */
@media(max-width:768px){
    .sidebar { transform:translateX(-100%); }
    .main { margin-left:0; }
    .content { padding:1.2rem; }
    .form-row,.form-row-3 { grid-template-columns:1fr; }
}
</style>