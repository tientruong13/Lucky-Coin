// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flip_result_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FlipResultModelAdapter extends TypeAdapter<FlipResultModel> {
  @override
  final int typeId = 0;

  @override
  FlipResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FlipResultModel(
      reason: fields[0] as String,
      picked: fields[2] as String,
      result: fields[1] as String,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FlipResultModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.reason)
      ..writeByte(1)
      ..write(obj.result)
      ..writeByte(2)
      ..write(obj.picked)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlipResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
