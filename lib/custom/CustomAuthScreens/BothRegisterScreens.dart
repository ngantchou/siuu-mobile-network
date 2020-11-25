import 'package:flutter/material.dart';

import '../customButton.dart';
import '../customTextField.dart';
import 'text/CustomTextinAuthScreens.dart';

class RegisterScreens extends StatefulWidget {
  final String hintText1;
  final String hintText2;
  final String hintText3;
  final String buttonText;
  final String navigationPath;

  RegisterScreens(
      {this.buttonText,
      this.hintText1,
      this.hintText2,
      this.hintText3,
      this.navigationPath});

  @override
  _RegisterScreensState createState() => _RegisterScreensState();
}

class _RegisterScreensState extends State<RegisterScreens> {
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
                  CustomTextAuthScreens('Vous avez déjà un compte ? '),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: CustomTextAuthScreens('Se connecter'),
                  ),
                ],
              ),
              SizedBox(height: height * 0.029),
              CustomTextField(
                hintText: widget.hintText1,
                isPassword: false,
              ),
              SizedBox(height: height * 0.029),
              CustomTextField(
                hintText: widget.hintText2,
                isPassword: false,
              ),
              SizedBox(height: height * 0.029),
              CustomTextField(
                hintText: widget.hintText3,
                isPassword: false,
              ),
              SizedBox(height: height * 0.073),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(widget.navigationPath);
                },
                child: CustomButton(
                    height: height * 0.0658,
                    width: width * 0.680,
                    borderRadius: 45,
                    label: widget.buttonText),
              ),
              SizedBox(height: height * 0.043),
              CustomTextAuthScreens(
                  'By registering, you are agreeing\nto our Terms of Service'),
              SizedBox(height: height * 0.043),
            ],
          ),
        ),
      ),
    );
  }
}
