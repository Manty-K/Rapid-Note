import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapid_note/constants/paths.dart';
import 'package:rapid_note/recordings/record_cubit.dart';
import 'package:rapid_note/screens/home_screen/home_screen.dart';

void main() async {
  //await Paths.initPaths();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecordCubit>(
          create: (context) => RecordCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Rapid Note',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
