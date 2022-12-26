import './cart.dart';
import './orders.dart';
import './sessions.dart';

class Customers {
  int id;
  String tel;
  String name;
  String? avatar;
  DateTime? tokenExpiration;
  bool verified;
  String? password;
  DateTime createdAt;
  DateTime? upsatedAt;
  List<Cart>? cart;
  List<Orders>? orders;
  List<Sessions>? sessions;

  Customers({
    required this.id,
    required this.tel,
    this.tokenExpiration,
    required this.verified,
    required this.password,
    required this.createdAt,
    this.upsatedAt,
    this.avatar,
    this.cart,
    this.orders,
    this.sessions,
    required this.name,
  });
  factory Customers.fromJson(Map<String, dynamic> json) => Customers(
        id: json['id'],
        tel: json['tel'] ?? "",
        avatar: json['avatar'],
        tokenExpiration: json['token_expiration'] != null
            ? DateTime.parse(json['token_expiration'])
            : null,
        verified: json['verified'] == 1? true : false,
        password: json['password'],
        createdAt: DateTime.parse(json['createdAt']),
        upsatedAt: json['upsatedAt'] != null
            ? DateTime.parse(json['upsatedAt'])
            : null,
        cart: json['cart'] != null
            ? List.generate(
                json['cart']!.length, (i) => Cart.fromJson(json['cart']![i]))
            : [],
        sessions: json['sessions'] != null
            ? List.generate(json['sessions']!.length,
                (i) => Sessions.fromJson(json['sessions']![i]))
            : [], 
            name: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['tel'] = tel;
    map['token_expiration'] = tokenExpiration?.toIso8601String();
    map['verified'] = verified;
    map['password'] = password;
    map['createdAt'] = createdAt.toIso8601String();
    map['upsatedAt'] = upsatedAt?.toIso8601String();
    map['cart'] = cart != null
        ? List.generate(cart!.length, (i) => cart![i].toJson())
        : [];
    map['orders'] = orders != null
        ? List.generate(orders!.length, (i) => orders![i].toJson())
        : [];
    map['sessions'] = sessions != null
        ? List.generate(sessions!.length, (i) => sessions![i].toJson())
        : [];

    return map;
  }
}
