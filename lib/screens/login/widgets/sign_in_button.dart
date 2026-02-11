// import 'package:flutter/material.dart';
// import 'package:siemb/blocs/login_bloc.dart';
//
//
// class SignInButton extends StatelessWidget{
//   final _loginBloc = LoginBloc();
//
//
//   Widget build(BuildContext context) {
//
//     return StreamBuilder <bool>(
//         stream: _loginBloc.valid,
//         builder: (context, snapshot) {
//           print(snapshot.hasData);
//           return Padding(
//             padding: const EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(
//                   height: 45,
//                   child: RaisedButton(
//                     onPressed: snapshot.hasData ? (){} : null,
//                     color: Color.fromRGBO(0, 153, 153, 1.0),
//                     disabledColor: Color.fromRGBO(0, 153, 153, 0.2),
//                     child: Text(
//                         "Entrar",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w300,
//                             letterSpacing: 0.3
//                         )
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//     );
//
//   }
//
//
//
// }