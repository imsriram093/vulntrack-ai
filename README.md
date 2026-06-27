# 🛡️ VulnTrack AI - Automated Vulnerability & Patch Management Tracker

VulnTrack AI is an enterprise infrastructure security tracking prototype engineered to streamline the full vulnerability remediation lifecycle, bridging core security scanning and multi-stage patch deployment safety.

## 📁 Repository Structure
* [cite_start]**`database/`**: Contains the full production-ready PostgreSQL DDL relational schema .
* **`notebooks/`**: Houses the interactive Google Colab Python prototype with mock database testing pipelines.
* **`assets/diagrams/`**: Features the technical design blueprints generated via Eraser.io.
* [cite_start]**`assets/wireframes/`**: Displays user interface dashboard screens built with Visily AI[cite: 65, 70, 76, 82].

---

## 🚀 Core Architectural Pipeline & Rationales

* [cite_start]**`users` Module (REQ-012):** Enforces identity boundaries matching RBAC profiles (`System Administrator`, `Security Analyst`, `DevOps Engineer`, `CISO`) and validating Multi-Factor Authentication configurations [cite: 174-183, 262].
* [cite_start]**`assets` Directory (REQ-001):** Operates as the configuration engine tracking hybrid corporate endpoints using native network mappings (`INET` addresses) [cite: 186-192, 264-265].
* [cite_start]**`vulnerabilities` Intel Ledger (REQ-006):** Tracks software intelligence details, mapping severity benchmarks (`CVSS` scaling limits) alongside active threat markers [cite: 197-206, 267-268].
* [cite_start]**`patch_approval_queue` Matrix (REQ-005):** Serves as the transactional engine driving software update packages across system check environments (`Pending` → `Testing` → `Approved`) [cite: 208-222, 270-272].
* [cite_start]**`audit_logs` Compliance Ledger (REQ-013):** Logs continuous, timestamped validation strings of privileged infrastructure changes for external regulatory compliance mappings [cite: 224-233, 274-275].

---

## 📈 Live Simulation & Capacity Proactive Engineering

### 🚨 API Traffic Monitoring Simulation (Phase 6)
The application includes an automated monitoring console that processes live telemetry stream feeds. [cite_start]During deployment simulations, the platform dynamically catches server resource constraints and operational response latency spikes (HTTP 504 Gateway errors)[cite: 314, 318]. [cite_start]Upon crossing a hard-coded 800ms boundary limit, a simulated self-healing automation orchestration runner isolates the culprit code commit and safely initializes a rolling rollback to the last verified stable container image [cite: 319-320].

### 🔮 Predictive Capacity Forecasting (Phase 7)
[cite_start]The platform integrates a proactive capacity analytics architecture utilizing linear regression trending slopes ($y = mx + c$) to evaluate operational capacity constraints over 30-day monitoring cycles [cite: 331-333]. [cite_start]The analytics system forecasts exactly how many days remain until core parameters cross critical structural boundaries, allowing engineering teams to address database load saturation bottlenecks prior to system failure [cite: 333-334].
