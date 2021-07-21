import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rapid_note/constants/paths.dart';
import 'package:rapid_note/constants/recorder_constants.dart';
import 'package:record/record.dart';
part 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordInitial());

  Record _audioRecorder = Record();

  void startRecording() async {
    final storagePermissionRequest =
        await Permission.storage.request().isGranted;
    final microphonePermissionRequest =
        await Permission.microphone.request().isGranted;

    bool permissionsGranted =
        storagePermissionRequest && microphonePermissionRequest;

    if (permissionsGranted) {
      Directory appFolder = Directory(Paths.recording);
      bool appFolderExists = await appFolder.exists();
      if (!appFolderExists) {
        final created = await appFolder.create(recursive: true);
        print(created.path);
      }

      final filepath = Paths.recording +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.rn';
      print(filepath);
      //  print('we can record');
      // final dir = await getApplicationDocumentsDirectory();
      // final downloads = await getExternalStorageDirectory();
      // print('Downloads: $downloads');
      // final documentDirPath = dir.path;

      // final folderPath = dir.path;

      // final filepath = folderPath +
      //     '/' +
      //     DateTime.now().millisecondsSinceEpoch.toString() +
      //     '.m4a';

      await _audioRecorder.start(path: filepath);
      emit(RecordOn());
    } else {
      print('Permissions not granted');
    }
  }

  void stopRecording() async {
    String? path = await _audioRecorder.stop();
    emit(RecordStopped());
    print('Output path $path');
  }

  Future<Amplitude> getAmplitude() async {
    final amplitude = await _audioRecorder.getAmplitude();
    return amplitude;
  }

  Stream<double> apStream() async* {
    while (true) {
      await Future.delayed(Duration(
          milliseconds: RecorderConstants.amplitudeRateInMilliSeconds));
      final ap = await _audioRecorder.getAmplitude();
      yield ap.current;
    }
  }

  String _replaceLastFolderStringInPath(String path, String toFolder) {
    final pathList = path.split('/');

    print('pathList : $pathList');
    String newPath = '/';
    for (var i = 1; i < pathList.length - 1; i++) {
      newPath = newPath += pathList[i] + '/';
    }

    newPath += toFolder;
    print('New $newPath');

    return newPath;
  }
}
