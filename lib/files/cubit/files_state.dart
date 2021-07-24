part of 'files_cubit.dart';

enum LoadStatus {
  initial,
  loading,
  loaded,
}

class FilesState {
  final List<Recording> recordings;
  final LoadStatus loadStatus;

  FilesState({required this.recordings, required this.loadStatus});

  List<RecordingGroup> get sortedRecordings {
    List<RecordingGroup> recordingGroups = [];

    final recordingsList = recordings;

    for (var i = 0; i < recordingsList.length; i++) {
      final selectedRecording = recordingsList[i];

      bool recordingAdded = false;

      for (var j = 0; j < recordingGroups.length; j++) {
        if (recordingGroups[j].recordings.any((recording) =>
            recording.dateTime.difference(selectedRecording.dateTime).inDays ==
            0)) {
          recordingGroups[j].addRecording(selectedRecording);
          recordingAdded = true;
        }
      }

      if (!recordingAdded) {
        recordingGroups.add(RecordingGroup.initial(selectedRecording));
      }
    }

    //sort inner items
    for (var group in recordingGroups) {
      // i..sort((a, b) {
      //   return b.compareTo(a);
      // });
      group.recordings.sort((a, b) {
        return b.dateTime.compareTo(a.dateTime);
      });
    }

    //sort groups
    recordingGroups.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    return recordingGroups;
  }

  factory FilesState.initial() {
    return FilesState(
      recordings: [],
      loadStatus: LoadStatus.initial,
    );
  }

  FilesState copyWith({
    List<Recording>? recordings,
    LoadStatus? loadStatus,
  }) {
    return FilesState(
      recordings: recordings ?? this.recordings,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }
}

class Recording {
  final FileSystemEntity file;

  final Duration fileDuration;

  late DateTime dateTime;

  Recording({
    required this.file,
    required this.fileDuration,
  }) {
    final millisecond = int.parse(file.path.split('/').last.split('.').first);
    dateTime = DateTime.fromMillisecondsSinceEpoch(millisecond);
  }
}

class RecordingGroup {
  DateTime date;

  List<Recording> recordings;

  RecordingGroup({required this.date, required this.recordings});

  factory RecordingGroup.initial(Recording recording) {
    return RecordingGroup(date: recording.dateTime, recordings: [recording]);
  }

  addRecording(Recording recording) {
    recordings.add(recording);
  }
}
