import 'package:flutter/material.dart';
import 'package:Siuu/custom/CustomAuthScreens/BothRegisterScreens.dart';

class Register1 extends StatefulWidget {
  @override
  _Register1State createState() => _Register1State();
}

class _Register1State extends State<Register1> {
  @override
  Widget build(BuildContext context) {
    return RegisterScreens(
      buttonText: 'Suivant',
      hintText1: 'Pays',
      hintText2: 'Pseudo',
      hintText3: 'Email',
      navigationPath: '/register2',
    );
  }
}
