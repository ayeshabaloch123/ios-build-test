class Session {
  String id;
  String name;
  String description;
  String imageUrl;
  String linkedinUrl;
  String instagramUrl;
  String twitterUrl;
  String activity;
  String date;
  String course;

  Session(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      this.linkedinUrl = '',
      this.instagramUrl = '',
      this.twitterUrl = '',
      required this.activity,
      required this.course,
      required this.date});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      linkedinUrl: json['linkedin_url'] as String? ?? '',
      instagramUrl: json['instagram_url'] as String? ?? '',
      twitterUrl: json['twitter_url'] as String? ?? '',
      activity: json['activity'] as String,
      course: json['course'] as String,
      date: json['date'] as String,
    );
  }
}
