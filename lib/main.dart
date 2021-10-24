import 'package:crypto_bloc/blocs/crypto/crypto_bloc.dart';
import 'package:crypto_bloc/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CryptoRepository(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.tealAccent,
        ),
        home: BlocProvider(
          create: (context) =>
              CryptoBloc(cryptoRepository: context.read<CryptoRepository>())
                ..add(AppStarted()),
          child: HomeScreen(),
        ),
      ),
    );
  }
}
