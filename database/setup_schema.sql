-- ============================================================
-- Automated Vulnerability & Patch Management Tracker
-- PostgreSQL 16+
-- ============================================================

CREATE SCHEMA IF NOT EXISTS avpm;

SET search_path TO avpm;

-- ============================================================
-- TABLE: users
-- Functional Requirement:
-- REQ-012 - Role Based Access Control (RBAC)
-- ============================================================

CREATE TABLE users
(
    user_id             SERIAL PRIMARY KEY,

    username            VARCHAR(50) NOT NULL UNIQUE,

    email               VARCHAR(150) NOT NULL UNIQUE,

    role_enum           VARCHAR(30) NOT NULL,

    mfa_enabled         BOOLEAN NOT NULL DEFAULT FALSE,

    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_user_role
    CHECK
    (
        role_enum IN
        (
            'System Administrator',
            'Security Analyst',
            'DevOps Engineer',
            'CISO'
        )
    )
);

COMMENT ON TABLE users IS
'REQ-012: Stores authenticated users with RBAC roles.';

COMMENT ON COLUMN users.role_enum IS
'RBAC role used for authorization.';

-- ============================================================
-- TABLE: assets
-- Functional Requirement:
-- REQ-001 - Automatic Asset Discovery
-- ============================================================

CREATE TABLE assets
(
    asset_id            SERIAL PRIMARY KEY,

    hostname            VARCHAR(150) NOT NULL UNIQUE,

    ip_address          INET NOT NULL UNIQUE,

    operating_system    VARCHAR(100) NOT NULL,

    environment_group   VARCHAR(50) NOT NULL,

    discovered_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_environment
    CHECK
    (
        environment_group IN
        (
            'Development',
            'Testing',
            'Staging',
            'Production'
        )
    )
);

COMMENT ON TABLE assets IS
'REQ-001: Enterprise assets discovered for vulnerability scanning.';

-- ============================================================
-- TABLE: vulnerabilities
-- Functional Requirement:
-- REQ-006 - Risk Based Vulnerability Prioritization
-- ============================================================

CREATE TABLE vulnerabilities
(
    cve_id                  VARCHAR(25) PRIMARY KEY,

    title                   VARCHAR(500) NOT NULL,

    cvss_score              NUMERIC(3,1) NOT NULL,

    exploit_available       BOOLEAN NOT NULL DEFAULT FALSE,

    remediation_deadline    TIMESTAMP,

    created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_cvss
    CHECK
    (
        cvss_score >= 0
        AND
        cvss_score <= 10
    )
);

COMMENT ON TABLE vulnerabilities IS
'REQ-006: Stores vulnerability intelligence and CVSS prioritization.';

-- ============================================================
-- TABLE: patch_approval_queue
-- Functional Requirement:
-- REQ-005 - Patch Approval Workflow
-- ============================================================

CREATE TABLE patch_approval_queue
(
    queue_id                SERIAL PRIMARY KEY,

    asset_id                INTEGER NOT NULL,

    cve_id                  VARCHAR(25) NOT NULL,

    status_stage            VARCHAR(30) NOT NULL DEFAULT 'Pending',

    assigned_owner_id       INTEGER,

    created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_patch_asset
        FOREIGN KEY (asset_id)
        REFERENCES assets(asset_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_patch_cve
        FOREIGN KEY (cve_id)
        REFERENCES vulnerabilities(cve_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_patch_owner
        FOREIGN KEY (assigned_owner_id)
        REFERENCES users(user_id)
        ON DELETE SET NULL,

    CONSTRAINT chk_patch_stage
    CHECK
    (
        status_stage IN
        (
            'Pending',
            'Testing',
            'Approved',
            'Deploying',
            'Completed',
            'Rejected',
            'Failed'
        )
    ),

    CONSTRAINT uq_asset_cve
    UNIQUE(asset_id, cve_id)
);

COMMENT ON TABLE patch_approval_queue IS
'REQ-005: Tracks patch approval workflow for each asset and vulnerability.';

-- ============================================================
-- TABLE: audit_logs
-- Functional Requirement:
-- REQ-013 - Complete Audit Trail
-- ============================================================

CREATE TABLE audit_logs
(
    log_id                  SERIAL PRIMARY KEY,

    "timestamp"             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    user_id                 INTEGER,

    action_performed        VARCHAR(255) NOT NULL,

    target_asset_id         INTEGER,

    CONSTRAINT fk_log_user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE SET NULL,

    CONSTRAINT fk_log_asset
        FOREIGN KEY(target_asset_id)
        REFERENCES assets(asset_id)
        ON DELETE SET NULL
);

COMMENT ON TABLE audit_logs IS
'REQ-013: Immutable audit history of user actions and patch activities.';

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_assets_hostname
ON assets(hostname);

CREATE INDEX idx_assets_os
ON assets(operating_system);

CREATE INDEX idx_vulnerability_cvss
ON vulnerabilities(cvss_score DESC);

CREATE INDEX idx_vulnerability_deadline
ON vulnerabilities(remediation_deadline);

CREATE INDEX idx_patch_status
ON patch_approval_queue(status_stage);

CREATE INDEX idx_patch_owner
ON patch_approval_queue(assigned_owner_id);

CREATE INDEX idx_patch_asset
ON patch_approval_queue(asset_id);

CREATE INDEX idx_patch_cve
ON patch_approval_queue(cve_id);

CREATE INDEX idx_audit_timestamp
ON audit_logs("timestamp" DESC);

CREATE INDEX idx_audit_user
ON audit_logs(user_id);

CREATE INDEX idx_audit_asset
ON audit_logs(target_asset_id);

-- ============================================================
-- OPTIONAL TRIGGER
-- Automatically updates updated_at on queue changes
-- ============================================================

CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_patch_queue_updated
BEFORE UPDATE
ON patch_approval_queue
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();
