import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'configurations/graphQLConfiguration.dart';
import 'home_page.dart';
import 'screens/onboarding_screen.dart';
import 'configurations/application_routes.dart';


GraphQLConfiguration graphQLConfig = GraphQLConfiguration();


void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      GraphQLProvider(
        client: graphQLConfig.client,
        child: CacheProvider(child: MyApp()),
      ),
    );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    OnboardingScreen onboardingScreen = new OnboardingScreen();
    GoogleMapPage googleMapPage = new GoogleMapPage();
    String _initRoute = '/onboard';
    Widget _defaultScreen = onboardingScreen;
    bool _isOnboarded = false;
    if(_isOnboarded){
      _initRoute = '/home';
      _defaultScreen = googleMapPage;
    }


    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Color(0xFF707070),
      ),
      home: _defaultScreen,
      initialRoute: _initRoute,
      routes: ApplicationRoutes.routes,
    );
  }



}
