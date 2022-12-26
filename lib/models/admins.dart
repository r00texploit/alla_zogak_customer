import './sessions.dart';

class Admins {
  int id;
  String email;
  DateTime? tokenExpiration;
  String password;
  DateTime createdAt;
  DateTime? updatedAt;
  List<Sessions>? sessions;

  Admins({
    required this.id,
    required this.email,
    this.tokenExpiration,
    required this.password,
    required this.createdAt,
    this.updatedAt,
    this.sessions,
  });
  factory Admins.fromJson(Map<String, dynamic> json) => Admins(
        id: json['id'],
        email: json['email'],
        tokenExpiration: json['token_expiration'] != null
            ? DateTime.parse(json['token_expiration'])
            : null,
        password: json['password'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        sessions: json['sessions'] != null
            ? List.generate(json['sessions']!.length,
                (i) => Sessions.fromJson(json['sessions']![i]))
            : [],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['email'] = email;
    map['token_expiration'] = tokenExpiration?.toIso8601String();
    map['password'] = password;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    map['sessions'] = sessions != null
        ? List.generate(sessions!.length, (i) => sessions![i].toJson())
        : [];

    return map;
  }
}
