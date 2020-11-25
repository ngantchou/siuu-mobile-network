import 'package:flutter/material.dart';
import 'package:Siuu/custom/customAppBars/appBar1.dart';
import 'package:Siuu/custom/customButton.dart';

class Publish extends StatefulWidget {
  @override
  _PublishState createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  String _dropDownValue;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1755),
        child: CustomAppbar(
          title: 'Home',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            children: [
              Container(
                height: height * 0.220,
                decoration: BoxDecoration(
                  color: Color(0xfffcfcfc),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.00, 4.00),
                      color: Color(0xff000000).withOpacity(0.08),
                      blurRadius: 16,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12.00),
                ),
                child: Center(
                  child: Text(
                    "Ajouter photo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 24,
                      color: Color(0xff959595),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.029),
              buildTextFieldContainer(
                height: height * 0.068,
                hint: "Titre",
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              ),
              SizedBox(height: height * 0.029),
              buildDropDownContainer(
                  text: 'choissisez  votre ice type', width: double.infinity),
              SizedBox(height: height * 0.029),
              buildTextFieldContainer(
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  height: height * 0.131,
                  hint: "Description",
                  maxlines: 3),
              SizedBox(height: height * 0.029),
              buildTextFieldContainer(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: height * 0.068,
                hint: "Lieu",
              ),
              SizedBox(height: height * 0.029),
              buildTextFieldContainer(
                contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: height * 0.068,
                hint: "Téléphone",
              ),
              SizedBox(height: height * 0.029),
              Row(
                children: [
                  buildDropDownContainer(
                    text: 'Début',
                    width: width * 0.364,
                  ),
                  Spacer(),
                  buildDropDownContainer(
                    text: 'Fin',
                    width: width * 0.364,
                  ),
                ],
              ),
              SizedBox(height: height * 0.043),
              CustomButton(
                  height: height * 0.081,
                  width: double.infinity,
                  borderRadius: 12,
                  label: 'Publier'),
              SizedBox(height: height * 0.146),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDropDownContainer({double width, String text}) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.068,
      width: width,
      decoration: BoxDecoration(
        color: Color(0xfffcfcfc),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 4.00),
            color: Color(0xff000000).withOpacity(0.08),
            blurRadius: 16,
          ),
        ],
        borderRadius: BorderRadius.circular(12.00),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: DropdownButton(
          underline: Container(),
          dropdownColor: Colors.white,
          hint: _dropDownValue == null
              ? Text(text)
              : Text(
                  _dropDownValue,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff172b4d),
                  ),
                ),
          isExpanded: true,
          iconSize: 20.0,
          style: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 14,
            color: Color(0xff78849e).withOpacity(0.56),
          ),
          items: [
            text,
            text,
            text,
          ].map(
            (val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            },
          ).toList(),
          onChanged: (val) {
            setState(
              () {
                _dropDownValue = val;
              },
            );
          },
        ),
      ),
    );
  }

  Container buildTextFieldContainer(
      {double height,
      String hint,
      int maxlines,
      EdgeInsetsGeometry contentPadding}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Color(0xfffcfcfc),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 4.00),
            color: Color(0xff000000).withOpacity(0.08),
            blurRadius: 16,
          ),
        ],
        borderRadius: BorderRadius.circular(12.00),
      ),
      child: TextFormField(
        maxLines: maxlines != null ? maxlines : null,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 16,
            color: Color(0xff78849e).withOpacity(0.56),
          ),
          hintText: hint,
          contentPadding: contentPadding,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
