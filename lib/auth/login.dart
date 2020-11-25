import 'package:flutter/material.dart';
import 'package:Siuu/custom/CustomAuthScreens/text/CustomTextinAuthScreens.dart';
import 'package:Siuu/custom/customButton.dart';
import 'package:Siuu/custom/customTextField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height * 0.043),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Siuu",
                      style: TextStyle(
                        fontFamily: "Gabriola",
                        fontSize: 27,
                        color: Color(0xff4d0cbb),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Se connecter",
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontSize: 11,
                          color: Color(0xff4d0cbb),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: height * 0.117),
              SizedBox(
                height: height * 0.117,
                width: width * 0.243,
                child: Image.asset(
                  'assets/images/Siu.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(height: height * 0.043),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextAuthScreens('Vous n\'avez pas un compte ?'),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/register1');
                    },
                    child: CustomTextAuthScreens(' S\'inscrire'),
                  ),
                ],
              ),
              SizedBox(height: height * 0.029),
              CustomTextField(
                hintText: 'NHLuong',
                isPassword: false,
              ),
              SizedBox(height: height * 0.029),
              CustomTextField(
                isPassword: true,
              ),
              SizedBox(height: height * 0.073),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/BNB');
                },
                child: CustomButton(
                  label: 'Se Connecter',
                  height: height * 0.0658,
                  width: width * 0.680,
                  borderRadius: 45,
                ),
              ),
              SizedBox(height: height * 0.043),
              CustomTextAuthScreens('Vous avez oublié votre mot de passe ?'),
              SizedBox(height: height * 0.043),
            ],
          ),
        ),
      ),
    );
  }
}
