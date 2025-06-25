import 'package:hive/hive.dart';

part 'calculation_record.g.dart';

@HiveType(typeId: 0)
class CalculationRecord {
  const CalculationRecord({required this.expression, required this.result, required this.timestamp});

  @HiveField(0)
  final String expression;

  @HiveField(1)
  final String result;

  @HiveField(2)
  final DateTime timestamp;
}
