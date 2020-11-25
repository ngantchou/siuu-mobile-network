import 'package:flutter/material.dart';
import 'package:Siuu/auth/login.dart';
import 'package:Siuu/auth/register/register1.dart';
import 'package:Siuu/screens/404.dart';
import 'package:Siuu/screens/Account/AccountSettings.dart';
import 'package:Siuu/screens/MediaPlayer.dart';
import 'package:Siuu/screens/Messages/Message.dart';
import 'package:Siuu/screens/Messages/chat.dart';
import 'package:Siuu/screens/home/comments.dart';
import 'package:Siuu/screens/home/expressYourself.dart';
import 'package:Siuu/screens/home/home.dart';
import 'package:Siuu/screens/notifications.dart';
import 'package:Siuu/screens/memories.dart';
import 'package:Siuu/screens/onBoardingScreen/onBoard.dart';
import 'package:Siuu/screens/search.dart';
import 'package:Siuu/screens/splashScreen.dart';
import 'package:Siuu/screens/story.dart';
import 'package:Siuu/screens/userProfile/profile.dart';
import 'package:Siuu/screens/camera.dart';

import 'BNB.dart';
import 'auth/register/register2.dart';
import 'screens/Messages/loader.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/onBoard':
        // Validation of correct data type
        return MaterialPageRoute(builder: (_) => OnBoard());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/BNB':
        return MaterialPageRoute(builder: (_) => BottomNavBar());
      case '/home':
        return MaterialPageRoute(builder: (_) => Home());
      case '/register1':
        return MaterialPageRoute(builder: (_) => Register1());
      case '/register2':
        return MaterialPageRoute(builder: (_) => Register2());
      case '/messages':
        return MaterialPageRoute(builder: (_) => Message());
      case '/memories':
        return MaterialPageRoute(builder: (_) => Memories());
      case '/notifications':
        return MaterialPageRoute(builder: (_) => Notifications());
      case '/expressYourself':
        return MaterialPageRoute(builder: (_) => ExpressYourself());
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());
      case '/accountSettings':
        return MaterialPageRoute(builder: (_) => AccountSettings());
      case '/mediaPlayer':
        return MaterialPageRoute(builder: (_) => MediaPlayer());
      case '/search':
        return MaterialPageRoute(builder: (_) => Search());
      case '/story':
        return MaterialPageRoute(builder: (_) => Story());
      case '/camera':
        return MaterialPageRoute(builder: (_) => Camera());
      case '/connectionLostScreen':
        return MaterialPageRoute(builder: (_) => ConnectionLostScreen());
      case '/comments':
        return MaterialPageRoute(
          builder: (_) => Comments(
            postContainer: args,
          ),
        );

      case '/chat':
        final Chat argss = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => Chat(
            name: argss.name,
            isRoomTalk: argss.isRoomTalk,
          ),
        );
      case '/loader':
        final Loader argss = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => Loader(
            name: argss.name,
            isRoomTalk: argss.isRoomTalk,
          ),
        );
      // case '/notification':
      //   return MaterialPageRoute(builder: (_) => Notification());

      // If args is not of the correct type, return an error page.
      // You can also throw an exception while in development.
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
