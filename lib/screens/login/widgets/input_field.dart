import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final String hint;
  final bool obscure;
  final IconData icon;
  final Function(String) onChanged;
  final bool hasError;


  const InputField({super.key, 
    required this.hint,
    required this.obscure,
    required this.icon,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {

        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.white24,
                width: 0.5,
              ),
            ),
          ),
          child: TextFormField(
            onChanged: onChanged,
            obscureText: obscure,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              icon: Icon(
                icon,
                color: Colors.white,
              ),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              contentPadding: const EdgeInsets.only(
                top: 30,
                right: 30,
                bottom: 30,
                left: 5
              ),
                errorText: hasError ? _error(hint) : null,
            ),
          ),
        );


  }

  String _error(String type) {
    if (type == "Email") {
      return 'Por favor, digite um email válido.';
    } else {
      return "A senha deve conter no mínimo 6 caracteres.";
    }
  }


}
