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
    files = getFiles();
  }

  List<FileSystemEntity> getFiles() {
    final List<FileSystemEntity> recordings =
        Directory(Paths.recording).listSync();
    return recordings;
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
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final name = files[index].path.split('/').last.split('.').first;
          DateTime d = DateTime.fromMillisecondsSinceEpoch(int.parse(name));
          String displayName = d.toString();
          return Dismissible(
            onDismissed: (direction) async {
              controller.stop();
              await files[index].delete();
              print('File deleted');
            },
            key: Key(name),
            child: ListTile(
              title: Text(displayName),
              onTap: () async {
                print('Tile clicked');
                await controller.stop();
                final fileDuration =
                    await controller.setPath(filePath: files[index].path);
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
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 200,
        color: Colors.yellow,
      ),
    );
  }
}
