import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:rapid_note/constants/paths.dart';
import 'package:rapid_note/player/audio_player_controller.dart';
part 'files_state.dart';

class FilesCubit extends Cubit<FilesState> {
  FilesCubit() : super(FilesState.initial()) {
    getFiles();
  }

  Future<void> getFiles() async {
    List<Recording> recordings = [];
    emit(state.copyWith(
      loadStatus: LoadStatus.loading,
    ));
    final List<FileSystemEntity> files = Directory(Paths.recording).listSync();

    for (final file in files) {
      AudioPlayerController controller = AudioPlayerController();
      Duration fileDuration =
          await controller.setPath(filePath: file.path) ?? Duration.zero;
      recordings.add(Recording(file: file, fileDuration: fileDuration));
    }

    emit(state.copyWith(
      recordings: recordings,
      loadStatus: LoadStatus.loaded,
    ));
  }
}
