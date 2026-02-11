

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:siemb/screens/bible/tabs/bible_search_tab.dart';


class BibleSearch extends StatefulWidget {
  final AsyncSnapshot<dynamic>? snapshot2;

  const BibleSearch({super.key, this.snapshot2});

  @override
  _BibleSearchState createState() => _BibleSearchState();
}

class _BibleSearchState extends State<BibleSearch> {
  final textController = TextEditingController();

  String search = '';


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65.0),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                title: Column(
                  children: [
                    const SizedBox(height: 15,),
                    Row(
                      children: [
                        Flexible(
                            flex: 10,
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  icon: const Icon(Icons.arrow_back,color: Colors.black54, size: 30), onPressed: (){Navigator.pop(context);}),
                            )),
                        Flexible(
                          flex: 50,
                          child: Container(
                            height: 70,
                            alignment: Alignment.center,
                            child: TextField(

                              controller: textController,
                              decoration: const InputDecoration(
                                isDense: true,
                                labelText: "Digite a expressão desejada.",
                                //border: OutlineInputBorder()
                              ),

                            ),
                          ),
                        ),
                        Flexible(
                          flex: 10,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(

                                icon: const Icon(Icons.search, color: Colors.black54, size: 30),
                                onPressed: (){refresh();},
                              ),
                            )
                        ),
                      ],
                    ),
                    //SizedBox(height: 10,)
                  ],
                ),
              ),
            ),
          body: _tabView()
            //FutureBuilder  (
          //   future: _bibleData(),
          //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          //     if (snapshot.hasData){
          //       return _tabView();//widget.initialPage == 1? widget.bookIndex : widget.chapterIndex);
          //     }else {
          //       return  Center(child: CircularProgressIndicator());
          //     }
          //
          //   },
          // )
        ),
      ),
    );
  }

  void refresh() {
    setState(() {
      search = textController.text;
    });
  }

  Widget _tabView() {
    return TabBarView(
      children: <Widget>[
        BibleSearchTab(search),
      ],
    );
  }


}
