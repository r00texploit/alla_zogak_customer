
class Address {
  int id;
  String address;
  Address({required this.id,required this.address});
  factory Address.fromJson(dynamic json) => Address(id: json['id'], address: json['address']);
}