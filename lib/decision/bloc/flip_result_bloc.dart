import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:lucky_coin_flip/decision/model/flip_result_model.dart';
import 'flip_result_event.dart';
import 'flip_result_state.dart';

class FlipResultBloc extends Bloc<FlipResultEvent, FlipResultState> {
  static const _boxName = 'flip_results';

  FlipResultBloc() : super(FlipResultInitial()) {
    on<SaveFlipResultEvent>(_onSave);
    on<LoadFlipResultsEvent>(_onLoad);
    on<ClearAllResultsEvent>(_onDeleteAll);
    on<DeleteFlipResultEvent>(_onDelete);
  }

  Future<Box<FlipResultModel>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<FlipResultModel>(_boxName);
    }
    return Hive.box<FlipResultModel>(_boxName);
  }

  Future<void> _onSave(SaveFlipResultEvent event, Emitter emit) async {
    final box = await _getBox();
    final result = FlipResultModel(
      picked: event.picked,
      reason: event.reason,
      result: event.result,
      timestamp: event.timestamp,
    );
    await box.add(result);
    emit(FlipResultSaved());
    add(LoadFlipResultsEvent());
  }

  Future<void> _onLoad(LoadFlipResultsEvent event, Emitter emit) async {
    final box = await _getBox();
    final items = box.values.toList().reversed.toList();
    emit(FlipResultLoaded(items));
  }

  Future<void> _onDeleteAll(ClearAllResultsEvent event, Emitter emit) async {
    final box = await _getBox();
    await box.clear();
    add(LoadFlipResultsEvent());
  }

  Future<void> _onDelete(DeleteFlipResultEvent event, Emitter emit) async {
    final box = await _getBox();
    await box.delete(event.key);
    add(LoadFlipResultsEvent());
  }
}
