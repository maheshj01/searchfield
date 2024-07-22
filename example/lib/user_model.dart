class UserModel {
  final int id;
  final String name;
  final String role;
  final String team;
  final String status;
  final String age;
  final String avatar;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.team,
    required this.status,
    required this.age,
    required this.avatar,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      team: json['team'],
      status: json['status'],
      age: json['age'] ?? '18',
      avatar: json['avatar'],
      email: json['email'],
    );
  }
}
