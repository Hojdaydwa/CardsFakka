import 'package:flutter/material.dart';
import 'storage.dart';
import 'purchase_service.dart';


class CardsPage extends StatefulWidget {

  const CardsPage({super.key});


  @override
  State<CardsPage> createState()=>_CardsPageState();

}



class _CardsPageState extends State<CardsPage>{


  String msisdn="";
  String token="";



  final List<Map<String,String>> cards=[


    {
      "name":"فكة 2.5 جنيه",
      "id":"Fakka_2.5_Unite",
      "price":"2.5"
    },


    {
      "name":"فكة 5 جنيه",
      "id":"Fakka_5_Unite",
      "price":"5"
    },


    {
      "name":"فكة 10 جنيه",
      "id":"Fakka_10_Unite",
      "price":"10"
    },


    {
      "name":"فكة 15 جنيه",
      "id":"Fakka_15_Unite",
      "price":"15"
    },


    {
      "name":"فكة 20 جنيه",
      "id":"Fakka_20_Unite",
      "price":"20"
    },


    {
      "name":"مارد 10 فليكس",
      "id":"Mared_10_Flexs",
      "price":"10"
    },


  ];




  @override
  void initState(){

    super.initState();

    loadData();

  }




  Future<void> loadData() async{


    final m =
    await Storage.getMsisdn();


    final t =
    await Storage.getAccessToken();



    setState((){

      msisdn=m ?? "";

      token=t ?? "";

    });


  }







  void buyCard(
      Map<String,String> card
      ){



    String receiver="";

    String pin="";



    showDialog(


      context: context,


      builder:(context){


        return AlertDialog(


          title:
          Text(card["name"]!),



          content:

          Column(

            mainAxisSize:
            MainAxisSize.min,


            children:[


              TextField(

                keyboardType:
                TextInputType.phone,


                decoration:
                const InputDecoration(

                  labelText:
                  "رقم المستلم"

                ),


                onChanged:(v){

                  receiver=v;

                },


              ),




              TextField(

                obscureText:true,


                keyboardType:
                TextInputType.number,


                decoration:
                const InputDecoration(

                  labelText:
                  "PIN"

                ),



                onChanged:(v){

                  pin=v;

                },


              )


            ],


          ),





          actions:[



            TextButton(

              onPressed:(){

                Navigator.pop(context);

              },


              child:
              const Text("إلغاء"),


            ),




            ElevatedButton(


              onPressed:() async{


                Navigator.pop(context);



                final result =
                await PurchaseService.buy(


                  cardId:
                  card["id"]!,


                  msisdn:
                  msisdn,


                  accessToken:
                  token,


                  receiver:
                  receiver,


                  pin:
                  pin,


                );



                ScaffoldMessenger.of(context)
                .showSnackBar(


                  SnackBar(

                    content:
                    Text(

                      result["status"]==200

                      ?

                      "✅ تم إرسال الطلب"

                      :

                      "❌ فشل الطلب"

                    ),

                  )


                );


              },


              child:
              const Text("شراء"),


            )


          ],


        );


      }

    );


  }








  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:
      AppBar(

        title:
        const Text(
          "🪙 Cards Fakka"
        ),


        backgroundColor:
        Colors.red,


      ),




      body:

      ListView.builder(


        itemCount:
        cards.length,


        itemBuilder:(context,index){



          final card =
          cards[index];



          return Card(


            margin:
            const EdgeInsets.all(12),



            child:
            ListTile(



              title:
              Text(
                card["name"]!
              ),



              subtitle:
              Text(
                "${card["price"]} جنيه"
              ),



              trailing:
              ElevatedButton(


                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.red,

                ),


                onPressed:(){

                  buyCard(card);

                },


                child:
                const Text(

                  "شراء",

                  style:
                  TextStyle(
                    color:Colors.white
                  ),

                ),


              ),



            ),


          );


        },


      ),


    );


  }


}