import 'package:flutter/material.dart';

class PoppablePageController {
  BuildContext _context;

  void attach({@required BuildContext context}) {
    _context = context;
  }

  void popUntilFirstRoute() {
    Navigator.of(_context).popUntil((Route<dynamic> r) => r.isFirst);
  }

  void popToFirstRoute() {
    Navigator.of(_context).popAndPushNamed('/');
  }

  bool isFirstRoute() {
    Route currentRoute;
    /*  Navigator.popUntil(_context, (route) {
      currentRoute = route;
      return true;
    });
    return currentRoute.isFirst;*/
    return true;
  }

  bool canPop() {
    return Navigator.canPop(_context);
  }

  void pop() {
    Navigator.pop(_context);
  }
}
