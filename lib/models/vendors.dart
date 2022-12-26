import './products.dart';
import './sessions.dart';
import './sub_orders.dart';

class Vendors {
  int id;
  String name;
  String tel;
  double? lat;
  double? lng;
  String? verificationToken;
  String? resetToken;
  DateTime? tokenExpiration;
  String avatar;
  bool verified;
  String password;
  String? address;
  DateTime createdAt;
  DateTime? updatedAt;
  List<Products>? products;
  List<Sessions>? sessions;
  List<SubOrders>? subOrders;

  Vendors({
    required this.id,
    required this.name,
    required this.tel,
    this.verificationToken,
    this.resetToken,
    this.tokenExpiration,
    required this.avatar,
    required this.verified,
    required this.password,
    this.address,
    required this.createdAt,
    this.updatedAt,
    this.products,
    this.sessions,
    this.subOrders,
    this.lat,
    this.lng,
  });
  factory Vendors.fromJson(Map<String, dynamic> json) => Vendors(
        id: json['id'],
        name: json['name'],
        tel: json['tel'],
        verificationToken: json['verification_token'],
        resetToken: json['reset_token'],
        tokenExpiration: json['token_expiration'] != null
            ? DateTime.parse(json['token_expiration'])
            : null,
        avatar: json['avatar'],
        verified: json['verified'] == 1 ? true : false,
        password: json['password'],
        address: json['address'],
        lat: json['lat'] != null ? double.parse(json['lat']) : null,
        lng: json['lng'] != null ? double.parse(json['lng']) : null,
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
        products: json['products'] != null
            ? List.generate(json['products']!.length,
                (i) => Products.fromJson(json['products']![i]))
            : [],
        sessions: json['sessions'] != null
            ? List.generate(json['sessions']!.length,
                (i) => Sessions.fromJson(json['sessions']![i]))
            : [],
        subOrders: json['sub_orders'] != null
            ? List.generate(json['sub_orders']!.length,
                (i) => SubOrders.fromJson(json['sub_orders']![i]))
            : [],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['id'] = id;
    map['name'] = name;
    map['tel'] = tel;
    map['verification_token'] = verificationToken;
    map['reset_token'] = resetToken;
    map['token_expiration'] = tokenExpiration?.toIso8601String();
    map['avatar'] = avatar;
    map['verified'] = verified;
    map['password'] = password;
    map['address'] = address;
    map['createdAt'] = createdAt.toIso8601String();
    map['updatedAt'] = updatedAt?.toIso8601String();
    map['products'] = products != null
        ? List.generate(products!.length, (i) => products![i].toJson())
        : [];
    map['sessions'] = sessions != null
        ? List.generate(sessions!.length, (i) => sessions![i].toJson())
        : [];
    map['sub_orders'] = subOrders != null
        ? List.generate(subOrders!.length, (i) => subOrders![i].toJson())
        : [];

    return map;
  }
}
