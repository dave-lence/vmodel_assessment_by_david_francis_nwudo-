import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';
import 'package:vmodel_test/screens/home_screen.dart';

void main() async {
  await initHiveForFlutter(); // Required for caching

  final HttpLink httpLink = HttpLink('https://uat-api.vmodel.app/graphql/');

  ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.client});
  final ValueNotifier<GraphQLClient> client;

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          color: Colors.white,
          home: AnimatedSplashScreen(
              duration: 3000,
              splash: const Text(
                'VM',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold),
              ),
              nextScreen: HomeScreen(),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              backgroundColor: Colors.white)),
    );
  }
}
