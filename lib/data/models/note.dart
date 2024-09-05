// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 2)
class Note extends HiveObject {
  @HiveField(0)
  int stcId;

  @HiveField(1)
  String note;

  @HiveField(2)
  bool isSynced;

  Note({
    required this.stcId,
    required this.note,
    this.isSynced = false,
  });
}
