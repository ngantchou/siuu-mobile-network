import 'dart:async';
import 'dart:convert';
import 'package:Siuu/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Siuu/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Siuu/services/user.dart';
import 'package:Siuu/provider.dart';

class Wallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WalletState();
  }
}

class _WalletState extends State<Wallet> with WidgetsBindingObserver {
  Future<String> futureBalance;
  int _counter = 0;
  AppLifecycleState _state;
  ToastService _toastService;
  bool flag = true;
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  int hoursStr = 0;
  int minutesStr = 0;
  int secondsStr = 0;
  int totalSeconds = 0;
  double bitcoin = 0.0;
  String publickey;
  UserService _userService;
  Stream<int> stopWatchStream() {
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    timerStream = stopWatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      // setState(() {
      hoursStr = ((newTick / (60 * 60)) % 60).floor();
      minutesStr = ((newTick / 60) % 60).floor();
      secondsStr = (newTick % 60).floor();
      // });
    });
    publickey = "";
    super.initState();
    futureBalance = fetchBalance();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.resumed) {
      timerSubscription.resume();
    } else {
      timerSubscription.pause();
      timerStream = null;
      setState(() {
        bitcoin = totalSeconds * 0.000000000955555556;
      });
    }

    _state = state;
  }

  void _incrementCounter() {
    if (timerSubscription.isPaused) {
      setState(() {
        timerSubscription.pause();
      });
    } else {
      setState(() {
        timerSubscription.resume();
      });
    }
  }

  Future<String> fetchBalance() async {
    final response = await http.get(
        'http://161.35.161.138:5000/api/token/mainnet/address/0xDbCCd61648edFFD465A50a7929B9f7a278Fd7D56');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var data = jsonDecode(response.body);
      return data['balance'];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load balance');
    }
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
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
                            buildText(fontSize: 12, text: 'SIUU wallet'),
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
                          buildText(fontSize: 45, text: 'Siuucoin'),
                          buildText(
                              fontSize: 35, color: 0xffFF8000, text: ' SIUU'),
                        ],
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FutureBuilder<DocumentSnapshot>(
                            future: users
                                .doc(_userService.getLoggedInUser().uuid)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }

                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data.data() != null) {
                                Map<String, dynamic> data =
                                    snapshot.data.data();
                                publickey = data['public_key'];
                                return Text("${data['public_key']}");
                              }

                              return Text("loading...");
                            },
                          ),
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
                      // buildText(fontSize: 30, text: '0.02439403'),
                      FutureBuilder<String>(
                        future: futureBalance,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return buildText(fontSize: 30, text: snapshot.data);
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                      buildText(fontSize: 12, text: 'Total balance'),
                      Spacer(
                        flex: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              buildText(fontSize: 21, text: '0'),
                              buildText(fontSize: 14, text: 'Operations'),
                            ],
                          ),
                          SizedBox(
                            width: width * 0.072,
                          ),
                          Column(
                            children: [
                              buildText(fontSize: 21, text: bitcoin.toString()),
                              buildText(fontSize: 14, text: 'earning'),
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
            // buildListTile(width),
            // buildListTile(width),
            // buildListTile(width),
            // buildListTile(width),
            // buildListTile(width),
          ],
        ),
      ),
    );
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: publickey));
    _toastService.toast(
        message: "Clée copié", context: context, type: ToastType.info);
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
