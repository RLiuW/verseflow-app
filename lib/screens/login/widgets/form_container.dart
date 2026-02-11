// import 'package:siemb/blocs/login_bloc.dart';
// import 'package:siemb/screens/login/widgets/input_field.dart';
// import 'package:flutter/material.dart';
//
// class FormContainer extends StatelessWidget {
//   final _loginBloc = LoginBloc();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20),
//       child: Form(
//         child: Column(
//           children: <Widget>[
//             InputField(
//               hint: "Email",
//               obscure: false,
//               icon: Icons.email_outlined,
//               stream: _loginBloc.outEmail,
//               onChanged: _loginBloc.changeEmail,
//             ),
//             InputField(
//               hint: "Senha",
//               obscure: true,
//               icon: Icons.lock_outline,
//               stream: _loginBloc.outPassword,
//               onChanged: _loginBloc.changePassword,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
