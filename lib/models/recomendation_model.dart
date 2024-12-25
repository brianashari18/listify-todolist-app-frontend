class Recommendation {
  final String link;
  final String snippet;

  Recommendation({
    required this.link,
    required this.snippet
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(link: json['link'], snippet: json['snippet']);
  }
}