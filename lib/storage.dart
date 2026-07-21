import 'package:shared_preferences/shared_preferences.dart';


class Storage {


  static Future<void> saveLogin({

    required String msisdn,

    required String accessToken,

    required String seamlessToken,

  }) async {


    final prefs =
    await SharedPreferences.getInstance();



    await prefs.setString(
      "msisdn",
      msisdn,
    );


    await prefs.setString(
      "accessToken",
      accessToken,
    );


    await prefs.setString(
      "seamlessToken",
      seamlessToken,
    );


  }




  static Future<String?> getMsisdn() async {

    final prefs =
    await SharedPreferences.getInstance();


    return prefs.getString(
      "msisdn",
    );

  }





  static Future<String?> getAccessToken() async {


    final prefs =
    await SharedPreferences.getInstance();


    return prefs.getString(
      "accessToken",
    );


  }





  static Future<String?> getSeamlessToken() async {


    final prefs =
    await SharedPreferences.getInstance();


    return prefs.getString(
      "seamlessToken",
    );


  }






  static Future<void> clear() async {


    final prefs =
    await SharedPreferences.getInstance();


    await prefs.clear();


  }



}