import 'package:flutter/material.dart';
import '../models/address.dart';
import './database.dart';

class AddressBloc extends ChangeNotifier {
  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  Future<void> loadData() async {
    _addresses = await DBHelper.instance.getAddresses();
    notifyListeners();
  }

  Future<bool> update(int id,Map<String, dynamic> data) async {
    bool resp = await DBHelper.instance.update(id,data);
    if (resp) {
      await loadData();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> insert(Map<String, dynamic> data) async {
    bool resp = await DBHelper.instance.insert(data);
    if (resp) {
      await loadData();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(int id) async {
    bool resp = await DBHelper.instance.delete(id);
    if (resp) {
      await loadData();
      return true;
    } else {
      return false;
    }
  }
  
}
