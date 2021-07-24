import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapid_note/constants/app_colors.dart';
import 'package:rapid_note/constants/paths.dart';
import 'package:rapid_note/recordings/record_cubit.dart';
import 'package:rapid_note/screens/home_screen/home_screen.dart';

import 'files/cubit/files_cubit.dart';

void main() async {
  //await Paths.initPaths();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.mainColor, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecordCubit>(
          create: (context) => RecordCubit(),
        ),
        BlocProvider<FilesCubit>(
          create: (context) => FilesCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Rapid Note',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen3(),
      ),
    );
  }
}
