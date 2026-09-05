package com.servlet;

/**
 * Business Partner bean / DTO.
 * Mirrors the BUSINESS_PARTNERS table columns.
 * No DB logic here — see BusinessDAO.
 */
public class Business {

    // Primary key
    private String businessId;

    // Section A — Business Information
    private String businessName;
    private String brandName;
    private String registrationNo;   // CIN / Business Registration Number
    private String gstin;
    private String pan;
    private String businessEmail;
    private String businessPhone;
    private String website;
    private String address;
    private String city;
    private String state;
    private String pinCode;

    // Section B — Authorized Contact
    private String contactPersonName;
    private String contactPersonDesignation;
    private String contactPersonEmail;
    private String contactPersonPhone;

    // Section C — Login Credentials
    private String loginEmail;
    private String passwordHash;     // SHA-256 hex; never store plain text

    // Account lifecycle
    private String accountStatus;   // PENDING | ACTIVE | SUSPENDED | REJECTED
    private String createdAt;
    private String updatedAt;

    // -----------------------------------------------------------------------
    // Constructors
    // -----------------------------------------------------------------------

    public Business() {}

    // Minimal constructor used after a successful login query
    public Business(String businessId, String businessName, String brandName,
                    String loginEmail, String accountStatus) {
        this.businessId     = businessId;
        this.businessName   = businessName;
        this.brandName      = brandName;
        this.loginEmail     = loginEmail;
        this.accountStatus  = accountStatus;
    }

    // -----------------------------------------------------------------------
    // Getters and Setters
    // -----------------------------------------------------------------------

    public String getBusinessId()                  { return businessId; }
    public void   setBusinessId(String v)          { this.businessId = v; }

    public String getBusinessName()                { return businessName; }
    public void   setBusinessName(String v)        { this.businessName = v; }

    public String getBrandName()                   { return brandName; }
    public void   setBrandName(String v)           { this.brandName = v; }

    public String getRegistrationNo()              { return registrationNo; }
    public void   setRegistrationNo(String v)      { this.registrationNo = v; }

    public String getGstin()                       { return gstin; }
    public void   setGstin(String v)               { this.gstin = v; }

    public String getPan()                         { return pan; }
    public void   setPan(String v)                 { this.pan = v; }

    public String getBusinessEmail()               { return businessEmail; }
    public void   setBusinessEmail(String v)       { this.businessEmail = v; }

    public String getBusinessPhone()               { return businessPhone; }
    public void   setBusinessPhone(String v)       { this.businessPhone = v; }

    public String getWebsite()                     { return website; }
    public void   setWebsite(String v)             { this.website = v; }

    public String getAddress()                     { return address; }
    public void   setAddress(String v)             { this.address = v; }

    public String getCity()                        { return city; }
    public void   setCity(String v)                { this.city = v; }

    public String getState()                       { return state; }
    public void   setState(String v)               { this.state = v; }

    public String getPinCode()                     { return pinCode; }
    public void   setPinCode(String v)             { this.pinCode = v; }

    public String getContactPersonName()           { return contactPersonName; }
    public void   setContactPersonName(String v)   { this.contactPersonName = v; }

    public String getContactPersonDesignation()    { return contactPersonDesignation; }
    public void   setContactPersonDesignation(String v) { this.contactPersonDesignation = v; }

    public String getContactPersonEmail()          { return contactPersonEmail; }
    public void   setContactPersonEmail(String v)  { this.contactPersonEmail = v; }

    public String getContactPersonPhone()          { return contactPersonPhone; }
    public void   setContactPersonPhone(String v)  { this.contactPersonPhone = v; }

    public String getLoginEmail()                  { return loginEmail; }
    public void   setLoginEmail(String v)          { this.loginEmail = v; }

    public String getPasswordHash()                { return passwordHash; }
    public void   setPasswordHash(String v)        { this.passwordHash = v; }

    public String getAccountStatus()               { return accountStatus; }
    public void   setAccountStatus(String v)       { this.accountStatus = v; }

    public String getCreatedAt()                   { return createdAt; }
    public void   setCreatedAt(String v)           { this.createdAt = v; }

    public String getUpdatedAt()                   { return updatedAt; }
    public void   setUpdatedAt(String v)           { this.updatedAt = v; }
}
