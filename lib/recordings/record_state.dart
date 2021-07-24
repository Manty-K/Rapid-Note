part of 'record_cubit.dart';

abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordOn extends RecordState {
  int min = 0;
  int sec = 0;
}

class RecordStopped extends RecordState {}

class RecordError extends RecordState {}
