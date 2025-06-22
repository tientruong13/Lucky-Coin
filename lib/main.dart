import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucky_coin_flip/decision/bloc/flip_result_bloc.dart';
import 'package:lucky_coin_flip/decision/model/flip_result_model.dart';
import 'package:lucky_coin_flip/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Hive.initFlutter();
  Hive.registerAdapter(FlipResultModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return BlocProvider(
          create: (_) => FlipResultBloc(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
            navigatorObservers: [routeObserver],
          ),
        );
      },
    );
  }
}
