import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../screens/place_details_screen.dart';
import '../screens/onboarding_screen.dart';

import '../home_page.dart';

class ApplicationRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/onboard': (context) => new OnboardingScreen(),
    '/home': (context) => new GoogleMapPage(),
     '/detail': (_) => new DetailPage(),
  };
}
