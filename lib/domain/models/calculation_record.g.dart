// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculation_record.dart';

class CalculationRecordAdapter extends TypeAdapter<CalculationRecord> {
  @override
  final int typeId = 0;

  @override
  CalculationRecord read(BinaryReader reader) {
    final fields = <int, dynamic>{};
    for (var i = 0; i < 3; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return CalculationRecord(
      expression: fields[0] as String,
      result: fields[1] as String,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CalculationRecord obj) {
    writer
      ..writeByte(0)
      ..write(obj.expression)
      ..writeByte(1)
      ..write(obj.result)
      ..writeByte(2)
      ..write(obj.timestamp);
  }
}
