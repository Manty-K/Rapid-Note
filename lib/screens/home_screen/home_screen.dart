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
      appBar: AppBar(),
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
