import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/user.dart';
import '../models/customers.dart';
import '../models/response_model.dart';

class UserBloc extends ChangeNotifier {
  Customers? _user;

  Customers? get user => _user;

  Future<void> loadData(BuildContext context) async {
    ResponseModel resp = await getProfile();
    if (resp.success) {
      _user = Customers.fromJson(resp.data);
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
  }

  Future<bool> update(Map<String, dynamic> data, BuildContext context) async {
    ResponseModel resp = await updateProfile(data);
    if (resp.success) {
      await loadData(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: Center(
            child: Row(
              children: [
                const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "تم تحديث المعلومات بنجاح",
                  style: GoogleFonts.cairo().copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
      return true;
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
      return false;
    }
  }

  Future<bool> newPassword(
      Map<String, dynamic> data, BuildContext context) async {
    ResponseModel resp = await updatePassword(data);
    if (resp.success) {
      await loadData(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30,
          child: Center(
            child: Row(
              children: [
                const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "تم تغيير الباسورد بنجاح",
                  style: GoogleFonts.cairo().copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
      return true;
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
                  Icons.warning,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("تأكد من الباسويرد الحالي"),
              ],
            ),
          ),
        ),
      ));
      return false;
    }
  }

  Future<void> uploadImages(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ["jpg", "png", "jpeg"],
      type: FileType.custom,
    );

    if (result != null) {
      final resp = await updateImage({
        "profile": await MultipartFile.fromFile(result.files[0].path as String)
      });
      if (resp.success) {
        await loadData(context);
      }
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
                Text("تم إلغاء الصوره"),
              ],
            ),
          ),
        ),
      ));
    }
    notifyListeners();
  }

  Future<bool> getOtp(BuildContext context) async {
    final resp = await sendOtp();
    if (resp.success) {
      return true;
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
                Text("تم إلغاء الصوره"),
              ],
            ),
          ),
        ),
      ));
      return false;
    }
  }

  Future<bool> validateOtp(String otp,BuildContext context) async {
    final resp = await verifyOtp(otp);
    if (resp.success) {
      return true;
    } else {
      return false;
    }
  }
}
