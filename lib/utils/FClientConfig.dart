class FClientConfig {
    /// Maximum log file size in KB
    static const int logFileMaxSizeInKB = 6000;

    /// External storage directory (can be set at runtime)
    static String? externalStorageDir;

    /// Volley-like timeout values
    static const int volleyHitShortWaitTime = 10000; // milliseconds
    static const int volleyHitWaitTime = 30000 * 10;
    static const int thirdPartyDependentTimeout = 60000;

    /// Folder names
    static const String testReportFolder = "testReport";
    static const String enclosureFolder = "enclosure";

    /// Default configuration values
    static const int defaultMaxRetries = 0;
    static const int documentImageSize = 480;
    static const int ppXAxisMinPixelSize = 100;
    static const int companyTruncLength = 15;

    /// Location ID
    static const String locId = "DEL";

    /// Timer values
    static const int resendButtonDelay = 30; // seconds
    static const int countDownTimerValue = 1; // seconds

    /// Module names
    static const String moduleVisitorManagement = "Visitor";
    static const String moduleStaffManagement = "Staff";
    static const String moduleMaintenanceManagement = "Maintenance";
    static const String moduleFlatManagement = "Flat";
    static const String moduleNoticeBoard = "Notice Board";
    static const String moduleNotifications = "Notification";
    static const String moduleInventory = "Inventory";
    static const String moduleVendorManagement = "Vendor";
    static const String moduleComplaintManagement = "Complaint";
    static const String moduleAccounting = "My bills";
    static const String moduleRevenueGeneration = "Revenue Generation";
    static const String moduleParkingManagement = "Parking";
    static const String moduleServantsMaidEntry = "Maid entry";
    static const String moduleAddressBook = "Address Book";

    /// Server response message
    static const String serverErrorResponseDataNotFound = "Data Not Found";

    /// OTP related
    static const String otpSmsStringToMatch = "is your One Time Password to verify mobile number";
    static const int minOtpLen = 4;
}
