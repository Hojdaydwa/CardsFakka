import 'package:flutter/material.dart';
import 'api_service.dart';
import 'storage.dart';
import 'cards_page.dart';


void main() {
  runApp(const FakkaApp());
}


class FakkaApp extends StatelessWidget {

  const FakkaApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "Cards Fakka",

      theme: ThemeData(

        primarySwatch: Colors.red,

      ),

      home: const LoginPage(),

    );

  }

}



class LoginPage extends StatefulWidget {

  const LoginPage({super.key});


  @override
  State<LoginPage> createState()=> _LoginPageState();

}




class _LoginPageState extends State<LoginPage>{


  bool loading=false;

  String status="جاهز";



  Future<void> login() async{


    try{


      setState((){

        loading=true;

        status="🔄 جاري الاتصال...";

      });



      final seamless =
      await ApiService.getSeamless();



      final seamlessToken =
      seamless["seamlessToken"];



      final msisdn =
      seamless["msisdn"];



      setState((){

        status="📱 $msisdn";

      });



      final token =
      await ApiService.getAccessToken(
        seamlessToken,
      );



      await Storage.saveLogin(

        msisdn: msisdn,

        accessToken: token,

        seamlessToken: seamlessToken,

      );



      setState((){

        loading=false;

        status="✅ تم تسجيل الدخول";

      });



      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:(context)=>
          const CardsPage(),

        ),

      );



    }catch(e){


      setState((){

        loading=false;

        status="❌ $e";

      });


    }


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(

      backgroundColor: Colors.white,


      body: Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            const Text(

              "🪙 Cards Fakka",

              style: TextStyle(

                color: Colors.red,

                fontSize:30,

                fontWeight:FontWeight.bold,

              ),

            ),



            const SizedBox(height:20),



            Text(status),



            const SizedBox(height:30),



            ElevatedButton(


              style:
              ElevatedButton.styleFrom(

                backgroundColor:Colors.red,

              ),


              onPressed:
              loading ? null : login,


              child:

              loading

              ? const CircularProgressIndicator(
                color:Colors.white,
              )

              :

              const Text(

                "تسجيل الدخول",

                style:
                TextStyle(
                  color:Colors.white,
                ),

              ),

            )


          ],


        ),


      ),

    );


  }


}