import 'package:alla_zogak_customer/api/wishlist.dart';
import 'package:flutter/material.dart';
import '../models/products.dart';
import '../models/response_model.dart';

class WishlistBloc extends ChangeNotifier {
  final List<Products> _wishlist = [];
  int _total = 0;

  List<Products> get products => _wishlist;
  int get total => _total;

  Future<int> loadData(BuildContext context,
      {int offset = 0, bool more = false}) async {
    if (!more) {
      _wishlist.clear();
      notifyListeners();
    }
    ResponseModel resp = await getMyWishlist(offset);
    if (resp.success) {
      List<Products> list = List.generate(
          resp.data.length, (i) => Products.fromJson(resp.data[i]));
      _wishlist.clear();
      for (var el in list) {
        _wishlist.add(el);
      }
      _total = resp.total as int;
      notifyListeners();
      return resp.total as int;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: Center(
            child: Row(
              children: const [
                Icon(
                  Icons.network_check,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("تأكد من إتصالك بالأنترنت"),
              ],
            ),
          ),
        ),
      ));
    }
    notifyListeners();
    return 0;
  }

  Future<void> remove(int id, BuildContext context) async {
    try {
      ResponseModel resp = await removeFromWishlist(id);
      if (resp.success) {
        await loadData(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 30,
            child: Center(
              child: Row(
                children: const [
                  Icon(
                    Icons.network_check,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("تأكد من إتصالك بالأنترنت"),
                ],
              ),
            ),
          ),
        ));
      }
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: Center(
            child: Row(
              children: const [
                Icon(
                  Icons.network_check,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("تأكد من إتصالك بالأنترنت"),
              ],
            ),
          ),
        ),
      ));
      notifyListeners();
    }
  }

  Future<void> add(Products data, BuildContext context) async {
    try {
      ResponseModel resp = await addToWishList(data.id);
      if (resp.success) {
        _wishlist.add(data);
        _total++;
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 30,
            child: Center(
              child: Row(
                children: const [
                  Icon(
                    Icons.network_check,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("تأكد من إتصالك بالأنترنت"),
                ],
              ),
            ),
          ),
        ));
      }
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: Center(
            child: Row(
              children: const [
                Icon(
                  Icons.network_check,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("تأكد من إتصالك بالأنترنت"),
              ],
            ),
          ),
        ),
      ));
      notifyListeners();
    }
  }

  bool verify(int id) {
    final index = _wishlist.indexWhere((el) => el.id == id);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }
}
