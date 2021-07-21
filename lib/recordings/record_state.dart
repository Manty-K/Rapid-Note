part of 'record_cubit.dart';

abstract class RecordState {}

class RecordInitial extends RecordState {}

class RecordOn extends RecordState {}

class RecordStopped extends RecordState {}

class RecordError extends RecordState {}
