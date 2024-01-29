import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebook/src/settings/settings_controller.dart';
import 'package:ebook/src/pages/home/home.dart';
import 'package:ebook/src/models/books.dart';
import 'package:ebook/src/pages/auth/login.dart';

class Api {
  static const String apiUrl = "ebook.devra.my.id";
  static Future<bool> sessionUser({
    required SettingsController settingsController,
  }) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var gettoken = localStorage.getString('token');
    if (gettoken != null) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> loginUser({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required GlobalKey<FormState> formKey,
    required SettingsController settingsController,
  }) async {
    if (formKey.currentState!.validate()) {
      var url = Uri.https(apiUrl, '/api/login');
      var response = await http.post(url, body: {
        "email": emailController.text,
        "password": passwordController.text,
      });
      var data = json.decode(response.body);

      if (data['status'].toString() == "success") {
        Fluttertoast.showToast(
          msg: 'Login Successful',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', json.encode(data['token']));
        localStorage.setString('name', json.encode(data['name']));
        localStorage.setString('user_id', json.encode(data['user_id']));
        localStorage.setString('imgUrl', json.encode(data['imgUrl']));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              settingsController: settingsController,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    }
  }

  static Future<void> registerUser({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required GlobalKey<FormState> formKey,
    required SettingsController settingsController,
  }) async {
    if (formKey.currentState!.validate()) {
      var url = Uri.https(apiUrl, '/api/register');
      var response = await http.post(url, body: {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      });
      var data = json.decode(response.body);
      if (data['status'].toString() == "success") {
        Fluttertoast.showToast(
          msg: 'Registration Successful',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', json.encode(data['token']));
        localStorage.setString('name', json.encode(data['name']));
        localStorage.setString('user_id', json.encode(data['user_id']));
        localStorage.setString('imgUrl', json.encode(data['imgUrl']));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              settingsController: settingsController,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    }
  }

  static Future<void> logoutUser({
    required BuildContext context,
    required SettingsController settingsController,
  }) async {
    var token = '';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var gettoken = localStorage.getString('token');
    if (gettoken != null) {
      token = gettoken.replaceAll('"', '');
    }
    var url = Uri.https(apiUrl, '/api/logout');
    var response =
        await http.post(url, headers: {'Authorization': 'Bearer $token'});
    var data = json.decode(response.body);
    if (data['status'].toString() == "success") {
      Fluttertoast.showToast(
        msg: 'Logout Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
      await localStorage.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(
            settingsController: settingsController,
          ),
        ),
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: data['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  static Future<void> changeProfileUser({
    required String imgUrl,
  }) async {
    var token = '';
    var user_id = '';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var gettoken = localStorage.getString('token');
    var getuserid = localStorage.getString('user_id');
    if (gettoken != null && getuserid != null) {
      token = gettoken.replaceAll('"', '');
      user_id = getuserid.replaceAll('"', '');
    }
    var url = Uri.https(apiUrl, '/api/update-profile');
    var response = await http.post(url, body: {
      "user_id": user_id,
      "imgUrl": imgUrl,
    }, headers: {
      'Authorization': 'Bearer $token'
    });
    var data = json.decode(response.body);
    if (data['status'].toString() == "success") {
      Fluttertoast.showToast(
        msg: 'Registration Successful',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        textColor: Colors.white,
        msg: data['message'],
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  static Future<List<Books>> getBook() async {
    var token = '';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var gettoken = localStorage.getString('token');
    if (gettoken != null) {
      token = gettoken.replaceAll('"', '');
    }
    var url = Uri.https(apiUrl, '/api/book');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonResponse["data"];
      return data.map((item) => Books.fromJson(item)).toList();
    } else {
      // Jika respons tidak berhasil, handle kesalahan
      throw Exception('Failed to load data from API');
    }
  }

  static Future<List<Books>> getMyBook() async {
    var token = '';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var gettoken = localStorage.getString('token');
    if (gettoken != null) {
      token = gettoken.replaceAll('"', '');
    }

    var url = Uri.https(apiUrl, '/api/my-book');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonResponse["data"];
      return data.map((item) => Books.fromJson(item)).toList();
    } else {
      // Jika respons tidak berhasil, handle kesalahan
      throw Exception('Failed to load data from API');
    }
  }

  static Future<List<int>> getIdMyBook() async {
    List<int> idbook = [];
    var token = '';
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var gettoken = localStorage.getString('token');
    if (gettoken != null) {
      token = gettoken.replaceAll('"', '');
    }

    var url = Uri.https(apiUrl, '/api/my-book');
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      for (var item in jsonResponse['data']) {
        if (item is Map<String, dynamic> && item.containsKey('id')) {
          idbook.add(item['id']);
        }
      }
      return idbook;
    } else {
      // Jika respons tidak berhasil, handle kesalahan
      throw Exception('Failed to load data from API');
    }
  }

  static Future<void> detailAddRemoveBook({
    required BuildContext context,
    required String bookId,
    required String text,
  }) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var gettoken = localStorage.getString('token');
    var getuserid = localStorage.getString('user_id');
    var token = '';
    var user_id = '';

    if (text == "In Library") {
      var url = Uri.https(apiUrl, '/api/remove-book');
      if (gettoken != null && getuserid != null) {
        token = gettoken.replaceAll('"', '');
        user_id = getuserid.replaceAll('"', '');
      }
      var response = await http.post(url, body: {
        "book_id": bookId, // Pastikan books.id adalah String
        "user_id": user_id, // Juga pastikan user_id berupa String
      }, headers: {
        'Authorization': 'Bearer $token'
      });

      var data = json.decode(response.body);
      if (data['status'].toString() == "success") {
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } else {
      var url = Uri.https(apiUrl, '/api/add-book');
      if (gettoken != null && getuserid != null) {
        token = gettoken.replaceAll('"', '');
        user_id = getuserid.replaceAll('"', '');
      }
      var response = await http.post(url, body: {
        "book_id": bookId, // Pastikan books.id adalah String
        "user_id": user_id, // Juga pastikan user_id berupa String
      }, headers: {
        'Authorization': 'Bearer $token'
      });

      var data = json.decode(response.body);
      if (data['status'].toString() == "success") {
        Fluttertoast.showToast(
          msg: data['message'],
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: data['message'],
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    }
  }
}
