class APIUrls {
  // Base URl
  static const String baseUrl = "/BuyereaseWebAPI/api";

  //Login API
  static const String urlLogin = "/Account/AuthenticateUser";

  //Password Change
  static const String urlForPasswordChange = "/Account/ChangePassword";

  //Forget Password
  static const String urlForForgetPassword = "/Account/ForgotPassword";

  //Get Data
  static const String urlGetData = "/Quality/GetQualityInspection";

  //Get Style Data
  static const String urlGetStyleData = "/Quality/GetStyles";

  //Send Data
  static const String urlSendData = "/Quality/SendQualityInspection";
}
