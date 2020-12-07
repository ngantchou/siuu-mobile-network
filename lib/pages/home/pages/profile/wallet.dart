import 'package:Siuu/res/colors.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.580,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(gradient: linearGradient),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back_ios_rounded,
                                  color: Colors.white),
                              Spacer(),
                              buildText(fontSize: 12, text: 'SIU wallet'),
                              Spacer(),
                            ],
                          ),
                        ),
                        Spacer(
                          flex: 3,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            buildText(fontSize: 45, text: 'Siucoin'),
                            buildText(
                                fontSize: 35, color: 0xffFF8000, text: ' SIU'),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.content_copy,
                                  size: 30, color: Colors.white),
                            ),
                          ],
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        buildText(fontSize: 30, text: '0.02439403'),
                        buildText(fontSize: 12, text: 'Total balance'),
                        Spacer(
                          flex: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                buildText(fontSize: 21, text: '614'),
                                buildText(fontSize: 14, text: 'Operations'),
                              ],
                            ),
                            SizedBox(
                              width: width * 0.072,
                            ),
                            Column(
                              children: [
                                buildText(fontSize: 21, text: '+\$15'),
                                buildText(fontSize: 14, text: 'Week'),
                              ],
                            )
                          ],
                        ),
                        Spacer(
                          flex: 2,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "My Last Earnings",
                  style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Color(0xff707070),
                  ),
                ),
              ),
              buildListTile(width),
              buildListTile(width),
              buildListTile(width),
              buildListTile(width),
              buildListTile(width),
            ],
          ),
        ),
      ),
    );
  }

  ListTile buildListTile(double width) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ListTile(
      leading: Container(
        height: height * 0.087,
        width: width * 0.6,
        child: Row(
          children: [
            Image.asset(
              'assets/images/SiuCoin.png',
              height: height * 0.087,
              width: width * 0.145,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                    text: "Recive to 21654984",
                    fontSize: 11,
                    color: 0xff505050),
                buildText(
                    text: "13 apr 2017   12:51",
                    fontSize: 9,
                    color: 0xff95989A),
              ],
            ),
          ],
        ),
      ),
      trailing: buildText(
          text: "+0.02439403    SIU", fontSize: 15, color: 0xff4FC166),
    );
  }

  Text buildText({String text, double fontSize, int color}) {
    return new Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: fontSize,
        color: color == null ? Colors.white : Color(color),
      ),
    );
  }
}
