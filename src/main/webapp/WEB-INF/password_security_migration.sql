-- Run once as the CarVerse schema owner before deploying password reset.
-- Widening PASSWORD preserves existing values; login upgrades legacy values lazily.
ALTER TABLE USER_REGISTRATION MODIFY (PASSWORD VARCHAR2(200));

BEGIN
    EXECUTE IMMEDIATE '
        CREATE TABLE PASSWORD_RESET_TOKENS (
            TOKEN_HASH   VARCHAR2(64)  NOT NULL,
            ACCOUNT_TYPE VARCHAR2(10)  NOT NULL,
            ACCOUNT_ID   VARCHAR2(100) NOT NULL,
            EXPIRES_AT   TIMESTAMP     NOT NULL,
            CREATED_AT   TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
            USED_AT      TIMESTAMP,
            CONSTRAINT password_reset_tokens_pk PRIMARY KEY (TOKEN_HASH),
            CONSTRAINT password_reset_type_ck CHECK (ACCOUNT_TYPE IN (''USER'', ''BUSINESS''))
        )';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE
        'CREATE INDEX password_reset_account_idx ON PASSWORD_RESET_TOKENS (ACCOUNT_TYPE, ACCOUNT_ID)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN RAISE; END IF;
END;
/
