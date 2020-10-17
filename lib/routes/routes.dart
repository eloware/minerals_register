import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minerals_register/pages/login.dart';
import 'package:minerals_register/pages/overview.dart';

class Routes {
  static const String Home = '';
  static const String Login = '/login';
  static const String Overview = '/overview';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home:
      case Login:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case Overview:
        return MaterialPageRoute(builder: (context) => OverviewPage());
    }

    return MaterialPageRoute(
        builder: (context) => RouteError(route: settings.name));
  }
}

class RouteError extends StatelessWidget {
  final String route;

  const RouteError({Key key, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Route error'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Route not found',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(route),
          ],
        ),
      ),
    );
  }
}
