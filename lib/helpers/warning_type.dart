import 'package:flutter/material.dart';

Widget warningType(String tipo) {
  if (tipo.contains('Pedido')) {
    return Image.asset("images/pray_type.png", height: 20, width: 20);
  } else if (tipo.contains('Ensaio') || tipo.contains('Música')) {
    return Image.asset("images/music_type.png", height: 20, width: 20);
  } else if (tipo.contains('Horário')) {
    return Image.asset("images/calendar_type.png", height: 20, width: 20);
  }
  return const SizedBox.shrink();
}