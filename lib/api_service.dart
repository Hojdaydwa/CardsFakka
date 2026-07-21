import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {


  static const String seamlessUrl =
      "https://mobile.vodafone.com.eg/checkSeamless/realms/vf-realm/protocol/openid-connect/auth?client_id=cash-app";



  static const String tokenUrl =
      "https://mobile.vodafone.com.eg/auth/realms/vf-realm/protocol/openid-connect/token";




  static Future<Map<String,dynamic>> getSeamless() async {


    final response = await http.get(

      Uri.parse(seamlessUrl),


      headers:{


        "User-Agent":
        "okhttp/4.12.0",


        "Accept-Encoding":
        "gzip",


        "Connection":
        "Keep-Alive",


        "clientId":
        "AnaVodafoneAndroid",


        "Accept-Language":
        "ar",


        "x-agent-operatingsystem":
        "16",


        "x-agent-device":
        "Samsung SM-A165F",


        "x-agent-version":
        "2025.11.1",


        "x-agent-build":
        "1063",


      },

    );



    if(response.statusCode != 200){

      throw Exception(
        "Seamless Error ${response.statusCode}"
      );

    }



    final data =
    jsonDecode(response.body);



    return data;


  }






  static Future<String> getAccessToken(
      String seamlessToken
      ) async {



    final response = await http.post(


      Uri.parse(tokenUrl),



      headers:{


        "User-Agent":
        "okhttp/4.12.0",


        "Accept":
        "application/json",


        "Content-Type":
        "application/x-www-form-urlencoded",


        "clientId":
        "AnaVodafoneAndroid",


        "Accept-Language":
        "ar",


        "seamlessToken":
        seamlessToken,


      },



      body:{


        "grant_type":
        "password",


        "client_id":
        "cash-app",


        "client_secret":
        "b86e30a8-ae29-467a-a71f-65c73f2ff5e3",


      },


    );




    if(response.statusCode != 200){

      throw Exception(
        "Token Error ${response.statusCode}"
      );

    }




    final data =
    jsonDecode(response.body);



    return data["access_token"];


  }



}