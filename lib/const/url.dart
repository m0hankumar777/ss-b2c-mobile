import 'package:B2C/const/config.dart' as config;

String baseUrl = "";
getBaseUrl() {
  if (config.isProduction) {
    baseUrl = prodUrl;
  } else {
    baseUrl = devUrl;
  }
}

const String devUrl = "https://dev.glamz.com/api/";
const String prodUrl = "https://dev.glamz.com/api/";

// const String devUrl = "https://glamz.com/api/";
// const String prodUrl = "https://glamz.com/api/";

const String generateOtp = "Login/GenerateOtp";
const String otpAuthentication = "Login/otpauthentication";
const String register = "Login/Register";
