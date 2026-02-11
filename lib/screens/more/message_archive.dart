import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siemb/tiles/message_card.dart';


class MessageArchive extends StatelessWidget{
  final double titleSize = 16.0;
  final double fontSize = 14.0;

  const MessageArchive({super.key});

  @override
  Widget build(BuildContext context) {

    Widget buildbBodyBack() => Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors:[ Color.fromRGBO(224, 235, 235, 0.8),
                //Color.fromRGBO(102, 0, 255, 0.5)],
                Color.fromRGBO(255, 255, 255, 1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Scaffold(

        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[

            buildbBodyBack(),


            Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),

                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("mensagens").get(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(),);
                    } else{

                      return Expanded(
                        child: ListView(
                          scrollDirection: Axis.vertical,

                          children: snapshot.data?.docs.map(
                                  (doc) {
                                return MessageCard(doc);
                              }
                          ).toList() ?? [],
                        ),
                      );
                    }
                  },
                ),


             ],
            ),
          ]
        )

    );


  }


}