class Recommendation {
  final String link;
  final String title;

  Recommendation({
    required this.link,
    required this.title
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(link: json['link'], title: json['title']);
  }
}