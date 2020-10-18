import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minerals_register/models/sample.dart';
import 'package:minerals_register/pages/login.dart';
import 'package:minerals_register/pages/overview.dart';
import 'package:minerals_register/pages/sample_details.dart';
import 'package:minerals_register/pages/sign_up.dart';

class Routes {
  static const String Home = '/';
  static const String Login = '/login';
  static const String Overview = '/overview';
  static const String Details = '/details';
  static const String SignUp = '/signup';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home:
      case Login:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case SignUp:
        return MaterialPageRoute(builder: (context) => SignUpPage());

      case Details:
        return MaterialPageRoute(builder: (context)=>SampleDetailsPage(sample: settings.arguments as Sample,));
      case Overview:
        return MaterialPageRoute(
            builder: (context) => OverviewPage(
                  samples: [
                    Sample.fromJson({
                      'id': '0011',
                      'serial': 'CR 00001',
                      'timeStamp': DateTime.now().toString(),
                      'mineral': 'Aurum',
                      'location': 'Brazil',
                      'value': 4500.14,
                      'origin': 'Cave',
                      'size': 'BIG',
                      'annotation': 'This is an annotation',
                      'sideMineral': 'Argentum',
                    })
                  ],
                ));
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
