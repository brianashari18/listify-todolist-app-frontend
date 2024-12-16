import 'dart:ui';

class Task {
  int id;
  String title;
  Color color;
  bool isShared;

  Task({
    required this.id,
    required this.title,
    required this.color,
    this.isShared = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    Color color = _colorFromString(json['color']);
    return Task(
      id: json['id'],
      title: json['name'],
      color: color,
      isShared: json['isShared'] ?? false,
    );
  }

  static Color _colorFromString(String colorString) {
    try {
      return Color(int.parse(colorString, radix: 16));
    } catch (e) {
      return const Color(0xFF7B7794);
    }
  }
}
