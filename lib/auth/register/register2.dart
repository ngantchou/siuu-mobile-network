import 'package:flutter/material.dart';
import 'package:Siuu/custom/CustomAuthScreens/BothRegisterScreens.dart';

class Register2 extends StatefulWidget {
  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  @override
  Widget build(BuildContext context) {
    return RegisterScreens(
      buttonText: 'S\'inscrire',
      hintText1: 'Téléphone',
      hintText2: 'Date de naissance',
      hintText3: 'Mot de passe',
      navigationPath: '/BNB',
    );
  }
}
