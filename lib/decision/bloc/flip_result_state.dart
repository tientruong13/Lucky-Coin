import 'package:equatable/equatable.dart';
import 'package:lucky_coin_flip/decision/model/flip_result_model.dart';

abstract class FlipResultState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FlipResultInitial extends FlipResultState {}

class FlipResultSaved extends FlipResultState {}

class FlipResultLoaded extends FlipResultState {
  final List<FlipResultModel> results;

  FlipResultLoaded(this.results);

  @override
  List<Object?> get props => [results];
}
