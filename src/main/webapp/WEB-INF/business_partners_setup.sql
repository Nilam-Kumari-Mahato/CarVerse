-- =============================================================================
-- CarVerse — Business Partner Database Setup
-- Schema: CARVERSE
-- Run this script once as the CARVERSE user (or a DBA) before deploying the
-- Business Partner module.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Drop table if it exists (safe re-run during development)
--    Comment out or remove these lines in production.
-- -----------------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE BUSINESS_PARTNERS CASCADE CONSTRAINTS';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN RAISE; END IF; -- -942 = table does not exist, ignore
END;
/

-- -----------------------------------------------------------------------------
-- 2. Create BUSINESS_PARTNERS table
-- -----------------------------------------------------------------------------
CREATE TABLE BUSINESS_PARTNERS (

    -- Primary key (format: bp_YYYY_<millis>, e.g. bp_2026_1748294847123)
    BUSINESS_ID             VARCHAR2(40)    NOT NULL,

    -- Section A: Business Information
    BUSINESS_NAME           VARCHAR2(200)   NOT NULL,
    BRAND_NAME              VARCHAR2(100)   NOT NULL,
    REGISTRATION_NO         VARCHAR2(100),           -- CIN / business reg number (optional)
    GSTIN                   VARCHAR2(20),             -- 15-digit GSTIN (optional)
    PAN                     VARCHAR2(12),             -- 10-character PAN (optional)
    BUSINESS_EMAIL          VARCHAR2(200)   NOT NULL,
    BUSINESS_PHONE          VARCHAR2(20)    NOT NULL,
    WEBSITE                 VARCHAR2(300),            -- optional
    ADDRESS                 VARCHAR2(500)   NOT NULL,
    CITY                    VARCHAR2(100)   NOT NULL,
    STATE                   VARCHAR2(100)   NOT NULL,
    PIN_CODE                VARCHAR2(6)     NOT NULL,

    -- Section B: Authorized Contact
    CONTACT_PERSON_NAME     VARCHAR2(200)   NOT NULL,
    CONTACT_PERSON_DESIGNATION VARCHAR2(100),        -- optional
    CONTACT_PERSON_EMAIL    VARCHAR2(200)   NOT NULL,
    CONTACT_PERSON_PHONE    VARCHAR2(20)    NOT NULL,

    -- Section C: Login Credentials
    LOGIN_EMAIL             VARCHAR2(200)   NOT NULL,
    -- Stored as  <saltHex>:<sha256Hex>  — never plain text
    PASSWORD_HASH           VARCHAR2(200)   NOT NULL,

    -- Account lifecycle
    ACCOUNT_STATUS          VARCHAR2(20)    NOT NULL
                                DEFAULT 'ACTIVE'
                                CONSTRAINT bp_status_chk
                                CHECK (ACCOUNT_STATUS IN
                                       ('PENDING','ACTIVE','SUSPENDED','REJECTED')),

    CREATED_AT              DATE            DEFAULT SYSDATE NOT NULL,
    UPDATED_AT              DATE            DEFAULT SYSDATE NOT NULL,

    -- Constraints
    CONSTRAINT bp_pk            PRIMARY KEY (BUSINESS_ID),
    CONSTRAINT bp_login_email_uq UNIQUE     (LOGIN_EMAIL)
);

-- -----------------------------------------------------------------------------
-- 3. Indexes for common lookup columns
-- -----------------------------------------------------------------------------

-- Fast lookup by login email (used on every login attempt)
CREATE INDEX bp_login_email_idx ON BUSINESS_PARTNERS (LOGIN_EMAIL);

-- Optional: lookup by business/brand name for admin search
CREATE INDEX bp_business_name_idx ON BUSINESS_PARTNERS (BUSINESS_NAME);
CREATE INDEX bp_brand_name_idx    ON BUSINESS_PARTNERS (BRAND_NAME);

-- Optional: filter by account status (admin panel)
CREATE INDEX bp_status_idx ON BUSINESS_PARTNERS (ACCOUNT_STATUS);

-- -----------------------------------------------------------------------------
-- 4. Comment on table and columns (good documentation practice)
-- -----------------------------------------------------------------------------
COMMENT ON TABLE  BUSINESS_PARTNERS IS
    'Business Partner accounts for the CarVerse platform. '
    'Represents car manufacturers, authorized dealers, or inventory providers.';

COMMENT ON COLUMN BUSINESS_PARTNERS.BUSINESS_ID  IS
    'Generated ID in format bp_YYYY_<timestamp>.';
COMMENT ON COLUMN BUSINESS_PARTNERS.PASSWORD_HASH IS
    'Salted SHA-256 hash stored as saltHex:hashHex. Never plain text.';
COMMENT ON COLUMN BUSINESS_PARTNERS.ACCOUNT_STATUS IS
    'PENDING=awaiting review, ACTIVE=can log in, SUSPENDED=blocked, REJECTED=denied.';
COMMENT ON COLUMN BUSINESS_PARTNERS.LOGIN_EMAIL IS
    'Unique login identifier. Separate from BUSINESS_EMAIL.';

-- -----------------------------------------------------------------------------
-- 5. Verify
-- -----------------------------------------------------------------------------
SELECT 'BUSINESS_PARTNERS table created successfully.' AS STATUS FROM DUAL;
SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE
  FROM USER_TAB_COLUMNS
 WHERE TABLE_NAME = 'BUSINESS_PARTNERS'
 ORDER BY COLUMN_ID;
