import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapid_note/recordings/record_cubit.dart';
import 'package:rapid_note/screens/home_screen/widgets/audio_visualizer.dart';
import 'package:rapid_note/screens/recordings_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<RecordCubit, RecordState>(builder: (context, state) {
        if (state is RecordOn) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Row(
                children: [
                  Spacer(),
                  StreamBuilder<double>(
                      initialData: -30.0,
                      stream: context.read<RecordCubit>().apStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          double value = snapshot.data ?? -30.0;
                          if (value == double.infinity || value < -30.0) {
                            value = -30.0;
                          }
                          return AudioVisualizer(
                              value: (value.abs() - 30).abs());
                        }
                        if (snapshot.hasError) {
                          return Text('Error');
                        } else {
                          return Text('No');
                        }
                      }),
                  Spacer(),
                ],
              ),
              Spacer(),
              IconButton(
                color: Colors.red,
                onPressed: () {
                  context.read<RecordCubit>().stopRecording();
                },
                icon: Icon(Icons.stop),
              ),
            ],
          );
        } else if (state is RecordStopped || state is RecordInitial) {
          return Center(
            child: IconButton(
              iconSize: 100,
              onPressed: () {
                context.read<RecordCubit>().startRecording();
              },
              icon: Icon(Icons.mic),
            ),
          );
        } else {
          return Text('Error Occured');
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecordingsList()));
        },
        child: Icon(Icons.file_present),
      ),
    );
  }
}

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff0f0c29),
                  !tapped ? Color(0xff302b63) : Color(0xff342f69),
                  Color(0xff24243e),
                ],
              ),
            ),
          ),
          SafeArea(
              child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'RAPID NOTE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  letterSpacing: 5,
                  fontWeight: FontWeight.w200,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    tapped = true;
                  });
                },
                onTapUp: (_) {
                  setState(() {
                    tapped = false;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    tapped = false;
                  });
                },
                child: Stack(
                  children: [
                    Positioned(
                      top: tapped ? 0 : 10,
                      child: Stack(
                        // fit: StackFit.expand,
                        children: [
                          micIcon(
                            context: context,
                            color: Colors.black45,
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: tapped ? 0 : 5,
                              sigmaY: tapped ? 0 : 5,
                            ),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    micIcon(
                      context: context,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                'MY NOTES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 5,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget micIcon({
    required BuildContext context,
    // Color color = Colors.white,
    Color color = const Color(0xffff0048),
  }) {
    return Icon(
      Icons.mic,
      size: MediaQuery.of(context).size.height / 2,
      color: color,
    );
  }
}
