import 'package:flutter/material.dart';
import 'package:Siuu/custom/customAppBars/appBar2.dart';

class ExpressYourself extends StatefulWidget {
  @override
  _ExpressYourselfState createState() => _ExpressYourselfState();
}

class _ExpressYourselfState extends State<ExpressYourself> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1755),
        child: Appbar2(
          title: 'Home',
          trailing: Text(
            "Share",
            style: TextStyle(
              fontFamily: "Segoe UI",
              fontWeight: FontWeight.w300,
              fontSize: 15,
              color: Color(0xffffffff),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/avatar.png'),
                  SizedBox(width: width * 0.024),
                  Text(
                    "Jerome Gaveau",
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 17,
                      color: Color(0xff454F63),
                    ),
                  )
                ],
              ),
              Container(
                child: TextFormField(
                  maxLines: 10,
                  decoration: InputDecoration(
                      hintText: 'Express yourself',
                      hintStyle: TextStyle(
                        fontFamily: "Segoe UI",
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Color(0xff78849e),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
