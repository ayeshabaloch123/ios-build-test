class Comment {
  final String sessionId;
  final String userId;
  final String text;

  Comment({
    required this.sessionId,
    required this.userId,
    required this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'text': text,
    };
  }
}
