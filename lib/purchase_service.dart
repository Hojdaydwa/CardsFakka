import 'dart:convert';
import 'package:http/http.dart' as http;


class PurchaseService {


  static const String url =
  "https://mobile.vodafone.com.eg/services/dxl/pom/productOrder";



  static Future<Map<String,dynamic>> buy({


    required String cardId,

    required String msisdn,

    required String accessToken,

    required String receiver,

    required String pin,


  }) async {



    final body = {


      "channel":{

        "name":"MobileApp"

      },


      "orderItem":[


        {


          "action":"insert",


          "id":cardId,


          "product":{


            "characteristic":[


              {

                "name":"PaymentMethod",

                "value":"VFCash"

              },


              {

                "name":"USE_EMONEY",

                "value":"False"

              },


              {

                "name":"MerchantCode",

                "value":"81841829"

              }


            ],



            "id":cardId,



            "relatedParty":[


              {

                "id":msisdn,

                "name":"MSISDN",

                "role":"Subscriber"

              },



              {

                "id":"Receiver",

                "name":"Receiver",

                "role":receiver

              }


            ]


          },



          "@type":"CashFakkaAndMared",


          "eCode":0


        }


      ],




      "relatedParty":[


        {

          "id":pin,

          "name":"pin",

          "role":"Requestor"

        }


      ],



      "@type":"CashFakkaAndMared"


    };






    final response = await http.post(


      Uri.parse(url),



      headers:{


        "User-Agent":

        "okhttp/4.12.0",



        "Accept":

        "application/json",



        "Content-Type":

        "application/json; charset=UTF-8",



        "Authorization":

        "Bearer $accessToken",



        "msisdn":

        msisdn,



        "clientId":

        "AnaVodafoneAndroid",



        "Accept-Language":

        "ar",


      },



      body:

      jsonEncode(body),



    );





    final data =

    jsonDecode(response.body);




    return {


      "status":

      response.statusCode,



      "data":

      data


    };



  }



}