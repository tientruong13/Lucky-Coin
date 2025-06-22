import 'package:hive/hive.dart';

part 'flip_result_model.g.dart';

@HiveType(typeId: 0)
class FlipResultModel extends HiveObject {
  @HiveField(0)
  final String reason;

  @HiveField(1)
  final String result;

  @HiveField(2)
  final String picked;

  @HiveField(3)
  final DateTime timestamp;

  FlipResultModel({
    required this.reason,
    required this.picked,
    required this.result,
    required this.timestamp,
  });
}
