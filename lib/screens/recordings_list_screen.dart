import 'dart:io';

import 'package:flutter/material.dart';

import 'package:rapid_note/constants/paths.dart';
import 'package:rapid_note/player/audio_player_controller.dart';

class RecordingsList extends StatefulWidget {
  const RecordingsList({Key? key}) : super(key: key);

  @override
  _RecordingsListState createState() => _RecordingsListState();
}

class _RecordingsListState extends State<RecordingsList> {
  List<FileSystemEntity> files = [];
  AudioPlayerController controller = AudioPlayerController();
  @override
  void initState() {
    super.initState();
    files = _getFiles();
  }

  List<FileSystemEntity> _getFiles() {
    final List<FileSystemEntity> recordings =
        Directory(Paths.recording).listSync();
    return recordings;
  }

  List<DateTime> get _filesToDateTimes {
    List<DateTime> datetimes = [];

    for (var file in files) {
      final millisecond = int.parse(file.path.split('/').last.split('.').first);
      datetimes.add(DateTime.fromMillisecondsSinceEpoch(millisecond));
    }

    return datetimes;
  }

  List<RGroup> process() {
    List<RGroup> processed = [];

    final list = _filesToDateTimes;

    for (var i = 0; i < list.length; i++) {
      final selectedDate = list[i];

      bool dateAdded = false;

      for (var j = 0; j < processed.length; j++) {
        print(
            'current Date = ${processed[j].times.isNotEmpty ? processed[j].times.first : 'no'} compare date $selectedDate');
        if (processed[j].times.any((time) =>
            time.day == selectedDate.day &&
            time.month == selectedDate.month &&
            time.year == selectedDate.year)) {
          //  print('contains');
          processed[j].addTime(selectedDate);
          dateAdded = true;
        }
      }

      if (!dateAdded) {
        processed.add(RGroup.initial(selectedDate));
        print('new added');
      }
    }
    //sort inner items
    for (var i in processed) {
      i.times.sort((a, b) {
        return b.compareTo(a);
      });
    }

    //sort groups
    processed.sort((a, b) {
      return b.day.compareTo(a.day);
    });

    return processed;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: process().map((RGroup rGroup) => buildG(rGroup)).toList(),
      ),
      // body: ListView.builder(
      //   itemCount: files.length,
      //   itemBuilder: (context, index) {
      //     final name = files[index].path.split('/').last.split('.').first;
      //     DateTime d = DateTime.fromMillisecondsSinceEpoch(int.parse(name));
      //     String displayName = d.toString();
      //     return Dismissible(
      //       onDismissed: (direction) async {
      //         controller.stop();
      //         await files[index].delete();
      //         print('File deleted');
      //       },
      //       key: Key(name),
      //       child: ListTile(
      //         title: Text(displayName),
      //         onTap: () async {
      //           print('Tile clicked');
      //           await controller.stop();
      //           final fileDuration =
      //               await controller.setPath(filePath: files[index].path);
      //           print('Duration $fileDuration');
      //           await controller.play();
      //         },
      //         // trailing: IconButton(
      //         //   icon: Icon(Icons.remove),
      //         //   onPressed: () {
      //         //     print('trailing clicked');
      //         //     files[index].delete();
      //         //   },
      //         // ),
      //       ),
      //     );
      //   },
      // ),
      bottomNavigationBar: Container(
        height: 200,
        color: Colors.yellow,
      ),
    );
  }

  Widget buildG(RGroup rGroup) {
    final today = DateTime.now();

    String title = '';
    int diffrence = rGroup.day.difference(today).inDays;

    if (diffrence == -1) {
      title = 'Yesterday';
    } else if (diffrence == 0) {
      title = 'Today';
    } else {
      title = getDateString(rGroup.day);
    }
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.green),
        ),
        ...rGroup.times
            .map((e) => Dismissible(
                  onDismissed: (direction) async {
                    controller.stop();
                    await files
                        .firstWhere(
                            (element) => element.path == dateTimeToPath(e))
                        .delete();
                    print('File deleted');
                  },
                  key: Key(e.millisecondsSinceEpoch.toString()),
                  child: ListTile(
                    title: Text(dateTimeToTimeString(e)),
                    onTap: () async {
                      print('Tile clicked');
                      await controller.stop();
                      final fileDuration =
                          await controller.setPath(filePath: dateTimeToPath(e));
                      print('Duration $fileDuration');
                      await controller.play();
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

  String dateTimeToPath(DateTime dateTime) {
    return Paths.recording +
        '/' +
        dateTime.millisecondsSinceEpoch.toString() +
        '.rn';
  }

  String dateTimeToTimeString(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}';
  }
}

class RecordindListTest extends StatelessWidget {
  List<DateTime> dates = [
    DateTime.utc(2021, 01, 01),
    DateTime.utc(2021, 7, 22),
    DateTime.utc(2021, 7, 21),
  ];

  // List<List<DateTime>> process(List<DateTime> list) {
  //   var processed = [] as List<List<DateTime>>;

  //   for (var i = 0; i < list.length; i++) {
  //     final selectedDate = list[i];

  //     bool dateAdded = false;

  //     for (var j = 0; j < processed.length; j++) {
  //       if (processed[j].any((e) =>
  //           e.day == selectedDate.day &&
  //           e.month == selectedDate.month &&
  //           e.year == selectedDate.year)) {
  //         processed[j].add(selectedDate);
  //         dateAdded = true;
  //       }
  //     }

  //     if (!dateAdded) {
  //       processed.add([selectedDate]);
  //     }
  //   }

  //   return processed;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(),
    );
  }
}

class RGroup {
  DateTime day;
  List<DateTime> times;

  RGroup({required this.day, required this.times});

  factory RGroup.fromList(List<DateTime> datetimes) {
    final date = datetimes.first;

    final day = DateTime.utc(date.year, date.month, date.day);

    return RGroup(day: day, times: datetimes);
  }

  factory RGroup.initial(DateTime datetime) {
    return RGroup(
      day: DateTime.utc(datetime.year, datetime.month, datetime.day),
      times: [datetime],
    );
  }
  void addTime(DateTime datetime) {
    times.add(datetime);
  }

  RGroup copyWith({
    DateTime? day,
    List<DateTime>? times,
  }) {
    return RGroup(
      day: day ?? this.day,
      times: times ?? this.times,
    );
  }
}
