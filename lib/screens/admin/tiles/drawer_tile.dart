import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  const DrawerTile (this.icon, this.text, this.controller, this.page, {super.key});


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: SizedBox(
          height: 70,
          child: Row(
            children: <Widget>[
              Icon(icon,
              size: 30,
              color: (controller.page ?? 0).toInt() == page ? Colors.white70 : Colors.black),
              const SizedBox(width: 30,),
              Text(
                text,
                style: TextStyle(
                  color: (controller.page ?? 0).toInt() == page ? Colors.white70 : Colors.black,
                  fontSize: 18
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}
