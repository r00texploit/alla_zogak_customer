import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../api/cart.dart';
import '../models/cart.dart';
import '../models/products.dart';
import '../models/response_model.dart';

class CartBloc extends ChangeNotifier {
  final List<Cart> _carts = [];
  final Map<int, bool> _loads = {};
  bool _loading = false;
  int _total = 0;
  int _status = 200;

  int get status => _status;
  List<Cart> get cart => _carts;
  bool get isLoading => _loading;
  int get cartTotal => _total;
  int get itemCount => _carts.length;

  Future<void> loadData(BuildContext context) async {
    _loading = true;
    notifyListeners();
    ResponseModel resp = await getMyCart();
    if (resp.success) {
      List<Cart> list =
          List.generate(resp.data.length, (i) => Cart.fromJson(resp.data[i]));
      _carts.clear();
      _total = 0;
      _status = 200;
      for (var el in list) {
        _carts.add(el);
        if (el.products is Products) {
          _total += el.products!.price * el.qty;
        }
      }
      _loading = false;
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
  }

  Future refresh(BuildContext context) async {
    _status = 200;
    notifyListeners();
    await loadData(context);
  }

  Future<void> remove(int id, BuildContext context) async {
    notifyListeners();
    final cartid = cart.firstWhere((el) => el.productId == id,
        orElse: () => Cart(
            id: 0,
            coustmerId: 0,
            productId: 0,
            categoryOptionValueId: 0,
            productOptionValueId: 0,
            qty: 0));
    if (cartid.id != 0) {
      ResponseModel resp = await removeFromCart(cartid.id);
      if (resp.success) {
        Cart item = _carts.firstWhere((el) => el.productId == id);
        if (item.products is Products) {
          _total += item.products!.price * item.qty;
        }
        _carts.removeWhere((el) => el.productId == id);
        _loading = false;
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
    }
    notifyListeners();
  }

  Future<void> inctanceRemove(int id, BuildContext context) async {
    notifyListeners();
    final index = cart.indexWhere((el) => el.id == id);
    if (index != -1) {
      _total -= cart[index].products!.price * cart[index].qty;
      cart.removeAt(index);
      await removeFromCart(id);
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
  }

  Future<void> add(Map<String, dynamic> data, BuildContext context) async {
    ResponseModel resp = await addToCart(data);
    if (resp.success) {
      loadData(context);
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
      notifyListeners();
    }
  }

  Future<void> updateToQty(int id, int qty, BuildContext context) async {
    notifyListeners();
    ResponseModel resp = await updateCart(id, {'qty': qty});
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
  }

  Future<void> placeOrder(Map<String, dynamic> data) async {
    try {
      ResponseModel resp = await order(data);
      if (resp.success) {
        _carts.clear();
        _total = 0;
        _loading = false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    notifyListeners();
  }

  bool verify(int id) {
    _loads[id] = false;
    int index = _carts.indexWhere((el) => el.productId == id);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }

  bool? loading(int id) {
    return _loads[id];
  }
}
