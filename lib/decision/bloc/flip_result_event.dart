import 'package:equatable/equatable.dart';

abstract class FlipResultEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaveFlipResultEvent extends FlipResultEvent {
  final String reason;
  final String result;
  final DateTime timestamp;
  final String picked;

  SaveFlipResultEvent({
    required this.reason,
    required this.picked,
    required this.result,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [reason, result, timestamp];
}

class ClearAllResultsEvent extends FlipResultEvent {}

class LoadFlipResultsEvent extends FlipResultEvent {}

class DeleteFlipResultEvent extends FlipResultEvent {
  final int key;
  DeleteFlipResultEvent(this.key);

  @override
  List<Object?> get props => [key];
}
