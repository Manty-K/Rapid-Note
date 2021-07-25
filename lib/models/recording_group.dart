import 'package:equatable/equatable.dart';

import 'recording.dart';

class RecordingGroup extends Equatable {
  final DateTime date;

  final List<Recording> recordings;

  RecordingGroup({required this.date, required this.recordings});

  factory RecordingGroup.initial(Recording recording) {
    return RecordingGroup(date: recording.dateTime, recordings: [recording]);
  }

  addRecording(Recording recording) {
    recordings.add(recording);
  }

  @override
  List<Object?> get props => [date, recordings];

  @override
  bool? get stringify => true;

  RecordingGroup copyWith({
    DateTime? date,
    List<Recording>? recordings,
  }) {
    return RecordingGroup(
      date: date ?? this.date,
      recordings: recordings ?? this.recordings,
    );
  }
}
