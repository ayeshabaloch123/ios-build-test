import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class Note extends HiveObject {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  String content;

  Note({
    required this.sessionId,
    required this.content,
  });
}
