import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maps_app/compass/cubit/compass_cubit.dart';
import 'package:maps_app/home_page.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';
import 'package:maps_app/utils/simple_bloc_observer.dart';
import 'package:bloc/bloc.dart';

const String apiKey = "AIzaSyCCrX-_8l28QQhk5mBnp4i3ptIevnbMEVM";
final getIt = GetIt.I;

void setup() {
  getIt.registerSingleton<MapCubit>(MapCubit());
  getIt.registerSingleton<CompassCubit>(CompassCubit());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAdMob.instance.initialize(appId: "ca-app-pub-2007717172579041~4790534354");
  HydratedBloc.storage = await HydratedStorage.build();
  Bloc.observer = SimpleBlocObserver();
  setup();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
