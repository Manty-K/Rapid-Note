import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rapid_note/constants/app_colors.dart';
import 'package:rapid_note/files/cubit/files_cubit.dart';
import 'package:rapid_note/player/audio_player_controller.dart';

class List2 extends StatelessWidget {
  AudioPlayerController controller = AudioPlayerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: BlocBuilder<FilesCubit, FilesState>(
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.loaded) {
            String _durationString(Duration duration) {
              String twoDigits(int n) => n.toString().padLeft(2, "0");
              String twoDigitMinutes =
                  twoDigits(duration.inMinutes.remainder(60));
              String twoDigitSeconds =
                  twoDigits(duration.inSeconds.remainder(60));
              return "$twoDigitMinutes:$twoDigitSeconds";
            }

            Widget buildG(RecordingGroup rGroup) {
              final today = DateTime.now();

              String title = '';
              int diffrence = rGroup.date.difference(today).inDays;

              if (diffrence == -1) {
                title = 'Yesterday';
              } else if (diffrence == 0) {
                title = 'Today';
              } else {
                title = getDateString(rGroup.date);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.highlightColor,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  ...rGroup.recordings
                      .map((groupRecording) => Dismissible(
                            background: Container(color: AppColors.shadowColor),
                            onDismissed: (direction) async {
                              controller.stop();
                              // await state.recordings
                              //     .firstWhere(
                              //         (recording) => recording.file.path== groupRecording.file.path));
                              // print('File deleted');
                              await state.recordings
                                  .firstWhere((element) =>
                                      element.file == groupRecording.file)
                                  .file
                                  .delete();
                              print('File deleted');
                            },
                            key: Key(groupRecording.fileDuration.toString()),
                            child: ListTile(
                              selectedTileColor: Colors.green,
                              title: Text(
                                dateTimeToTimeString(groupRecording.dateTime),
                                style: TextStyle(
                                  color: AppColors.accentColor,
                                ),
                              ),
                              trailing: Text(
                                _durationString(groupRecording.fileDuration),
                                style: TextStyle(
                                  color: AppColors.accentColor,
                                ),
                              ),
                              onTap: () async {
                                print('Tile clicked');
                                await controller.stop();
                                final fileDuration = await controller.setPath(
                                    filePath: groupRecording.file.path);
                                print('Duration $fileDuration');
                                await controller.play();
                                await controller.stop();
                              },
                              // trailing: IconButton(
                              //   icon: Icon(Icons.remove),
                              //   onPressed: () {
                              //     print('trailing clicked');
                              //     files[index].delete();
                              //   },
                              // ),
                            ),
                          ))
                      .toList()
                ],
              );
            }

            return SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: state.sortedRecordings
                        .map((RecordingGroup recordingGroup) =>
                            buildG(recordingGroup))
                        .toList(),
                  ),
                ),
              ),
            );
          } else if (state.loadStatus == LoadStatus.loading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.accentColor,
            ));
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -4),
              spreadRadius: 2,
              color: AppColors.highlightColor,
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: StreamBuilder<PlayerState>(
            stream: controller.player.playerStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.playing ? 'Playing' : 'Stopped');
              } else {
                return Text('Stopped');
              }
            }),
      ),
    );
  }

  String getDateString(DateTime dateTime) {
    String day = dateTime.day.toString();
    String month = '';
    switch (dateTime.month) {
      case 1:
        month = 'Jan';
        break;
      case 2:
        month = 'Feb';
        break;
      case 3:
        month = 'Mar';
        break;
      case 4:
        month = 'Apr';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'Jun';
        break;
      case 7:
        month = 'Jul';
        break;
      case 8:
        month = 'Aug';
        break;
      case 9:
        month = 'Sept';
        break;
      case 10:
        month = 'Oct';
        break;
      case 11:
        month = 'Nov';
        break;
      case 12:
        month = 'Dec';
        break;
    }

    return '$day $month';
  }

  String dateTimeToTimeString(DateTime dateTime) {
    bool isPM = false;
    int hour = dateTime.hour;
    int min = dateTime.minute;

    if (hour > 12) {
      isPM = true;
      hour -= 12;
    }

    return '${hour < 10 ? '0' + hour.toString() : hour.toString()}:${min < 10 ? '0' + min.toString() : min.toString()} ${isPM ? 'pm' : 'am'}';
  }
}
