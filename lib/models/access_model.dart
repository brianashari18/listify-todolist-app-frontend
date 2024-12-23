class Access {
  final String email;
  final String access;

  Access({required this.email, required this.access});

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
        email: json['email'],
        access: json['accessRights'] == 1 ? 'View' : 'Edit');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Access &&
        other.email == email;
  }

  @override
  int get hashCode => email.hashCode ^ access.hashCode;
}
