part of 'files_cubit.dart';

enum LoadStatus {
  initial,
  loading,
  loaded,
}

abstract class FilesState {}

class FilesInitial extends FilesState {}

class FilesLoading extends FilesState {}

class FilesLoaded extends FilesState {
  final List<Recording> recordings;

  FilesLoaded({required this.recordings});

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

    ///Sort inner recordings
    for (var group in recordingGroups) {
      group.recordings.sort((a, b) {
        return b.dateTime.compareTo(a.dateTime);
      });
    }

    ///Sort groups
    recordingGroups.sort((a, b) {
      return b.date.compareTo(a.date);
    });

    return recordingGroups;
  }
}

class FilesPermisionNotGranted extends FilesState {}
